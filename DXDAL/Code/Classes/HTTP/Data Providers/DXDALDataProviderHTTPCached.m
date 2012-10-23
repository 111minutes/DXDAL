//
//  DXDALDataProviderHTTPCached.m
//  DXDAL
//
//  Created by Me on 18.10.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALDataProviderHTTPCached.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "DXDALRequestHTTP.h"
#import "DXDALParser.h"
#import "DXDALMapper.h"
#import "EGOCache.h"

#define kStatusCodeKey @"statusCode"
#define kResponseStringKey @"responseString"
#define kResponseDataKey @"responseData"

typedef void (^SuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^ErrorHandler)(AFHTTPRequestOperation *operation, NSError *error);

@interface DXDALDataProviderHTTPCached ()

- (NSDictionary *)dictionaryWithResponseString:(NSString *)responseString
                                  responseData:(id)responseData
                                    statusCode:(NSInteger)statusCode;
- (NSDictionary *)cachedResponseDictionaryForRequest:(DXDALRequestHTTP *)request;
- (NSString *)cachedResponseStringFromDcitionary:(NSDictionary *)dictionary;
- (id)cachedResponseDataFromDcitionary:(NSDictionary *)dictionary;
- (NSInteger)cachedResponseStatusCodeFromDcitionary:(NSDictionary *)dictionary;

@end

@implementation DXDALDataProviderHTTPCached
@synthesize httpClient = _httpClient;

- (id)init
{
    self = [super init];
    if (self) {
        // by default we have max lifetime for cached object
        self.expirationInterval = DBL_MAX;
    }
    return self;
}

- (NSDictionary *)dictionaryWithResponseString:(NSString *)responseString
                                  responseData:(id)responseData
                                    statusCode:(NSInteger)statusCode
{
    NSMutableDictionary *responseDictionary = [NSMutableDictionary new];
    [responseDictionary setValue:responseString forKey:kResponseStringKey];
    [responseDictionary setValue:responseData forKey:kResponseDataKey];
    NSNumber *statusCodeNumber = [NSNumber numberWithInt:statusCode];
    [responseDictionary setValue:statusCodeNumber forKey:kStatusCodeKey];
    
    return responseDictionary;
}

- (NSDictionary *)cachedResponseDictionaryForRequest:(DXDALRequestHTTP *)request
{
    EGOCache *cache = [EGOCache currentCache];
    NSData *plistData = [cache plistForKey:request.httpPath];
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:plistData];
    return dictionary;
}

- (NSString *)cachedResponseStringFromDcitionary:(NSDictionary *)dictionary
{
    return [dictionary valueForKey:kResponseStringKey];
}

- (id)cachedResponseDataFromDcitionary:(NSDictionary *)dictionary
{
    return [dictionary valueForKey:kResponseDataKey];
}

- (NSInteger)cachedResponseStatusCodeFromDcitionary:(NSDictionary *)dictionary
{
    NSInteger code = [[dictionary valueForKey:kStatusCodeKey] integerValue];
    return code;
}

- (void)enqueueRequest:(DXDALRequestHTTP *)aRequest
{
    assert(aRequest != nil);
    BOOL isHTTPMethodGET = [((DXDALRequestHTTP *)aRequest).httpMethod.capitalizedString isEqualToString:@"GET"];
    NSAssert(isHTTPMethodGET, @"DXDALDataProviderHTTPCached : You should use request only with GET HTTP method");
    
    [_httpClient clearDefaultHeaders];
    
    DXDALRequestHTTP *httpRequest = (DXDALRequestHTTP*)aRequest;
    if (httpRequest.defaultHTTPHeaders){
        for (NSString *key in [httpRequest.defaultHTTPHeaders allKeys]){
            [_httpClient setDefaultHeader:key value:[httpRequest.defaultHTTPHeaders objectForKey:key]];
        }
    }
    
    EGOCache *cache = [EGOCache currentCache];
    BOOL isExistsValue = [cache hasCacheForKey:aRequest.httpPath];
    if (isExistsValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *responseDictionary = [self cachedResponseDictionaryForRequest:aRequest];
            NSString *responseString = [self cachedResponseStringFromDcitionary:responseDictionary];
            id responseObject = [self cachedResponseDataFromDcitionary:responseDictionary];
            NSInteger responseStatusCode = [self cachedResponseStatusCodeFromDcitionary:responseDictionary];
            
            [httpRequest didFinishWithResponseString:responseString
                                      responseObject:responseObject
                                  responseStatusCode:responseStatusCode];

        });
    } else {
        AFHTTPRequestOperation *operation = [self operationFromRequest:httpRequest];
        [_httpClient enqueueHTTPRequestOperation:operation];
    }
}

- (SuccessHandler)successHandlerWithHTTPRequest:(DXDALRequestHTTP*)httpRequest
{
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *assertMessage = @"DXDALDataProviderHTTPCached: Response object should be of NSDictionary class";
        NSAssert([responseObject isKindOfClass:[NSDictionary class]], assertMessage);
        
        [httpRequest didFinishWithResponseString:operation.responseString
                                  responseObject:responseObject
                              responseStatusCode:operation.response.statusCode];
        
        
        EGOCache *cache = [EGOCache currentCache];
        NSDictionary *responseDictionary = [self dictionaryWithResponseString:operation.responseString
                                                                 responseData:responseObject
                                                                   statusCode:operation.response.statusCode];
        [cache setPlist:responseDictionary forKey:httpRequest.httpPath withTimeoutInterval:self.expirationInterval];
    };
}

- (ErrorHandler)errorHandlerWithHTTPRequest:(DXDALRequestHTTP*)httpRequest
{
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        [httpRequest didFailWithResponse:error];
    };
}

- (AFHTTPRequestOperation*)operationFromRequest:(DXDALRequestHTTP*)httpRequest
{
    NSURLRequest *urlRequest = [self urlRequestFromRequest:httpRequest];
    
    SuccessHandler success = [self successHandlerWithHTTPRequest:httpRequest];
    ErrorHandler failure = [self errorHandlerWithHTTPRequest:httpRequest];
    
    AFHTTPRequestOperation *operation = [self.httpClient HTTPRequestOperationWithRequest:urlRequest
                                                                                 success:success
                                                                                 failure:failure];
    
    void (^progressBlock)(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead);
    progressBlock = ^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        float progress =  (float)totalBytesRead / (float)totalBytesExpectedToRead;
        float delta = (float)bytesRead / (float)totalBytesExpectedToRead;
        [httpRequest didChangeProgressValue:progress progressDelta:delta];
    };
    [operation setDownloadProgressBlock:progressBlock];
    
    return operation;
}

@end

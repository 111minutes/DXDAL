//
//  DXDALDataProviderHTTPCached.m
//  DXDAL
//
//  Created by Me on 18.10.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DXDALDataProviderHTTPCached.h"
#import "JSONKit.h"
#import "DXDALRequestHTTP.h"
#import "DXDALParser.h"
#import "DXDALMapper.h"
#import "EGOCache.h"

#define kStatusCodeKey @"statusCode"
#define kResponseStringKey @"responseString"
#define kResponseDataKey @"responseData"

@interface DXDALDataProviderHTTPCached ()

- (NSDictionary *)dictionaryWithResponseString:(NSString *)responseString
                                  responseData:(id)responseData
                                    statusCode:(NSInteger)statusCode;
- (NSDictionary *)cachedResponseDictionaryForRequest:(DXDALRequestHTTP *)request;
- (NSString *)cachedResponseStringFromDcitionary:(NSDictionary *)dictionary;
- (id)cachedResponseDataFromDcitionary:(NSDictionary *)dictionary;
- (NSInteger)cachedResponseStatusCodeFromDcitionary:(NSDictionary *)dictionary;
- (NSString *)keyFromRequest:(DXDALRequestHTTP *)request;

@end

@implementation DXDALDataProviderHTTPCached

- (id)initWithBaseURL:(NSURL*)aBaseURL {
    self = [super initWithBaseURL:aBaseURL];
    if (self) {
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
    EGOCache *cache = [EGOCache globalCache];
    NSData *plistData = [cache dataForKey:[self keyFromRequest:request]];
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

- (NSString *)keyFromRequest:(DXDALRequestHTTP *)request
{
    return [request.httpPath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

- (void)checkHTTPMethodForRequest:(DXDALRequestHTTP *)request
{
    BOOL isHTTPMethodGET = [request.httpMethod.uppercaseString isEqualToString:@"GET"];
    NSAssert(isHTTPMethodGET, @"DXDALDataProviderHTTPCached : You should use request only with GET HTTP method");
}

- (void)enqueueRequest:(DXDALRequestHTTP *)aRequest
{
    assert(aRequest != nil);
    [self checkHTTPMethodForRequest:aRequest];
    
    [self.httpClient clearDefaultHeaders];
    
    DXDALRequestHTTP *httpRequest = (DXDALRequestHTTP*)aRequest;
    if (httpRequest.defaultHTTPHeaders){
        for (NSString *key in [httpRequest.defaultHTTPHeaders allKeys]){
            [self.httpClient setDefaultHeader:key value:[httpRequest.defaultHTTPHeaders objectForKey:key]];
        }
    }
    
    EGOCache *cache = [EGOCache globalCache];
    BOOL isExistsValue = [cache dataForKey:[self keyFromRequest:aRequest]] != nil;
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
        [self.httpClient enqueueHTTPRequestOperation:operation];
    }
}

- (DXDALAFSuccessHandler)successHandlerWithHTTPRequest:(DXDALRequestHTTP*)httpRequest
{
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
                
        EGOCache *cache = [EGOCache globalCache];
        NSDictionary *responseDictionary = [self dictionaryWithResponseString:operation.responseString
                                                                 responseData:responseObject
                                                                   statusCode:operation.response.statusCode];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDictionary];
        [cache setData:data forKey:[self keyFromRequest:httpRequest] withTimeoutInterval:self.expirationInterval];
        
        [httpRequest didFinishWithResponseString:operation.responseString
                                  responseObject:responseObject
                              responseStatusCode:operation.response.statusCode];
    };
}

- (DXDALAFErrorHandler)errorHandlerWithHTTPRequest:(DXDALRequestHTTP*)httpRequest
{
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        [httpRequest didFailWithResponse:error];
    };
}

@end

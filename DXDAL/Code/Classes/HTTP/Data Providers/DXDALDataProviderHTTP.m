//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "DXDALDataProviderHTTP.h"
#import "DXDALRequestHTTP.h"
#import "DXDALParser.h"
#import "DXDALMapper.h"


@implementation DXDALDataProviderHTTP
@synthesize httpClient = _httpClient;

- (id)initWithBaseURL:(NSURL*)aBaseURL {
    self = [super init];
    if (self) {
        self.httpClient = [[DXDALHTTPClient alloc] initWithBaseURL:aBaseURL];
    }
    return self;
}

- (void)enqueueRequest:(DXDALRequest *)aRequest {
    assert(aRequest != nil);
    
    [_httpClient clearDefaultHeaders];

    DXDALRequestHTTP *httpRequest = (DXDALRequestHTTP*)aRequest;
    if (httpRequest.defaultHTTPHeaders){
        for (NSString *key in [httpRequest.defaultHTTPHeaders allKeys]){
            [_httpClient setDefaultHeader:key value:[httpRequest.defaultHTTPHeaders objectForKey:key]];
        }
    }
    
    AFHTTPRequestOperation *operation = [self operationFromRequest:httpRequest];
    
    httpRequest.requestOperation = operation;
    
    [_httpClient enqueueHTTPRequestOperation:operation];
}

- (NSURLRequest*)urlRequestFromRequest:(DXDALRequestHTTP*) httpRequest
{
    return [_httpClient requestWithMethod:httpRequest.httpMethod path:httpRequest.httpPath parameters:httpRequest.params];
}

- (AFHTTPRequestOperation*) operationFromRequest:(DXDALRequestHTTP*) httpRequest
{
    NSURLRequest *urlRequest = [self urlRequestFromRequest:httpRequest];
    NSLog(@"start request: %@", [urlRequest URL]);
    
    DXDALAFSuccessHandler success = [self successHandlerWithHTTPRequest:httpRequest];
    DXDALAFErrorHandler failure = [self errorHandlerWithHTTPRequest:httpRequest];
	AFHTTPRequestOperation *operation = [_httpClient HTTPRequestOperationWithRequest:urlRequest
                                                                             success:success
                                                                             failure:failure];
    
    
    void (^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);
    progressBlock = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float progress =  (float)totalBytesRead / (float)totalBytesExpectedToRead;
        float delta = (float)bytesRead / (float)totalBytesExpectedToRead;
        [httpRequest didChangeProgressValue:progress progressDelta:delta];
    };
    [operation setDownloadProgressBlock:progressBlock];
    
    return operation;
}

- (DXDALAFSuccessHandler)successHandlerWithHTTPRequest:(DXDALRequestHTTP*)httpRequest
{
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        [httpRequest didFinishWithResponseString:operation.responseString
                                  responseObject:responseObject
                              responseStatusCode:operation.response.statusCode];
        
    };
}

- (DXDALAFErrorHandler)errorHandlerWithHTTPRequest:(DXDALRequestHTTP*)httpRequest
{
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSMutableDictionary *userInfo = [[error userInfo] mutableCopy];
        
        NSDictionary *serverErrorMessage = [operation.responseString objectFromJSONString];
        
        if (serverErrorMessage) {
            [userInfo setObject:serverErrorMessage forKey:@"ErrorMessage"];
        } else if (operation.responseString) {
            [userInfo setObject:operation.responseString forKey:@"ErrorMessage"];
        }
        
        
        NSError *innerError = [[NSError alloc] initWithDomain:@"DXDAL"
                                                         code:operation.response.statusCode
                                                     userInfo:userInfo];
        
        [httpRequest didFailWithResponse:innerError];
    };
}

@end
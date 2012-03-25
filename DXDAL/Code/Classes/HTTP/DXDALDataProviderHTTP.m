//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DXDALDataProviderHTTP.h"
#import "DXDALRequestHTTP.h"
#import "AFNetworking.h"
#import "DXDALResponseParserJSON.h"   
#import "JSONKit.h"


@implementation DXDALDataProviderHTTP
@synthesize httpClient = _httpClient;

- (id)initWithBaseURL:(NSURL*)aBaseURL {
    self = [super init];
    if (self) {
        _httpClient = [[DXDALHTTPClient alloc] initWithBaseURL:aBaseURL];
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
    
	AFHTTPRequestOperation *operation = [_httpClient HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result = [httpRequest.parser parseJSON:operation.responseString withEntityClass:httpRequest.entityClass];
        
        [httpRequest didFinishWithResponse:result];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSMutableDictionary *userInfo = [[error userInfo] mutableCopy];
        
        NSDictionary *serverErrorMessage = [operation.responseString objectFromJSONString];
        
        if (serverErrorMessage) {
            [userInfo setObject:serverErrorMessage forKey:@"ErrorMessage"];
        }
        
        
        NSError *innerError = [[NSError alloc] initWithDomain:@"DXDAL" 
                                                         code:operation.response.statusCode 
                                                     userInfo:userInfo];
        
        [httpRequest didFailWithResponse:innerError];
    }];
    return operation;
}

@end
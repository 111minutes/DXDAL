//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DXDALDataProviderHTTP.h"
#import "DXDALRequestHTTP.h"
#import "AFNetworking.h"

@implementation DXDALDataProviderHTTP {
    AFHTTPClient *_httpClient;
}

- (id)initWithBaseURL:(NSURL*)aBaseURL {
    self = [super init];
    if (self) {
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:aBaseURL];
    }
    return self;
}

- (DXDALRequest *)prepareRequest {
    return [[DXDALRequestHTTP alloc] initWithDataProvider:self];
}

- (void)enqueueRequest:(DXDALRequest *)aRequest {
    assert(aRequest != nil);
    
    DXDALRequestHTTP *httpRequest = (DXDALRequestHTTP*)aRequest;
    
    NSURLRequest *urlRequest = [_httpClient requestWithMethod:httpRequest.httpMethod path:httpRequest.httpPath parameters:httpRequest.params];
    
	AFHTTPRequestOperation *operation = [_httpClient HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [aRequest didFinishWithResponse:operation.responseString];
    } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSMutableDictionary *userInfo = [[error userInfo] mutableCopy];
     
     [userInfo setObject:operation.responseString forKey:@"ErrorMessage"];
     
     NSError *innerError = [[NSError alloc] initWithDomain:@"DXDAL" 
                                                      code:operation.response.statusCode 
                                                  userInfo:userInfo];
     
     [aRequest didFailWithResponse:innerError];
     
    }];
    [_httpClient enqueueHTTPRequestOperation:operation];
}


@end
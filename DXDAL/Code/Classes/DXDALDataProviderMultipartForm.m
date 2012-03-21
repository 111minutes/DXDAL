//
//  DXDALDataProviderMultipartForm.m
//  DXDAL
//
//  Created by Maxim Letushov on 3/21/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALDataProviderMultipartForm.h"

#import "AFHTTPClient.h"
#import "DXDALRequestHTTP.h"
#import "DXDALRequestMultipartForm.h"
#import "DXDALResponseParserJSON.h"   
#import "AFNetworking.h"
#import "JSONKit.h"


@implementation DXDALDataProviderMultipartForm {
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
    return [[DXDALRequestMultipartForm alloc] initWithDataProvider:self];
}

- (void)enqueueRequest:(DXDALRequest *)aRequest {
    assert(aRequest != nil);
    
    DXDALRequestMultipartForm *multipartFormRequest = (DXDALRequestMultipartForm*)aRequest;
    if (multipartFormRequest.defaultHTTPHeaders){
        for (NSString *key in [multipartFormRequest.defaultHTTPHeaders allKeys]){
            [_httpClient setDefaultHeader:key value:[multipartFormRequest.defaultHTTPHeaders objectForKey:key]];
        }
    }
        
    NSURLRequest *urlRequest = [_httpClient multipartFormRequestWithMethod:multipartFormRequest.httpMethod path:multipartFormRequest.httpPath parameters:multipartFormRequest.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       
        [formData appendPartWithFileURL:[NSURL URLWithString:multipartFormRequest.fileURLstring] name:multipartFormRequest.fileName error:nil];
    }];
    
    NSLog(@"start request: %@", [urlRequest URL]);
    
	AFHTTPRequestOperation *operation = [_httpClient HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result = [multipartFormRequest.parser parseJSON:operation.responseString withEntityClass:multipartFormRequest.entityClass];
        
        [aRequest didFinishWithResponse:result];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSMutableDictionary *userInfo = [[error userInfo] mutableCopy];
        
        NSDictionary *serverErrorMessage = [operation.responseString objectFromJSONString];
        
        if (serverErrorMessage) {
            [userInfo setObject:serverErrorMessage forKey:@"ErrorMessage"];
        }
        
        
        NSError *innerError = [[NSError alloc] initWithDomain:@"DXDAL" 
                                                         code:operation.response.statusCode 
                                                     userInfo:userInfo];
        
        [aRequest didFailWithResponse:innerError];
        
    }];
    
    [_httpClient enqueueHTTPRequestOperation:operation];
}

@end
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

@implementation DXDALDataProviderMultipartForm

- (DXDALRequest *)prepareRequest {
    return [[DXDALRequestMultipartForm alloc] initWithDataProvider:self];
}

- (NSURLRequest*)urlRequestFromRequest:(DXDALRequest*) request {
    DXDALRequestMultipartForm *multipartFormRequest = (DXDALRequestMultipartForm*) request;
    NSURLRequest *urlRequest = [self.httpClient multipartFormRequestWithMethod:multipartFormRequest.httpMethod path:multipartFormRequest.httpPath parameters:multipartFormRequest.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:[NSURL URLWithString:multipartFormRequest.fileURLstring] name:multipartFormRequest.fileName error:nil];
    }];
    return urlRequest;
}



@end
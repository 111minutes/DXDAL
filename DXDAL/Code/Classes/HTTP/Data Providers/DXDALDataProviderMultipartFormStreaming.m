//
//  DXDALDataProviderMultipartFormStreaming.m
//  DXDAL
//
//  Created by Maxim on 10/5/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALDataProviderMultipartFormStreaming.h"
#import "DXDALRequestMultipartStreaming.h"

@implementation DXDALDataProviderMultipartFormStreaming

- (NSMutableURLRequest *)urlRequestFromRequest:(DXDALRequestHTTP *) httpRequest {
    DXDALRequestMultipartStreaming *multipartStreamingRequest = (DXDALRequestMultipartStreaming*) httpRequest;
    
    NSMutableURLRequest *urlRequest = [self.httpClient multipartFormRequestWithMethod:multipartStreamingRequest.httpMethod path:multipartStreamingRequest.httpPath parameters:multipartStreamingRequest.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }];
    
    if (multipartStreamingRequest.timeout > 0) {
        [urlRequest setTimeoutInterval:multipartStreamingRequest.timeout];
    }
    
    return urlRequest;
}

- (AFHTTPRequestOperation *)operationFromRequest:(DXDALRequestHTTP *)aHttpRequest {
    
    DXDALRequestMultipartStreaming *streamingRequest = (DXDALRequestMultipartStreaming *)aHttpRequest;
    AFHTTPRequestOperation *operation = [super operationFromRequest:aHttpRequest];
    
    operation.inputStream = [NSInputStream inputStreamWithFileAtPath:streamingRequest.pathForResource];
    
    return operation;
}

@end
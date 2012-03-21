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

- (void)enqueueRequest:(DXDALRequest *)aRequest {
    assert(aRequest != nil);
    
    DXDALRequestMultipartForm *httpRequest = (DXDALRequestMultipartForm*)aRequest;
    if (httpRequest.defaultHTTPHeaders){
        for (NSString *key in [httpRequest.defaultHTTPHeaders allKeys]){
            [self.httpClient setDefaultHeader:key value:[httpRequest.defaultHTTPHeaders objectForKey:key]];
        }
    }
    
    NSURLRequest *urlRequest = [self urlRequestFromRequest:httpRequest];
    NSLog(@"start request: %@", [urlRequest URL]);
    
    AFHTTPRequestOperation *operation = [self operationFromURLRequest:urlRequest request:httpRequest];
    
    __block NSString *videoURL = httpRequest.fileURLstring;
    __block NSInteger prevNotificationBytesCount = 0;
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {

        BOOL isNeedSendNotification = NO;
        
        NSMutableDictionary *params = nil;
        
        int part = totalBytesExpectedToWrite / 20;
        if (totalBytesWritten - prevNotificationBytesCount > part) {
            prevNotificationBytesCount = totalBytesWritten;
            isNeedSendNotification = YES;
        }
        
        if (isNeedSendNotification) {
            params = [NSMutableDictionary new];
            [params setValue:videoURL forKey:VideoNotificationURL];
            [params setValue:[NSNumber numberWithFloat:totalBytesWritten/totalBytesExpectedToWrite] forKey:VideoNotificationProgress];
            
            prevNotificationBytesCount = totalBytesWritten;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadingProgressNotificationName object:nil userInfo:params];
        }
        
    }];
    
    [self.httpClient enqueueHTTPRequestOperation:operation];
}



@end


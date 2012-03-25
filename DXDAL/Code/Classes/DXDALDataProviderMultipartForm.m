//
//  DXDALDataProviderMultipartForm.m
//  DXDAL
//
//  Created by Maxim Letushov on 3/21/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALDataProviderMultipartForm.h"

#import "DXDALRequestMultipartForm.h"
#import "DXDALResponseParserJSON.h"   
#import "AFNetworking.h"
#import "JSONKit.h"

@implementation DXDALDataProviderMultipartForm

//- (DXDALRequest *)prepareRequest {
//    return [[DXDALRequestMultipartForm alloc] initWithDataProvider:self];
//}

- (NSURLRequest*)urlRequestFromRequest:(DXDALRequestHTTP*) httpRequest{
    DXDALRequestMultipartForm *multipartFormRequest = (DXDALRequestMultipartForm*) httpRequest;
    NSURLRequest *urlRequest = [self.httpClient multipartFormRequestWithMethod:multipartFormRequest.httpMethod path:multipartFormRequest.httpPath parameters:multipartFormRequest.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:[NSURL URLWithString:multipartFormRequest.fileURLstring] name:multipartFormRequest.name error:nil];
    }];
    return urlRequest;
}

- (AFHTTPRequestOperation*) operationFromRequest:(DXDALRequestHTTP *)aHttpRequest
{
    AFHTTPRequestOperation* operation = [super operationFromRequest:aHttpRequest];
    
    DXDALRequestMultipartForm* httpRequest = (DXDALRequestMultipartForm*)aHttpRequest;
    
    __block NSString *videoURL = httpRequest.fileURLstring;
    __block NSInteger prevNotificationBytesCount = 0;
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        
        int part = totalBytesExpectedToWrite / 20;
        
        if(totalBytesWritten !=prevNotificationBytesCount) {
            if (totalBytesWritten == totalBytesExpectedToWrite || totalBytesWritten - prevNotificationBytesCount > part) {
                
                prevNotificationBytesCount = totalBytesWritten;
                
                NSMutableDictionary *params = [NSMutableDictionary new];
                [params setValue:videoURL forKey:VideoNotificationURL];
                float value = totalBytesWritten;
                [params setValue:[NSNumber numberWithFloat:value/totalBytesExpectedToWrite] forKey:VideoNotificationProgress];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadingProgressNotificationName object:nil userInfo:params];
            }
        }
    }];
    
    return operation;
}

@end


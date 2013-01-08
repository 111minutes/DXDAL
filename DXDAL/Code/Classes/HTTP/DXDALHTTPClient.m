//
//  DXDALHTTPClient.m
//  DXDAL
//
//  Created by Malaar on 25.03.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALHTTPClient.h"

@implementation DXDALHTTPClient


- (NSMutableURLRequest *)rawDataRequestWithMethod:(NSString *)method
                                             path:(NSString *)path
                                       parameters:(NSDictionary *)parameters
                                          rawData:(NSData *)rawData
{
    NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:nil];
    
    [request setHTTPBody:rawData];
    
    return request;
}

- (void) clearDefaultHeaders
{
    NSMutableDictionary *defaultHeaders = [self valueForKey:@"_defaultHeaders"];
    
    [defaultHeaders removeAllObjects];
}

@end

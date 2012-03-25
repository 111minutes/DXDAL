//
//  DXDALHTTPClient.m
//  DXDAL
//
//  Created by Malaar on 25.03.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALHTTPClient.h"

@implementation DXDALHTTPClient

- (void) clearDefaultHeaders
{
    NSMutableDictionary *defaultHeaders = [self valueForKey:@"_defaultHeaders"];
    
    [defaultHeaders removeAllObjects];
}

@end

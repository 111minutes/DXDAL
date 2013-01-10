//
//  DXDALDataProviderHTTPCached.h
//  DXDAL
//
//  Created by Me on 18.10.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DXDALDataProviderHTTP.h"

@interface DXDALDataProviderHTTPCached : DXDALDataProviderHTTP

@property (nonatomic) NSTimeInterval expirationInterval;

- (void)checkHTTPMethodForRequest:(DXDALRequestHTTP *)request;

@end

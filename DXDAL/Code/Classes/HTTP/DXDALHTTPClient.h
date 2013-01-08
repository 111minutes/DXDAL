//
//  DXDALHTTPClient.h
//  DXDAL
//
//  Created by Malaar on 25.03.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "AFHTTPClient.h"

@interface DXDALHTTPClient : AFHTTPClient

- (NSMutableURLRequest *)rawDataRequestWithMethod:(NSString *)method
                                             path:(NSString *)path
                                       parameters:(NSDictionary *)parameters
                                          rawData:(NSData *)rawData;

- (void) clearDefaultHeaders;

@end

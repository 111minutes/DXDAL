//
//  DXDALRequestHTTPRawData.m
//  DXDAL
//
//  Created by Yuriy Bosov on 4/13/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALRequestHTTPRawData.h"

@implementation DXDALRequestHTTPRawData

- (void) didFinishWithResponseString:(NSString *)responseString responseStatusCode:(NSInteger)responseStatusCode {
    NSNumber *statusCode = [NSNumber numberWithInteger:responseStatusCode];
    if (responseStatusCode == 200) {
        [self didFinishWithResponse:statusCode];
    } else {
        [self didFailWithResponse:statusCode];
    }
}

@end

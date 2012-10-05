//
//  DXDALRequestMultipartStreaming.h
//  DXDAL
//
//  Created by Maxim on 10/5/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXDALRequestHTTP.h"

@interface DXDALRequestMultipartStreaming : DXDALRequestHTTP

@property (nonatomic, strong) NSString *pathForResource;
@property (nonatomic, assign) NSInteger timeout;

@end

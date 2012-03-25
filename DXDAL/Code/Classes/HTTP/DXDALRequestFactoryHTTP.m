//
//  DXDALRequestFactoryHTTP.m
//  DXDAL
//
//  Created by Malaar on 25.03.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALRequestFactoryHTTP.h"
#import "DXDALRequestHTTP.h"
#import "DXDALDataProviderHTTP.h"


@implementation DXDALRequestFactoryHTTP

- (id <DXDALDataProvider>)getDataProvider
{
    return [DXDALDataProviderHTTP new];
}

- (Class)getDefaultRequestClass
{
    return [DXDALRequestHTTP class];
}


@end

//
//  DXDALDataProviderMultipartForm.h
//  DXDAL
//
//  Created by Maxim Letushov on 3/21/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <JSONKit/JSONKit.h>
#import "DXDALDataProviderHTTP.h"

#define VideoUploadingProgressNotificationName @"VideoUploadingProgressNotificationName"
#define VideoNotificationURL @"VideoNotificationURL"
#define VideoNotificationProgress @"VideoNotificationProgress"

@interface DXDALDataProviderMultipartForm : DXDALDataProviderHTTP


@end

//
//  DXDALRequestMultipartForm.h
//  DXDAL
//
//  Created by Maxim Letushov on 3/21/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXDALRequestHTTP.h"

@interface DXDALRequestMultipartForm : DXDALRequestHTTP

@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileURLstring;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, readwrite) int timeout;
@end

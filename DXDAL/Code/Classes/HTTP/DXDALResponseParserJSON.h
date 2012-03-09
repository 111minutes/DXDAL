//
//  DXDALResponseParserJSON.h
//  DXDAL
//
//  Created by Sergey Zenchenko on 3/9/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DXDALRequestHTTP;

@interface DXDALResponseParserJSON : NSObject

- (id)parseJSON:(NSString*)json fromRequest:(DXDALRequestHTTP*)httpRequest;

@end

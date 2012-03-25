//
//  DXDALResponseParserJSON.m
//  DXDAL
//
//  Created by Sergey Zenchenko on 3/9/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALParserJSON.h"
#import "JSONKit.h"
//#import "DXDALRequestHTTP.h"

@implementation DXDALParserJSON

- (id) parseString:(NSString *)aString
{
    return [aString objectFromJSONString];
}


@end

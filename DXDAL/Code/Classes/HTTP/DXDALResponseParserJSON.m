//
//  DXDALResponseParserJSON.m
//  DXDAL
//
//  Created by Sergey Zenchenko on 3/9/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALResponseParserJSON.h"
#import "NSObject+JTObjectMapping.h"
#import "JSONKit.h"
#import "DXDALRequestHTTP.h"

@implementation DXDALResponseParserJSON

- (id)parseJSON:(NSString*)json fromRequest:(DXDALRequestHTTP*)httpRequest {
    id jsonResult = [json objectFromJSONString];
    
    id result = nil;
    if ([jsonResult isKindOfClass:[NSArray class]]) {
        result = [NSMutableArray new];
        for (NSDictionary *dict in jsonResult) {
            NSObject *obj = [httpRequest.entityClass objectFromJSONObject:dict mapping:httpRequest.mapping];
            [result addObject:obj];
        }
    } else {
        result = [httpRequest.entityClass objectFromJSONObject:jsonResult mapping:httpRequest.mapping];
    }
    
    return result;
}

@end

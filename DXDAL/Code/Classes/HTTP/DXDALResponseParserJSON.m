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


- (id)parseJSON:(NSString *)json withEntityClass:(Class)entityClass {
    id jsonResult = [json objectFromJSONString];

    id result = nil;
    if ([jsonResult isKindOfClass:[NSArray class]]) {
        result = [NSMutableArray new];
        for (NSDictionary *dict in jsonResult) {
            NSObject *obj = [entityClass objectFromJSONObject:dict mapping:[entityClass mapping]];
            [result addObject:obj];
        }
    } else {
        result = [entityClass objectFromJSONObject:jsonResult mapping:[entityClass mapping]];
    }

    return result;
}


@end

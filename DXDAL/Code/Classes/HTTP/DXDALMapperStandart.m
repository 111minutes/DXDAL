
//
//  DXDALMapperStandart.m
//  DXDAL
//
//  Created by Malaar on 25.03.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALMapperStandart.h"
#import "NSObject+JTObjectMapping.h"


@implementation DXDALMapperStandart

- (id) mapFromInputData:(id)inputData withClass:(Class)mappingClass
{
    id result = nil;
    if ([inputData isKindOfClass:[NSArray class]]) {
        result = [NSMutableArray new];
        for (NSDictionary *dict in inputData) {
            NSObject *obj = [mappingClass objectFromJSONObject:dict mapping:[mappingClass mapping]];
            [result addObject:obj];
        }
    } else {
        result = [mappingClass objectFromJSONObject:inputData mapping:[mappingClass mapping]];
    }
    
    return result;
}

@end

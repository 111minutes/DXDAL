//
//  DXDALPaginationParser.m
//  DXDAL
//
//  Created by Max Mashkov on 9/5/13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "DXDALPaginationParser.h"

@implementation DXDALPaginationParser

- (id) parseString:(NSString *)aString
{
    id result = [super parseString:aString];
    id parserResult = nil;
    
    if ([result isKindOfClass:[NSDictionary class]] && self.entitiesKey) {
        if ([result[self.entitiesKey] isKindOfClass:[NSArray class]]) {
            parserResult = [[NSArray alloc] initWithArray:result[self.entitiesKey]];
        }
    }
    
    return parserResult ? : result;
}

@end

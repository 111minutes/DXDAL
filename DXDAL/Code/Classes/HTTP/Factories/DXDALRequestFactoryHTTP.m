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
#import "DXDALPaginationParser.h"

@implementation DXDALRequestFactoryHTTP

- (id <DXDALDataProvider>)getDataProvider
{
    if ([self baseURL]) {
        return [[DXDALDataProviderHTTP alloc] initWithBaseURL:[NSURL URLWithString:[self baseURL]]];
    } else {
        return [DXDALDataProviderHTTP new];
    }
}

- (NSString *) baseURL
{
    return nil;
}

- (Class)getDefaultRequestClass
{
    return [DXDALRequestHTTP class];
}

- (void)setupDefaults
{
    [super setupDefaults];
    
    __weak DXDALRequestFactoryHTTP *__self = self;
    
    [self addDefaultConfig:^(DXDALRequestHTTP *request) {
        
        if (!request.parser) {
            request.parser = [DXDALParserJSON new];
        }
        
        if (!request.httpMethod) {
            request.httpMethod = @"GET";
        }
        
        request.timeoutInterval = 30.f;
        request.needsBackgrounding = YES;
        
        if (!request.entityClass && NSStringFromClass([__self defaultRequestEntityClass])) {
            request.entityClass = [__self defaultRequestEntityClass];
        }
        
        if ([request.parser isKindOfClass:[DXDALPaginationParser class]]) {
            [(DXDALPaginationParser *)[request parser] setEntitiesKey:[__self defaultRequestEntitiesKey]];
        }
    }];
}


@end

//
//  DXDALRequestHTTPPagination.m
//  DXDAL
//
//  Created by Yuriy Bosov on 4/5/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALRequestHTTPPagination.h"
#import "DXDALPaginationParser.h"

@implementation DXDALRequestHTTPPagination

- (id) initWithDataProvider:(id<DXDALDataProvider>)dataProvider
{
    self = [super initWithDataProvider:dataProvider];
    if (self)
    {
        // default value 
        self.pageTitle = @"page";
        self.countPerPageTitle = @"count";
        self.countPerPage = 20;
        self.startPageNumber = 0;
        self.parser = [DXDALPaginationParser new];
    }
    return self;
}

- (void)setEntitiesKey:(NSString *)entitiesKey
{
    if (_entitiesKey != entitiesKey) {
        _entitiesKey = entitiesKey;
        if ([self.parser respondsToSelector:@selector(setEntitiesKey:)]) {
            [self.parser performSelector:@selector(setEntitiesKey:) withObject:entitiesKey];
        }
    }
}

- (void) loadNextPage
{
    [self addParam:[NSString stringWithFormat:@"%d",currentPage] withName:_pageTitle];
    [self addParam:[NSString stringWithFormat:@"%d",_countPerPage] withName:_countPerPageTitle];
    [super start];
}

- (void) rezetRequest
{
    currentPage = _startPageNumber;
}

- (void)didFinishWithResponse:(NSDictionary *)response 
{
    assert(response != nil);
    currentPage++;
    [super didFinishWithResponse:response];
}

- (void) setStartPageNumber:(NSUInteger)aStartPageNumber
{
    _startPageNumber = aStartPageNumber;
    currentPage = _startPageNumber;
}

@end

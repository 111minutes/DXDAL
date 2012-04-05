//
//  DXDALRequestHTTPPagination.m
//  DXDAL
//
//  Created by Yuriy Bosov on 4/5/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALRequestHTTPPagination.h"

@implementation DXDALRequestHTTPPagination

@synthesize pageTitle;
@synthesize countPerPageTitle;
@synthesize startPageNumber;
@synthesize countPerPage;

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
    }
    return self;
}

- (void) loadNextPage
{
    [self addParam:[NSString stringWithFormat:@"%d",currentPage] withName:pageTitle];
    [self addParam:[NSString stringWithFormat:@"%d",countPerPage] withName:countPerPageTitle];
    [super start];
}

- (void) rezetRequest
{
    currentPage = startPageNumber;
}

- (void)didFinishWithResponse:(NSDictionary *)response 
{
    assert(response != nil);
    currentPage++;
    [super didFinishWithResponse:response];
}

@end

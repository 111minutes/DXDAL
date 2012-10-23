//
//  DXDALRequestHTTPPagination.h
//  DXDAL
//
//  Created by Yuriy Bosov on 4/5/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDALRequestHTTP.h"

@interface DXDALRequestHTTPPagination : DXDALRequestHTTP
{
@private
    NSUInteger currentPage;
}

@property (strong, nonatomic) NSString *pageTitle;
@property (strong, nonatomic) NSString *countPerPageTitle;
@property (nonatomic) NSUInteger startPageNumber;
@property (nonatomic) NSUInteger countPerPage;

- (void) rezetRequest;
- (void) loadNextPage;

@end

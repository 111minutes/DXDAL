//
//  DXDALTests.m
//  DXDALTests
//
//  Created by Sergey Zenchenko on 3/1/12.
//  Copyright (c) 2012 DIMALEX. All rights reserved.
//

#import "DXDALTests.h"
#import "UsersAPI.h"
#import "DXDALRequest.h"
#import "DXDALHTTPRequest.h"
#import "OCMock.h"

@implementation DXDALTests

- (void)testLogin {
    
    UsersAPI *usersAPI = [UsersAPI new];

    NSAssert(usersAPI != nil, @"Can't create api");
    
    DXDALRequest *request = [usersAPI loginWithLogin:@"test" password:@"test"];

    assert(request);
    
    __block BOOL success = NO;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    [request addSuccessHandler:^(DXDALRequestResponse *resp){
        success = YES;
        dispatch_semaphore_signal(sema);
    }];        
    
    [request start];
    
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    assert(success);
    
}

@end

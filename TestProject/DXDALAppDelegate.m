//
//  DXDALAppDelegate.m
//  TestProject
//
//  Created by Sergey Zenchenko on 3/2/12.
//  Copyright (c) 2012 DIMALEX. All rights reserved.
//

#import "DXDALAppDelegate.h"
#import "UsersAPI.h"
#import "DXDALRequest.h"
#import "User.h"

@implementation DXDALAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];    
    
    UsersAPI *api = [UsersAPI new];
    
    User *u = [User new];
    
    u.name = @"test3";
    u.email = @"test3@asd.com";
    u.password = @"qweqweqwe";
    u.passwordConfirmation = @"qweqweqwe";
    u.username = @"test3";
    u.age = @"100";
    
    DXDALRequest *request = [api headRequest];
    
    [request addSuccessHandler:^(id response){
        NSLog(@"Response = %@", response);
    }];

    [request addErrorHandler:^(NSError *error){
        NSLog(@"Error = %@", [error userInfo]);
    }];
    
    [request start];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

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
@implementation DXDALAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];    
    
    UsersAPI *api = [UsersAPI new];
    
    DXDALRequest *request = [api loginWithLogin:@"login" password:@"password"];
    
    [request addSuccessHandler:^(DXDALRequestResponse *response){
        self.window.backgroundColor = [UIColor whiteColor];
    }];
    
    [request addErrorHandler:^(NSError *error){
        self.window.backgroundColor = [UIColor redColor];
    }];
    
    [request start];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end

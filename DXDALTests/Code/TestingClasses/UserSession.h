//
//  UserSession.h
//  DXDAL
//
//  Created by Sergey Zenchenko on 3/9/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *token;

@end

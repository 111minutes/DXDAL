//
//  User.h
//  DXDAL
//
//  Created by Sergey Zenchenko on 3/9/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *passwordConfirmation;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *age;

@end

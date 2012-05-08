//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UsersAPI.h"
#import "DXDALRequestHTTP.h"
#import "DXDALDataProviderHTTP.h"
#import "UserSession.h"

@implementation UsersAPI

- (id <DXDALDataProvider>)getDataProvider {
    return [[DXDALDataProviderHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"http://0.0.0.0:3000"]];
}

- (void)setupDefaults {
    
}

- (DXDALRequest *)loginWithLogin:(NSString *)login password:(NSString *)password {
    return [self buildRequestWithConfigBlock:^(DXDALRequestHTTP *request) {
        request.httpMethod = @"Post";
        request.httpPath = @"/api/user_sessions";
        
        request.entityClass = [UserSession class];
        
        //request.mapping = [NSDictionary dictionaryWithObject:@"token" forKey:@"token"];
        
        [request addParam:login withName:@"email"];
        [request addParam:password withName:@"password"];
    }];
}

- (DXDALRequest *)signUpWithUser:(User*)user; {
    return [self buildRequestWithConfigBlock:^(DXDALRequestHTTP *request) {
        request.httpMethod = @"Post";
        request.httpPath = @"/api/users";
        
        request.entityClass = [User class];
        
        NSMutableDictionary *mapping = [NSMutableDictionary new];
        
        [mapping setObject:@"email" forKey:@"email"];
        [mapping setObject:@"name" forKey:@"name"];
        [mapping setObject:@"username" forKey:@"username"];
        [mapping setObject:@"password" forKey:@"password"];
        [mapping setObject:@"password_confirmation" forKey:@"passwordConfirmation"];
        [mapping setObject:@"age" forKey:@"age"];
        
        //request.mapping = mapping;
        
        [request addParam:user.name withName:@"user[name]"];
        [request addParam:user.email withName:@"user[email"];
        [request addParam:user.age withName:@"user[age"];
        [request addParam:user.username withName:@"user[username"];
        [request addParam:user.password withName:@"user[password"];
        [request addParam:user.passwordConfirmation withName:@"user[password_confirmation"];
    }];
}


@end
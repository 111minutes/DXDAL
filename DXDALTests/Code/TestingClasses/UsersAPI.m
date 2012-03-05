//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UsersAPI.h"
#import "DXDALRequestHTTP.h"
#import "DXDALDataProviderHTTP.h"

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

        [request addParam:login withName:@"login"];
        [request addParam:password withName:@"password"];
    }];
}

- (DXDALRequest *)getUsersList {
    return [self buildRequestWithConfigBlock:^(DXDALRequest *request) {

    }];
}

- (DXDALRequest *)logout {
    return [self buildRequestWithConfigBlock:^(DXDALRequest *request) {

    }];
}


@end
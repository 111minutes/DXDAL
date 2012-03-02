//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UsersAPI.h"
#import "DXDALHTTPRequest.h"
#import "DXDALHTTPDataProvider.h"


@implementation UsersAPI

- (id <DXDALDataProvider>)getDataProvider {
    return [DXDALHTTPDataProvider new];
}

- (void)setupDefaults {
   [self addDefaultConfig:^(DXDALHTTPRequest *request){
       request.httpBaseURL = @"http://afnetworking.org";
       request.defaultHTTPHeaders = [NSDictionary new];
   }];
}

- (DXDALRequest *)loginWithLogin:(NSString *)login password:(NSString *)password {
    return [self buildRequestWithConfigBlock:^(DXDALHTTPRequest *request) {
        request.httpMethod = @"Post";
        request.httpPath = @"/user_session";

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
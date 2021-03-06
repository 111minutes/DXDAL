//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DXDALRequestFactoryHTTP.h"
#import "User.h"

@interface UsersAPI : DXDALRequestFactoryHTTP

- (DXDALRequest *)headRequest;
- (DXDALRequest *)loginWithLogin:(NSString *)login password:(NSString *)password;
- (DXDALRequest *)signUpWithUser:(User*)user;

@end
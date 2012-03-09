//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DXDALRequestFactory.h"
#import "User.h"

@interface UsersAPI : DXDALRequestFactory

- (DXDALRequest *)loginWithLogin:(NSString *)login password:(NSString *)password;
- (DXDALRequest *)signUpWithUser:(User*)user;

@end
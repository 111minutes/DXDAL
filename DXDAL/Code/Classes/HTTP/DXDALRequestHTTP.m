//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "DXDALRequestHTTP.h"

@implementation DXDALRequestHTTP

@synthesize httpMethod = _httpMethod;
@synthesize httpPath = _httpPath;
@synthesize defaultHTTPHeaders = _defaultHTTPHeaders;
@synthesize entityClass, mapping;

- (NSString*)httpMethod {
    return [_httpMethod uppercaseString];
}

@end
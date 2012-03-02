//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DXDALRequest.h"


@interface DXDALHTTPRequest : DXDALRequest

@property(nonatomic, readwrite, strong) NSString *httpMethod;
@property(nonatomic, readwrite, strong) NSString *httpPath;
@property(nonatomic, readwrite, strong) NSString *httpBaseURL;
@property(nonatomic, readwrite, strong) NSDictionary *defaultHTTPHeaders;

- (NSURLRequest *)urlRequest;

@end
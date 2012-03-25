//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class DXDALRequest;
@class AFHTTPRequestOperation;

@protocol DXDALDataProvider <NSObject>

- (void)enqueueRequest:(DXDALRequest*)request;

@end
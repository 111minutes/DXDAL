//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class DXDALRequest;
@class AFHTTPRequestOperation;

@protocol DXDALDataProvider <NSObject>

- (DXDALRequest*)prepareRequest;

- (void)enqueueRequest:(DXDALRequest*)request;

- (NSURLRequest*)urlRequestFromRequest:(DXDALRequest*) request;

- (AFHTTPRequestOperation*)operationFromURLRequest:(NSURLRequest*) urlRequest request:(DXDALRequest*) request;

@end
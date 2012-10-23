//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DXDALDataProvider.h"
#import "DXDALHTTPClient.h"

typedef void (^DXDALAFSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^DXDALAFErrorHandler)(AFHTTPRequestOperation *operation, NSError *error);

@class DXDALRequestHTTP;

@interface DXDALDataProviderHTTP : NSObject <DXDALDataProvider> 

- (id)initWithBaseURL:(NSURL*)aBaseURL;

- (NSURLRequest*) urlRequestFromRequest:(DXDALRequestHTTP*) httpRequest;
- (AFHTTPRequestOperation*) operationFromRequest:(DXDALRequestHTTP*) httpRequest;

- (DXDALAFSuccessHandler)successHandlerWithHTTPRequest:(DXDALRequestHTTP*)httpRequest;
- (DXDALAFErrorHandler)errorHandlerWithHTTPRequest:(DXDALRequestHTTP*)httpRequest;

@property (nonatomic, strong) DXDALHTTPClient *httpClient;

@end
//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DXDALDataProvider.h"
#import "DXDALHTTPClient.h"

@class DXDALRequestHTTP;

@interface DXDALDataProviderHTTP : NSObject <DXDALDataProvider> 

- (id)initWithBaseURL:(NSURL*)aBaseURL;

- (NSURLRequest*) urlRequestFromRequest:(DXDALRequestHTTP*) httpRequest;
- (AFHTTPRequestOperation*) operationFromRequest:(DXDALRequestHTTP*) httpRequest;

@property (nonatomic, strong) DXDALHTTPClient *httpClient;

@end
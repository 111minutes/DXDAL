//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DXDALDataProvider.h"
#import "AFHTTPClient.h"


@interface DXDALDataProviderHTTP : NSObject <DXDALDataProvider> 

- (id)initWithBaseURL:(NSURL*)aBaseURL;

@property (nonatomic, strong) AFHTTPClient *httpClient;

@end
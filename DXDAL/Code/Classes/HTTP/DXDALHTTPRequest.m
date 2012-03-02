//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "DXDALHTTPRequest.h"

@implementation DXDALHTTPRequest

@synthesize httpMethod = _httpMethod;
@synthesize httpPath = _httpPath;
@synthesize httpBaseURL = _httpBaseURL;
@synthesize defaultHTTPHeaders = _defaultHTTPHeaders;

- (NSURLRequest *)urlRequest {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_httpBaseURL, _httpPath]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    return urlRequest;
}

@end
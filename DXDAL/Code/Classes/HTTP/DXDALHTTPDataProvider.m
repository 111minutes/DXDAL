//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DXDALHTTPDataProvider.h"
#import "DXDALHTTPRequest.h"
#import "AFNetworking.h"

@implementation DXDALHTTPDataProvider {
    NSOperationQueue *_queue;
}

- (id)init {
    self = [super init];
    if (self) {
        _queue = [NSOperationQueue new];
    }
    return self;
}

- (DXDALRequest *)prepareRequest {
    return [[DXDALHTTPRequest alloc] initWithDataProvider:self];
}

- (void)enqueueRequest:(DXDALRequest *)request {

    DXDALHTTPRequest *httpRequest = (DXDALHTTPRequest *) request;

    NSURLRequest *urlRequest = [httpRequest urlRequest];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [httpRequest didFinishWithResponse:operation.responseString];
    }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [httpRequest didFailWithResponse:operation.responseString];

            }
    ];



    [_queue addOperation:operation];
}


@end
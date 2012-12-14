//
//  DXDALDataProviderRawData.m
//  Pods
//
//  Created by TheSooth on 11/17/12.
//
//

#import "DXDALDataProviderRawData.h"
#import "DXDALRequestHTTPRawData.h"

@implementation DXDALDataProviderRawData

- (NSMutableURLRequest *)urlRequestFromRequest:(DXDALRequestHTTP *) httpRequest {
    DXDALRequestHTTPRawData *rawDataRequest = (DXDALRequestHTTPRawData *) httpRequest;
    
    NSMutableURLRequest *urlRequest = [self.httpClient rawDataRequestWithMethod:rawDataRequest.httpMethod path:rawDataRequest.httpPath parameters:rawDataRequest.params rawData:rawDataRequest.rawData];
    
    return urlRequest;
}
@end

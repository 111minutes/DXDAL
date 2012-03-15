//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DXDALRequest.h"

@protocol DXDALResponseParser;


@interface DXDALRequestHTTP : DXDALRequest


@property(nonatomic, readwrite, strong) NSString *httpMethod;
@property(nonatomic, readwrite, strong) NSString *httpPath;
@property(nonatomic, readwrite, strong) NSDictionary *defaultHTTPHeaders;

@property (nonatomic, assign) Class entityClass;
@property (nonatomic, strong) NSDictionary *mapping;
@property (nonatomic, strong) id<DXDALResponseParser> parser;
@end
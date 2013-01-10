//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DXDALRequest.h"
#import "AFNetworking.h"

@protocol DXDALParser;
@protocol DXDALMapper;


@interface DXDALRequestHTTP : DXDALRequest

@property(nonatomic, readwrite, strong) NSString *httpMethod;
@property(nonatomic, readwrite, strong) NSString *httpPath;
@property(nonatomic, readwrite, strong) NSDictionary *defaultHTTPHeaders;

@property (nonatomic, weak)  AFHTTPRequestOperation *requestOperation;

@property (nonatomic, assign) Class entityClass;
@property (nonatomic, strong) id<DXDALParser> parser;
@property (nonatomic, strong) id<DXDALMapper> mapper;

@property (nonatomic, strong) NSString *jsonValidationPatternFileName;


- (void) didFinishWithResponseString:(NSString *)responseString 
                      responseObject:(id)responseObject 
                  responseStatusCode:(NSInteger)responseStatusCode;

@end
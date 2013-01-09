//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "DXDALRequestHTTP.h"
#import "DXDALMapperStandart.h"
#import "DXDALParserJSON.h"

@implementation DXDALRequestHTTP

@synthesize httpMethod = _httpMethod;
@synthesize httpPath = _httpPath;
@synthesize defaultHTTPHeaders = _defaultHTTPHeaders;
@synthesize entityClass;
@synthesize parser;
@synthesize mapper;

- (id) initWithDataProvider:(id<DXDALDataProvider>)dataProvider
{
    self = [super initWithDataProvider:dataProvider];
    if (self)
    {
        self.mapper = [DXDALMapperStandart new];
    }
    return self;
}

- (NSString*)httpMethod {
    return [_httpMethod uppercaseString];
}

- (void) didFinishWithResponseString:(NSString *)responseString
                      responseObject:(id)responseObject
                  responseStatusCode:(NSInteger)responseStatusCode {
    
    if (responseString != nil) {
        
        id result = nil;
        
        if (self.parser) {
            
            id parsedObject = [self.parser parseString:responseString];
            
            BOOL isStandartMapperWithEntityClass = self.entityClass && [self.mapper isKindOfClass:[DXDALMapperStandart class]];
            BOOL isCustomMapper = ![self.mapper isKindOfClass:[DXDALMapperStandart class]];
            BOOL canMap = self.mapper && (isStandartMapperWithEntityClass || isCustomMapper);
    
            if (canMap) {
                result = [self.mapper mapFromInputData:parsedObject withClass:self.entityClass];
            } else {
                result = parsedObject;
            }
            
        } else {
            result = responseString;
        }
        
    } else if ([responseObject isKindOfClass:[NSData class]]) {
        [self didFinishWithResponse:responseObject];
    }
}

@end
//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DXDALConfigurableRequest.h"
#import "DXDALRequest.h"
#import "DXDALDataProvider.h"

@interface DXDALRequest () <DXDALConfigurableRequest>

@property (nonatomic, strong, readwrite) NSMutableDictionary *params;

@end

@implementation DXDALRequest {
    NSMutableArray *_successHandlers;
    NSMutableArray *_errorHandlers;
    NSMutableArray *_progressHandlers;
    
    __unsafe_unretained id<DXDALDataProvider> _dataProvider;
}

@synthesize params = _params;

- (id)initWithDataProvider:(id<DXDALDataProvider>)dataProvider {
    assert(dataProvider != nil);
    
    self = [super init];
    if (self) {
        _dataProvider = dataProvider;
        _successHandlers = [NSMutableArray new];
        _errorHandlers = [NSMutableArray new];
        _progressHandlers = [NSMutableArray new];
        _params = [NSMutableDictionary new];
    }
    return self;
}

- (void)addParamString:(NSString *)param withName:(NSString *)key {
    assert(key != nil);
    assert(param != nil);
    
    [_params setObject:param forKey:key];
}

- (void)addParam:(NSObject*)param withName:(NSString *)key
{
    assert(key != nil);
    assert(param != nil);
    
    if(
       [param isKindOfClass:[NSString class]] ||
       [param isKindOfClass:[NSNumber class]] ||
       [param isKindOfClass:[NSArray class]] ||
       [param isKindOfClass:[NSDictionary class]]
       )
    {
        [_params setObject:param forKey:key];
    }
    else
    {
        NSAssert(NO, @"Wrong param type!");
    }
}

- (void)addSuccessHandler:(DXDALRequestSuccesHandler)handler {
    assert(handler != nil);
    [_successHandlers addObject:[handler copy]];
}

- (void)addErrorHandler:(DXDALRequestErrorHandler)handler {
    assert(handler != nil);
    [_errorHandlers addObject:[handler copy]];
}

- (void)addProgressHandler:(DXDALProgressHandler)handler {
    assert(handler != nil);
    [_progressHandlers addObject:[handler copy]];
}

- (void)start {
    [_dataProvider enqueueRequest:self];
}

- (void)stop {

}

- (void)pause {

}

- (void)resume {

}

- (void)didFinishWithResponse:(id)response {
    assert(response != nil);
    
    for (id block in _successHandlers) {
        DXDALRequestSuccesHandler handler = block;
        handler(response);
    }
}

- (void)didFailWithResponse:(id)response {
    assert(response != nil);
    
    for (id block in _errorHandlers) {
        DXDALRequestErrorHandler handler = block;
        handler(response);
    }
}

- (void)didChangeProgressValue:(float)progressValue {
    for (id block in _progressHandlers) {
        DXDALProgressHandler handler = block;
        handler(progressValue);
    }
}

@end
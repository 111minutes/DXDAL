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
@property (nonatomic, strong) NSMutableArray *requestDidStartHandlers;
@property (nonatomic, strong) NSMutableArray *requestDidStopHandlers;
@property (nonatomic, strong) NSMutableArray *successHandlers;
@property (nonatomic, strong) NSMutableArray *errorHandlers;
@property (nonatomic, strong) NSMutableArray *uploadProgressHandlers;
@property (nonatomic, strong) NSMutableArray *downloadProgressHandlers;

@end

@implementation DXDALRequest {
    __unsafe_unretained id<DXDALDataProvider> _dataProvider;
}

- (id)initWithDataProvider:(id<DXDALDataProvider>)dataProvider {
    assert(dataProvider != nil);
    
    self = [super init];
    if (self) {
        _dataProvider = dataProvider;
        self.requestDidStartHandlers = [NSMutableArray new];
        self.requestDidStopHandlers = [NSMutableArray new];
        self.successHandlers = [NSMutableArray new];
        self.errorHandlers = [NSMutableArray new];
        self.uploadProgressHandlers = [NSMutableArray new];
        self.downloadProgressHandlers = [NSMutableArray new];
        _params = nil;
    }
    return self;
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
        if (_params == nil) {
            _params = [NSMutableDictionary new];
        }
        [_params setObject:param forKey:key];
    }
    else
    {
        NSAssert(NO, @"Wrong param type!");
    }
}

- (void)addRequestDidStartHandler:(DXDALRequestDidStartHandler)handler
{
    assert(handler != nil);
    [_requestDidStartHandlers addObject:[handler copy]];
}

- (void)addRequestDidStopHandler:(DXDALRequestDidStopHandler)handler
{
    assert(handler != nil);
    [_requestDidStopHandlers addObject:[handler copy]];
}

- (void)addSuccessHandler:(DXDALRequestSuccesHandler)handler
{
    assert(handler != nil);
    [_successHandlers addObject:[handler copy]];
}

- (void)addErrorHandler:(DXDALRequestErrorHandler)handler
{
    assert(handler != nil);
    [_errorHandlers addObject:[handler copy]];
}

- (void)addUploadProgressHandler:(DXDALUploadProgressHandler)handler
{
    assert(handler != nil);
    [self.uploadProgressHandlers addObject:[handler copy]];
}

- (void)addDownloadProgressHandler:(DXDALDownloadProgressHandler)handler
{
    assert(handler != nil);
    [self.downloadProgressHandlers addObject:[handler copy]];
}

- (void)didChangeUploadProgressValue:(float)progressValue progressDelta:(float)progressDelta
{
    for (id block in self.uploadProgressHandlers) {
        DXDALUploadProgressHandler handler = block;
        handler(progressValue, progressDelta);
    }
}

- (void)didChangeDownloadProgressValue:(float)progressValue progressDelta:(float)progressDelta
{
    for (id block in self.downloadProgressHandlers) {
        DXDALDownloadProgressHandler handler = block;
        handler(progressValue, progressDelta);
    }
}

- (void)start
{
    [_dataProvider enqueueRequest:self];
    for (DXDALRequestDidStartHandler handler in _requestDidStartHandlers) {
        if (handler) {
            handler(self);
        }
    }
}

- (void)stop
{
    for (DXDALRequestDidStopHandler handler in _requestDidStopHandlers) {
        if (handler) {
            handler(self);
        }
    }
}

- (void)pause
{

}

- (void)resume
{

}

- (void)didFinishWithResponse:(id)response
{
    if (response) {
        for (id block in _successHandlers) {
            DXDALRequestSuccesHandler handler = block;
            handler(response);
        }

    } else {
        [self didFailWithResponse:response];
    }
    
}

- (void)didFailWithResponse:(id)response
{    
    for (id block in _errorHandlers) {
        DXDALRequestErrorHandler handler = block;
        handler(response);
    }
}

- (void)removeAllHandlers
{
    [self.uploadProgressHandlers removeAllObjects];
    [self.downloadProgressHandlers removeAllObjects];
    [self.requestDidStartHandlers removeAllObjects];
    [self.requestDidStopHandlers removeAllObjects];
    [self.successHandlers removeAllObjects];
    [self.errorHandlers removeAllObjects];
}

@end
//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import <AFNetworking-Fork/AFHTTPRequestOperation.h>

@protocol DXDALConfigurableRequest;
@protocol DXDALDataProvider;

@class DXDALRequestResponse, DXDALRequest;

typedef void (^DXDALRequestDidStartHandler)(DXDALRequest *request);
typedef void (^DXDALRequestDidStopHandler)(DXDALRequest *request);

typedef void (^DXDALRequestSuccesHandler)(id response);

typedef void (^DXDALRequestErrorHandler)(NSError *error);

typedef void (^DXDALProgressHandler)(float currentProgress, float progressDelta);

@interface DXDALRequest : NSObject 

@property (nonatomic, strong, readonly) NSMutableDictionary *params;

- (id)initWithDataProvider:(id<DXDALDataProvider>)dataProvider;

- (void)addRequestDidStartHandler:(DXDALRequestDidStartHandler)handler;
- (void)addRequestDidStopHandler:(DXDALRequestDidStopHandler)handler;

- (void)addSuccessHandler:(DXDALRequestSuccesHandler)handler;

- (void)addErrorHandler:(DXDALRequestErrorHandler)handler;

- (void)addProgressHandler:(DXDALProgressHandler)handler;

- (void)start;

- (void)stop;

- (void)pause;

- (void)resume;

- (void)addParamString:(NSString *)param withName:(NSString *)key NS_DEPRECATED_IOS(4_0, 4_0);
- (void)addParam:(NSObject*)param withName:(NSString *)key;

- (void)didFinishWithResponse:(id)response;
- (void)didFailWithResponse:(id)response;
- (void)didChangeProgressValue:(float)progressValue progressDelta:(float)progressDelta;

- (void)removeAllHandlers;

@end
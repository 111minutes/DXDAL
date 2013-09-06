//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol DXDALConfigurableRequest;
@protocol DXDALDataProvider;

@class DXDALRequestResponse, DXDALRequest;

typedef void (^DXDALUploadProgressHandler)(float currentUploadProgress, float uploadProgressDelta);
typedef void (^DXDALDownloadProgressHandler)(float currentDownloadProgress, float downloadProgressDelta);

typedef void (^DXDALRequestDidStartHandler)(DXDALRequest *request);
typedef void (^DXDALRequestDidStopHandler)(DXDALRequest *request);
typedef void (^DXDALRequestSuccesHandler)(id response);
typedef void (^DXDALRequestErrorHandler)(NSError *error);

@interface DXDALRequest : NSObject 

@property (nonatomic, strong, readonly) NSMutableDictionary *params;

- (id)initWithDataProvider:(id<DXDALDataProvider>)dataProvider;

- (void)addUploadProgressHandler:(DXDALUploadProgressHandler)handler;
- (void)addDownloadProgressHandler:(DXDALDownloadProgressHandler)handler;

- (void)didChangeUploadProgressValue:(float)progressValue progressDelta:(float)progressDelta;
- (void)didChangeDownloadProgressValue:(float)progressValue progressDelta:(float)progressDelta;

- (void)addRequestDidStartHandler:(DXDALRequestDidStartHandler)handler;
- (void)addRequestDidStopHandler:(DXDALRequestDidStopHandler)handler;
- (void)addSuccessHandler:(DXDALRequestSuccesHandler)handler;
- (void)addErrorHandler:(DXDALRequestErrorHandler)handler;

- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;

- (void)addParam:(NSObject*)param withName:(NSString *)key;

- (void)didFinishWithResponse:(id)response;
- (void)didFailWithResponse:(id)response;

- (void)removeAllHandlers;

@end
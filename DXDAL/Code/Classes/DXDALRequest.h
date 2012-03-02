//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol DXDALConfigurableRequest;
@protocol DXDALDataProvider;

@class DXDALRequestResponse;

typedef void (^DXDALRequestSuccesHandler)(DXDALRequestResponse *response);

typedef void (^DXDALRequestErrorHandler)(NSError *error);

@interface DXDALRequest : NSObject 

- (id)initWithDataProvider:(id<DXDALDataProvider>)dataProvider;

- (void)addSuccessHandler:(DXDALRequestSuccesHandler)handler;

- (void)addErrorHandler:(DXDALRequestErrorHandler)handler;

- (void)start;

- (void)stop;

- (void)pause;

- (void)resume;

- (void)addParam:(NSString *)param withName:(NSString *)key;

- (void)didFinishWithResponse:(id)response;
- (void)didFailWithResponse:(id)response;


@end
//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class DXDALRequest;
@protocol DXDALDataProvider;


typedef void (^DXDALRequestConfigurationBlock)(id request);

@protocol DXDALRequestFactoryProtocol <NSObject>

@property (nonatomic, readonly, strong) id<DXDALDataProvider> dataProvider;

- (id <DXDALDataProvider>)getDataProvider;

- (DXDALRequest*)buildRequestWithConfigBlock:(DXDALRequestConfigurationBlock)configBlock;
- (DXDALRequest*)buildRequestWithConfigBlock:(DXDALRequestConfigurationBlock)configBlock requestClass:(Class)RequestClass;

- (void)addDefaultConfig:(DXDALRequestConfigurationBlock)configBlock;

- (void)setupDefaults;

@end
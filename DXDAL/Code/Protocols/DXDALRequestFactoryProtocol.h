//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class DXDALRequest;
@class DXDALRequestHTTPPagination;
@protocol DXDALDataProvider;


typedef void (^DXDALRequestConfigurationBlock)(id request);
typedef void (^DXDALPaginationRequestConfigurationBlock)(DXDALRequestHTTPPagination *request);

@protocol DXDALRequestFactoryProtocol <NSObject>

@property (nonatomic, readonly, strong) id<DXDALDataProvider> dataProvider;

- (id <DXDALDataProvider>)getDataProvider;
- (Class)getDefaultRequestClass;

- (DXDALRequest *)buildRequestWithConfigBlock:(DXDALRequestConfigurationBlock)configBlock;
- (DXDALRequest *)buildRequestWithConfigBlock:(DXDALRequestConfigurationBlock)configBlock requestClass:(Class)RequestClass;
- (DXDALRequest *)buildPaginationRequestWithConfigBlock:(DXDALPaginationRequestConfigurationBlock)configBlock;

- (void)addDefaultConfig:(DXDALRequestConfigurationBlock)configBlock;
- (void)setupDefaults;

- (Class)defaultRequestEntityClass;
- (NSString*)defaultRequestEntitiesKey;

@end
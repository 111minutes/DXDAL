//
//  Created by zen on 3/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DXDALRequestFactory.h"
#import "DXDALRequest.h"
#import "DXDALDataProvider.h"

@interface DXDALRequestFactory ()

@property (nonatomic, readwrite, strong) id<DXDALDataProvider> dataProvider;

@end

@implementation DXDALRequestFactory {
    NSMutableArray *_defaultConfigBlocks;
}

@synthesize dataProvider;

- (id <DXDALDataProvider>)getDataProvider {
    NSAssert(NO, @"Override this method in subclasses!");
    return nil;
}

- (Class)getDefaultRequestClass
{
    NSAssert(NO, @"Override this method in subclasses!");
    return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        _defaultConfigBlocks = [NSMutableArray new];

        self.dataProvider = [self getDataProvider];
        
        assert(self.dataProvider != nil);
        
        [self setupDefaults];
    }
    return self;
}

- (DXDALRequest *)buildRequestWithConfigBlock:(DXDALRequestConfigurationBlock)configBlock {
	return [self buildRequestWithConfigBlock:configBlock requestClass:nil];
}

- (DXDALRequest *)buildRequestWithConfigBlock:(DXDALRequestConfigurationBlock)configBlock requestClass:(Class)RequestClass {
    assert(configBlock != nil);

	DXDALRequest *request = nil;

	if(!RequestClass)
        RequestClass = [self getDefaultRequestClass];
    request = [[RequestClass alloc] initWithDataProvider:self.dataProvider];

    assert(request != nil);

    for (id block in _defaultConfigBlocks) {
        DXDALRequestConfigurationBlock configurationBlock = block;
        configurationBlock(request);
    }

    configBlock(request);

    return request;
}

- (void)setupDefaults {

}

- (void)addDefaultConfig:(DXDALRequestConfigurationBlock)configBlock {
    assert(configBlock != nil);
    
    [_defaultConfigBlocks addObject:configBlock];
}

@end
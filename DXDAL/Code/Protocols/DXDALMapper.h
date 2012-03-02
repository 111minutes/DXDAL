//
//  Created by zen on 3/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol DXDALMapper <NSObject>

- (id)mapFromInputData:(id)inputData withClass:(Class)mappingClass;

@end
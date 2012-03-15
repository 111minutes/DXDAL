//
//  Created by zen on 3/15/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol DXDALResponseParser

- (id)parseJSON:(NSString*)json withEntityClass:(Class)class;

@end
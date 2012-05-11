
## Using DXDAL

At first you should create request factory

``` objective-c
@interface MyRequestFactory : DXDALRequestFactory
```

where you should override two methods:

``` objective-c
- (id <DXDALDataProvider>)getDataProvider;
- (Class)getDefaultRequestClass; 
```

for example:
``` objective-c
- (id<DXDALDataProvider>)getDataProvider {
    return [[DXDALDataProviderHTTP alloc] initWithBaseURL:[NSURL URLWithString:@"http://google.com"]];
}

- (Class)getDefaultRequestClass {
    return [DXDALRequestHTTP class];
}
```

## Default parameters

use 
``` objective-c
- (void)addDefaultConfig:(DXDALRequestConfigurationBlock)configBlock;
```
то add default configuration blocks for every request, for example:

``` objective-c
MyRequestFactory *factory = [MyRequestFactory sharedInstance];
```        
[factory addDefaultConfig:^(id request) {
            [request addParam:user.userID withName:@"user_id"];
}];
```

## Requestst definition

### GET Request

``` objective-c
- (DXDALRequest *)getLastUpdateDate {
    return [self buildRequestWithConfigBlock:^(DXDALRequestHTTP *request) {
        request.httpMethod = @"GET";
        request.httpPath = @"get_last_updated"; // method
        
        [request addParam:somedate withName:@"date"];
        
        request.parser = [DXDALParserJSON new];
        request.mapper = [MDUpdateDateMapper new];
        
        request.entityClass = [NSString class];
        
    }];
}
```

### POST Request

``` objective-c
- (DXDALRequest*)loginUserName:(NSString *)userName password:(NSString *)password {
    return [self buildRequestWithConfigBlock:^(DXDALRequestHTTP *request) {
        request.httpMethod = @"POST";
        request.httpPath = @"check_credentials"; //metod
        
        [request addParam:userName withName:@"username"];
        [request addParam:password withName:@"password"];
        
        request.parser = [DXDALParserJSON new];
        request.mapper = [UserModelMapper new];
        request.entityClass = [User class];
        
        [request addErrorHandler:[self standartErrorHandler]];
    }];
}
```

### ModelMapper 

it's class which implements DXDALMapper protocol with method:
``` objective-c
- (id)mapFromInputData:(id)inputData withClass:(Class)mappingClass;
```

where inputData - it's parsed dictionary from server response, for example:
``` objective-c
- (id)mapFromInputData:(id)inputData withClass:(Class)mappingClass {

    User *user = [[User alloc] init];
        
    user.firstName = [inputData objectForKey:@"first_name"];
    user.lastName = [inputData objectForKey:@"last_name"];
    
    return user;
}
```

## Using request example

``` objective-c
DXDALRequestSuccesHandler successLogin = ^(id response){
    
    User *user = response;
    NSLog(@"user name: %@ %@", user.firstName, user.lastName);

}

MDAuthRequestFactory *factory = [MDAuthRequestFactory sharedInstance];
    
DXDALRequest *request = [factory loginUserName:_loginField.text password:_passwordField.text];
[request addSuccessHandler:successLogin];
[request addErrorHandler:^(NSError *error)
{
    NSLog(@"Login request error: %@", [error description]);
}];

[request start];
```

## Progress

You can add progress block:

``` objective-c
- (void)addProgressHandler:(DXDALProgressHandler)handler;
```

it will returns progressValue and progressDelta, for example:

``` objective-c
DXDALProgressHandler progressHandler = ^(float progress, float progressDelta) {
    NSLog(@"progress: %f, progressDelta: %f", progress, progressDelta);
};

[request addProgressHandler:progressHandler];
```



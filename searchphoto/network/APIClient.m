//
//#import "APIClient.h"
//
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://httpbin.org";
//
//@implementation APIClient
//
//+ (instancetype)sharedClient {
//    static APIClient *_sharedClient = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
//        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    });
//    
//    return _sharedClient;
//}
//
//- (void) postRequestUri : (NSString* )uri parameters:(id) params response: (void (^)(NSString* response))block{
//    [self POST:uri parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"[responseObject] %@", responseObject);
//        block(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"[error] %@", error);
//        block(nil);
//    }];
//}
//
//- (void) getRequestUri : (NSString* )uri parameters:(id) params response: (void (^)(NSString* response))block{
//    [self GET:uri parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"[responseObject] %@", responseObject);
//        block(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"[error] %@", error);
//        block(nil);
//    }];
//}
//
//@end

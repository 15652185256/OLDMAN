//
//  NetRequestClass.h
//  MVVMTest
//
//

#import <Foundation/Foundation.h>

@interface NetRequestClass : NSObject

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

//#pragma GET请求
//+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter WithReturnValeuBlock: (ReturnValueBlock) block WithErrorCodeBlock: (ErrorCodeBlock) errorBlock WithFailureBlock: (FailureBlock) failureBlock;
//
//#pragma POST请求
//+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter WithReturnValeuBlock: (ReturnValueBlock) block WithErrorCodeBlock: (ErrorCodeBlock) errorBlock WithFailureBlock: (FailureBlock) failureBlock;

#pragma 注册/登录
+ (void) NetRequestLoginRegWithRequestURL: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter WithReturnValeuBlock: (ReturnValueBlock) block WithErrorCodeBlock: (ErrorCodeBlock) errorBlock WithFailureBlock: (FailureBlock) failureBlock;

@end

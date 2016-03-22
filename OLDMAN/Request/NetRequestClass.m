//
//  NetRequestClass.m
//  MVVMTest
//
//

#import "NetRequestClass.h"
#import "MyMD5.h"
#import "NSFileManager+Method.h"//判断请求超时

@interface NetRequestClass ()

@end


@implementation NetRequestClass
#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}


/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

//#pragma --mark GET请求方式
//+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter WithReturnValeuBlock: (ReturnValueBlock) block WithErrorCodeBlock: (ErrorCodeBlock) errorBlock WithFailureBlock: (FailureBlock) failureBlock
//{
//
//    //设置一个缓存路径
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches/%@",[MyMD5 md5:requestURLString]];
//    
//    //判断文件存在 且 超时 重新下载 ，否则读缓存
//    NSFileManager * NsManager=[NSFileManager defaultManager];
//    if ([NsManager fileExistsAtPath:path] && [NsManager timeOutFileName:[MyMD5 md5:requestURLString] time:60*30]) {
//        
//        AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
//        [manager GET:path parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
//            NSMutableData * data=[NSMutableData dataWithContentsOfFile:path];//使用缓存
//            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            block(dic);
//        }];
//    }
//    else{
//        //开始网络请求
//        AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
//        AFHTTPRequestOperation * op = [manager GET:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            //当请求成功的时候,把请求数据保存在我们的沙盒目录下
//            [responseObject writeToFile:path atomically:YES];
//            
//            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            //DDLog(@"%@", dic);
//            block(dic);
//            
//        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
//            
//            //判断文件存在
//            NSFileManager * manager=[NSFileManager defaultManager];
//            if ([manager fileExistsAtPath:path]) {
//                NSMutableData * data=[NSMutableData dataWithContentsOfFile:path];//使用缓存
//                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                block(dic);
//            }
//            failureBlock();
//        }];
//        
//        op.responseSerializer = [AFHTTPResponseSerializer serializer];
//        
//        [op start];
//    }
//}
//
//
//
//#pragma --mark POST请求方式
//+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter WithReturnValeuBlock: (ReturnValueBlock) block WithErrorCodeBlock: (ErrorCodeBlock) errorBlock WithFailureBlock: (FailureBlock) failureBlock
//{
//    //设置一个缓存路径
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches/%@",[MyMD5 md5:requestURLString]];
//    
//    //判断文件存在 且 超时 重新下载 ，否则读缓存
//    NSFileManager * NsManager=[NSFileManager defaultManager];
//    if ([NsManager fileExistsAtPath:path] && ![NsManager timeOutFileName:[MyMD5 md5:requestURLString] time:60*30]) {
//        
//        AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
//        [manager POST:path parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
//            NSMutableData * data=[NSMutableData dataWithContentsOfFile:path];//使用缓存
//            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            block(dic);
//        }];
//    }
//    else{
//        //开始网络请求
//        AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
//        AFHTTPRequestOperation * op = [manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            //当请求成功的时候,把请求数据保存在我们的沙盒目录下
//            [responseObject writeToFile:path atomically:YES];
//            
//            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            
//            block(dic);
//            
//        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
//            
//            //判断文件存在
//            NSFileManager * manager=[NSFileManager defaultManager];
//            if ([manager fileExistsAtPath:path]) {
//                NSMutableData * data=[NSMutableData dataWithContentsOfFile:path];//使用缓存
//                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                block(dic);
//            }
//            failureBlock();
//        }];
//        
//        op.responseSerializer = [AFHTTPResponseSerializer serializer];
//        
//        [op start];
//    }
//}



#pragma --mark POST 注册/登录
+ (void) NetRequestLoginRegWithRequestURL: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter WithReturnValeuBlock: (ReturnValueBlock) block WithErrorCodeBlock: (ErrorCodeBlock) errorBlock WithFailureBlock: (FailureBlock) failureBlock
{
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval=10.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    AFHTTPRequestOperation * op = [manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        block(dic);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        failureBlock();
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
}



@end

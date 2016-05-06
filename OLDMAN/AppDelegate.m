//
//  AppDelegate.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/26.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AppDelegate.h"

#import "FMDBManager.h"//数据库

#import "JPUSHService.h"//极光推送

#import "RootViewController.h"//采集员

#import "MainViewController.h"//初审

#import "LoginViewController.h"//登录

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    //注册通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:pushAppKey channel:@"PublishChannel" apsForProduction:0];
    
    //注册 自定义消息
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    
    
    
//    NSLog(@"%@",NSHomeDirectory());
//    //获取当前时间
//    NSDate * currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
//    NSString * dateString = [dateFormatter stringFromDate:currentDate];
//    
//    
//    NSMutableDictionary * dataDic=[[NSMutableDictionary alloc] init];
//    
//    [dataDic setObject:dateString forKey:@"time"];
//    [dataDic setObject:@"1231321" forKey:@"content"];
//    [dataDic setObject:@"4" forKey:@"NewsID"];
//    [dataDic setObject:[user objectForKey:doc_id] forKey:@"DocID"];//接受人
//    [dataDic setObject:@"0" forKey:@"state"];//消息状态
//    
//    //保存 数据库
//    [[FMDBManager shareManager]addNewsData:dataDic];
    
    
    
//    //版本更新
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        //获取发布版本的Version
//        NSString * string=[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=1084264948"] encoding:NSUTF8StringEncoding error:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //回归主线程
//            if (string!=nil && [string length]>0 && [string rangeOfString:@"version"].length==7) {
//                [self checkAppUpdate:string];
//            }
//        });
//    });
    
    
    //版本更新
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        //获取发布版本的Version
//        __block NSString * VersionString=@"";
//        
//        AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
//        AFHTTPRequestOperation * op = [manager POST:GetIosVersion parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSDictionary * returnValue = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            
//            if ([returnValue[@"success"] intValue]==1) {
//                
//                if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
//                    
//                    VersionString=(NSString*)[returnValue[@"data"] objectForKey:@"version"];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //回归主线程
//                        if (![PublicFunction isBlankString:VersionString]) {
//                            [self checkAppUpdate:VersionString];
//                        }
//                    });
//                }
//            }
//        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
//        }];
//        op.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [op start];
//    });
    
    
    
    //页面跳转
    if ([[user objectForKey:ISLOGIN] intValue]==0) {
        LoginViewController * lvc=[[LoginViewController alloc]init];
        self.window.rootViewController=lvc;
    }else{
        
        if ([[user objectForKey:idenity] intValue]==1) {
            RootViewController * rvc=[[RootViewController alloc]init];
            UINavigationController * nvc=[[UINavigationController alloc]initWithRootViewController:rvc];
            self.window.rootViewController=nvc;
        } else {
            MainViewController * mvc=[[MainViewController alloc]init];
            UINavigationController * nvc=[[UINavigationController alloc]initWithRootViewController:mvc];
            self.window.rootViewController=nvc;
        }
    }
    [user synchronize];
    
    
    
    
    
    
    
    
    return YES;
}

//dealloc中需要移除监听
-(void)dealloc
{
    //注册 自定义消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

//注册成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
    [JPUSHService registerDeviceToken:deviceToken];
    
    //修改别名
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if (![PublicFunction isBlankString:[user objectForKey:doc_id]]) {
        [JPUSHService setTags:nil alias:[user objectForKey:doc_id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            NSLog(@"nalias: %@\n",iAlias);
        }];
    } else {
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            NSLog(@"nalias: %@\n",iAlias);
        }];
    }
}
//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



//接受自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    //自定义消息
    NSDictionary * userInfo = [notification userInfo];
    NSString * data = [userInfo valueForKey:@"content"];

    
    //NSLog(@"%@",data);
    
    NSData * jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    //获取消息内容
    NSString * content=[dict objectForKey:@"message"];
    
    //获取消息ID
    NSString * NewsID=[dict objectForKey:@"notice_id"];
    
    //NSLog(@"NewsID:%@",NewsID);
    
    //获取当前时间
    NSDate * currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    
    NSMutableDictionary * dataDic=[[NSMutableDictionary alloc] init];
    
    [dataDic setObject:dateString forKey:@"time"];
    if (![PublicFunction isBlankString:content]) {
        [dataDic setObject:content forKey:@"content"];//消息内容
    }
    if (![PublicFunction isBlankString:NewsID]) {
        [dataDic setObject:NewsID forKey:@"NewsID"];//消息ID
    }
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if (![PublicFunction isBlankString:[user objectForKey:doc_id]]) {
        [dataDic setObject:[user objectForKey:doc_id] forKey:@"DocID"];//接受人
        [dataDic setObject:@"0" forKey:@"state"];//消息状态
        
        //保存 数据库
        [[FMDBManager shareManager]addNewsData:dataDic];
    }
}




#pragma mark--比较当前版本与新上线版本比较
//-(void)checkAppUpdate:(NSString*)appInfo
//{
//    //获取当前版本
//    NSString * version=[[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"];
//    
//    //发布的版本
//    NSString * appInfo1=[appInfo substringFromIndex:[appInfo rangeOfString:@"\"version\":"].location+10];
//    appInfo1=[[appInfo1 substringToIndex:[appInfo1 rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    
//    
//    //判断,如果当前版本与发布的版本不同，则进入更新。如果相等，那么当前就是最高版本
//    if (![appInfo1 isEqualToString:version]) {
//        NSLog(@"新版本:%@ 当前版本:%@",appInfo1,version);
//        
//        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"新版本 %@ 已发布",appInfo1] delegate:self cancelButtonTitle:nil otherButtonTitles:@"版本更新", nil];
//        alertview.tag=4000;
//        [alertview show];
//    } else {
//        //        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"已是最高版本" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        //        [alertView show];
//    }
//}



#pragma mark--比较当前版本与新上线版本比较
-(void)checkAppUpdate:(NSString*)appInfo
{
    //获取当前版本
    NSString * version=[[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"];
    
    //判断,如果当前版本与发布的版本不同，则进入更新。如果相等，那么当前就是最高版本
    if (![appInfo isEqualToString:version]) {
        NSLog(@"新版本:%@ 当前版本:%@",appInfo,version);
        
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"新版本 %@ 已发布",appInfo] delegate:self cancelButtonTitle:nil otherButtonTitles:@"版本更新", nil];
        alertview.tag=4000;
        [alertview show];
    }
}

#pragma mark--前往更新
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==4000) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:VersionUpdateDownloadAddress]];
    }
}


//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //推送消息置为0
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

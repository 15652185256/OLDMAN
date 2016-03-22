//
//  LoginViewModel.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/23.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

//登录操作
-(void) LoginSystem
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    
    NSDictionary * parameter = @{@"userName":[user objectForKey:UserName],@"passWord":[user objectForKey:PassWord]};
    
    //NSDictionary * parameter = @{@"userName":@"caiji",@"passWord":@"a123456"};
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:LoginHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        [self fetchValueSuccessWithDic:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        [self errorCodeWithDic:errorCode];
    } WithFailureBlock:^{
        [self netFailure];
    }];
}

#pragma 获取到正确的数据，对正确的数据进行处理
-(void)fetchValueSuccessWithDic: (NSDictionary *) returnValue
{
    //NSLog(@"%@",returnValue);
    
    if ([returnValue[@"success"] intValue]==1) {
        
        if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
            
            //修改 登录人 信息
            [user setObject:@"1" forKey:ISLOGIN];
            
            [user setObject:[returnValue[@"data"] objectForKey:doc_id] forKey:doc_id];//id
            
            [user setObject:[returnValue[@"data"] objectForKey:idenity] forKey:idenity];//身份
            
            //[user setObject:[returnValue[@"data"] objectForKey:ADDRESS] forKey:ADDRESS];//地址
            //[user setObject:[returnValue[@"data"] objectForKey:BIRTH_DATE] forKey:BIRTH_DATE];//生日
            //[user setObject:[returnValue[@"data"] objectForKey:CARDID] forKey:CARDID];//身份证
            
            //[user setObject:[returnValue[@"data"] objectForKey:DOC_NAME] forKey:DOC_NAME];//姓名
            
            //[user setObject:[returnValue[@"data"] objectForKey:EMAIL] forKey:EMAIL];//邮箱
            //[user setObject:[returnValue[@"data"] objectForKey:GENDER] forKey:GENDER];//性别
            //[user setObject:[returnValue[@"data"] objectForKey:IDENTITY] forKey:IDENTITY];//身份
            //[user setObject:[returnValue[@"data"] objectForKey:PHONE] forKey:PHONE];//电话
            //[user setObject:[returnValue[@"data"] objectForKey:QQ] forKey:QQ];//QQ
            
            //[user setObject:[returnValue objectForKey:TEL] forKey:TEL];//手机
            
            [user synchronize];
            
        }
    }
    //对从后台获取的数据进行处理，然后传给ViewController层进行显示
    self.returnBlock(returnValue);
}

#pragma 对ErrorCode进行处理
-(void) errorCodeWithDic: (NSDictionary *) errorDic
{
    self.errorBlock(errorDic);
}

#pragma 对网路异常进行处理
-(void) netFailure
{
    self.failureBlock();
}

@end

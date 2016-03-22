//
//  RootViewModel.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/23.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "RootViewModel.h"

#import "RootModel.h"//数据模型

@implementation RootViewModel

//请求数据列表
-(void)GetRootList:(NSString*)HTTP type:(int)type currentPage:(NSString*)currentPage pageSize:(NSString*)pageSize
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    
    NSDictionary * parameter;
    
    switch (type) {
        case 0:
            parameter = @{@"doc_id":[user objectForKey:doc_id],@"currentPage":currentPage,@"pageSize":pageSize};
            break;
        case 1:
            parameter = @{@"doc_id":[user objectForKey:doc_id],@"currentPage":currentPage,@"pageSize":pageSize};
            break;
        case 2:
            parameter = @{@"doc_id":[user objectForKey:doc_id],@"currentPage":currentPage,@"pageSize":pageSize,@"state":@"2"};
            break;
        case 3:
            parameter = @{@"doc_id":[user objectForKey:doc_id],@"currentPage":currentPage,@"pageSize":pageSize,@"state":@"3",@"type":@"all"};
            break;
        case 4:
            parameter = @{@"doc_id":[user objectForKey:doc_id],@"currentPage":currentPage,@"pageSize":pageSize,@"state":@"4"};
            break;
        case 5:
            parameter = @{@"doc_id":[user objectForKey:doc_id],@"currentPage":currentPage,@"pageSize":pageSize,@"state":@"5",@"type":@"all"};
            break;
        default:
            break;
    }
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:HTTP WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        [self fetchValueSuccessWithDic:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        [self errorCodeWithDic:errorCode];
    } WithFailureBlock:^{
        [self netFailure];
    }];
}

#pragma 获取到正确的数据，对正确的数据进行处理
-(void)fetchValueSuccessWithDic: (NSArray *) returnValue
{
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

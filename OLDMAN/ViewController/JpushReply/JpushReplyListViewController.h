//
//  JpushReplyListViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/24.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JpushReplyListViewController : UIViewController

@property(nonatomic,copy)NSString * content;//消息内容

@property(nonatomic,copy)NSString * NewsID;//消息ID

@property(nonatomic,copy)NSString * Time;//消息 发布时间

@property(nonatomic,copy)NSString * state;//消息 状态

@end

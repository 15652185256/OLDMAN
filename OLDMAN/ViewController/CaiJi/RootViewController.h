//
//  RootViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/15.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeiKaiShiViewController.h"//未开始

#import "JinXingZhongViewController.h"//进行中

#import "WeiTongGuoViewController.h"//未通过

#import "YiWanChengViewController.h"//已完成

@interface RootViewController : UIViewController<WeiKaiShiRefreshDelegate,JinXingZhongRefreshDelegate,WeiTongGuoRefreshDelegate,YiWanChengRefreshDelegate>

@end

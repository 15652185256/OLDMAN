//
//  YiShenHeViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/25.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YiShenHeViewController : UIViewController

//传值
@property(nonatomic,copy)void(^myBlock)(NSString*);

-(void)beginRefreshing;//刷新

@end

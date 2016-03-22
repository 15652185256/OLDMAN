//
//  YiWanChengViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/24.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YiWanChengRefreshDelegate <NSObject>
-(void)RefreshData;
@end

@interface YiWanChengViewController : UIViewController

@property (nonatomic,assign) id<YiWanChengRefreshDelegate> delegate;

//传值
@property(nonatomic,copy)void(^myBlock)(NSString*);

@end

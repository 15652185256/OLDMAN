//
//  YiShenHeViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/25.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YiShenHeRefreshDelegate <NSObject>
-(void)RefreshData;
@end

@interface YiShenHeViewController : UIViewController

@property (nonatomic,assign) id<YiShenHeRefreshDelegate> delegate;

//传值
@property(nonatomic,copy)void(^myBlock)(NSString*);

@end

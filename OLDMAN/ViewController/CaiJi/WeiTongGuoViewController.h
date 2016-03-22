//
//  WeiTongGuoViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/24.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeiTongGuoRefreshDelegate <NSObject>
-(void)RefreshData;
@end

@interface WeiTongGuoViewController : UIViewController

@property (nonatomic,assign) id<WeiTongGuoRefreshDelegate> delegate;

//传值
@property(nonatomic,copy)void(^myBlock)(NSString*);

@end

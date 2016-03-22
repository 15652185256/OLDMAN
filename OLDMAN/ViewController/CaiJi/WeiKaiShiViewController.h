//
//  WeiKaiShiViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/24.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeiKaiShiRefreshDelegate <NSObject>
-(void)RefreshData;
@end

@interface WeiKaiShiViewController : UIViewController

@property (nonatomic,assign) id<WeiKaiShiRefreshDelegate> delegate;

//传值
@property(nonatomic,copy)void(^myBlock)(NSString*);

@end

//
//  DaiShenHeViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/25.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaiShenHeRefreshDelegate <NSObject>
-(void)RefreshData;
@end

@interface DaiShenHeViewController : UIViewController

@property (nonatomic,assign) id<DaiShenHeRefreshDelegate> delegate;

//传值
@property(nonatomic,copy)void(^myBlock)(NSString*);

@end

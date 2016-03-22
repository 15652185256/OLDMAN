//
//  MainViewController.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/25.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DaiShenHeViewController.h"//待审核

#import "YiShenHeViewController.h"//已审核

@interface MainViewController : UIViewController<DaiShenHeRefreshDelegate,YiShenHeRefreshDelegate>

@end

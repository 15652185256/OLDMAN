//
//  RootViewModel.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/23.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "ViewModelClass.h"

@interface RootViewModel : ViewModelClass

//请求数据列表
-(void)GetRootList:(NSString*)HTTP type:(int)type currentPage:(NSString*)currentPage pageSize:(NSString*)pageSize;

@end

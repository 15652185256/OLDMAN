//
//  CollectViewModel.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/24.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "ViewModelClass.h"

@interface CollectViewModel : ViewModelClass

//请求数据列表
-(void)SelectAssessmentResult:(NSString*)shenFenZJ tableFlag:(NSString*)tableFlag;

@end

//
//  FunctionTableViewCell.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/21.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FunctionModel.h"

@interface FunctionTableViewCell : UITableViewCell

//标题
@property(nonatomic,retain) UILabel * title_Label;
//状态
@property(nonatomic,retain) UILabel * state_Label;
//右箭头
@property(nonatomic,retain) UIImageView * arrow_ImageView;
//图标
@property(nonatomic,retain) UIButton * letter_button;

-(void)configModel:(NSString*)title tag:(NSInteger)tag model:(FunctionModel*)model;

//传值
@property(nonatomic,copy)void(^myBlock)(NSInteger);

@end

//
//  SearchTableViewCell.h
//  OLDMAN
//
//  Created by 赵晓东 on 16/5/10.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootModel.h"

@interface SearchTableViewCell : UITableViewCell

//标号
@property(nonatomic,retain) UILabel * numberLabel;
//姓名
@property(nonatomic,retain) UILabel * xingMing_Label;
//身份证号
@property(nonatomic,retain) UILabel * shenFenZH_Label;
//分发
@property(nonatomic,retain) UIButton * send_Button;
//分割线
@property(nonatomic,retain) UIView * lineView;

-(void)configModel:(RootModel*)model row:(NSInteger)row;

//传值
@property(nonatomic,copy)void(^myBlock)(NSInteger);

@end

//
//  RootTableViewCell.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootModel.h"

@interface RootTableViewCell : UITableViewCell

//标号
@property(nonatomic,retain) UILabel * numberLabel;
//姓名
@property(nonatomic,retain) UILabel * xingMing_Label;
//身份证号
@property(nonatomic,retain) UILabel * shenFenZH_Label;
//图片地址
@property(nonatomic,copy) NSString * collect_filePath;//采集
@property(nonatomic,copy) NSString * assessment_filePath;//评估
//标志
@property(nonatomic,retain) UIImageView * state_ImageView;
//分割线
@property(nonatomic,retain) UIView * lineView;

-(void)configModel:(RootModel*)model row:(NSInteger)row;

@end

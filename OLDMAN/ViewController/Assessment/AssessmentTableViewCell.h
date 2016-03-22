//
//  AssessmentTableViewCell.h
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/12.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AssessmentModel.h"

@interface AssessmentTableViewCell : UITableViewCell

//标号背景
@property(nonatomic,retain) UIImageView * numberImageView;
//标号
@property(nonatomic,retain) UILabel * numberLabel;
//标题
@property(nonatomic,retain) UILabel * title_Label;
//标记
@property(nonatomic,retain) UILabel * tag_Label;
//右箭头
@property(nonatomic,retain) UIImageView * arrow_ImageView;
//对号
@property(nonatomic,retain) UIImageView * check_number_ImageView;


-(void)configModel:(NSString*)title row:(NSInteger)row state:(NSInteger)state assessmentModel:(AssessmentModel*)assessmentModel;

@end

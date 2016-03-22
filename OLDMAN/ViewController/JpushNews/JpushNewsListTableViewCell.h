//
//  JpushNewsListTableViewCell.h
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/17.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JpushNewsModel.h"
@interface JpushNewsListTableViewCell : UITableViewCell
//标志
@property(nonatomic,retain) UIView * isReadView;
//内容
@property(nonatomic,retain) UILabel * detailLabel;
//发布时间
@property(nonatomic,retain) UILabel * postTimeLabel;
//右箭头
@property(nonatomic,retain) UIImageView * arrowImageView;


@property(nonatomic,copy) NSString * labelText;

@property(nonatomic,retain) NSMutableAttributedString * attributedString;

@property(nonatomic,retain) NSMutableParagraphStyle * paragraphStyle;


-(void)configModel:(JpushNewsModel*)model;
@end

//
//  JpushReplyListTableViewCell.h
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/24.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JpushReplyModel.h"
@interface JpushReplyListTableViewCell : UITableViewCell
//标题
@property(nonatomic,retain) UILabel * titleLabel;
//内容
@property(nonatomic,retain) UILabel * detailLabel;
//发布时间
@property(nonatomic,retain) UILabel * postTimeLabel;
//右箭头
@property(nonatomic,retain) UIImageView * arrowImageView;
//分割线
@property(nonatomic,retain) UIView * lineView;


@property(nonatomic,assign,readonly) CGFloat cellHeight;

@property(nonatomic,assign,readonly) CGFloat rowHeight;


@property(nonatomic,assign) CGSize oldSize;

@property(nonatomic,assign) CGSize newSize;


-(void)configModel:(JpushReplyModel*)model;

@end

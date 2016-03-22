//
//  CollectTableViewCell.h
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/21.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectModel.h"

@interface CollectTableViewCell : UITableViewCell

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

-(void)configModel:(NSString*)title row:(NSInteger)row collectModel:(CollectModel*)collectModel;

@end

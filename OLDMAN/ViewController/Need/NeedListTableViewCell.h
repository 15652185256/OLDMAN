//
//  NeedListTableViewCell.h
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/2.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NeedModel.h"

@interface NeedListTableViewCell : UITableViewCell

//标号背景
@property(nonatomic,retain) UIImageView * numberImageView;
//标题
@property(nonatomic,retain) UILabel * title_Label;
//标记
@property(nonatomic,retain) UILabel * tag_Label;
//对号
@property(nonatomic,retain) UIImageView * check_number_ImageView;
//右箭头
@property(nonatomic,retain) UIImageView * arrow_ImageView;

-(void)configModel:(NSString*)title row:(NSInteger)row needModel:(NeedModel*)needModel;

@end

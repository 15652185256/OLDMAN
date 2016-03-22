//
//  AdviseListTableViewCell.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/3/1.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseListTableViewCell.h"

@implementation AdviseListTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self prepareUI];
    }
    return self;
}

-(void)prepareUI
{
    //self.contentView.backgroundColor=CREATECOLOR(246, 246, 246, 1);
    
    
    //姓名
    self.title_Label=[ZCControl createLabelWithFrame:CGRectMake(15.0, 0, Title_text_font*12, cell_Height) Font:cell_text_font Text:nil];
    [self.contentView addSubview:self.title_Label];
    self.title_Label.textColor=Title_text_color;
    
    //对号
    self.check_number_ImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-3.0-36.0, (cell_Height-24.0)/2, 24.0, 24.0) ImageName:@"check_number@2x"];
    
    
    
    //右箭头
    self.arrow_ImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-7.0, (cell_Height-12.0)/2, 7.0, 12.0) ImageName:@"personal_arrow@2x"];
    [self.contentView addSubview:self.arrow_ImageView];
    
}


-(void)configModel:(NSString*)title row:(NSInteger)row needModel:(NeedModel*)needModel
{
    self.title_Label.text=title;
    
    
    
    
    switch (row) {
        case 0:
            if ([needModel.yingYangSS intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 1:
            if ([needModel.yiLiaoWS intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 2:
            if ([needModel.jiaTingHL intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 3:
            if ([needModel.jinJiJY intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 4:
            if ([needModel.sheQuRJ intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 5:
            if ([needModel.jiaZhengFW intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 6:
            if ([needModel.xinLiWY intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 7:
            if ([needModel.qiTa intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 8:
            if ([needModel.teShuFW intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 9:
            if ([needModel.buChongXX intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        default:
            break;
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

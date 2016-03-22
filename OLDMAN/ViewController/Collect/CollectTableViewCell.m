//
//  CollectTableViewCell.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/21.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "CollectTableViewCell.h"

@implementation CollectTableViewCell

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
    //self.contentView.backgroundColor=View_Background_Color;
    
    
    //标题
    self.title_Label=[ZCControl createLabelWithFrame:CGRectMake(15.0, 0, Title_text_font*12, cell_Height) Font:cell_text_font Text:nil];
    [self.contentView addSubview:self.title_Label];
    self.title_Label.textColor=Title_text_color;
    
    //对号
    self.check_number_ImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-3.0-36.0, (cell_Height-24.0)/2, 24.0, 24.0) ImageName:@"check_number@2x"];
    //[self.contentView addSubview:self.check_number_ImageView];
    
    //标记
    self.tag_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMinX(self.check_number_ImageView.frame)-Tag_text_font*5, 0, Tag_text_font*5, cell_Height) Font:Tag_text_font Text:@"（必填项）"];
    self.tag_Label.textColor=Tag_text_color;
    
    
    //右箭头
    self.arrow_ImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-7.0, (cell_Height-12.0)/2, 7.0, 12.0) ImageName:@"personal_arrow@2x"];
    [self.contentView addSubview:self.arrow_ImageView];
}


-(void)configModel:(NSString*)title row:(NSInteger)row collectModel:(CollectModel*)collectModel
{
    self.title_Label.text=title;
    
    switch (row) {
        case 0:
            [self.contentView addSubview:self.tag_Label];
            break;
        case 1:
            [self.contentView addSubview:self.tag_Label];
            break;
        case 2:
            [self.contentView addSubview:self.tag_Label];
            break;
        case 3:
            [self.contentView addSubview:self.tag_Label];
            break;
        case 4:
            [self.contentView addSubview:self.tag_Label];
            break;
        case 5:
            [self.contentView addSubview:self.tag_Label];
            break;
        case 6:
            [self.contentView addSubview:self.tag_Label];
            break;
        case 7:
            [self.tag_Label removeFromSuperview];
            break;
        case 8:
            [self.tag_Label removeFromSuperview];
            break;
        case 9:
            [self.contentView addSubview:self.tag_Label];
            break;
        case 10:
            [self.tag_Label removeFromSuperview];
            break;
            
        default:
            break;
    }
    
    switch (row) {
        case 0:
            if ([collectModel.yongHuQZ intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 1:
            if ([collectModel.shenFenXX intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 2:
            if ([collectModel.geRenXX intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 3:
            if ([collectModel.jianHuRenXX intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 4:
            if ([collectModel.jinJiLX intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 5:
            if ([collectModel.muQianZK intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 6:
            if ([collectModel.yiQueZhenJB intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 7:
            if ([collectModel.jiaTingZH intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 8:
            if ([collectModel.waiBuTG intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 9:
            if ([collectModel.xinXiCJ intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 10:
            if ([collectModel.juJiaZH intValue]==1) {
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

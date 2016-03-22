//
//  AssessmentTableViewCell.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/12.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AssessmentTableViewCell.h"

@implementation AssessmentTableViewCell


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
    //姓名
    self.title_Label=[ZCControl createLabelWithFrame:CGRectMake(15.0, 0, Title_text_font*12, cell_Height) Font:cell_text_font Text:nil];
    [self.contentView addSubview:self.title_Label];
    self.title_Label.textColor=Title_text_color;
    
    
    //对号
    self.check_number_ImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-3.0-36.0, (cell_Height-24.0)/2, 24.0, 24.0) ImageName:@"check_number@2x"];
    
    
    //状态
    self.tag_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMinX(self.check_number_ImageView.frame)-Tag_text_font*6, 0, Tag_text_font*6, cell_Height) Font:Tag_text_font Text:@"（必填项）"];
    self.tag_Label.textColor=Tag_text_color;
    
    
    //右箭头
    self.arrow_ImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-7.0, (cell_Height-12.0)/2, 7.0, 12.0) ImageName:@"personal_arrow@2x"];
    [self.contentView addSubview:self.arrow_ImageView];
}


-(void)configModel:(NSString*)title row:(NSInteger)row state:(NSInteger)state assessmentModel:(AssessmentModel*)assessmentModel
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
            
        default:
            break;
    }

    
    if (state==1) {
        switch (row) {
            case 1:
                self.tag_Label.text=@"（无需采集）";
                break;
            case 2:
                self.tag_Label.text=@"（无需采集）";
                break;
            case 3:
                self.tag_Label.text=@"（无需采集）";
                break;
            case 4:
                self.tag_Label.text=@"（无需采集）";
                break;
            case 5:
                self.tag_Label.text=@"（无需采集）";
                break;
                
            default:
                break;
        }
    } else {
        
        switch (row) {
            case 1:
                self.tag_Label.text=@"（必填项）";
                break;
            case 2:
                self.tag_Label.text=@"（必填项）";
                break;
            case 3:
                self.tag_Label.text=@"（必填项）";
                break;
            case 4:
                self.tag_Label.text=@"（必填项）";
                break;
            case 5:
                self.tag_Label.text=@"（必填项）";
                break;
                
            default:
                break;
        }
    }
    
    
    
    
    switch (row) {
        case 0:
            if ([assessmentModel.pingGuJB intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 1:
            if ([assessmentModel.riChengSH intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 2:
            if ([assessmentModel.jingShenZT intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 3:
            if ([assessmentModel.ganZhiJ intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 4:
            if ([assessmentModel.sheHuiCY intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 5:
            if ([assessmentModel.buChongPG intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 6:
            if ([assessmentModel.nengLiPG intValue]==1) {
                [self.contentView addSubview:self.check_number_ImageView];
            } else {
                [self.check_number_ImageView removeFromSuperview];
            }
            break;
        case 8:
            if ([assessmentModel.pingGuBC intValue]==1) {
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

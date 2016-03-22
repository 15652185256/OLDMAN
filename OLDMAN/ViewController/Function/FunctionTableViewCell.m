//
//  FunctionTableViewCell.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/21.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "FunctionTableViewCell.h"

@implementation FunctionTableViewCell

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
    //标题
    self.title_Label=[ZCControl createLabelWithFrame:CGRectMake(15.0, 0, WIDTH-15.0-21.0-10.0-10.0, cell_Height) Font:cell_text_font Text:nil];
    [self.contentView addSubview:self.title_Label];
    self.title_Label.textColor=Title_text_color;
    
    //状态
    self.state_Label=[ZCControl createLabelWithFrame:CGRectMake(WIDTH-110.0-15.0-24.0-10.0, 0, 110.0, cell_Height) Font:cell_text_font Text:nil];
    
    //图标
    self.letter_button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-30.0-24.0-5.0, 0, 34.0, cell_Height) Text:nil ImageName:@"letter@2x" bgImageName:nil Target:self Method:@selector(button_Click:)];
    
    //右 箭头
    self.arrow_ImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-7.0, (cell_Height-12.0)/2, 7.0, 12.0) ImageName:@"personal_arrow@2x"];
}



-(void)configModel:(NSString*)title tag:(NSInteger)tag model:(FunctionModel*)model
{
    if (tag!=0) {
        [self.contentView addSubview:self.arrow_ImageView];
    }
    
    
    if (![PublicFunction isBlankString:model.assessment]) {
        switch (tag) {
            case 1:
            {
                [self.contentView addSubview:self.state_Label];
                self.state_Label.text=[PublicFunction selectState:[model.collection intValue]];
                self.state_Label.textColor=[PublicFunction selectState_textColor:[model.collection intValue]];
                if ([model.collection intValue]==5 || [model.collection intValue]==6) {
                    [self.contentView addSubview:self.letter_button];
                    self.letter_button.tag=1;
                } else {
                    [self.letter_button removeFromSuperview];
                }
            }
                break;
            case 2:
            {
                [self.contentView addSubview:self.state_Label];
                self.state_Label.text=[PublicFunction selectState:[model.assessment intValue]];
                self.state_Label.textColor=[PublicFunction selectState_textColor:[model.assessment intValue]];
                if ([model.assessment intValue]==5 || [model.assessment intValue]==6) {
                    [self.contentView addSubview:self.letter_button];
                    self.letter_button.tag=2;
                } else {
                    [self.letter_button removeFromSuperview];
                }
            }
                break;
            case 3:
            {
                [self.contentView addSubview:self.state_Label];
                self.state_Label.text=[PublicFunction selectState:[model.xuqiu intValue]];
                self.state_Label.textColor=[PublicFunction selectState_textColor:[model.xuqiu intValue]];
                if ([model.xuqiu intValue]==5 || [model.xuqiu intValue]==6) {
                    [self.contentView addSubview:self.letter_button];
                    self.letter_button.tag=3;
                } else {
                    [self.letter_button removeFromSuperview];
                }
            }
                break;
            case 4:
            {
                [self.contentView addSubview:self.state_Label];
                self.state_Label.text=[PublicFunction selectState:[model.jianyi intValue]];
                self.state_Label.textColor=[PublicFunction selectState_textColor:[model.jianyi intValue]];
                if ([model.jianyi intValue]==5 || [model.jianyi intValue]==6) {
                    [self.contentView addSubview:self.letter_button];
                    self.letter_button.tag=4;
                } else {
                    [self.letter_button removeFromSuperview];
                }
            }
                break;
            default:
                break;
        }
    }

    self.title_Label.text=title;
}



-(void)button_Click:(UIButton*)button
{
    if (self.myBlock) {
        self.myBlock(button.tag);
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

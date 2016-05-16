//
//  SearchTableViewCell.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/5/10.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

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
    //标号
    self.numberLabel=[ZCControl createLabelWithFrame:CGRectMake(15.0, 0, PAGESIZE(35.0), cell_Height) Font:10 Text:nil];
    [self.contentView addSubview:self.numberLabel];
    self.numberLabel.textColor=CREATECOLOR(49.0, 153.0, 49.0, 1);
    self.numberLabel.font=[UIFont boldSystemFontOfSize:PAGESIZE(14.0)];
    
    //姓名
    self.xingMing_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.numberLabel.frame), 0, PAGESIZE(80.0), cell_Height) Font:PAGESIZE(16.0) Text:nil];
    [self.contentView addSubview:self.xingMing_Label];
    self.xingMing_Label.textColor=Title_text_color;
    
    //身份证号
    self.shenFenZH_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.xingMing_Label.frame)+3.0, 0, WIDTH-(PAGESIZE(80.0)+PAGESIZE(35.0)+15.0)-60.0, cell_Height) Font:PAGESIZE(16.0) Text:nil];
    self.shenFenZH_Label.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.shenFenZH_Label];
    self.shenFenZH_Label.textColor=Title_text_color;
    
    
    //分发
    self.send_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-50.0, (cell_Height-24.0)/2, 40.0, 24.0) Text:@"分发" ImageName:nil bgImageName:nil Target:self Method:@selector(send_ButtonClick:)];
    [self.contentView addSubview:self.send_Button];
    [self.send_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.send_Button.titleLabel.font = [UIFont systemFontOfSize:PAGESIZE(13.0)];
    self.send_Button.backgroundColor = CREATECOLOR(49.0, 153.0, 49.0, 1);

    self.send_Button.layer.cornerRadius = 3;
    self.send_Button.layer.masksToBounds = YES;
    
    //分割线
    self.lineView=[ZCControl createView:CGRectMake(15.0, cell_Height-0.5, WIDTH-15.0, 0.5)];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor=Line_View_color;
}

-(void)send_ButtonClick:(UIButton*)button
{
    if (self.myBlock) {
        self.myBlock(button.tag);
    }
}

-(void)configModel:(RootModel*)model row:(NSInteger)row
{
    
    //标号
    self.numberLabel.text=[NSString stringWithFormat:@"%ld.",row+1];
    
    //姓名
    self.xingMing_Label.text=model.xingMing;
    
    //身份证
    self.shenFenZH_Label.text=model.shenFenZJ;
    
    self.send_Button.tag = row;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

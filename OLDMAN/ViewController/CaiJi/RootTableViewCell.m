//
//  RootTableViewCell.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "RootTableViewCell.h"

@implementation RootTableViewCell

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
    self.xingMing_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.numberLabel.frame), 0, PAGESIZE(95.0), cell_Height) Font:PAGESIZE(16.0) Text:nil];
    [self.contentView addSubview:self.xingMing_Label];
    self.xingMing_Label.textColor=Title_text_color;
    
    //身份证号
    self.shenFenZH_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.xingMing_Label.frame)+3.0, 0, WIDTH-(PAGESIZE(95.0)+PAGESIZE(35.0)+15.0)-35.0, cell_Height) Font:PAGESIZE(16.0) Text:nil];
    self.shenFenZH_Label.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.shenFenZH_Label];
    self.shenFenZH_Label.textColor=Title_text_color;
    
    
    //标志
    self.collect_filePath = [[NSBundle mainBundle] pathForResource:@"collect@2x" ofType:@"png"];
    self.assessment_filePath = [[NSBundle mainBundle] pathForResource:@"assessment@2x" ofType:@"png"];
    
    self.state_ImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-32.0, (cell_Height-24.0)/2, 24.0, 24.0) ImageName:nil];
    [self.contentView addSubview:self.state_ImageView];
    
    //分割线
    self.lineView=[ZCControl createView:CGRectMake(15.0, cell_Height-0.5, WIDTH-15.0, 0.5)];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor=Line_View_color;
}

-(void)configModel:(RootModel*)model row:(NSInteger)row
{
    
    //标号
    self.numberLabel.text=[NSString stringWithFormat:@"%ld.",row+1];
    
    //姓名
    self.xingMing_Label.text=model.xingMing;
    
    //身份证
    self.shenFenZH_Label.text=model.shenFenZJ;
    
    //标志
    if ([model.assessment_user_category intValue]==0) {
        self.state_ImageView.image=[UIImage imageWithContentsOfFile:self.collect_filePath];
    } else if ([model.assessment_user_category intValue]==1) {
        self.state_ImageView.image=[UIImage imageWithContentsOfFile:self.assessment_filePath];
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

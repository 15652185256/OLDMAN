//
//  JpushReplyListTableViewCell.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/24.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "JpushReplyListTableViewCell.h"

@implementation JpushReplyListTableViewCell

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
    self.contentView.backgroundColor=CREATECOLOR(246, 246, 246, 1);
    
    _cellHeight=80;

    //标题
    self.titleLabel=[ZCControl createLabelWithFrame:CGRectMake(15.0, 10.0, 50.0, 15.0) Font:15.0 Text:@"回复："];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor=Nav_Tabbar_backgroundColor;
    
    //发布时间
    self.postTimeLabel=[ZCControl createLabelWithFrame:CGRectMake(WIDTH-15.0-170.0, 10.0, 170.0, 15.0) Font:14.0 Text:nil];
    [self.contentView addSubview:self.postTimeLabel];
    self.postTimeLabel.textColor=Field_text_color;
    
    //右箭头
    self.arrowImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-7.0, 11.0, 7.0, 12.0) ImageName:@"personal_arrow@2x"];
    [self.contentView addSubview:self.arrowImageView];
    
    //内容    
    self.detailLabel=[ZCControl createLabelWithFrame:CGRectMake(15.0, 10.0+15.0+2.0, WIDTH-30.0, _cellHeight-(10.0+15.0+5.0+2.0)) Font:15.0 Text:nil];
    [self.contentView addSubview:self.detailLabel];
    self.detailLabel.textColor=Field_text_color;
    self.detailLabel.numberOfLines=0;
    
    
    //分割线
    self.lineView=[[UIView alloc]init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor=Line_View_color;
}

-(void)configModel:(JpushReplyModel*)model
{
    //发布时间
    self.postTimeLabel.text=model.time;
    
    self.detailLabel.frame=model.detailLabelF;
    self.detailLabel.text=[NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",model.content];
    
    self.lineView.frame=CGRectMake(15.0, model.cellHeight-0.5, WIDTH-15.0, 0.5);
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

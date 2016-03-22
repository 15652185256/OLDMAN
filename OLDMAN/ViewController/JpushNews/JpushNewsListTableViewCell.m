//
//  JpushNewsListTableViewCell.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/17.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "JpushNewsListTableViewCell.h"

@implementation JpushNewsListTableViewCell


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
    //发布时间
    self.postTimeLabel=[ZCControl createLabelWithFrame:CGRectMake(WIDTH-15.0-170.0, 10.0, 170.0, 14.0) Font:14.0 Text:nil];
    [self.contentView addSubview:self.postTimeLabel];
    self.postTimeLabel.textColor=Field_text_color;
    
    //右箭头
    self.arrowImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-10.0-7.0, 11.0, 7.0, 12.0) ImageName:@"personal_arrow@2x"];
    [self.contentView addSubview:self.arrowImageView];
    
    //内容
    self.detailLabel=[ZCControl createLabelWithFrame:CGRectMake(10.0+10.0+10.0, 10.0+14.0+3.0, WIDTH-45.0, 80.0-(10.0+14.0+5.0+3.0)) Font:15.0 Text:nil];
    [self.contentView addSubview:self.detailLabel];
    self.detailLabel.textColor=Field_text_color;
    self.detailLabel.numberOfLines=2;
    
}

-(void)configModel:(JpushNewsModel*)model
{
    //发布时间
    self.postTimeLabel.text=model.time;
    
    if (![PublicFunction isBlankString:model.content]) {
        //内容
        _labelText=[NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",model.content];
        
        _attributedString = [[NSMutableAttributedString alloc] initWithString:_labelText];
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [_paragraphStyle setLineSpacing:2];//调整行间距
        
        [_attributedString addAttribute:NSParagraphStyleAttributeName value:_paragraphStyle range:NSMakeRange(0, [_labelText length])];
        self.detailLabel.attributedText = _attributedString;
    }
    
    [self.isReadView removeFromSuperview];
    
    if ([model.state intValue]==0) {
        //标记
        self.isReadView=[ZCControl createView:CGRectMake(10, (80-10)/2, 10, 10)];
        self.isReadView.backgroundColor=CREATECOLOR(165, 197, 29, 1);
        self.isReadView.layer.cornerRadius=self.isReadView.frame.size.width/2;
        self.isReadView.layer.masksToBounds=YES;
        [self.contentView addSubview:self.isReadView];
        
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

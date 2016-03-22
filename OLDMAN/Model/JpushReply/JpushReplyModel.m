//
//  JpushReplyModel.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/24.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "JpushReplyModel.h"

@implementation JpushReplyModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}


- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        if (![PublicFunction isBlankString:self.content]) {
            
            CGSize oldSize = CGSizeMake(WIDTH-30, 9999);
            
            CGSize newSize = [self.content boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            
            if (newSize.height>50) {
                _cellHeight=80+(newSize.height-50)+12;
                
                _detailLabelF = CGRectMake(15, 30, WIDTH-30, newSize.height);
            } else {
                
                _cellHeight=80;
                
                _detailLabelF = CGRectMake(15, 30, WIDTH-30, 80);
            }
        }
    }
    
    return _cellHeight;
}
@end

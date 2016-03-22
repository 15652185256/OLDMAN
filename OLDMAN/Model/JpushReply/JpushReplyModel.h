//
//  JpushReplyModel.h
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/24.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JpushReplyModel : NSObject
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString * NewsID;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 内容控件的frame */
@property (nonatomic, assign) CGRect detailLabelF;
@end

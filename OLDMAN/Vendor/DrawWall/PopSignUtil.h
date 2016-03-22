//
//  PopSignUtil.h
//  YRF
//
//

#import <UIKit/UIKit.h>
#import "DrawSignView.h"



@interface PopSignUtil : UIView
@property(nonatomic,copy)CallBackBlock noB;

+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
          withCancel:(CallBackBlock)callBackBlock;
+(void)closePop;
@end

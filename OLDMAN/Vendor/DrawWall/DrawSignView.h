//
//  DrawSignView.h
//  YRF
//
//

#import <UIKit/UIKit.h>
#import "MyView.h"

typedef void(^SignCallBackBlock) (UIImage*);
typedef void(^CallBackBlock) ();

@interface DrawSignView : UIView


@property(nonatomic,copy)SignCallBackBlock signCallBackBlock;
@property(nonatomic,copy)CallBackBlock cancelBlock;
@end

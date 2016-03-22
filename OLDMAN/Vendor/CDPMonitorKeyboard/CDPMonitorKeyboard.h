//
//  CDPMonitorKeyboard.h
//  keyboard
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CDPMonitorKeyboard : NSObject

//获取其单例
+(CDPMonitorKeyboard *)defaultMonitorKeyboard;

//键盘出现时调用方法
-(void)keyboardWillShowWithSuperView:(UIView *)superView andNotification:(NSNotification *)notification higherThanKeyboard:(NSInteger)valueOfTheHigher contentOffsety:(float)contentOffsety;

//键盘消失时调用方法
-(void)keyboardWillHide;


@end

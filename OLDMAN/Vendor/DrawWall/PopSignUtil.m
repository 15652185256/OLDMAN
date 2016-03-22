//
//  PopSignUtil.m
//  YRF
//
//

#import "PopSignUtil.h"
//#import "ConformView.h"
//页面尺寸
#define WIDTH [UIScreen mainScreen].bounds.size.width    //屏幕宽度
#define HEIGHT [UIScreen mainScreen].bounds.size.height  //屏幕高度

#define SAFETY_RELEASE(x)   {[(x) release]; (x)=nil;}

static PopSignUtil *popSignUtil = nil;

@implementation PopSignUtil{
    UIButton *okBtn;
    UIButton *cancelBtn;
    //遮罩层
    UIView *zhezhaoView;
}


//取得单例实例(线程安全写法)
+(id)shareRestance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popSignUtil = [[PopSignUtil alloc]init];
    });
    return popSignUtil;
}


/** 构造函数 */
-(id)init{
    self = [super init];
    if (self) {
        //遮罩层
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return self;
}

//定制弹出框。模态对话框。
+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
         withCancel:(CallBackBlock)callBackBlock{
    PopSignUtil * p = [PopSignUtil shareRestance];
    [p setPopWithVC:VC withOk:signCallBackBlock withCancel:callBackBlock];
}


/** 设定 */
-(void)setPopWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
         withCancel:(CallBackBlock)cancelBlock{

    if (!zhezhaoView) {
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    
    [VC.view addSubview:zhezhaoView];
    
//    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    [appDelegate.window.rootViewController.view addSubview:zhezhaoView];
//    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    
    zhezhaoView.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT);

    DrawSignView * conformView = [[DrawSignView alloc]init];
    conformView.cancelBlock = cancelBlock;
    [cancelBlock release];
    conformView.signCallBackBlock  = signCallBackBlock;
    [signCallBackBlock release];

    conformView.frame = CGRectMake( 0, 0, WIDTH, HEIGHT);
    [zhezhaoView addSubview:conformView];
    [conformView release];

    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    zhezhaoView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [UIView commitAnimations];
}


/** 关闭弹出框 */
+(void)closePop{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p closePop];
}


/** 关闭弹出框 */
-(void)closePop{
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    [CATransaction begin];
    [UIView animateWithDuration:0.25f animations:^{
        zhezhaoView.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
    } completion:^(BOOL finished) {
        //都关闭啊都关闭
        [zhezhaoView removeFromSuperview];
        SAFETY_RELEASE(zhezhaoView);
    }];
    [CATransaction commit];
}




@end

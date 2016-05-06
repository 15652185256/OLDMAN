
#import "LoginViewController.h"

#import "LoginViewModel.h"//登录操作


#import "RootViewController.h"//采集

#import "MainViewController.h"//初审

//键盘移动
#import "CDPMonitorKeyboard.h"

#import "JPUSHService.h"//极光推送


#import "ForgetPasswordViewController.h"//忘记密码

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField * _userNameTextField;//用户名
    
    UITextField * _passwordTextField;//密码
    
}
@property(nonatomic,strong)ForgetPasswordViewController * ForgetPasswordVC;//忘记密码

@property(nonatomic,strong)UINavigationController * TopVC;//头

@property(nonatomic,strong)RootViewController * RootVC;//采集

@property(nonatomic,strong)MainViewController * MainVC;//初审
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    _ForgetPasswordVC=[[ForgetPasswordViewController alloc]init];//忘记密码
    
    _RootVC=[[RootViewController alloc]init];//采集
    
    _MainVC=[[MainViewController alloc]init];//初审
    
    //设置导航
    [self createNav];
    
    //创建页面
    [self createView];
}

#pragma mark 设置导航
-(void)createNav
{
    //设置背景
    UIImageView * bgImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) ImageName:@"login"];
    [self.view addSubview:bgImageView];
    
    //头部
    UIView * navView=[ZCControl createView:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:navView];
    navView.backgroundColor=Nav_Tabbar_backgroundColor;
    
    //标题
    UILabel * navTitleLabel=[ZCControl createLabelWithFrame:CGRectMake(0, 20, WIDTH, 44) Font:Title_text_font Text:@"北京市老年人评估及服务系统"];
    navTitleLabel.font=[UIFont boldSystemFontOfSize:Title_text_font];
    [self.view addSubview:navTitleLabel];
    navTitleLabel.textColor=CREATECOLOR(255, 255, 255, 1);
    navTitleLabel.textAlignment=NSTextAlignmentCenter;
}

//创建页面
-(void)createView
{
    
    float logoHeight=0;
    if (HEIGHT>480){
        logoHeight=PAGESIZE(270);
    }else{
        logoHeight=PAGESIZE(270)-17;
    }
    
    
    //logo
    UIImageView * logoImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, PAGESIZE(155), PAGESIZE(162)) ImageName:@"logo"];
    [self.view addSubview:logoImageView];
    logoImageView.center=CGPointMake(WIDTH/2, PAGESIZE(180));
    
    
    //账号
    UIImageView * userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6, 50)];
    _userNameTextField=[ZCControl createTextFieldWithFrame:CGRectMake(15, logoHeight+20, WIDTH-30, 50) placeholder:@"请输入用户名称" passWord:NO leftImageView:userImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    _userNameTextField.backgroundColor=CREATECOLOR(255, 255, 255, 1);
    _userNameTextField.textColor=CREATECOLOR(155, 155, 155, 1);
    [_userNameTextField setValue:CREATECOLOR(155, 155, 155, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_userNameTextField];
    _userNameTextField.delegate=self;
    
    
    //密码
    UIImageView * passwordImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6, 50)];
    _passwordTextField=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(_userNameTextField.frame)+10, WIDTH-30, 50) placeholder:@"请输入登录密码" passWord:YES leftImageView:passwordImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    _passwordTextField.backgroundColor=CREATECOLOR(255, 255, 255, 1);
    _passwordTextField.textColor=CREATECOLOR(155, 155, 155, 1);
    [_passwordTextField setValue:CREATECOLOR(155, 155, 155, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_passwordTextField];
    _passwordTextField.delegate=self;
    
    //忘记密码
    UIButton * forgetPassworkBurron=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-90, CGRectGetMaxY(_passwordTextField.frame)+17, 80, 21) Text:@"忘记密码?" ImageName:nil bgImageName:nil Target:self Method:@selector(forgetPassworkBurronClick)];
    forgetPassworkBurron.titleLabel.font=[UIFont systemFontOfSize:14];
    [forgetPassworkBurron setTitleColor:CREATECOLOR(77, 163, 29, 1) forState:UIControlStateNormal];
    [self.view addSubview:forgetPassworkBurron];

    
    //登录
    UIButton * loginButton=[ZCControl createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(forgetPassworkBurron.frame)+33, WIDTH-30, 50) Text:@"登录" ImageName:nil bgImageName:nil Target:self Method:@selector(loginButtonClick)];
    [loginButton setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    loginButton.titleLabel.font=[UIFont systemFontOfSize:18];
    [loginButton setBackgroundColor:Nav_Tabbar_backgroundColor];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5.0;
    [self.view addSubview:loginButton];
    
    
    
    if (HEIGHT>CGRectGetMaxY(loginButton.frame)+PAGESIZE(50)) {
        //公司名称
        UILabel * gongSiMC_label=[ZCControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(loginButton.frame)+PAGESIZE(50), WIDTH, 14) Font:13 Text:@"医养康（北京）健康管理有限公司"];
        [self.view addSubview:gongSiMC_label];
        gongSiMC_label.textColor=CREATECOLOR(155, 155, 155, 1);
        gongSiMC_label.textAlignment=NSTextAlignmentCenter;
        
        
        //版权所有
        UILabel * banQuanSY_label=[ZCControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(gongSiMC_label.frame)+PAGESIZE(10), WIDTH, 14) Font:13  Text:@"版权所有 @CopyRight 2007-2016"];
        [self.view addSubview:banQuanSY_label];
        banQuanSY_label.textColor=CREATECOLOR(155, 155, 155, 1);
        banQuanSY_label.textAlignment=NSTextAlignmentCenter;
    }
    
    //收起键盘
    UITapGestureRecognizer * tapRoot = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRootAction)];
    //设置点击次数
    tapRoot.numberOfTapsRequired = 1;
    //设置几根胡萝卜有效
    tapRoot.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRoot];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}



#pragma mark 忘记密码
-(void)forgetPassworkBurronClick
{
    _ForgetPasswordVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:_ForgetPasswordVC animated:YES completion:^{}];
}


#pragma mark 登录
-(void)loginButtonClick
{
    if ([_userNameTextField.text isEqualToString:@""]) {

        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入用户名称" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
//        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请输入用户名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
//        [alertController addAction:otherAction];
//        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if ([_passwordTextField.text isEqualToString:@""]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入登录密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else {
        
        
        NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
        
        [user setObject:_userNameTextField.text forKey:UserName];
        [user setObject:_passwordTextField.text forKey:PassWord];
        

        

        [KVNProgress show];
        
        LoginViewModel * _loginViewModel = [[LoginViewModel alloc] init];
        
        [_loginViewModel LoginSystem];
        
        [_loginViewModel setBlockWithReturnBlock:^(id returnValue) {
            
            [KVNProgress dismiss];
            
            if ([returnValue count]!=0) {
                
                if ([returnValue[@"success"] intValue]==1) {
                    
                    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                    
                    if ([[user objectForKey:ISLOGIN] intValue]==1) {
                        
                        dispatch_main_after(1.0f, ^{
                            [KVNProgress showSuccessWithStatus:@"登录成功"];
                            
                            dispatch_main_after(1.0f, ^{
                                
                                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                                
                                if ([[user objectForKey:idenity] intValue]==1) {
                                    _TopVC=[[UINavigationController alloc]initWithRootViewController:_RootVC];
                                    _TopVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                    [self presentViewController:_TopVC animated:YES completion:^{}];
                                } else {
                                    _TopVC=[[UINavigationController alloc]initWithRootViewController:_MainVC];
                                    _TopVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                    [self presentViewController:_TopVC animated:YES completion:^{}];
                                }
                                
                                [user synchronize];
                                
                                
                                //修改别名
                                if (![PublicFunction isBlankString:[user objectForKey:doc_id]]) {
                                    [JPUSHService setTags:nil alias:[user objectForKey:doc_id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                                        NSLog(@"nalias: %@\n",iAlias);
                                    }];
                                } else {
                                    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                                        NSLog(@"nalias: %@\n",iAlias);
                                    }];
                                }
                                
                                
                                
                                
                            });
                        });
                        
                    } else {
                        
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"用户名/密码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                    }
                    
                } else {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }
            } else {
            
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }

        } WithErrorBlock:^(id errorCode) {
            [KVNProgress dismiss];
        } WithFailureBlock:^{
            [KVNProgress dismiss];
        }];
    }
}



static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}






#pragma mark 输入完毕
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //收起键盘
    [self tapRootAction];
    
    return YES;
}

#pragma mark 键盘监听方法设置
//当键盘出现时调用
-(void)keyboardWillShow:(NSNotification *)aNotification
{
    //第一个参数写输入view的父view即可，第二个写监听获得的notification，第三个写希望高于键盘的高度(只在被键盘遮挡时才启用,如控件未被遮挡,则无变化)
    //如果想不通输入view获得不同高度，可自己在此方法里分别判断区别
    [[CDPMonitorKeyboard defaultMonitorKeyboard] keyboardWillShowWithSuperView:self.view andNotification:aNotification higherThanKeyboard:0 contentOffsety:0];
    
}
//当键退出时调用
-(void)keyboardWillHide:(NSNotification *)aNotification
{
    [[CDPMonitorKeyboard defaultMonitorKeyboard] keyboardWillHide];
}
//dealloc中需要移除监听
-(void)dealloc
{
    //移除监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    //移除监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
//收起键盘
-(void)tapRootAction
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

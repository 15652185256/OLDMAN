//
//  ForgetPasswordViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/21.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()
{
    UIWebView * webView;
    
    NSURLRequest * urlRequest;
}
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //设置导航
    [self createNav];
    
    //设置页面
    [self createView];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    [webView removeFromSuperview];
    urlRequest=nil;
}

#pragma mark 设置导航
-(void)createNav
{
    //导航条
    UIView * navView=[ZCControl createView:CGRectMake(0, 0, WIDTH, 64)];
    navView.backgroundColor=Nav_Tabbar_backgroundColor;
    [self.view addSubview:navView];
    
    //返回
    UIButton * returnButton=[ZCControl createButtonWithFrame:CGRectMake(15, 20+(44-18)/2, 100, 18) Text:nil ImageName:@"reg_return@2x.png" bgImageName:nil Target:self Method:@selector(returnButtonClick)];
    [navView addSubview:returnButton];
    returnButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 100/10*8);
    
    //标题
    UILabel * navTitleLabel=[ZCControl createLabelWithFrame:CGRectMake(0, 20, WIDTH, 44) Font:Title_text_font Text:@"忘记密码"];
    navTitleLabel.font=[UIFont boldSystemFontOfSize:Title_text_font];
    [self.view addSubview:navTitleLabel];
    navTitleLabel.textColor=CREATECOLOR(255, 255, 255, 1);
    navTitleLabel.textAlignment=NSTextAlignmentCenter;
    
}

//返回
-(void)returnButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark 设置页面
-(void)createView
{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    NSURL * url = [NSURL URLWithString:ForgetPasswordHttp];
    urlRequest = [NSURLRequest requestWithURL:url];
}
//请求数据
-(void)loadData
{
    [webView loadRequest:urlRequest];
    [self.view addSubview:webView];
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

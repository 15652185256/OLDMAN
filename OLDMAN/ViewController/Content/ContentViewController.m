//
//  ContentViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/17.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()
{
    UIWebView * webView;
    
    NSURL * url;
    
    NSURLRequest * urlRequest;
}
@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景
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
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"注意事项";
    
    //设置导航背景图
    self.navigationController.navigationBar.barTintColor = Nav_Tabbar_backgroundColor;
    
    //返回
    UIButton * returnButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 10, 18) Text:nil ImageName:nil bgImageName:@"reg_return@2x.png" Target:self Method:@selector(returnButtonClick)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:returnButton];
}

//返回
-(void)returnButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 设置页面
-(void)createView
{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    url = [NSURL URLWithString:MattersNeedAttentionHttp];
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

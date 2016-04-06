//
//  MainViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/25.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "MainViewController.h"

#import "UserCountModel.h"

#import "DaiShenHeViewController.h"//待审核

#import "YiShenHeViewController.h"//已审核

//登录页
#import "LoginViewController.h"
//功能列表
#import "FunctionViewController.h"




#import "FMDBManager.h"

#import "JpushNewsListViewController.h"//推送信息


#import "JPUSHService.h"//极光推送


@interface MainViewController ()<UIScrollViewDelegate>
{
    UIView * hengView;//标记横线
    
    UIView * navigationView;//头部视图
    
    int nav_height;//头部视图 高度
    
    
    //设置信息按钮
    UIButton * _newsButton;
    
    UILabel * Dai_label;//待审核
    
    UILabel * Yi_label;//已审核
    
    UserCountModel * _userCountModel;//数据源
    
    NSInteger index;//页码
}
//头标题数组
@property(nonatomic,retain)NSArray * titleArray;

@property(nonatomic,retain)UIScrollView * rootScrollView;

@property(nonatomic,retain)LoginViewController * LoginVC;//登录页

@property(nonatomic,retain)DaiShenHeViewController * dvc;//待审核

@property(nonatomic,retain)YiShenHeViewController * yvc;//已审核

@property(nonatomic,retain)JpushNewsListViewController * JpushNewsVC;//推送信息

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    _LoginVC=[[LoginViewController alloc]init];//登录页
    
    _JpushNewsVC=[[JpushNewsListViewController alloc]init];//推送信息
    
    _userCountModel=[[UserCountModel alloc]init];//数据源
    
    index=0;

    //设置导航
    [self createNav];
    
    //设置头部
    [self createTopView];

    //设置页面
    [self createView];
    
    //注册 自定义消息
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

//dealloc中需要移除监听
-(void)dealloc
{
    //注册 自定义消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    //刷新页面
    [self RefreshView];
    
    if ([[FMDBManager shareManager] IsSelectNewsData].count!=0) {
        //设置信息按钮
        [_newsButton setImage:[UIImage imageNamed:@"nav_news@2x"] forState:UIControlStateNormal];
    } else {
        //设置信息按钮
        [_newsButton setImage:[UIImage imageNamed:@"nav_un_news@2x"] forState:UIControlStateNormal];
    }
}

//接受自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    if ([[FMDBManager shareManager] IsSelectNewsData].count!=0) {
        //设置信息按钮
        [_newsButton setImage:[UIImage imageNamed:@"nav_news@2x"] forState:UIControlStateNormal];
    } else {
        //设置信息按钮
        [_newsButton setImage:[UIImage imageNamed:@"nav_un_news@2x"] forState:UIControlStateNormal];
    }
}

//请求 头部人数 数据
-(void)RefreshData
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    
    NSDictionary * parameter = @{@"doc_id":[user objectForKey:doc_id]};
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getUserCountWithAssessmentHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_userCountModel setValuesForKeysWithDictionary:returnValue[@"data"]];
                
                if ([_userCountModel.waittingforexamine intValue]!=0) {
                    Dai_label.text=[NSString stringWithFormat:@"(%@)",_userCountModel.waittingforexamine];
                } else {
                    Dai_label.text=@"";
                }
                
                if ([_userCountModel.examinecomplete intValue]!=0) {
                    Yi_label.text=[NSString stringWithFormat:@"(%@)",_userCountModel.examinecomplete];
                } else {
                    Yi_label.text=@"";
                }
                
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}


#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航背景图
    self.navigationController.navigationBar.barTintColor = Nav_Tabbar_backgroundColor;
    
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"北京市老年人评估及服务系统";
    
    
    //设置信息按钮
    _newsButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 22, 18) Text:nil ImageName:nil bgImageName:nil Target:self Method:@selector(newsButtonClick)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_newsButton];
    
    
}

#pragma mark 设置头部
-(void)createTopView
{
    //头部视图 高度
    nav_height=65;
    
    
    navigationView=[ZCControl createView:CGRectMake(0, 0, WIDTH, nav_height)];
    navigationView.backgroundColor=View_Background_Color;
    [self.view addSubview:navigationView];
    
    
    self.titleArray=@[@"待审核",@"已完成"];
    
    hengView=[[UIView alloc] initWithFrame:CGRectMake(0, nav_height-3, WIDTH/self.titleArray.count,3)];
    hengView.backgroundColor=Nav_Tabbar_backgroundColor;
    [navigationView addSubview:hengView];
    
    
    //待审核
    UIButton * Dai_Button=[ZCControl createButtonWithFrame:CGRectMake(0, 0, WIDTH/self.titleArray.count, nav_height) Text:self.titleArray[0] ImageName:nil bgImageName:nil Target:self Method:@selector(title_Button_Click:)];
    [navigationView addSubview:Dai_Button];
    Dai_Button.tag=3000;
    Dai_Button.titleLabel.font=[UIFont systemFontOfSize:14];
    [Dai_Button setTitleColor:Nav_Tabbar_backgroundColor forState:UIControlStateNormal];
    Dai_Button.titleEdgeInsets=UIEdgeInsetsMake(28, 0, 0, 0);
    
    
    UIImageView * Dai_imageView=[ZCControl createImageViewWithFrame:CGRectMake((WIDTH/self.titleArray.count-22)/2, 10, 22, 22) ImageName:@"history@2x"];
    [Dai_Button addSubview:Dai_imageView];
    Dai_imageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer * tap_Dai = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_switch_GestureAction:)];
    [Dai_imageView addGestureRecognizer:tap_Dai];
    
    Dai_label=[ZCControl createLabelWithFrame:CGRectMake(WIDTH/4+24, 28, WIDTH/4, nav_height-28) Font:11 Text:@"222"];
    Dai_label.textColor=[UIColor redColor];
    [Dai_Button addSubview:Dai_label];
    
    
    //已审核
    UIButton * Yi_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/self.titleArray.count, 0, WIDTH/self.titleArray.count, nav_height) Text:self.titleArray[1] ImageName:nil bgImageName:nil Target:self Method:@selector(title_Button_Click:)];
    [navigationView addSubview:Yi_Button];
    Yi_Button.tag=3001;
    Yi_Button.titleLabel.font=[UIFont systemFontOfSize:14];
    [Yi_Button setTitleColor:CREATECOLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    Yi_Button.titleEdgeInsets=UIEdgeInsetsMake(28, 0, 0, 0);
    
    UIImageView * Yi_imageView=[ZCControl createImageViewWithFrame:CGRectMake((WIDTH/self.titleArray.count-22)/2, 10, 22, 22) ImageName:@"complete@2x"];
    [Yi_Button addSubview:Yi_imageView];
    Yi_imageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer * tap_Yi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_switch_GestureAction:)];
    [Yi_imageView addGestureRecognizer:tap_Yi];
    
    
    Yi_label=[ZCControl createLabelWithFrame:CGRectMake(WIDTH/4+24, 28, WIDTH/4, nav_height-28) Font:11 Text:nil];
    Yi_label.textColor=[UIColor redColor];
    [Yi_Button addSubview:Yi_label];
}





//信息按钮跳转
-(void)newsButtonClick
{
    //系统消息
    [self.navigationController pushViewController:_JpushNewsVC animated:YES];
}



#pragma mark 点击切换
-(void)tap_switch_GestureAction:(UITapGestureRecognizer*)tap
{
    for (int j=0; j<self.titleArray.count; j++) {
        UIButton * allbutton=(UIButton*)[navigationView viewWithTag:3000+j];
        [allbutton setTitleColor:CREATECOLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    }
    
    UIButton * button=(UIButton*)tap.view.superview;
    
    [button setTitleColor:Nav_Tabbar_backgroundColor forState:UIControlStateNormal];
    
    CGPoint center = hengView.center;
    [UIView beginAnimations:@"" context:nil];
    center.x = button.center.x;
    [UIView setAnimationDuration:0.01];
    hengView.center = center;
    [UIView commitAnimations];
    
    //更改页码
    _rootScrollView.contentOffset=CGPointMake(WIDTH*(button.tag-3000), 0);
    index=button.tag-3000;
    
    //刷新页面
    [self RefreshView];
}


//点击切换
-(void)title_Button_Click:(UIButton*)button
{
    for (int j=0; j<self.titleArray.count; j++) {
        UIButton * allbutton=(UIButton*)[navigationView viewWithTag:3000+j];
        [allbutton setTitleColor:CREATECOLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    }
    
    [button setTitleColor:Nav_Tabbar_backgroundColor forState:UIControlStateNormal];
    
    CGPoint center = hengView.center;
    [UIView beginAnimations:@"" context:nil];
    center.x = button.center.x;
    [UIView setAnimationDuration:0.01];
    hengView.center = center;
    [UIView commitAnimations];
    
    //更改页码
    _rootScrollView.contentOffset=CGPointMake(WIDTH*(button.tag-3000), 0);
    index=button.tag-3000;
    
    //刷新页面
    [self RefreshView];
}



#pragma mark 设置页面
-(void)createView
{
    //主视图
    _rootScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, nav_height, WIDTH, HEIGHT-64-nav_height-Tabbar_HE)];
    [self.view addSubview:_rootScrollView];
    
    FunctionViewController * fvc=[[FunctionViewController alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    _dvc=[[DaiShenHeViewController alloc]init];
    _dvc.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT-64-44-Tabbar_HE);
    [_rootScrollView addSubview:_dvc.view];
    _dvc.myBlock=^(NSString * shenFenZJ){
        fvc.shenFenZJ=shenFenZJ;
        [weakSelf.navigationController pushViewController:fvc animated:YES];
    };
    
    _yvc=[[YiShenHeViewController alloc]init];
    _yvc.view.frame=CGRectMake(WIDTH, 0, WIDTH, HEIGHT-64-44-Tabbar_HE);
    _yvc.myBlock=^(NSString * shenFenZJ){
        fvc.shenFenZJ=shenFenZJ;
        [weakSelf.navigationController pushViewController:fvc animated:YES];
    };
    
    
    _rootScrollView.contentSize=CGSizeMake(WIDTH*4, 0);
    //设置允许翻页
    _rootScrollView.pagingEnabled=YES;
    //设置代理
    _rootScrollView.delegate=self;
    
    //禁用滚动条,防止缩放还原时崩溃
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.bounces = NO;
    
    
    
    //设置退出按钮
    UIButton * exit_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"退出" ImageName:nil bgImageName:nil Target:self Method:@selector(exit_Button_Click)];
    [self.view addSubview:exit_Button];
    [exit_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    exit_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [exit_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
}

#pragma mark 退出登录
-(void)exit_Button_Click
{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.tag=4000;
    [alertview show];
}

#pragma mark 退出登录
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==4000) {
        if (buttonIndex==1) {
            NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
            [user setObject:@"0" forKey:ISLOGIN]; //状态
            //[user setObject:@"" forKey:doc_id];   //id
            [user setObject:@"" forKey:idenity];  //身份
            [user synchronize];
            
            
            //跳转登陆页
            _LoginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:_LoginVC animated:YES completion:^{}];
            [self.view removeFromSuperview];
            
            
//            //修改别名
//            if (![PublicFunction isBlankString:[user objectForKey:doc_id]]) {
//                [JPUSHService setTags:nil alias:[user objectForKey:doc_id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
//                    NSLog(@"nalias: %@\n",iAlias);
//                }];
//            } else {
//                [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
//                    NSLog(@"nalias: %@\n",iAlias);
//                }];
//            }
        }
    }
    
}

//代理相应
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更改页码
    index=scrollView.contentOffset.x/WIDTH;
    
    for (int j=0; j<self.titleArray.count; j++) {
        UIButton * allbutton=(UIButton*)[navigationView viewWithTag:3000+j];
        [allbutton setTitleColor:CREATECOLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    }
    
    UIButton * tapButton=(UIButton*)[navigationView viewWithTag:3000+index];
    [tapButton setTitleColor:Nav_Tabbar_backgroundColor forState:UIControlStateNormal];
    
    CGPoint center = hengView.center;
    [UIView beginAnimations:@"" context:nil];
    center.x = tapButton.center.x;
    [UIView setAnimationDuration:0.01];
    hengView.center = center;
    [UIView commitAnimations];
    
    
    //刷新页面
    [self RefreshView];
    
}

//刷新页面
-(void)RefreshView
{
    //请求 头部人数 数据
    [self RefreshData];
    
    [_dvc.view removeFromSuperview];
    [_yvc.view removeFromSuperview];
    switch (index) {
        case 0:
            [_rootScrollView addSubview:_dvc.view];
            [_dvc beginRefreshing];
            break;
        case 1:
            [_rootScrollView addSubview:_yvc.view];
            [_yvc beginRefreshing];
            break;
        default:
            break;
    }
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

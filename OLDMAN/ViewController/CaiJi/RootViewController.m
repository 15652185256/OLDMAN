//
//  RootViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/15.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "RootViewController.h"

#import "UserCountModel.h"



#import "LoginViewController.h"//登录页

#import "FunctionViewController.h"//功能列表

#import "JpushNewsListViewController.h"//推送信息


#import "WeiKaiShiViewController.h"//未开始

#import "JinXingZhongViewController.h"//进行中

#import "WeiTongGuoViewController.h"//未通过

#import "YiWanChengViewController.h"//已完成


#import "FMDBManager.h"//数据库

#import "JPUSHService.h"//极光推送


@interface RootViewController ()<UIScrollViewDelegate>
{
    UIView * hengView;//标记横线
    
    UIView * navigationView;//头部视图
    
    int nav_height;//头部视图 高度
    
    
    //设置信息按钮
    UIButton * _newsButton;
    
    
    UILabel * _kaiShi_label;//未开始
    
    UILabel * _jinXing_label;//进行中
    
    UILabel * _tongGuo_label;//未通过
    
    UILabel * _wanCheng_label;//已完成
    
    
    UIScrollView * _rootScrollView;//主视图
    
    UserCountModel * _userCountModel;//数据源
    
    NSInteger index;//页码
}

//头标题数组
@property(nonatomic,retain)NSArray * titleArray;

@property(nonatomic,retain)LoginViewController * LoginVC;//登录页

@property(nonatomic,retain)WeiKaiShiViewController * kvc;//未开始

@property(nonatomic,retain)JinXingZhongViewController * jvc;//进行中

@property(nonatomic,retain)WeiTongGuoViewController * tvc;//未通过

@property(nonatomic,retain)YiWanChengViewController * wvc;//已完成

@property(nonatomic,retain)JpushNewsListViewController * JpushNewsVC;//推送信息

@end

@implementation RootViewController

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


//刷新
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
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getUserCountWithCollectionHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_userCountModel setValuesForKeysWithDictionary:returnValue[@"data"]];
                
                if ([_userCountModel.nostart intValue]!=0) {
                    _kaiShi_label.text=[NSString stringWithFormat:@"(%@)",_userCountModel.nostart];
                } else {
                    _kaiShi_label.text=@"";
                }
                
                if ([_userCountModel.running intValue]!=0) {
                    _jinXing_label.text=[NSString stringWithFormat:@"(%@)",_userCountModel.running];
                } else {
                    _jinXing_label.text=@"";
                }
                
                if ([_userCountModel.nothrough intValue]!=0) {
                    _tongGuo_label.text=[NSString stringWithFormat:@"(%@)",_userCountModel.nothrough];
                } else {
                    _tongGuo_label.text=@"";
                }
                
                if ([_userCountModel.collectioncomplete intValue]!=0) {
                    _wanCheng_label.text=[NSString stringWithFormat:@"(%@)",_userCountModel.collectioncomplete];
                } else {
                    _wanCheng_label.text=@"";
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
    
    hengView=[[UIView alloc] initWithFrame:CGRectMake(0, nav_height-3, WIDTH/4, 3)];
    hengView.backgroundColor=CREATECOLOR(86, 174, 215, 1);
    [navigationView addSubview:hengView];
    
    self.titleArray=@[@"未开始",@"进行中",@"未通过",@"已完成"];
    //未开始
    UIButton * kaiShi_Button=[ZCControl createButtonWithFrame:CGRectMake(0, 0, WIDTH/4, nav_height) Text:self.titleArray[0] ImageName:nil bgImageName:nil Target:self Method:@selector(title_Button_Click:)];
    [navigationView addSubview:kaiShi_Button];
    kaiShi_Button.tag=3000;
    kaiShi_Button.titleLabel.font=[UIFont systemFontOfSize:13];
    [kaiShi_Button setTitleColor:Nav_Tabbar_backgroundColor forState:UIControlStateNormal];
    kaiShi_Button.titleEdgeInsets=UIEdgeInsetsMake(28, 0, 0, 0);
    
    UIImageView * kaiShi_imageView=[ZCControl createImageViewWithFrame:CGRectMake((WIDTH/4-22)/2, 10, 22, 22) ImageName:@"history@2x"];
    [kaiShi_Button addSubview:kaiShi_imageView];
    kaiShi_imageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer * tap_kaiShi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_switch_GestureAction:)];
    [kaiShi_imageView addGestureRecognizer:tap_kaiShi];
    
    
    _kaiShi_label=[ZCControl createLabelWithFrame:CGRectMake(WIDTH/8+21, 28, WIDTH/8, nav_height-28) Font:11 Text:nil];
    _kaiShi_label.textColor=[UIColor redColor];
    [kaiShi_Button addSubview:_kaiShi_label];
    
    
    //进行中
    UIButton * jinXing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/4, 0, WIDTH/4, nav_height) Text:self.titleArray[1] ImageName:nil bgImageName:nil Target:self Method:@selector(title_Button_Click:)];
    [navigationView addSubview:jinXing_Button];
    jinXing_Button.tag=3001;
    jinXing_Button.titleLabel.font=[UIFont systemFontOfSize:13];
    [jinXing_Button setTitleColor:CREATECOLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    jinXing_Button.titleEdgeInsets=UIEdgeInsetsMake(28, 0, 0, 0);
    
    UIImageView * jinXing_imageView=[ZCControl createImageViewWithFrame:CGRectMake((WIDTH/4-22)/2, 10, 22, 22) ImageName:@"reply@2x"];
    [jinXing_Button addSubview:jinXing_imageView];
    jinXing_imageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer * tap_jinXing = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_switch_GestureAction:)];
    [jinXing_imageView addGestureRecognizer:tap_jinXing];
    
    
    _jinXing_label=[ZCControl createLabelWithFrame:CGRectMake(WIDTH/8+21, 28, WIDTH/8, nav_height-28) Font:11 Text:nil];
    _jinXing_label.textColor=[UIColor redColor];
    [jinXing_Button addSubview:_jinXing_label];
    
    //未通过
    UIButton * tongGuo_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/4*2, 0, WIDTH/4, nav_height) Text:self.titleArray[2] ImageName:nil bgImageName:nil Target:self Method:@selector(title_Button_Click:)];
    [navigationView addSubview:tongGuo_Button];
    tongGuo_Button.tag=3002;
    tongGuo_Button.titleLabel.font=[UIFont systemFontOfSize:13];
    [tongGuo_Button setTitleColor:CREATECOLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    tongGuo_Button.titleEdgeInsets=UIEdgeInsetsMake(28, 0, 0, 0);
    
    UIImageView * tongGuo_imageView=[ZCControl createImageViewWithFrame:CGRectMake((WIDTH/4-22)/2, 10, 22, 22) ImageName:@"close@2x"];
    [tongGuo_Button addSubview:tongGuo_imageView];
    tongGuo_imageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer * tap_tongGuo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_switch_GestureAction:)];
    [tongGuo_imageView addGestureRecognizer:tap_tongGuo];
    
    
    _tongGuo_label=[ZCControl createLabelWithFrame:CGRectMake(WIDTH/8+21, 28, WIDTH/8, nav_height-28) Font:11 Text:nil];
    _tongGuo_label.textColor=[UIColor redColor];
    [tongGuo_Button addSubview:_tongGuo_label];
    
    
    //已完成
    UIButton * wanCheng_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/4*3, 0, WIDTH/4, nav_height) Text:self.titleArray[3] ImageName:nil bgImageName:nil Target:self Method:@selector(title_Button_Click:)];
    [navigationView addSubview:wanCheng_Button];
    wanCheng_Button.tag=3003;
    wanCheng_Button.titleLabel.font=[UIFont systemFontOfSize:13];
    [wanCheng_Button setTitleColor:CREATECOLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    wanCheng_Button.titleEdgeInsets=UIEdgeInsetsMake(28, 0, 0, 0);
    
    UIImageView * wanCheng_imageView=[ZCControl createImageViewWithFrame:CGRectMake((WIDTH/4-22)/2, 10, 22, 22) ImageName:@"complete@2x"];
    [wanCheng_Button addSubview:wanCheng_imageView];
    wanCheng_imageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer * tap_wanCheng = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_switch_GestureAction:)];
    [wanCheng_imageView addGestureRecognizer:tap_wanCheng];
    
    
    _wanCheng_label=[ZCControl createLabelWithFrame:CGRectMake(WIDTH/8+21, 28, WIDTH/8, nav_height-28) Font:11  Text:nil];
    _wanCheng_label.textColor=[UIColor redColor];
    [wanCheng_Button addSubview:_wanCheng_label];
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
    _rootScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, nav_height, WIDTH, HEIGHT-64-Tabbar_HE-nav_height)];
    [self.view addSubview:_rootScrollView];
    
    FunctionViewController * fvc=[[FunctionViewController alloc]init];//功能列表
    
    __weak typeof(self) weakSelf = self;
    
    _kvc=[[WeiKaiShiViewController alloc]init];
    _kvc.view.frame=CGRectMake(0, 0, WIDTH, _rootScrollView.frame.size.height);
    [_rootScrollView addSubview:_kvc.view];
    _kvc.myBlock=^(NSString * shenFenZJ){
        fvc.shenFenZJ=shenFenZJ;
        [weakSelf.navigationController pushViewController:fvc animated:YES];
    };
    
    _jvc=[[JinXingZhongViewController alloc]init];
    _jvc.view.frame=CGRectMake(WIDTH, 0, WIDTH, _rootScrollView.frame.size.height);
    _jvc.myBlock=^(NSString * shenFenZJ){
        fvc.shenFenZJ=shenFenZJ;
        [weakSelf.navigationController pushViewController:fvc animated:YES];
    };
    
    _tvc=[[WeiTongGuoViewController alloc]init];
    _tvc.view.frame=CGRectMake(WIDTH*2, 0, WIDTH, _rootScrollView.frame.size.height);
    _tvc.myBlock=^(NSString * shenFenZJ){
        fvc.shenFenZJ=shenFenZJ;
        [weakSelf.navigationController pushViewController:fvc animated:YES];
    };
    
    _wvc=[[YiWanChengViewController alloc]init];
    _wvc.view.frame=CGRectMake(WIDTH*3, 0, WIDTH, _rootScrollView.frame.size.height);
    _wvc.myBlock=^(NSString * shenFenZJ){
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
    alertview.tag=40000;
    [alertview show];
}

#pragma mark 退出登录
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==40000) {
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
    
    [_kvc.view removeFromSuperview];
    [_jvc.view removeFromSuperview];
    [_tvc.view removeFromSuperview];
    [_wvc.view removeFromSuperview];
    switch (index) {
        case 0:
            [_rootScrollView addSubview:_kvc.view];
            [_kvc beginRefreshing];
            break;
        case 1:
            [_rootScrollView addSubview:_jvc.view];
            [_jvc beginRefreshing];
            break;
        case 2:
            [_rootScrollView addSubview:_tvc.view];
            [_tvc beginRefreshing];
            break;
        case 3:
            [_rootScrollView addSubview:_wvc.view];
            [_wvc beginRefreshing];
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

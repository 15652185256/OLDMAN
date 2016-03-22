//
//  CollectViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/17.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectModel.h"
#import "CollectTableViewCell.h"

#import "YongHuQZViewController.h"//用户签字

#import "ShenFenXXViewController.h"//身份信息

#import "GeRenXXViewController.h"//个人信息

#import "JianHuRenXXViewController.h"//监护人信息

#import "JinJiLXViewController.h"//紧急联系人信息

#import "MuQianZKViewController.h"//目前生活状况

#import "YiQueZhenJBViewController.h"//已确诊的疾病

#import "JiaTingZHViewController.h"//家庭主要照护者信息

#import "WaiBuTGViewController.h"//外部提供专业看护服务

#import "XinXiCJViewController.h"//信息采集初步结果

#import "JuJiaZHViewController.h"//居家照护管理员信息


#import "BoHuiViewController.h"//驳回原因

#import "FunctionViewModel.h"
#import "FunctionModel.h"


@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;//主视图
    
    UIButton * _Save_Button;//提交
    
    UIButton * _BoHui_Button;//驳回
    
    UIButton * _TongGuo_Button;//通过
    
    FunctionModel * _functionModel;//大项状态

    CollectModel * _collectModel;//小项状态
    
    NSArray * _titleArray;//标题
    
    UIButton * _returnButton;
}
@property(nonatomic,retain)YongHuQZViewController * YongHuQZVC;//用户签字

@property(nonatomic,retain)ShenFenXXViewController * ShenFenXXVC;//身份信息

@property(nonatomic,retain)GeRenXXViewController * GeRenXXVC;//个人信息

@property(nonatomic,retain)JianHuRenXXViewController * JianHuRenXXVC;//监护人信息

@property(nonatomic,retain)JinJiLXViewController * JinJiLXVC;//紧急联系人信息

@property(nonatomic,retain)MuQianZKViewController * MuQianZKVC;//目前生活状况

@property(nonatomic,retain)YiQueZhenJBViewController * YiQueZhenJBVC;//已确诊的疾病

@property(nonatomic,retain)JiaTingZHViewController * JiaTingZHVC;//家庭主要照护者信息

@property(nonatomic,retain)WaiBuTGViewController * WaiBuTGVC;//外部提供专业看护服务

@property(nonatomic,retain)XinXiCJViewController * XinXiCJVC;//信息采集初步结果

@property(nonatomic,retain)JuJiaZHViewController * JuJiaZHVC;//居家照护管理员信息

@property(nonatomic,retain)BoHuiViewController * BoHuiVC;//驳回原因

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景
    self.view.backgroundColor=View_Background_Color;
    
    
    _titleArray=[NSArray arrayWithObjects:@"一.  服务协议",@"二.  身份信息",@"三.  个人信息",@"四.  监护人信息",@"五.  紧急联系人信息",@"六.  目前生活状况",@"七.  已确诊的疾病",@"八.  家庭主要照护者信息",@"九.  外部提供专业看护服务",@"十.  信息采集初步结果",@"十一.  居家照护管理员", nil];//标题
    
    
    _YongHuQZVC=[[YongHuQZViewController alloc]init];//用户签字
    
    _ShenFenXXVC=[[ShenFenXXViewController alloc]init];//身份信息
    
    _GeRenXXVC=[[GeRenXXViewController alloc]init];//个人信息
    
    _JianHuRenXXVC=[[JianHuRenXXViewController alloc]init];//监护人信息
    
    _JinJiLXVC=[[JinJiLXViewController alloc]init];//紧急联系人信息
    
    _MuQianZKVC=[[MuQianZKViewController alloc]init];//目前生活状况
    
    _YiQueZhenJBVC=[[YiQueZhenJBViewController alloc]init];//已确诊的疾病
    
    _JiaTingZHVC=[[JiaTingZHViewController alloc]init];//家庭主要照护者信息
    
    _WaiBuTGVC=[[WaiBuTGViewController alloc]init];//外部提供专业看护服务
    
    _XinXiCJVC=[[XinXiCJViewController alloc]init];//信息采集初步结果
    
    _JuJiaZHVC=[[JuJiaZHViewController alloc]init];//居家照护管理员信息
    
    _BoHuiVC=[[BoHuiViewController alloc]init];//驳回原因
    
    _functionModel=[[FunctionModel alloc]init];//大项状态
    
    _collectModel=[[CollectModel alloc]init];//小项状态
    
    //设置导航
    [self createNav];
    
    //设置页面
    [self createView];
}


//刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    //加载 状态 数据
    [self loadFunctionData];
    //加载 小项进展结果
    [self loadUserState];
}


#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"基本信息";
    
    //设置导航背景图
    self.navigationController.navigationBar.barTintColor = Nav_Tabbar_backgroundColor;
    
    
    [_returnButton removeFromSuperview];
    
    //返回
    _returnButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, Return_button_width, 18) Text:nil ImageName:@"reg_return@2x.png" bgImageName:nil Target:self Method:@selector(returnButtonClick)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_returnButton];
    _returnButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, Return_button_width/3*2);
    
}

//返回
-(void)returnButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark 设置页面
-(void)createView
{
    //主视图
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=View_Background_Color;
    //_tableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
    [_tableView setSeparatorColor:CREATECOLOR(227, 227, 227, 1)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[CollectTableViewCell class] forCellReuseIdentifier:@"ID"];
    
    
    
    //提交
    _Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"提交" ImageName:nil bgImageName:nil Target:self Method:@selector(Button_Click:)];
    [_Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    _Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [_Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
    _Save_Button.tag=3000;
    
    
    //驳回
    _BoHui_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH/2-1, Tabbar_HE) Text:@"驳回" ImageName:nil bgImageName:nil Target:self Method:@selector(Button_Click:)];
    [_BoHui_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    _BoHui_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [_BoHui_Button setBackgroundColor:CREATECOLOR(122, 128, 137, 1)];
    _BoHui_Button.tag=3001;
    
    
    
    //通过
    _TongGuo_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2+1, HEIGHT-Tabbar_HE-64, WIDTH/2-1, Tabbar_HE) Text:@"通过" ImageName:nil bgImageName:nil Target:self Method:@selector(Button_Click:)];
    [_TongGuo_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    _TongGuo_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [_TongGuo_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
    _TongGuo_Button.tag=3002;
    
    
    [self addButton];
}



//添加按钮
-(void)addButton
{
    [_Save_Button removeFromSuperview];
    [_BoHui_Button removeFromSuperview];
    [_TongGuo_Button removeFromSuperview];
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        if ([_functionModel.collection intValue]==1 || [_functionModel.collection intValue]==5 || [_functionModel.collection intValue]==6) {
            [self.view addSubview:_Save_Button];
            
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64-Tabbar_HE);
        } else {
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64);
        }
    } else if ([[user objectForKey:idenity] intValue]==2) {
        if ([_functionModel.collection intValue]==2) {
            [self.view addSubview:_BoHui_Button];
            [self.view addSubview:_TongGuo_Button];

            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64-Tabbar_HE);
        } else {
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64);
        }
    }
}

#pragma mark 加载 状态 数据
-(void)loadFunctionData
{
    //请求数据
    FunctionViewModel * _functionViewModel=[[FunctionViewModel alloc]init];
    
    [_functionViewModel SelectAssessmengtState:self.shenFenZJ];
    
    [KVNProgress show];
    
    [_functionViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_functionModel setValuesForKeysWithDictionary:returnValue[@"data"]];
            }
            
            [self addButton];
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } WithErrorBlock:^(id errorCode) {
        [KVNProgress dismiss];
    } WithFailureBlock:^{
        [KVNProgress dismiss];
    }];
}


#pragma mark 加载 小项进展结果
-(void)loadUserState
{    
    NSDictionary * parameter = @{@"shenFenZJ":self.shenFenZJ};
    
    [KVNProgress show];
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getUserStateForCollectionHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {

                for (NSDictionary * arr in returnValue[@"data"]) {
                    
                    NSString * code=[arr objectForKey:@"code"];
                    
                    NSString * state=[arr objectForKey:@"state"];
                    
                    switch ([code intValue]) {
                        case 0:
                            _collectModel.yongHuQZ=state;
                            break;
                        case 1:
                            _collectModel.shenFenXX=state;
                            break;
                        case 2:
                            _collectModel.geRenXX=state;
                            break;
                        case 3:
                            _collectModel.jianHuRenXX=state;
                            break;
                        case 38:
                            _collectModel.jinJiLX=state;
                            break;
                        case 4:
                            _collectModel.muQianZK=state;
                            break;
                        case 5:
                            _collectModel.yiQueZhenJB=state;
                            break;
                        case 6:
                            _collectModel.jiaTingZH=state;
                            break;
                        case 7:
                            _collectModel.waiBuTG=state;
                            break;
                        case 8:
                            _collectModel.xinXiCJ=state;
                            break;
                        case 9:
                            _collectModel.juJiaZH=state;
                            break;
                        
                        default:
                            break;
                    }
                }
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
        //刷新页面
        [_tableView reloadData];
        
    } WithErrorCodeBlock:^(id errorCode) {

    } WithFailureBlock:^{

    }];
}



#pragma mark 操作
-(void)Button_Click:(UIButton*)button
{
    switch (button.tag-3000) {
        case 0:
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要提交吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertview.tag=4000;
            [alertview show];
        }
            break;
        case 1:
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要驳回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertview.tag=4001;
            [alertview show];
        }
            break;
        case 2:
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要通过吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertview.tag=4002;
            [alertview show];
        }
            break;
        default:
            break;
    }
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==4000) {
        if (buttonIndex==1) {
            
            if ([PublicFunction isBlankString:_collectModel.yongHuQZ] || [_collectModel.yongHuQZ intValue]==0) {
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“服务协议”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
            } else if ([PublicFunction isBlankString:_collectModel.shenFenXX] || [_collectModel.shenFenXX intValue]==0){
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“身份信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }else if ([PublicFunction isBlankString:_collectModel.geRenXX] || [_collectModel.geRenXX intValue]==0){
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“个人信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            } else if ([PublicFunction isBlankString:_collectModel.jianHuRenXX] || [_collectModel.jianHuRenXX intValue]==0){
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“监护人信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            } else if ([PublicFunction isBlankString:_collectModel.jinJiLX] || [_collectModel.jinJiLX intValue]==0){
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“紧急联系人信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            } else if ([PublicFunction isBlankString:_collectModel.muQianZK] || [_collectModel.muQianZK intValue]==0){
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“目前生活状况”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            } else if ([PublicFunction isBlankString:_collectModel.yiQueZhenJB] || [_collectModel.yiQueZhenJB intValue]==0){
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“已确诊的疾病”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            } else if ([PublicFunction isBlankString:_collectModel.xinXiCJ] || [_collectModel.xinXiCJ intValue]==0){
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“信息采集初步结果”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            } else {
                //提交
                [self update_Save];
            }
            
        }
    }
    
    
    
    if (alertView.tag==4001) {
        if (buttonIndex==1) {
            
            //驳回
            _BoHuiVC.shenFenZJ=self.shenFenZJ;
            _BoHuiVC.type=@"1";
            [self.navigationController pushViewController:_BoHuiVC animated:YES];
            
        }
    }
    
    
    
    if (alertView.tag==4002) {
        if (buttonIndex==1) {
            
            //通过
            [self update_TongGuo];
        }
    }
}






#pragma mark 提交
-(void)update_Save
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"1" forKey:@"type"];
    
    [parameter setObject:@"2" forKey:@"value"];
    
    [KVNProgress show];
    
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:updateProcessStateHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        [KVNProgress dismiss];
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] intValue]==1) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"上传失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        [KVNProgress dismiss];
        
    } WithFailureBlock:^{
        [KVNProgress dismiss];
        
    }];
}



#pragma mark 通过
-(void)update_TongGuo
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"1" forKey:@"type"];
    
    [parameter setObject:@"3" forKey:@"value"];
    
    [KVNProgress show];

    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:updateProcessStateHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        [KVNProgress dismiss];
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] intValue]==1) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"上传失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        [KVNProgress dismiss];
        
    } WithFailureBlock:^{
        [KVNProgress dismiss];
        
    }];
}






#pragma mark 创建搜索列表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [cell configModel:_titleArray[indexPath.row] row:indexPath.row collectModel:_collectModel];
    
    return cell;
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell_Height;
}


//头部高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return PAGESIZE(15.0)+5.0;
    }
    else{
        return PAGESIZE(15.0);
    }
}
//尾部高度
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}


#pragma mark 用户管理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                //用户签字
                _YongHuQZVC.shenFenZJ=self.shenFenZJ;
                _YongHuQZVC.collection=_functionModel.collection;
                _YongHuQZVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:_YongHuQZVC animated:YES completion:^{}];
            }
                break;
            case 1:
            {
                //身份信息
                _ShenFenXXVC.shenFenZJ=self.shenFenZJ;
                _ShenFenXXVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_ShenFenXXVC animated:YES];
            }
                break;
            case 2:
            {
                //个人信息
                _GeRenXXVC.shenFenZJ=self.shenFenZJ;
                _GeRenXXVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_GeRenXXVC animated:YES];
            }
                break;
            case 3:
            {
                //监护人信息
                _JianHuRenXXVC.shenFenZJ=self.shenFenZJ;
                _JianHuRenXXVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_JianHuRenXXVC animated:YES];
            }
                break;
            case 4:
            {
                //紧急联系人信息
                _JinJiLXVC.shenFenZJ=self.shenFenZJ;
                _JinJiLXVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_JinJiLXVC animated:YES];
            }
                break;
            case 5:
            {
                //目前生活状况
                _MuQianZKVC.shenFenZJ=self.shenFenZJ;
                _MuQianZKVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_MuQianZKVC animated:YES];
            }
                break;
            case 6:
            {
                //已确诊的疾病
                _YiQueZhenJBVC.shenFenZJ=self.shenFenZJ;
                _YiQueZhenJBVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_YiQueZhenJBVC animated:YES];
            }
                break;
            case 7:
            {
                //家庭主要照护者信息
                _JiaTingZHVC.shenFenZJ=self.shenFenZJ;
                _JiaTingZHVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_JiaTingZHVC animated:YES];
            }
                break;
            case 8:
            {
                //外部提供专业看护服务
                _WaiBuTGVC.shenFenZJ=self.shenFenZJ;
                _WaiBuTGVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_WaiBuTGVC animated:YES];
            }
                break;
            case 9:
            {
                //信息采集初步结果
                _XinXiCJVC.shenFenZJ=self.shenFenZJ;
                _XinXiCJVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_XinXiCJVC animated:YES];
            }
                break;
            case 10:
            {
                //居家照护管理员信息
                _JuJiaZHVC.shenFenZJ=self.shenFenZJ;
                _JuJiaZHVC.collection=_functionModel.collection;
                [self.navigationController pushViewController:_JuJiaZHVC animated:YES];
            }
                break;
            default:
                break;
        }
        
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

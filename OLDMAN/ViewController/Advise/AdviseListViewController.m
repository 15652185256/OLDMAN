//
//  AdviseListViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/25.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "AdviseListViewController.h"

#import "AdviseListTableViewCell.h"

#import "NeedModel.h"

#import "AdviseYingYangSSViewController.h"//营养膳食

#import "AdviseYiLiaoWSViewController.h"//医疗卫生

#import "AdviseJiaTingHLViewController.h"//家庭护理

#import "AdviseJinJiJYViewController.h"//紧急救援

#import "AdviseSheQuRJViewController.h"//社区日间照料

#import "AdviseJiaZhengFWViewController.h"//家政服务

#import "AdviseXinLiWYViewController.h"//心理及文娱活动

#import "AdviseQiTaViewController.h"//其他

#import "AdviseTeShuFWViewController.h"//特殊服务需求

#import "AdviseBuChongXXViewController.h"//补充信息

#import "BoHuiViewController.h"//驳回原因

#import "FunctionViewModel.h"
#import "FunctionModel.h"

@interface AdviseListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;//主视图
    
    UIButton * Save_Button;//提交
    
    UIButton * BoHui_Button;//驳回
    
    UIButton * TongGuo_Button;//通过
    
    FunctionModel * _functionModel;//大项状态
    
    NeedModel * _needModel;//小项状态
}
@property(nonatomic,retain)NSArray * titleArray;//标题

@property(nonatomic,retain)AdviseYingYangSSViewController * YingYangSSVC;//营养膳食

@property(nonatomic,retain)AdviseYiLiaoWSViewController * YiLiaoWSVC;//医疗卫生

@property(nonatomic,retain)AdviseJiaTingHLViewController * JiaTingHLVC;//家庭护理

@property(nonatomic,retain)AdviseJinJiJYViewController * JinJiJYVC;//紧急救援

@property(nonatomic,retain)AdviseSheQuRJViewController * SheQuRJVC;//社区日间照料

@property(nonatomic,retain)AdviseJiaZhengFWViewController * JiaZhengFWVC;//家政服务

@property(nonatomic,retain)AdviseXinLiWYViewController * XinLiWYVC;//心理及文娱活动

@property(nonatomic,retain)AdviseQiTaViewController * QiTaVC;//其他

@property(nonatomic,retain)AdviseTeShuFWViewController * TeShuFWVC;//特殊服务需求

@property(nonatomic,retain)AdviseBuChongXXViewController * BuChongXXVC;//补充信息

@property(nonatomic,retain)BoHuiViewController * BoHuiVC;//驳回原因
@end

@implementation AdviseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置背景
    self.view.backgroundColor=View_Background_Color;
    
    _titleArray=[NSArray arrayWithObjects:@"一.  营养膳食",@"二.  医疗卫生",@"三.  家庭护理",@"四.  紧急救援",@"五.  社区日间照料",@"六.  家政服务",@"七.  心理及文娱活动",@"八.  其他",@"九.  特殊服务需求",@"十.  补充信息", nil];//标题
    
    _YingYangSSVC=[[AdviseYingYangSSViewController alloc]init];//营养膳食
    
    _YiLiaoWSVC=[[AdviseYiLiaoWSViewController alloc]init];//医疗卫生
    
    _JiaTingHLVC=[[AdviseJiaTingHLViewController alloc]init];//家庭护理
    
    _JinJiJYVC=[[AdviseJinJiJYViewController alloc]init];//紧急救援
    
    _SheQuRJVC=[[AdviseSheQuRJViewController alloc]init];//社区日间照料
    
    _JiaZhengFWVC=[[AdviseJiaZhengFWViewController alloc]init];//家政服务
    
    _XinLiWYVC=[[AdviseXinLiWYViewController alloc]init];//心理及文娱活动
    
    _QiTaVC=[[AdviseQiTaViewController alloc]init];//其他
    
    _TeShuFWVC=[[AdviseTeShuFWViewController alloc]init];//特殊服务需求
    
    _BuChongXXVC=[[AdviseBuChongXXViewController alloc]init];//补充信息
    
    _BoHuiVC=[[BoHuiViewController alloc]init];//驳回原因
    
    _functionModel=[[FunctionModel alloc]init];//大项状态
    
    _needModel=[[NeedModel alloc]init];//小项状态
    
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
    self.navigationItem.title = @"服务建议";
    
    //设置导航背景图
    self.navigationController.navigationBar.barTintColor = Nav_Tabbar_backgroundColor;
    
    //返回
    UIButton * returnButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, Return_button_width, 18) Text:nil ImageName:@"reg_return@2x.png" bgImageName:nil Target:self Method:@selector(returnButtonClick)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:returnButton];
    returnButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, Return_button_width/3*2);
    
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
    [_tableView registerClass:[AdviseListTableViewCell class] forCellReuseIdentifier:@"ID"];
    
    
    //提交
    Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"提交" ImageName:nil bgImageName:nil Target:self Method:@selector(Button_Click:)];
    [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
    Save_Button.tag=3000;
    
    
    
    //驳回
    BoHui_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH/2-1, Tabbar_HE) Text:@"驳回" ImageName:nil bgImageName:nil Target:self Method:@selector(Button_Click:)];
    [BoHui_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    BoHui_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [BoHui_Button setBackgroundColor:CREATECOLOR(122, 128, 137, 1)];
    BoHui_Button.tag=3001;
    
    
    
    //通过
    TongGuo_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2+1, HEIGHT-Tabbar_HE-64, WIDTH/2-1, Tabbar_HE) Text:@"通过" ImageName:nil bgImageName:nil Target:self Method:@selector(Button_Click:)];
    [TongGuo_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    TongGuo_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [TongGuo_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
    TongGuo_Button.tag=3002;
    
    
    [self addButton];
}



//添加按钮
-(void)addButton
{
    [Save_Button removeFromSuperview];
    [BoHui_Button removeFromSuperview];
    [TongGuo_Button removeFromSuperview];
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        if ([_functionModel.jianyi intValue]==1 || [_functionModel.jianyi intValue]==5 || [_functionModel.jianyi intValue]==6) {
            [self.view addSubview:Save_Button];
            
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64-Tabbar_HE);
        } else {
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64);
        }
    } else if ([[user objectForKey:idenity] intValue]==2) {
        if ([_functionModel.jianyi intValue]==2) {
            [self.view addSubview:BoHui_Button];
            [self.view addSubview:TongGuo_Button];
            
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64-Tabbar_HE);
        } else {
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64);
        }
    }
}


#pragma mark 加载数据
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
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getUserStateForJianyiHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {

                for (NSDictionary * arr in returnValue[@"data"]) {
                    
                    NSString * code=[arr objectForKey:@"code"];
                    
                    NSString * state=[arr objectForKey:@"state"];
                    
                    switch ([code intValue]) {
                        case 28:
                            _needModel.yingYangSS=state;
                            break;
                        case 29:
                            _needModel.yiLiaoWS=state;
                            break;
                        case 30:
                            _needModel.jiaTingHL=state;
                            break;
                        case 31:
                            _needModel.jinJiJY=state;
                            break;
                        case 32:
                            _needModel.sheQuRJ=state;
                            break;
                        case 33:
                            _needModel.jiaZhengFW=state;
                            break;
                        case 34:
                            _needModel.xinLiWY=state;
                            break;
                        case 35:
                            _needModel.qiTa=state;
                            break;
                        case 36:
                            _needModel.teShuFW=state;
                            break;
                        case 37:
                            _needModel.buChongXX=state;
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
            
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
            
            [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
            
            [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
            
            [parameter setObject:@"4" forKey:@"type"];
            
            [parameter setObject:@"2" forKey:@"value"];
            
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
    }
    
    
    
    if (alertView.tag==4001) {
        if (buttonIndex==1) {
            
            BoHuiViewController * nvc=[[BoHuiViewController alloc]init];
            nvc.shenFenZJ=self.shenFenZJ;
            nvc.type=@"4";
            [self.navigationController pushViewController:nvc animated:YES];
            
        }
    }
    
    
    
    if (alertView.tag==4002) {
        if (buttonIndex==1) {
            
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
            
            [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
            
            [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
            
            [parameter setObject:@"4" forKey:@"type"];
            
            [parameter setObject:@"3" forKey:@"value"];
            
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
    }
    
}


#pragma mark 创建搜索列表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdviseListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [cell configModel:_titleArray[indexPath.row] row:indexPath.row needModel:_needModel];
    
    return cell;
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return Tabbar_HE;
    }
    else {
        return cell_Height;
    }
}


//头部高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return PAGESIZE(15.0)+5.0;
    }
    else{
        return 35.0;
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
                //营养膳食
                _YingYangSSVC.shenFenZJ=self.shenFenZJ;
                _YingYangSSVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_YingYangSSVC animated:YES];
            }
                break;
                
            case 1:
            {
                //医疗卫生
                _YiLiaoWSVC.shenFenZJ=self.shenFenZJ;
                _YiLiaoWSVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_YiLiaoWSVC animated:YES];
            }
                break;
                
            case 2:
            {
                //家庭护理
                _JiaTingHLVC.shenFenZJ=self.shenFenZJ;
                _JiaTingHLVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_JiaTingHLVC animated:YES];
            }
                break;
                
            case 3:
            {
                //紧急救援
                _JinJiJYVC.shenFenZJ=self.shenFenZJ;
                _JinJiJYVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_JinJiJYVC animated:YES];
            }
                break;
                
            case 4:
            {
                //社区日间照料
                _SheQuRJVC.shenFenZJ=self.shenFenZJ;
                _SheQuRJVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_SheQuRJVC animated:YES];
            }
                break;
                
            case 5:
            {
                //家政服务
                _JiaZhengFWVC.shenFenZJ=self.shenFenZJ;
                _JiaZhengFWVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_JiaZhengFWVC animated:YES];
            }
                break;
                
            case 6:
            {
                //心理及文娱活动
                _XinLiWYVC.shenFenZJ=self.shenFenZJ;
                _XinLiWYVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_XinLiWYVC animated:YES];
            }
                break;
                
            case 7:
            {
                //其他
                _QiTaVC.shenFenZJ=self.shenFenZJ;
                _QiTaVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_QiTaVC animated:YES];
            }
                break;
                
            case 8:
            {
                //特殊服务需求
                _TeShuFWVC.shenFenZJ=self.shenFenZJ;
                _TeShuFWVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_TeShuFWVC animated:YES];
            }
                break;
                
            case 9:
            {
                //补充信息
                _BuChongXXVC.shenFenZJ=self.shenFenZJ;
                _BuChongXXVC.jianyi=_functionModel.jianyi;
                [self.navigationController pushViewController:_BuChongXXVC animated:YES];
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

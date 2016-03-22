//
//  AssessmentViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/17.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "AssessmentViewController.h"
#import "PingGuJBModel.h"
#import "CollectViewModel.h"

#import "AssessmentModel.h"

#import "AssessmentTableViewCell.h"

#import "PingGuJBViewController.h"//评估基本信息

#import "RiChengSHViewController.h"//日常生活能力

#import "JingShenZTViewController.h"//精神状态

#import "GanZhiJViewController.h"//感知觉与沟通

#import "SheHuiCYViewController.h"//社会参与

#import "BuChongPGViewController.h"//补充评估信息

#import "NengLiPGViewController.h"//能力评估信息

#import "ZhuZePGViewController.h"//主责评估员信息

#import "PingGuBCViewController.h"//评估补充说明

#import "BoHuiViewController.h"//驳回原因

#import "FunctionViewModel.h"
#import "FunctionModel.h"

@interface AssessmentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;//主视图
    
    UIButton * Save_Button;//提交
    
    UIButton * BoHui_Button;//驳回
    
    UIButton * TongGuo_Button;//通过
    
    FunctionModel * _functionModel;//大项状态
    
    PingGuJBModel * _pingGuJBModel;//评估基本信息
    
    AssessmentModel * _assessmentModel;//小项状态
}
@property(nonatomic,retain)NSArray * titleArray;//标题

@property(nonatomic,retain)PingGuJBViewController * PingGuJBVC;//评估基本信息

@property(nonatomic,retain)RiChengSHViewController * RiChengSHVC;//日常生活能力

@property(nonatomic,retain)JingShenZTViewController * JingShenZTVC;//精神状态

@property(nonatomic,retain)GanZhiJViewController * GanZhiJVC;//感知觉与沟通

@property(nonatomic,retain)SheHuiCYViewController * SheHuiCYVC;//社会参与

@property(nonatomic,retain)BuChongPGViewController * BuChongPGVC;//补充评估信息

@property(nonatomic,retain)NengLiPGViewController * NengLiPGVC;//能力评估信息

@property(nonatomic,retain)ZhuZePGViewController * ZhuZePGVC;//主责评估员信息

@property(nonatomic,retain)PingGuBCViewController * PingGuBCVC;//评估补充说明

@property(nonatomic,retain)BoHuiViewController * BoHuiVC;//驳回原因

@end

@implementation AssessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景
    self.view.backgroundColor=View_Background_Color;
    
    
    _titleArray=[NSArray arrayWithObjects:@"一.  评估基本信息",@"二.  日常生活能力",@"三.  精神状态",@"四.  感知觉与沟通",@"五.  社会参与",@"六.  补充评估信息",@"七.  能力评估信息",@"八.  主责评估员信息",@"九.  评估补充说明", nil];
    
    
    _PingGuJBVC=[[PingGuJBViewController alloc]init];//评估基本信息
    
    _RiChengSHVC=[[RiChengSHViewController alloc]init];//日常生活能力
    
    _JingShenZTVC=[[JingShenZTViewController alloc]init];//精神状态
    
    _GanZhiJVC=[[GanZhiJViewController alloc]init];//感知觉与沟通
    
    _SheHuiCYVC=[[SheHuiCYViewController alloc]init];//社会参与
    
    _BuChongPGVC=[[BuChongPGViewController alloc]init];//补充评估信息
    
    _NengLiPGVC=[[NengLiPGViewController alloc]init];//能力评估信息
    
    _ZhuZePGVC=[[ZhuZePGViewController alloc]init];//主责评估员信息
    
    _PingGuBCVC=[[PingGuBCViewController alloc]init];//评估补充说明
    
    _BoHuiVC=[[BoHuiViewController alloc]init];//驳回原因
    
    _pingGuJBModel=[[PingGuJBModel alloc]init];//评估基本信息
    
    _functionModel=[[FunctionModel alloc]init];//大项状态
    
    _assessmentModel=[[AssessmentModel alloc]init];//小项状态
    
    //设置导航
    [self createNav];
    
    //设置页面
    [self createView];
}

//刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    //请求评估基本信息
    [self get_pingGuJB_Data];
    
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
    self.navigationItem.title = @"评估信息";
    
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
    [_tableView registerClass:[AssessmentTableViewCell class] forCellReuseIdentifier:@"ID"];
    
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
        if ([_functionModel.assessment intValue]==1 || [_functionModel.assessment intValue]==5 || [_functionModel.assessment intValue]==6) {
            [self.view addSubview:Save_Button];
            
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64-Tabbar_HE);
        } else {
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64);
        }
    } else if ([[user objectForKey:idenity] intValue]==2) {
        if ([_functionModel.assessment intValue]==2) {
            [self.view addSubview:BoHui_Button];
            [self.view addSubview:TongGuo_Button];
            
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64-Tabbar_HE);
        } else {
            _tableView.frame=CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64);
        }
    }
}


#pragma mark  请求评估基本信息
-(void)get_pingGuJB_Data
{
    //请求数据
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"10"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_pingGuJBModel setValuesForKeysWithDictionary:returnValue[@"data"]];
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
        [_tableView reloadData];
        
        //状态查询
        [self loadFunctionData];
        
    } WithErrorBlock:^(id errorCode) {
        [KVNProgress dismiss];
    } WithFailureBlock:^{
        [KVNProgress dismiss];
    }];
}


#pragma mark  状态查询
-(void)loadFunctionData
{
    //请求数据
    FunctionViewModel * _functionViewModel=[[FunctionViewModel alloc]init];
    
    [_functionViewModel SelectAssessmengtState:self.shenFenZJ];
    
    [_functionViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
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
        
    } WithFailureBlock:^{
        
    }];
}



#pragma mark 加载 小项进展结果
-(void)loadUserState
{
    NSDictionary * parameter = @{@"shenFenZJ":self.shenFenZJ};
    
    [KVNProgress show];
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getUserStateForAssessmentHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary * arr in returnValue[@"data"]) {
                    
                    NSString * code=[arr objectForKey:@"code"];
                    
                    NSString * state=[arr objectForKey:@"state"];
                    
                    switch ([code intValue]) {
                        case 10:
                            _assessmentModel.pingGuJB=state;
                            break;
                        case 11:
                            _assessmentModel.riChengSH=state;
                            break;
                        case 12:
                            _assessmentModel.jingShenZT=state;
                            break;
                        case 13:
                            _assessmentModel.ganZhiJ=state;
                            break;
                        case 14:
                            _assessmentModel.sheHuiCY=state;
                            break;
                        case 15:
                            _assessmentModel.buChongPG=state;
                            break;
                        case 16:
                            _assessmentModel.nengLiPG=state;
                            break;
                        case 17:
                            _assessmentModel.pingGuBC=state;
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
            
            if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
                
                if ([[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
                    [self ture_saiCha];
                } else {
                    if ([_pingGuJBModel.saiCha intValue]==0) {
                        [self false_saiCha];
                    } else {
                        [self ture_saiCha];
                    }
                }
                
            } else {
                [self false_saiCha];
            }
            
        }
    }
    
    
    
    if (alertView.tag==4001) {
        if (buttonIndex==1) {
            //驳回
            _BoHuiVC.shenFenZJ=self.shenFenZJ;
            _BoHuiVC.type=@"2";
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


//判断是否需要采集 筛查为零
-(void)false_saiCha
{
    if ([PublicFunction isBlankString:_assessmentModel.pingGuJB] || [_assessmentModel.pingGuJB intValue]==0) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“评估基本信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else if ([PublicFunction isBlankString:_assessmentModel.riChengSH] || [_assessmentModel.riChengSH intValue]==0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“日常生活能力”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if ([PublicFunction isBlankString:_assessmentModel.jingShenZT] || [_assessmentModel.jingShenZT intValue]==0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“精神状态”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if ([PublicFunction isBlankString:_assessmentModel.ganZhiJ] || [_assessmentModel.ganZhiJ intValue]==0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“感知觉与沟通”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if ([PublicFunction isBlankString:_assessmentModel.sheHuiCY] || [_assessmentModel.sheHuiCY intValue]==0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“社会参与”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if ([PublicFunction isBlankString:_assessmentModel.buChongPG] || [_assessmentModel.buChongPG intValue]==0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“补充评估信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if ([PublicFunction isBlankString:_assessmentModel.nengLiPG] || [_assessmentModel.nengLiPG intValue]==0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“能力评估信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else {
        //提交
        [self update_Save];
    }
}


//判断是否需要采集 筛查不为零
-(void)ture_saiCha
{
    if ([PublicFunction isBlankString:_assessmentModel.pingGuJB] || [_assessmentModel.pingGuJB intValue]==0) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“评估基本信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else if ([PublicFunction isBlankString:_assessmentModel.nengLiPG] || [_assessmentModel.nengLiPG intValue]==0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请采集“能力评估信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else {
        //提交
        [self update_Save];
    }
}








#pragma mark 提交
-(void)update_Save
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"2" forKey:@"type"];
    
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








#pragma mark 通过
-(void)update_TongGuo
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"2" forKey:@"type"];
    
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
    AssessmentTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
        
        if ([[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
            [cell configModel:_titleArray[indexPath.row] row:indexPath.row state:1 assessmentModel:_assessmentModel];
        } else {
            if ([_pingGuJBModel.saiCha intValue]==0) {
                [cell configModel:_titleArray[indexPath.row] row:indexPath.row state:0 assessmentModel:_assessmentModel];
            } else {
                [cell configModel:_titleArray[indexPath.row] row:indexPath.row state:1 assessmentModel:_assessmentModel];
            }
        }
        
    } else {
        [cell configModel:_titleArray[indexPath.row] row:indexPath.row state:0 assessmentModel:_assessmentModel];
    }
    
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
                //评估基本信息
                _PingGuJBVC.shenFenZJ=self.shenFenZJ;
                _PingGuJBVC.assessment=_functionModel.assessment;
                [self.navigationController pushViewController:_PingGuJBVC animated:YES];
            }
                break;
            case 1:
            {
                if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
                    
                    if (![[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
                        if ([_pingGuJBModel.saiCha intValue]==0) {
                            //日常生活能力
                            _RiChengSHVC.shenFenZJ=self.shenFenZJ;
                            _RiChengSHVC.assessment=_functionModel.assessment;
                            [self.navigationController pushViewController:_RiChengSHVC animated:YES];
                        }
                    }
                    
                } else {
                    //日常生活能力
                    _RiChengSHVC.shenFenZJ=self.shenFenZJ;
                    _RiChengSHVC.assessment=_functionModel.assessment;
                    [self.navigationController pushViewController:_RiChengSHVC animated:YES];
                }
            }
                break;
            case 2:
            {
                if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
                    
                    if (![[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
                        if ([_pingGuJBModel.saiCha intValue]==0) {
                            //精神状态
                            _JingShenZTVC.shenFenZJ=self.shenFenZJ;
                            _JingShenZTVC.assessment=_functionModel.assessment;
                            [self.navigationController pushViewController:_JingShenZTVC animated:YES];
                        }
                    }
                    
                } else {
                    //精神状态
                    _JingShenZTVC.shenFenZJ=self.shenFenZJ;
                    _JingShenZTVC.assessment=_functionModel.assessment;
                    [self.navigationController pushViewController:_JingShenZTVC animated:YES];
                }
            }
                break;
            case 3:
            {
                if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
                    
                    if (![[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
                        if ([_pingGuJBModel.saiCha intValue]==0) {
                            //感知觉与沟通
                            _GanZhiJVC.shenFenZJ=self.shenFenZJ;
                            _GanZhiJVC.assessment=_functionModel.assessment;
                            [self.navigationController pushViewController:_GanZhiJVC animated:YES];
                        }
                    }
                    
                } else {
                    //感知觉与沟通
                    _GanZhiJVC.shenFenZJ=self.shenFenZJ;
                    _GanZhiJVC.assessment=_functionModel.assessment;
                    [self.navigationController pushViewController:_GanZhiJVC animated:YES];
                }
            }
                break;
            case 4:
            {
                if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
                    
                    if (![[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
                        if ([_pingGuJBModel.saiCha intValue]==0) {
                            //社会参与
                            _SheHuiCYVC.shenFenZJ=self.shenFenZJ;
                            _SheHuiCYVC.assessment=_functionModel.assessment;
                            [self.navigationController pushViewController:_SheHuiCYVC animated:YES];
                        }
                    }
                    
                } else {
                    //社会参与
                    _SheHuiCYVC.shenFenZJ=self.shenFenZJ;
                    _SheHuiCYVC.assessment=_functionModel.assessment;
                    [self.navigationController pushViewController:_SheHuiCYVC animated:YES];
                }
            }
                break;
            case 5:
            {
                if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
                    
                    if (![[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
                        if ([_pingGuJBModel.saiCha intValue]==0) {
                            //补充评估信息
                            _BuChongPGVC.shenFenZJ=self.shenFenZJ;
                            _BuChongPGVC.assessment=_functionModel.assessment;
                            [self.navigationController pushViewController:_BuChongPGVC animated:YES];
                        }
                    }
                    
                } else {
                    //补充评估信息
                    _BuChongPGVC.shenFenZJ=self.shenFenZJ;
                    _BuChongPGVC.assessment=_functionModel.assessment;
                    [self.navigationController pushViewController:_BuChongPGVC animated:YES];
                }
            }
                break;
            case 6:
            {
                //能力评估信息
                _NengLiPGVC.shenFenZJ=self.shenFenZJ;
                _NengLiPGVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:_NengLiPGVC animated:YES completion:^{}];
            }
                break;
            case 7:
            {
                //主责评估员信息
                _ZhuZePGVC.shenFenZJ=self.shenFenZJ;
                [self.navigationController pushViewController:_ZhuZePGVC animated:YES];
            }
                break;
            case 8 :
            {
                //评估补充说明
                _PingGuBCVC.shenFenZJ=self.shenFenZJ;
                _PingGuBCVC.assessment=_functionModel.assessment;
                [self.navigationController pushViewController:_PingGuBCVC animated:YES];
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

//
//  FunctionViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "FunctionViewController.h"

#import "FunctionTableViewCell.h"
#import "FunctionViewModel.h"
#import "FunctionModel.h"

#import "RNBlurModalView.h"//弹出框

//注意事项
#import "ContentViewController.h"
//信息采集
#import "CollectViewController.h"
//评估
#import "AssessmentViewController.h"
//服务需求
#import "NeedListViewController.h"
//服务建议
#import "AdviseListViewController.h"

@interface FunctionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;//主视图
    
    FunctionModel * _functionModel;//数据源
    
    NSArray * _titleArray;//标题
}

@property(nonatomic,retain)ContentViewController * ContentVC;//注意事项

@property(nonatomic,retain)CollectViewController * CollectVC;//信息采集

@property(nonatomic,retain)AssessmentViewController * AssessmentVC;//评估

@property(nonatomic,retain)NeedListViewController * NeedVC;//服务需求

@property(nonatomic,retain)AdviseListViewController * AdviseVC;//服务建议

@end

@implementation FunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景
    self.view.backgroundColor=View_Background_Color;
    
    //标题
    _titleArray=[NSArray arrayWithObjects:@"注意事项",@"基本信息",@"评估信息",@"服务需求",@"服务建议", nil];
    
    //注意事项
    _ContentVC=[[ContentViewController alloc]init];
    
    //信息采集
    _CollectVC=[[CollectViewController alloc]init];
    
    //评估
    _AssessmentVC=[[AssessmentViewController alloc]init];
    
    //服务需求
    _NeedVC=[[NeedListViewController alloc]init];
    
    //服务建议
    _AdviseVC=[[AdviseListViewController alloc]init];
    
    //数据源
    _functionModel=[[FunctionModel alloc]init];

    //设置导航
    [self createNav];
    
    //设置页面
    [self createView];
}
//刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    //加载数据
    [self loadData];
}

#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"服务项目";
    
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=View_Background_Color;
    //_tableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
    [_tableView setSeparatorColor:CREATECOLOR(227, 227, 227, 1)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[FunctionTableViewCell class] forCellReuseIdentifier:@"ID"];
}




#pragma mark 加载数据
-(void)loadData
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
                
                [_tableView reloadData];
            }
            
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

#pragma mark 创建搜索列表
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FunctionTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    
    cell.myBlock=^(NSInteger tag){
        switch (tag) {
            case 1:
            {
                RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:_titleArray[indexPath.row] message:[NSString stringWithFormat:@"审核未通过，驳回原因：\n%@\n",_functionModel.collectionRemark]];
                
                [modal show];
            }
                break;
                
            case 2:
            {
                RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:_titleArray[indexPath.row] message:[NSString stringWithFormat:@"审核未通过，驳回原因：\n%@\n",_functionModel.assessmentRemark]];
                
                [modal show];
            }
                break;
                
            case 3:
            {
                RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:_titleArray[indexPath.row] message:[NSString stringWithFormat:@"审核未通过，驳回原因：\n%@\n",_functionModel.xuqiuRemark]];
                
                [modal show];
            }
                break;
                
            case 4:
            {
                RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:_titleArray[indexPath.row] message:[NSString stringWithFormat:@"审核未通过，驳回原因：\n%@\n",_functionModel.jianyiRemark]];
                
                [modal show];
            }
                break;
                
            default:
                break;
        }
    };
    
    [cell configModel:_titleArray[indexPath.row] tag:indexPath.row model:_functionModel];
    
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
    return PAGESIZE(15.0)+5.0;
}
//尾部高度
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

#pragma mark 用户管理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //注意事项
            [self.navigationController pushViewController:_ContentVC animated:YES];
        }
            break;
        case 1:
        {
            if ([_functionModel.collection intValue]!=-1) {
                //信息采集
                _CollectVC.shenFenZJ=self.shenFenZJ;
                [self.navigationController pushViewController:_CollectVC animated:YES];
            }
        }
            break;
        case 2:
        {
            if ([_functionModel.assessment intValue]!=-1) {
                //评估
                _AssessmentVC.shenFenZJ=self.shenFenZJ;
                [self.navigationController pushViewController:_AssessmentVC animated:YES];
            }
        }
            break;
        case 3:
        {
            if ([_functionModel.xuqiu intValue]!=-1) {
                _NeedVC.shenFenZJ=self.shenFenZJ;
                [self.navigationController pushViewController:_NeedVC animated:YES];
            }
        }
            break;
        case 4:
        {
            if ([_functionModel.jianyi intValue]!=-1) {
                //服务建议
                _AdviseVC.shenFenZJ=self.shenFenZJ;
                [self.navigationController pushViewController:_AdviseVC animated:YES];
            }
        }
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

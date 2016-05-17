//
//  SearchViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/5/10.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "SearchViewController.h"

#import "RootModel.h"
#import "SearchTableViewCell.h"

#import "MJRefresh.h"//上下拉刷新

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * _tableView;//主视图
    
    UITextField * xingMing_Field;//姓名
    
    UITextField * shenFenZH_Field;//身份证件号
    
    UILabel * prompt_Label;//提示
    
    UILabel * warn_Label;//警报
}
@property(nonatomic,assign)int NewsListPage;
//数据
@property(nonatomic,retain)NSMutableArray * dataSourse;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=View_Background_Color;
    
    //设置导航
    [self createNav];
    
    _dataSourse=[[NSMutableArray alloc]init];
    
    //设置页面
    [self createView];
}

#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"分发";
    
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor=View_Background_Color;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
    //[_tableView setSeparatorColor:CREATECOLOR(227, 227, 227, 1)];//设置默认颜色
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"ID"];
    
    
    //头部搜索视图
    UIView * TopView = [ZCControl createView:CGRectMake(0, 0, WIDTH, 260)];
    _tableView.tableHeaderView = TopView;
    
    //下划线
    UIView * lineView = [ZCControl createView:CGRectMake(0, TopView.frame.size.height-0.5, WIDTH, 0.5)];
    lineView.backgroundColor = Line_View_color;
    [TopView addSubview:lineView];
    
    
    //姓名  标题
    UILabel * xingMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 30, 44+Title_text_font*3, Title_text_font) Font:18 Text:@"姓            名"];
    [TopView addSubview:xingMing_Label];
    xingMing_Label.textColor=Title_text_color;
    
    //姓名 签字框
    xingMing_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(xingMing_Label.frame), CGRectGetMinY(xingMing_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-xingMing_Label.frame.size.width-30, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    xingMing_Field.textColor=Field_text_color;
    [TopView addSubview:xingMing_Field];
    xingMing_Field.delegate = self;
    
    
    
    //身份证件号
    UILabel * shenFenZH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(xingMing_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:18 Text:@"身份证件号"];
    [TopView addSubview:shenFenZH_Label];
    shenFenZH_Label.textColor=Title_text_color;
    
    //身份证件号 签字框
    shenFenZH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(shenFenZH_Label.frame), CGRectGetMinY(shenFenZH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-shenFenZH_Label.frame.size.width-30, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    shenFenZH_Field.textColor=Field_text_color;
    [TopView addSubview:shenFenZH_Field];
    shenFenZH_Field.delegate = self;
    
    
    //提示
    prompt_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(shenFenZH_Field.frame), WIDTH-30, 60) Font:14 Text:nil];
    prompt_Label.textColor = [UIColor redColor];
    prompt_Label.textAlignment = NSTextAlignmentCenter;
    [TopView addSubview:prompt_Label];
    
    
    //搜索
    UIButton * sendButton=[ZCControl createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(prompt_Label.frame), WIDTH-30, 42) Text:@"搜索" ImageName:nil bgImageName:nil Target:self Method:@selector(sendButtonClick)];
    [sendButton setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    sendButton.titleLabel.font=[UIFont systemFontOfSize:18];
    [sendButton setBackgroundColor:Nav_Tabbar_backgroundColor];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 5.0;
    [TopView addSubview:sendButton];
    
    
    
    //提示
    warn_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(sendButton.frame), WIDTH-30, 50) Font:14 Text:nil];
    warn_Label.textColor = [UIColor redColor];
    [TopView addSubview:warn_Label];
    
    
    
    //收起键盘
    UITapGestureRecognizer * tapRoot = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRootAction)];
    //设置点击次数
    tapRoot.numberOfTapsRequired = 1;
    //设置几根胡萝卜有效
    tapRoot.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRoot];
}


-(void)viewWillAppear:(BOOL)animated
{
    xingMing_Field.text = @"";
    
    shenFenZH_Field.text = @"";
    
    prompt_Label.text = @"＊请至少输入一项";
    
    warn_Label.text = @"";
    
    [_dataSourse removeAllObjects];
    
    [_tableView reloadData];
}



//搜索查询
-(void)sendButtonClick
{
    if ([PublicFunction isBlankString:xingMing_Field.text] && [PublicFunction isBlankString:shenFenZH_Field.text]) {

        prompt_Label.text = @"请输入“姓名”";
        
    } else if (![PublicFunction isBlankString:shenFenZH_Field.text] && ![PublicFunction validateIdentityCard:shenFenZH_Field.text]) {

        prompt_Label.text = @"请输入正确的“身份证件号”";
        
    } else {
        
        prompt_Label.text = @"";

        //查询数据
        [self loadData];
    }
}


//查询数据
-(void)loadData
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:shenFenZH_Field.text forKey:@"shenFenZJ"];
    
    [parameter setObject:xingMing_Field.text forKey:@"xingMing"];
    
    [KVNProgress show];
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:getNotDistributeForAppHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        [KVNProgress dismiss];
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                
                NSArray * array = returnValue[@"data"];
                for (NSDictionary * dict in array) {
                    RootModel * model = [[RootModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [_dataSourse addObject:model];
                }
            } else {
                warn_Label.text = @"查无此人，请核对信息是否正确！";
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
        [_tableView reloadData];
        
    } WithErrorCodeBlock:^(id errorCode) {
        [KVNProgress dismiss];
    } WithFailureBlock:^{
        [KVNProgress dismiss];
    }];
}





#pragma mark 输入完毕
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([xingMing_Field.text isEqualToString:@""] && [shenFenZH_Field.text isEqualToString:@""]) {
        warn_Label.text = @"";
    }
    //收起键盘
    [self tapRootAction];
    
    return YES;
}



//收起键盘
-(void)tapRootAction
{
    if ([xingMing_Field.text isEqualToString:@""] && [shenFenZH_Field.text isEqualToString:@""]) {
        warn_Label.text = @"";
    }
    [_tableView endEditing:YES];
}




#pragma mark 创建搜索列表
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourse.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.myBlock=^(NSInteger tag){
        
        [self distributeByDocId:tag];
        
        //[self.navigationController popViewControllerAnimated:YES];
    };
    
    RootModel * model=_dataSourse[indexPath.row];
    
    [cell configModel:model row:indexPath.row];
    
    return cell;
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell_Height;
}


//分发数据
-(void)distributeByDocId:(NSInteger)tag
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    RootModel * model=_dataSourse[tag];
    [parameter setObject:model.shenFenZJ forKey:@"shenFenZJ"];
    
    [KVNProgress show];
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:distributeByDocIdHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        [KVNProgress dismiss];
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
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

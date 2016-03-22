//
//  JpushReplyListViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/24.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "JpushReplyListViewController.h"

#import "CDPMonitorKeyboard.h"//键盘移动

#import "JpushReplyModel.h"
#import "JpushReplyListTableViewCell.h"

#import "FMDBManager.h"

@interface JpushReplyListViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView * HeaderView;//头部 内容
    
    UITableView * _tableView;//主视图
    
    UITextView * _textView;//回复框
    
    UILabel * _placeholderLabel;//提示语
    
    JpushReplyListTableViewCell * _cell;//这个cell用来复用计算单元格高度,避免浪费空间
}
@property(nonatomic,retain)NSMutableArray * dataSource;//数据源
@end

@implementation JpushReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置背景
    self.view.backgroundColor=View_Background_Color;
    
    _dataSource=[[NSMutableArray alloc]init];//数据源
    
    //设置导航
    [self createNav];
    
    //设置页面
    [self createView];
}

//更新状态
-(void)updateNewsData
{
    [[FMDBManager shareManager] updateNewsDataByNewsID:self.NewsID Time:self.Time];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    //头部视图
    [self createHeaderView];
    
    //请求数据
    [self loadData];
    
    if ([self.state intValue]==0) {
        //更新状态
        [self updateNewsData];
    }
}
//释放
-(void)viewWillDisappear:(BOOL)animated
{
    [_dataSource removeAllObjects];
    
    [HeaderView removeFromSuperview];
}

#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"消息内容";
    
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor=View_Background_Color;
    [_tableView setSeparatorColor:CREATECOLOR(227, 227, 227, 1)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[JpushReplyListTableViewCell class] forCellReuseIdentifier:@"Reply"];
    
    
    //尾部视图
    [self createFooterView];
    
    
    //收起键盘
    UITapGestureRecognizer * tapRoot = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRootAction)];
    //设置点击次数
    tapRoot.numberOfTapsRequired = 1;
    //设置几根胡萝卜有效
    tapRoot.numberOfTouchesRequired = 1;
    [_tableView addGestureRecognizer:tapRoot];
}

//头部视图
-(void)createHeaderView
{
    //头部 内容
    HeaderView=[[UIView alloc]init];
    
    UILabel * contentLabel=[ZCControl createLabelWithFrame:CGRectMake(15, 10, WIDTH-30, 15) Font:15 Text:nil];
    contentLabel.textColor=CREATECOLOR(153, 153, 153, 1);
    contentLabel.numberOfLines=0;
    
    
    
    NSString * labelText=[NSString stringWithFormat:@"%@\n",self.content];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:3];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    contentLabel.attributedText = attributedString;
    
    [contentLabel sizeToFit];
    
    [HeaderView addSubview:contentLabel];
    HeaderView.frame=CGRectMake(0, 0, WIDTH, CGRectGetMaxY(contentLabel.frame));
    
    UIView * HeaderLineView=[ZCControl createView:CGRectMake(15, CGRectGetMaxY(HeaderView.frame)-0.5, WIDTH-15, 0.5)];
    [HeaderView addSubview:HeaderLineView];
    HeaderLineView.backgroundColor=CREATECOLOR(214, 214, 214, 1);
    
    _tableView.tableHeaderView=HeaderView;
    
}
    

//尾部视图
-(void)createFooterView
{
    //尾部内容
    UIView * FooterView=[ZCControl createView:CGRectMake(0, 0, WIDTH, 380)];
    
    _textView=[ZCControl createTextViewWithFrame:CGRectMake(10, 10, WIDTH-80, 100) scrollEnabled:YES editable:YES Font:Field_text_font];
    _textView.textColor=Field_text_color;
    _textView.delegate=self;
    
    [FooterView addSubview:_textView];
    
    
    //回复
    UIButton * addButton=[ZCControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame)+10, 10, 50, 30) Text:nil ImageName:nil bgImageName:@"submit.png" Target:self Method:@selector(addButton_Click)];
    [FooterView addSubview:addButton];

    
    _placeholderLabel=[ZCControl createLabelWithFrame:CGRectMake(5, 5, CGRectGetWidth(_textView.frame), Field_text_font) Font:Field_text_font Text:@"请输入回复内容"];
    _placeholderLabel.backgroundColor=[UIColor clearColor];
    _placeholderLabel.textColor=Field_text_color;
    [_textView addSubview:_placeholderLabel];
    
    _tableView.tableFooterView=FooterView;
    
    
}


#pragma mark - 请求数据
-(void)loadData
{
    [_dataSource removeAllObjects];
    
    for (NSInteger i=[[FMDBManager shareManager] selectReplyData:self.NewsID].count-1; i>=0; i--) {
        
        [self.dataSource addObject:[[FMDBManager shareManager] selectReplyData:self.NewsID][i]];
    }
    
    [_tableView reloadData];
}





#pragma mark - 必选方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JpushReplyModel * model=_dataSource[indexPath.row];
    
    return model.cellHeight;
    
    /*在这应加载Model中的数据，而不是在创建cell，加载返回数据
    if (!_cell) {
        _cell = [[JpushReplyListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Reply"];
    }
    JpushReplyModel * model=_dataSource[indexPath.row];
    [_cell configModel:model];
    
    return _cell.rowHeight;
    */
}
//后执行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JpushReplyListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Reply" forIndexPath:indexPath];
    JpushReplyModel * model=_dataSource[indexPath.row];
    [cell configModel:model];
    return cell;
}









#pragma mark - textView事件
//回复
-(void)addButton_Click
{
    if (_textView.text.length==0) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入回复内容" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        
        //去除首尾空格和换行
        NSString * content = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //获取当前时间
        NSDate * currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString * dateString = [dateFormatter stringFromDate:currentDate];
        
        NSMutableDictionary * dataDic=[[NSMutableDictionary alloc] init];
        
        [dataDic setObject:dateString forKey:@"time"];
        [dataDic setObject:content forKey:@"content"];
        [dataDic setObject:self.NewsID forKey:@"NewsID"];
        
        //保存 数据库
        [[FMDBManager shareManager]addReplyData:dataDic];
        
        _textView.text=@"";
        _placeholderLabel.text=@"请输入回复内容";
        
        //刷新数据
        [self loadData];
        
        //保存
        [self receiveAppMessage:content];
    }
}

//开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeholderLabel.text=@"";
}

//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView
{
    //模仿UITextFeild的placeholder属相
    if (_textView.text.length==0) {
        _placeholderLabel.text=@"请输入回复内容";
    } else {
        _placeholderLabel.text=@"";
    }
}




#pragma mark - 保存
-(void)receiveAppMessage:(NSString*)content
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    //NSLog(@"self.NewsID:%@",self.NewsID);
    
    if (![PublicFunction isBlankString:self.NewsID]) {
        [parameter setObject:self.NewsID forKey:@"notice_id"];
    }
    
    if (![PublicFunction isBlankString:content]) {
        [parameter setObject:content forKey:@"app_context"];
    }
    
    if (![PublicFunction isBlankString:[user objectForKey:doc_id]]) {
        [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    }

    
    [KVNProgress show];
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:receiveAppMessageHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        [KVNProgress dismiss];
        
        //NSLog(@"%@",returnValue);
        
    } WithErrorCodeBlock:^(id errorCode) {
        [KVNProgress dismiss];
        //NSLog(@"%@",errorCode);
    } WithFailureBlock:^{
        [KVNProgress dismiss];
    }];
}













#pragma mark - 收起键盘
-(void)tapRootAction
{
    [_tableView endEditing:YES];
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

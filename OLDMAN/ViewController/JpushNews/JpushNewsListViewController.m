//
//  JpushNewsListViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/2/17.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "JpushNewsListViewController.h"
#import "JpushNewsModel.h"
#import "JpushNewsListTableViewCell.h"

#import "JpushReplyListViewController.h"//详情页

#import "FMDBManager.h"

#import "MJRefresh.h"//上下拉刷新

@interface JpushNewsListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;//新闻列表
}

@property(nonatomic,retain)NSMutableArray * dataSource;//数据
//为了去删除多选的内容,那么在准备两个数组
//一个数组用来装删除的数据,
@property(nonatomic,retain)NSMutableArray * deleteData;//这个用来删除数据源用
//另一个数组用来装删除数据的indexPath
@property(nonatomic,retain)NSMutableArray * deleteIndexPath;//用来刷新使用


@property(nonatomic,retain)JpushReplyListViewController * JpushReplyVC;//详情页

@end

@implementation JpushNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置背景
    self.view.backgroundColor=View_Background_Color;
    
    
    self.dataSource=[[NSMutableArray alloc]init];
    
    self.deleteData=[[NSMutableArray alloc]init];
    
    self.deleteIndexPath=[[NSMutableArray alloc]init];
    
    _JpushReplyVC=[[JpushReplyListViewController alloc]init];
    
    //设置导航
    [self createNav];
    
    //设置页面
    [self createView];
    
    //备编辑按钮
    [self createEditButton];
}
//刷新
-(void)viewWillAppear:(BOOL)animated
{
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    [self.dataSource removeAllObjects];
    
    [self.deleteData removeAllObjects];
    
    [self.deleteIndexPath removeAllObjects];
}


#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"消息中心";
    
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
    [_tableView setSeparatorColor:CREATECOLOR(214, 214, 214, 1)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[JpushNewsListTableViewCell class] forCellReuseIdentifier:@"ID"];
    
    
    //去掉多余cell分割线
    [self setExtraCellLineHidden:_tableView];
    
    
    //添加上下拉刷新
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        //当出发下拉刷新的时候
        [weakSelf loadData];
    }];
    
}

//去掉多余cell分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [tableView setTableFooterView:view];
}





#pragma mark 请求数据
-(void)loadData
{
    [self.dataSource removeAllObjects];
    
    //获取数据
//    NSArray * array=[[FMDBManager shareManager] selectNewsData];
    
//    NSLog(@"%ld",array.count);
//    self.dataSource=[array mutableCopy];
    
    for (NSInteger i=[[FMDBManager shareManager] selectNewsData].count-1; i>=0; i--) {
        
        [self.dataSource addObject:[[FMDBManager shareManager] selectNewsData][i]];
    }
    
    //结束刷新
    [_tableView.header endRefreshing];

    [_tableView reloadData];
}



#pragma mark 设备编辑按钮
-(void)createEditButton
{
    //准备编辑按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title=@"编辑";
    self.navigationController.navigationBar.tintColor = CREATECOLOR(255, 255, 255, 1);
    
    //准备编辑视图,上面加一个删除的按钮
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64, WIDTH, 40)];
    view.backgroundColor = CREATECOLOR(255, 255, 255, 1);
    view.tag = 1000;
    
    UIView * topView=[ZCControl createView:CGRectMake(0, 0, WIDTH, 0.5)];
    view.backgroundColor = CREATECOLOR(227, 227, 227, 1);
    [view addSubview:topView];
    
    
    UIButton * deleteButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, 40) Text:@"删除" ImageName:nil bgImageName:nil Target:self Method:@selector(deleteButtonClick:)];
    deleteButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [deleteButton setTitleColor:CREATECOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
    [view addSubview:deleteButton];
    //因为上来没有东西可删,所以先禁用按钮
    deleteButton.enabled = NO;
    deleteButton.tag = 2000;
    
    [self.view addSubview:view];
}
//清除所有的选中数据
-(void)clearSelectData
{
    [_deleteData removeAllObjects];
    [_deleteIndexPath removeAllObjects];
}

//这个是删除按钮的响应方法
-(void)deleteButtonClick:(UIButton *)button
{
    //首先在数据源里删除数据
    [_dataSource removeObjectsInArray:_deleteData];
    //刷新表格
    [_tableView deleteRowsAtIndexPaths:_deleteIndexPath withRowAnimation:UITableViewRowAnimationMiddle];
    
    
    for (JpushNewsModel * model in _deleteData) {
        [[FMDBManager shareManager]deleteNewsDataByNewsID:model.NewsID Time:model.time];
    }
    
    
    //因为删除后,数据源中就没有这此已经删除的数据了,为了防止程序在下一次删除时,删除到非法数据,所以要将数据清空
    [self clearSelectData];
    
    //删除之后,让按钮变灰
    if (_deleteData.count == 0) {
        UIButton * button = (UIButton *)[self.view viewWithTag:2000];
        [button setTitleColor:CREATECOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        button.enabled = NO;
    }
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
    
    if (editing) {
        self.editButtonItem.title=@"取消";
        _tableView.frame=CGRectMake(0, 0, WIDTH, HEIGHT-64-40);
    }
    else {
        self.editButtonItem.title=@"编辑";
        _tableView.frame=CGRectMake(0, 0, WIDTH, HEIGHT-64);
    }
    
    //设置一个动画,来根据是否在编辑状态,然后让删除条出现或隐藏
    UIView * view = [self.view viewWithTag:1000];
    //因为要在block里去修改center的值,因为center是一个局部变量,
    //所以默认在block里,是不允许操作修改的,那么,如果要完成目标操作,那么在center前加一个 __block来修饰一下
    __block CGPoint center = view.center;
    if (editing) {
        [UIView animateWithDuration:0.3 animations:^{
            center.y -= 40;
            view.center = center;
        }];
        
        //在这里去加一个清空操作,因为,可以选中但不做任何操作,那么为了防止下一次再操作时崩掉,清掉所有数据
        [self clearSelectData];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            center.y += 40;
            view.center = center;
        }];
    }
}




#pragma mark - 编辑方法
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark - 选中单元格的方法
//选中单元格的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView.editing) {
        //先找到单元格对应的数据
        JpushNewsModel * model = [_dataSource objectAtIndex:indexPath.row];
        [_deleteData addObject:model];
        [_deleteIndexPath addObject:indexPath];
        if (_deleteData.count != 0) {
            UIButton * button = (UIButton *)[self.view viewWithTag:2000];
            [button setTitleColor:CREATECOLOR(165, 197, 29, 1) forState:UIControlStateNormal];
            button.enabled = YES;
        }
        
    } else {
        JpushNewsModel * model = [_dataSource objectAtIndex:indexPath.row];
        //消息详情
        _JpushReplyVC.Time=model.time;
        _JpushReplyVC.content=model.content;
        _JpushReplyVC.NewsID=model.NewsID;
        _JpushReplyVC.state=model.state;
        [self.navigationController pushViewController:_JpushReplyVC animated:YES];
    }
}
//取消选中单元格的方法,反选
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView.editing) {
        JpushNewsModel * model = [_dataSource objectAtIndex:indexPath.row];
        if ([_deleteData containsObject:model]) {
            [_deleteData removeObject:model];
            [_deleteIndexPath removeObject:indexPath];
            if (_deleteData.count == 0) {
                UIButton * button = (UIButton *)[self.view viewWithTag:2000];
                [button setTitleColor:CREATECOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
                button.enabled = NO;
            }
        }
    }
}



#pragma mark - 必选方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JpushNewsListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    JpushNewsModel * model=_dataSource[indexPath.row];
    [cell configModel:model];
    return cell;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

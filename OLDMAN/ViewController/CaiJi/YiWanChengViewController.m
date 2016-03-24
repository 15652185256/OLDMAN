//
//  YiWanChengViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/24.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "YiWanChengViewController.h"

#import "RootModel.h"
#import "RootTableViewCell.h"

#import "RootViewModel.h"//人员列表

#import "MJRefresh.h"//上下拉刷新

@interface YiWanChengViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;//主视图
}
@property(nonatomic,assign)int NewsListPage;
//数据
@property(nonatomic,retain)NSMutableArray * dataSourse;
@end

@implementation YiWanChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    _dataSourse=[[NSMutableArray alloc]init];
    
    //设置页面
    [self createView];
}

#pragma mark 设置页面
-(void)createView
{
    //主视图
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH*0, 0, WIDTH, HEIGHT-64-PAGESIZE(46)-65) style:UITableViewStylePlain];
    _tableView.backgroundColor=View_Background_Color;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
    [_tableView setSeparatorColor:CREATECOLOR(227, 227, 227, 1)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[RootTableViewCell class] forCellReuseIdentifier:@"ID"];
    
    
    //添加上下拉刷新
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        //当出发下拉刷新的时候
        _NewsListPage=1;
        [weakSelf loadData:_NewsListPage];
    }];
    
    //添加上拉刷新
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:_NewsListPage];
    }];
}

//下拉刷新
-(void)beginRefreshing
{
    _NewsListPage=1;
    //加载数据
    [_tableView.header beginRefreshing];
}

#pragma mark 加载数据
-(void)loadData:(int)page
{
    //请求数据
    RootViewModel * _rootViewModel=[[RootViewModel alloc]init];
    
    [_rootViewModel GetRootList:getgrxxHttp type:3 currentPage:[NSString stringWithFormat:@"%d",page] pageSize:[NSString stringWithFormat:@"%d",20]];
    
    [_rootViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        

        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                
                 _NewsListPage++;
                
                if (page==1) {
                    
                    [_dataSourse removeAllObjects];
                }
                
                for (NSDictionary * dict in returnValue[@"data"]) {
                    
                    RootModel * model=[[RootModel alloc]init];
                    
                    [model setValuesForKeysWithDictionary:dict];
                    
                    [_dataSourse addObject:model];
                }
            } else {
                
                if (page==1) {
                    [_dataSourse removeAllObjects];
                }
            }
            
        } else {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
        [_tableView reloadData];
        
        //结束刷新
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
    } WithErrorBlock:^(id errorCode) {
        [_tableView reloadData];
        //结束刷新
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } WithFailureBlock:^{
        [_tableView reloadData];
        //结束刷新
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}


#pragma mark 创建搜索列表
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourse.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RootTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    RootModel * model=_dataSourse[indexPath.row];
    
    [cell configModel:model row:indexPath.row];
    
    return cell;
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell_Height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RootModel * model=_dataSourse[indexPath.row];
    if (self.myBlock) {
        self.myBlock(model.shenFenZJ);
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

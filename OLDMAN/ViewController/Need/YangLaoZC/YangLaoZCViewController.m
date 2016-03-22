//
//  YangLaoZCViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/3/8.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "YangLaoZCViewController.h"
#import "YangLaoZCModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QCheckBox.h"//复选

#import "QRadioButton.h"//单选

@interface YangLaoZCViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    UIButton * Save_Button;//保存
    
    
    
    NSArray * juZhuQK_Title_Array;//居住情况 标题数组
    
    NSString * my_juZhuQK;//居住情况 选项

    
    NSArray * yueShouRu_Title_Array;//月收入情况 标题数组
    
    NSString * my_yueShouRu;//月收入情况 选项
    
    
    NSArray * yiXiaQK_Title_Array;//以下情况 标题数组
    
    NSString * my_yiXiaQK;//以下情况 选项
    
    
    UIView * peiSongCan_View;//是否需要配送餐
    
    NSArray * peiSongCan_Title_Array;//是否需要配送餐 标题数组
    
    NSString * my_peiSongCan;//是否需要配送餐 选项
    
    
    UIView * songCanYY_view;//送餐原因
    
    NSArray * songCanYY_Title_Array;//送餐原因 标题数组
    
    NSMutableDictionary * my_songCanYY_Dict;//送餐原因 选项
    
    //UITextField * songCanYY_Field;//送餐原因(其他)
    
    
    UIView * songCanLiang_view;//送餐量
    
    NSArray * songCanLiang_Title_Array;//送餐量 标题数组
    
    NSString * my_songCanLiang;//送餐量 选项
    
    
    UIView * songCanJG_view;//送餐价格
    
    NSArray * songCanJG_Title_Array;//送餐价格 标题数组
    
    NSString * my_songCanJG;//送餐价格 选项
    
    
    UIView * teShuXQ_view;//特殊需求
    
    NSArray * teShuXQ_Title_Array;//特殊需求 标题数组
    
    NSMutableDictionary * my_teShuXQ_Dict;//特殊需求 选项
    
    UITextField * teShuXQ_Field;//特殊需求(其他)
    
    
    UILabel * BuChongXX_Label;//意见 建议 标题
    
    UIButton * BuChongXX_Button;//意见 建议 介绍
    
    UITextView * BuChongXX_TextView;//意见 建议
    
    
    
    YangLaoZCModel * _yangLaoZCModel;//养老助餐调研
}
@end

@implementation YangLaoZCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //实列化
    my_songCanYY_Dict=[[NSMutableDictionary alloc]init];//送餐原因 选项
    
    my_teShuXQ_Dict=[[NSMutableDictionary alloc]init];//特殊需求 选项
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _yangLaoZCModel=[[YangLaoZCModel alloc]init];//养老助餐调研
    //请求 养老助餐调研
    [self load_YangLaoZC_Data];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _yangLaoZCModel=nil;
    
    [my_songCanYY_Dict removeAllObjects];
    [my_teShuXQ_Dict removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
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
    self.navigationItem.title = @"养老助餐调研";
    
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


#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //居住情况 标题数组
    juZhuQK_Title_Array=@[@"与子女等照护人一起居住",@"仅与配偶一起居住",@"独自居住"];
    
    //月收入情况 标题数组
    yueShouRu_Title_Array=@[@"2000元以下",@"2000-3000元",@"3001-5000元",@"5001-8000元",@"8000元以上"];

    //以下情况 标题数组
    yiXiaQK_Title_Array=@[@"低保",@"低收入",@"无社会保障",@"计划生育特殊困难家庭",@"以上均不是"];

    //是否需要配送餐 标题数组
    peiSongCan_Title_Array=@[@"是",@"否"];

    //送餐原因 标题数组
    songCanYY_Title_Array=@[@"不愿在家做饭",@"小区附近买菜不方便",@"子女不在身边，腿脚不方便",@"其他"];

    //送餐量 标题数组
    songCanLiang_Title_Array=@[@"每天1餐",@"每天2餐",@"每天3餐"];

    //送餐价格 标题数组
    songCanJG_Title_Array=@[@"10元以下",@"10-15元",@"16-20元",@"21-25元",@"25元以上"];
    
    //特殊需求 标题数组
    teShuXQ_Title_Array=@[@"无",@"糖尿病健康饮食",@"高血压健康饮食",@"卧床流食",@"清真饮食",@"其他"];
}



#pragma mark 请求 养老助餐调研
-(void)load_YangLaoZC_Data
{
    //请求数据
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"45"];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_yangLaoZCModel setValuesForKeysWithDictionary:returnValue[@"data"]];
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
        //设置页面
        [self createView];
        
    } WithErrorBlock:^(id errorCode) {
        [KVNProgress dismiss];
    } WithFailureBlock:^{
        [KVNProgress dismiss];
    }];
}


#pragma mark 设置页面
-(void)createView
{
    RootScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    [self.view addSubview:RootScrollView];
    RootScrollView.backgroundColor=View_Background_Color;
    RootScrollView.delegate=self;
    RootScrollView.tag=60000;
    
    
    
    //居住情况 标题数组
    UIView * juZhuQK_View=[ZCControl createView:CGRectMake(0, 20, WIDTH, 24*(juZhuQK_Title_Array.count+1))];
    [RootScrollView addSubview:juZhuQK_View];
    
    //居住情况 标题
    UILabel * juZhuQK_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"1. 居住情况"];
    [juZhuQK_View addSubview:juZhuQK_Label];
    juZhuQK_Label.textColor=Title_text_color;
    
    //居住情况 介绍
    UIButton * juZhuQK_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(juZhuQK_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [juZhuQK_View addSubview:juZhuQK_Button];
    juZhuQK_Button.tag=90000;
    
    
    //起始高度
    float juZhuQK_View_frame_origin_y=CGRectGetMaxY(juZhuQK_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<juZhuQK_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"juZhuQK"];
        [juZhuQK_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, juZhuQK_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=YES;
        
        xuanXiang_Button.tag=3000+i;
        
        if (![PublicFunction isBlankString:_yangLaoZCModel.juZhuQK]) {
            if ([_yangLaoZCModel.juZhuQK intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }

        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [juZhuQK_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=juZhuQK_Title_Array[i];
        
        juZhuQK_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    juZhuQK_View.frame = CGRectMake(0, 20, WIDTH, juZhuQK_View_frame_origin_y);
    
    
    
    
    
    //月收入情况 标题数组
    UIView * yueShouRu_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(juZhuQK_View.frame)+20, WIDTH, 24*(yueShouRu_Title_Array.count+1))];
    [RootScrollView addSubview:yueShouRu_View];
    
    //月收入情况 标题
    UILabel * yueShouRu_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"2. 月收入情况"];
    [yueShouRu_View addSubview:yueShouRu_Label];
    yueShouRu_Label.textColor=Title_text_color;
    
    //月收入情况 介绍
    UIButton * yueShouRu_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yueShouRu_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [yueShouRu_View addSubview:yueShouRu_Button];
    yueShouRu_Button.tag=90001;
    
    //起始高度
    float yueShouRu_View_frame_origin_y=CGRectGetMaxY(yueShouRu_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<yueShouRu_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"yueShouRu"];
        [yueShouRu_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, yueShouRu_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=YES;
        
        xuanXiang_Button.tag=4000+i;
        
        if (![PublicFunction isBlankString:_yangLaoZCModel.yueShouRQ]) {
            if ([_yangLaoZCModel.yueShouRQ intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [yueShouRu_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=yueShouRu_Title_Array[i];
        
        yueShouRu_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    yueShouRu_View.frame = CGRectMake(0, CGRectGetMaxY(juZhuQK_View.frame)+20, WIDTH, yueShouRu_View_frame_origin_y);
    
    
    
    
    //以下情况 标题数组
    UIView * yiXiaQK_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(yueShouRu_View.frame)+20, WIDTH, 24*(yiXiaQK_Title_Array.count+1))];
    [RootScrollView addSubview:yiXiaQK_View];
    
    //以下情况 标题
    UILabel * yiXiaQK_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"3. 您是否属于以下情况"];
    [yiXiaQK_View addSubview:yiXiaQK_Label];
    yiXiaQK_Label.textColor=Title_text_color;
    
    //以下情况 介绍
    UIButton * yiXiaQK_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yiXiaQK_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [yiXiaQK_View addSubview:yiXiaQK_Button];
    yiXiaQK_Button.tag=90002;
    
    //起始高度
    float yiXiaQK_View_frame_origin_y=CGRectGetMaxY(yiXiaQK_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<yiXiaQK_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"yiXiaQK"];
        [yiXiaQK_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, yiXiaQK_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=YES;
        
        xuanXiang_Button.tag=5000+i;
        
        if (![PublicFunction isBlankString:_yangLaoZCModel.ninShiFS]) {
            if ([_yangLaoZCModel.ninShiFS intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [yiXiaQK_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=yiXiaQK_Title_Array[i];
        
        yiXiaQK_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    yiXiaQK_View.frame = CGRectMake(0, CGRectGetMaxY(yueShouRu_View.frame)+20, WIDTH, yiXiaQK_View_frame_origin_y);
    
    
    
    
    
    
    //是否需要配送餐 标题数组
    peiSongCan_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(yiXiaQK_View.frame)+20, WIDTH, 24*(peiSongCan_Title_Array.count+1))];
    [RootScrollView addSubview:peiSongCan_View];
    
    //是否需要配送餐 标题
    UILabel * peiSongCan_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"4. 是否需要配送餐"];
    [peiSongCan_View addSubview:peiSongCan_Label];
    peiSongCan_Label.textColor=Title_text_color;
    
    //是否需要配送餐 介绍
    UIButton * peiSongCan_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(peiSongCan_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [peiSongCan_View addSubview:peiSongCan_Button];
    peiSongCan_Button.tag=90003;
    
    //起始高度
    float peiSongCan_View_frame_origin_y=CGRectGetMaxY(peiSongCan_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<peiSongCan_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"peiSongCan"];
        [peiSongCan_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, peiSongCan_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=YES;
        
        xuanXiang_Button.tag=6000+i;
        
        if (![PublicFunction isBlankString:_yangLaoZCModel.shiFouXY]) {
            if ([_yangLaoZCModel.shiFouXY intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [peiSongCan_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=peiSongCan_Title_Array[i];
        
        peiSongCan_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    peiSongCan_View.frame = CGRectMake(0, CGRectGetMaxY(yiXiaQK_View.frame)+20, WIDTH, peiSongCan_View_frame_origin_y);
    
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(peiSongCan_View.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.xuqiu intValue]==0 || [self.xuqiu intValue]==1 || [self.xuqiu intValue]==5 || [self.xuqiu intValue]==6) {
            //保存
            Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
            [self.view addSubview:Save_Button];
            [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
            Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
            [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
            
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(peiSongCan_View.frame)+20+Tabbar_HE);
        }
    }
    
    
    if ([PublicFunction isBlankString:_yangLaoZCModel.shiFouXY]) {
        //默认需要配送餐
        [self create_peiSongCan];
    } else if (![PublicFunction isBlankString:_yangLaoZCModel.shiFouXY] && [_yangLaoZCModel.shiFouXY intValue]==0) {
        //需要配送餐
        [self create_peiSongCan];
    } else if (![PublicFunction isBlankString:_yangLaoZCModel.shiFouXY] && [_yangLaoZCModel.shiFouXY intValue]==1) {
        //不需要 送餐
        [self create_no_peiSongCan];
    }
    
    
    
    
    //收起键盘
    UITapGestureRecognizer * tapRoot = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRootAction)];
    //设置点击次数
    tapRoot.numberOfTapsRequired = 1;
    //设置几根胡萝卜有效
    tapRoot.numberOfTouchesRequired = 1;
    [RootScrollView addGestureRecognizer:tapRoot];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}







#pragma mark 设置 不需要 送餐 页面
-(void)create_no_peiSongCan
{
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(peiSongCan_View.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.xuqiu intValue]==0 || [self.xuqiu intValue]==1 || [self.xuqiu intValue]==5 || [self.xuqiu intValue]==6) {
            
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(peiSongCan_View.frame)+20+Tabbar_HE);
        }
    }
}










#pragma mark 设置 需要 送餐 页面
-(void)create_peiSongCan
{
    //送餐原因 标题数组
    songCanYY_view=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(peiSongCan_View.frame)+20, WIDTH, 24*(songCanYY_Title_Array.count+1))];
    [RootScrollView addSubview:songCanYY_view];
    
    //送餐原因 标题
    UILabel * songCanYY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"5. 您需要配送餐的原因"];
    [songCanYY_view addSubview:songCanYY_Label];
    songCanYY_Label.textColor=Title_text_color;
    
    //送餐原因 介绍
    UIButton * songCanYY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(songCanYY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [songCanYY_view addSubview:songCanYY_Button];
    songCanYY_Button.tag=90004;
    
    //请求数据 数组
    NSArray * songCanYY_strArray;
    if (![PublicFunction isBlankString:_yangLaoZCModel.ninXuYP]) {
        songCanYY_strArray=[_yangLaoZCModel.ninXuYP componentsSeparatedByString:@","];
    }
    
    //起始高度
    float songCanYY_View_frame_origin_y=CGRectGetMaxY(songCanYY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<songCanYY_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, songCanYY_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [songCanYY_view addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=7000+i;
        
        
//        if (![PublicFunction isBlankString:_yangLaoZCModel.ninXuYP]) {
//            int n=0;
//            for (int j=0; j<songCanYY_strArray.count; j++) {
//                if (![PublicFunction isBlankString:songCanYY_strArray[j]]) {
//                    if (![[songCanYY_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
//                        if ([songCanYY_strArray[j] intValue]==i) {
//                            [xuanXiang_Check setChecked:YES];
//                        }
//                        n++;
//                    } else {
//                        if (i==songCanYY_Title_Array.count-1) {
//                            [xuanXiang_Check setChecked:YES];
//                        }
//                        break;
//                    }
//                }
//            }
//        }
        
        if (![PublicFunction isBlankString:_yangLaoZCModel.ninXuYP]) {
            for (int j=0; j<songCanYY_strArray.count; j++) {
                if ([songCanYY_strArray[j] intValue]==i) {
                    [xuanXiang_Check setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [songCanYY_view addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=songCanYY_Title_Array[i];
        
        songCanYY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    songCanYY_view.frame = CGRectMake(0, CGRectGetMaxY(peiSongCan_View.frame)+20, WIDTH, songCanYY_View_frame_origin_y);
    
    
    
    
//    //送餐原因 签字框
//    songCanYY_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(songCanYY_view.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
//    songCanYY_Field.textColor=Field_text_color;
//    [RootScrollView addSubview:songCanYY_Field];
//    songCanYY_Field.delegate=self;
//    songCanYY_Field.userInteractionEnabled=NO;
//    
//    
//    if (![PublicFunction isBlankString:_yangLaoZCModel.ninXuYP]) {
//        int n=0;
//        NSString * qiTa=@"";
//        for (int j=0; j<songCanYY_strArray.count; j++) {
//            if (![PublicFunction isBlankString:songCanYY_strArray[j]]) {
//                if (![[songCanYY_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
//                    n++;
//                } else {
//                    songCanYY_Field.userInteractionEnabled=YES;
//                    break;
//                }
//            }
//        }
//        for (int j=n; j<songCanYY_strArray.count; j++) {
//            if (![PublicFunction isBlankString:songCanYY_strArray[j]]) {
//                if (j!=songCanYY_strArray.count-1) {
//                    qiTa=[qiTa stringByAppendingFormat:@"%@,",songCanYY_strArray[j]];
//                } else {
//                    qiTa=[qiTa stringByAppendingFormat:@"%@",songCanYY_strArray[j]];
//                }
//            }
//        }
//        if (![PublicFunction isBlankString:qiTa]) {
//            songCanYY_Field.text=[qiTa substringFromIndex:1];
//        }
//    }
    
    
    
    //送餐量 标题数组
    songCanLiang_view=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(songCanYY_view.frame)+20, WIDTH, 24*(songCanLiang_Title_Array.count+1))];
    [RootScrollView addSubview:songCanLiang_view];
    
    //送餐量 标题
    UILabel * songCanLiang_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"6. 您送餐量需求"];
    [songCanLiang_view addSubview:songCanLiang_Label];
    songCanLiang_Label.textColor=Title_text_color;
    
    //送餐量 介绍
    UIButton * songCanLiang_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(songCanLiang_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [songCanLiang_view addSubview:songCanLiang_Button];
    songCanLiang_Button.tag=90005;
    
    //起始高度
    float songCanLiang_View_frame_origin_y=CGRectGetMaxY(songCanLiang_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<songCanLiang_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"songCanLiang"];
        [songCanLiang_view addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, songCanLiang_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=YES;
        
        xuanXiang_Button.tag=8000+i;
        
        if (![PublicFunction isBlankString:_yangLaoZCModel.ninSongCL]) {
            if ([_yangLaoZCModel.ninSongCL intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [songCanLiang_view addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=songCanLiang_Title_Array[i];
        
        songCanLiang_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    songCanLiang_view.frame = CGRectMake(0, CGRectGetMaxY(songCanYY_view.frame)+20, WIDTH, songCanLiang_View_frame_origin_y);
    
    
    
    
    
    
    
    //送餐价格 标题数组
    songCanJG_view=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(songCanLiang_view.frame)+20, WIDTH, 24*(songCanJG_Title_Array.count+1))];
    [RootScrollView addSubview:songCanJG_view];
    
    //送餐价格 标题
    UILabel * songCanJG_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"7. 您认为配送每餐多少钱您能接受"];
    [songCanJG_view addSubview:songCanJG_Label];
    songCanJG_Label.textColor=Title_text_color;
    
    //送餐价格 介绍
    UIButton * songCanJG_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(songCanJG_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [songCanJG_view addSubview:songCanJG_Button];
    songCanJG_Button.tag=90006;
    
    //起始高度
    float songCanJG_View_frame_origin_y=CGRectGetMaxY(songCanJG_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<songCanJG_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"songCanJG"];
        [songCanJG_view addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, songCanJG_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=YES;
        
        xuanXiang_Button.tag=9000+i;
        
        if (![PublicFunction isBlankString:_yangLaoZCModel.ninRenWP]) {
            if ([_yangLaoZCModel.ninRenWP intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [songCanJG_view addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=songCanJG_Title_Array[i];
        
        songCanJG_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    songCanJG_view.frame = CGRectMake(0, CGRectGetMaxY(songCanLiang_view.frame)+20, WIDTH, songCanJG_View_frame_origin_y);
    
    
    
    
    
    
    
    //特殊需求 标题数组
    teShuXQ_view=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(songCanJG_view.frame)+20, WIDTH, 24*(teShuXQ_Title_Array.count+1))];
    [RootScrollView addSubview:teShuXQ_view];
    
    //特殊需求 标题
    UILabel * teShuXQ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"8. 您对饮食有何特殊需求"];
    [teShuXQ_view addSubview:teShuXQ_Label];
    teShuXQ_Label.textColor=Title_text_color;
    
    //特殊需求 介绍
    UIButton * teShuXQ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(teShuXQ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [teShuXQ_view addSubview:teShuXQ_Button];
    teShuXQ_Button.tag=90007;
    
    //请求数据 数组
    NSArray * teShuXQ_strArray;
    if (![PublicFunction isBlankString:_yangLaoZCModel.ninDuiYS]) {
        teShuXQ_strArray=[_yangLaoZCModel.ninDuiYS componentsSeparatedByString:@","];
    }
    
    //是否 选无
    int is_teShuXQ=0;
    
    if (![PublicFunction isBlankString:_yangLaoZCModel.ninDuiYS]) {
        for (int j=0; j<teShuXQ_strArray.count; j++) {
            if (_yangLaoZCModel.ninDuiYS.length==2) {
                if ([teShuXQ_strArray[j] intValue]==0) {
                    is_teShuXQ=1;
                }
            }
        }
    }
    
    //起始高度
    float teShuXQ_View_frame_origin_y=CGRectGetMaxY(teShuXQ_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<teShuXQ_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, teShuXQ_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [teShuXQ_view addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=10000+i;
        
        if (is_teShuXQ==1) {
            if (i==0) {
                [xuanXiang_Check setChecked:YES];
            } else {
                [xuanXiang_Check setChecked:NO];
                xuanXiang_Check.userInteractionEnabled=NO;
            }
        } else {
            if (![PublicFunction isBlankString:_yangLaoZCModel.ninDuiYS]) {
                int n=0;
                for (int j=0; j<teShuXQ_strArray.count; j++) {
                    if (![PublicFunction isBlankString:teShuXQ_strArray[j]]) {
                        if (![[teShuXQ_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
                            if ([teShuXQ_strArray[j] intValue]==i) {
                                [xuanXiang_Check setChecked:YES];
                            }
                            n++;
                        } else {
                            if (i==teShuXQ_Title_Array.count-1) {
                                [xuanXiang_Check setChecked:YES];
                            }
                            break;
                        }
                    }
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [teShuXQ_view addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=teShuXQ_Title_Array[i];
        
        teShuXQ_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    teShuXQ_view.frame = CGRectMake(0, CGRectGetMaxY(songCanJG_view.frame)+20, WIDTH, teShuXQ_View_frame_origin_y);
    
    
    
    
    //特殊需求 签字框
    teShuXQ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(teShuXQ_view.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    teShuXQ_Field.textColor=Field_text_color;
    [RootScrollView addSubview:teShuXQ_Field];
    teShuXQ_Field.delegate=self;
    teShuXQ_Field.userInteractionEnabled=NO;
    
    
    if (![PublicFunction isBlankString:_yangLaoZCModel.ninDuiYS]) {
        int n=0;
        NSString * qiTa=@"";
        for (int j=0; j<teShuXQ_strArray.count; j++) {
            if (![PublicFunction isBlankString:teShuXQ_strArray[j]]) {
                if (![[teShuXQ_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
                    n++;
                } else {
                    teShuXQ_Field.userInteractionEnabled=YES;
                    break;
                }
            }
        }
        for (int j=n; j<teShuXQ_strArray.count; j++) {
            if (![PublicFunction isBlankString:teShuXQ_strArray[j]]) {
                if (j!=teShuXQ_strArray.count-1) {
                    qiTa=[qiTa stringByAppendingFormat:@"%@,",teShuXQ_strArray[j]];
                } else {
                    qiTa=[qiTa stringByAppendingFormat:@"%@",teShuXQ_strArray[j]];
                }
            }
        }
        if (![PublicFunction isBlankString:qiTa]) {
            teShuXQ_Field.text=[qiTa substringFromIndex:1];
        }
    }
    
    
    //意见 建议 标题
    BuChongXX_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(teShuXQ_Field.frame)+20, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"9. 您对养老助餐工作的意见或建议"];
    [RootScrollView addSubview:BuChongXX_Label];
    BuChongXX_Label.textColor=Title_text_color;
    
    //意见 建议 介绍
    BuChongXX_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(BuChongXX_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:BuChongXX_Button];
    BuChongXX_Button.tag=90008;
    
    //意见 建议 输入框
    BuChongXX_TextView=[ZCControl createTextViewWithFrame:CGRectMake(15, CGRectGetMaxY(BuChongXX_Label.frame)+Q_ICON_HE, WIDTH-55, 100) scrollEnabled:YES editable:YES Font:Field_text_font];
    BuChongXX_TextView.textColor=Field_text_color;
    BuChongXX_TextView.delegate=self;
    [RootScrollView addSubview:BuChongXX_TextView];
    
    
    if (![PublicFunction isBlankString:_yangLaoZCModel.ninDuiYL]) {
        
        BuChongXX_TextView.text=_yangLaoZCModel.ninDuiYL;
    }
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(BuChongXX_TextView.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.xuqiu intValue]==0 || [self.xuqiu intValue]==1 || [self.xuqiu intValue]==5 || [self.xuqiu intValue]==6) {
            
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(BuChongXX_TextView.frame)+20+Tabbar_HE);
        }
    }
}




#pragma mark 移除控件
-(void)remove_All_View
{
    [songCanYY_view removeFromSuperview];
    //[songCanYY_Field removeFromSuperview];
    
    [songCanLiang_view removeFromSuperview];
    
    [songCanJG_view removeFromSuperview];
    
    [teShuXQ_view removeFromSuperview];
    [teShuXQ_Field removeFromSuperview];
    
    [BuChongXX_Label removeFromSuperview];
    [BuChongXX_Button removeFromSuperview];
    [BuChongXX_TextView removeFromSuperview];
}





#pragma mark - 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"单选"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"单选"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"单选"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"单选"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"多选，根据实际情况勾选配送餐原因"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"单选"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"单选"];
            
            [modal show];
        }
            break;
            
        case 90007:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"多选，根据实际情况勾选饮食特殊需求"];
            
            [modal show];
        }
            break;
            
        case 90008:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"根据实际情况填写意见或建议"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {

    if ([groupId isEqualToString:@"juZhuQK"]) {
        my_juZhuQK=[NSString stringWithFormat:@"%ld",radio.tag-3000];
    }
    
    if ([groupId isEqualToString:@"yueShouRu"]) {
        my_yueShouRu=[NSString stringWithFormat:@"%ld",radio.tag-4000];
    }
    
    if ([groupId isEqualToString:@"yiXiaQK"]) {
        my_yiXiaQK=[NSString stringWithFormat:@"%ld",radio.tag-5000];
    }
    
    if ([groupId isEqualToString:@"peiSongCan"]) {
        
        if ([my_peiSongCan intValue]!=radio.tag-6000) {
            //NSLog(@"my_pingGuZ:%@ tag:%ld",my_peiSongCan,radio.tag-6000);
            if (radio.tag-6000==0) {
                [self remove_All_View];
                [self create_peiSongCan];
            } else if (radio.tag-6000==1) {
                [self remove_All_View];
                [self create_no_peiSongCan];
            }
        }
        my_peiSongCan=[NSString stringWithFormat:@"%ld",radio.tag-6000];
    }
    
    if ([groupId isEqualToString:@"songCanLiang"]) {
        my_songCanLiang=[NSString stringWithFormat:@"%ld",radio.tag-8000];
    }
    
    if ([groupId isEqualToString:@"songCanJG"]) {
        my_songCanJG=[NSString stringWithFormat:@"%ld",radio.tag-9000];
    }
}


#pragma mark - 复选
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    switch (checkbox.tag/1000) {
        case 7:
        {
            if (checked==1) {
                [my_songCanYY_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-7000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-7000]];
            } else {
                [my_songCanYY_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-7000]];
            }
//            if (checked==1) {
//                if (checkbox.tag-7000==songCanYY_Title_Array.count-1) {
//                    songCanYY_Field.userInteractionEnabled=YES;
//                }
//            } else {
//                songCanYY_Field.userInteractionEnabled=NO;
//                songCanYY_Field.text=@"";
//            }
        }
            break;
        case 10:
        {
            if (checked==1) {
                if (checkbox.tag==10000) {
                    [my_teShuXQ_Dict removeAllObjects];
                    
                    for (int i=1; i<teShuXQ_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[teShuXQ_view viewWithTag:10000+i];
                        xuanXiang_Check.userInteractionEnabled=NO;
                        [xuanXiang_Check setChecked:NO];
                    }
                }
                
                [my_teShuXQ_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-10000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-10000]];
            } else {
                if (checkbox.tag==10000) {
                    
                    for (int i=1; i<teShuXQ_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[teShuXQ_view viewWithTag:10000+i];
                        xuanXiang_Check.userInteractionEnabled=YES;
                    }
                }
                
                [my_teShuXQ_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-10000]];
            }
            if (checked==1) {
                if (checkbox.tag-10000==teShuXQ_Title_Array.count-1) {
                    teShuXQ_Field.userInteractionEnabled=YES;
                }
            } else {
                teShuXQ_Field.userInteractionEnabled=NO;
                teShuXQ_Field.text=@"";
            }
        }
            break;
        default:
            break;
    }

}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_juZhuQK]) {
#pragma mark - 居住情况
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“居住情况”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_yueShouRu]) {
#pragma mark - 月收入情况
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“月收入情况”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_yiXiaQK]) {
#pragma mark - 您是否属于以下情况
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“您是否属于以下情况”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_peiSongCan]) {
#pragma mark - 是否需要配送餐
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“是否需要配送餐”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:my_peiSongCan] && [my_peiSongCan intValue]==0) {
        //需要送餐
        [self Is_PeiSongCan];
    }else if (![PublicFunction isBlankString:my_peiSongCan] && [my_peiSongCan intValue]==1) {
        
        //更新 养老助餐调研
        [self update_YangLaoZC];
    }
    
}

//需要送餐
-(void)Is_PeiSongCan
{
    if (my_songCanYY_Dict.count==0) {
#pragma mark - 您需要配送餐的原因
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“您需要配送餐的原因”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }
//    else if ([PublicFunction isRangeOfString:my_songCanYY_Dict num:songCanYY_Title_Array.count-1] && [PublicFunction isBlankString:songCanYY_Field.text]) {
//#pragma mark - 配送餐的原因 其他项
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“您需要配送餐的原因的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//        
//    }
    else if ([PublicFunction isBlankString:my_songCanLiang]) {
#pragma mark - 您送餐量需求
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“您送餐量需求”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_songCanJG]) {
#pragma mark - 您认为配送餐每餐多少钱您能接受
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“您认为配送餐每餐多少钱您能接受”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (my_teShuXQ_Dict.count==0) {
#pragma mark - 您对饮食有何特殊要求
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“您对饮食有何特殊要求”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isRangeOfString:my_teShuXQ_Dict num:teShuXQ_Title_Array.count-1] && [PublicFunction isBlankString:teShuXQ_Field.text]) {
#pragma mark - 您对饮食有何特殊要求 其他项
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“您对饮食有何特殊要求的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        
        //更新 养老助餐调研
        [self update_YangLaoZC];
    }
}


//更新 养老助餐调研
-(void)update_YangLaoZC
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"45" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    if (![PublicFunction isBlankString:my_juZhuQK]) {
        [parameter setObject:my_juZhuQK forKey:@"juZhuQK"];
    }
    
    if (![PublicFunction isBlankString:my_yueShouRu]) {
        [parameter setObject:my_yueShouRu forKey:@"yueShouRQ"];
    }
    
    if (![PublicFunction isBlankString:my_yiXiaQK]) {
        [parameter setObject:my_yiXiaQK forKey:@"ninShiFS"];
    }
    
    if (![PublicFunction isBlankString:my_peiSongCan]) {
        [parameter setObject:my_peiSongCan forKey:@"shiFouXY"];
    }
    
//    NSArray * my_songCanYY_keysArray=[my_songCanYY_Dict allKeys];
//    NSMutableString * my_songCanYY=[[NSMutableString alloc]init];
//    for (NSString * str in my_songCanYY_keysArray) {
//        if ([str intValue]!=songCanYY_Title_Array.count-1) {
//            [my_songCanYY appendFormat:@"%@,",str];
//        }
//    }
//    for (NSString * str in my_songCanYY_keysArray) {
//        if ([str intValue]==songCanYY_Title_Array.count-1) {
//            [my_songCanYY appendFormat:@"X%@",songCanYY_Field.text];
//        }
//    }
    NSArray * my_songCanYY_keysArray=[my_songCanYY_Dict allKeys];
    NSMutableString * my_songCanYY=[[NSMutableString alloc]init];
    for (int i=0; i<my_songCanYY_keysArray.count; i++) {
        if (i==my_songCanYY_keysArray.count-1) {
            [my_songCanYY appendFormat:@"%@",my_songCanYY_keysArray[i]];
        } else {
            [my_songCanYY appendFormat:@"%@,",my_songCanYY_keysArray[i]];
        }
    }
    [parameter setObject:my_songCanYY forKey:@"ninXuYP"];
    
    if (![PublicFunction isBlankString:my_songCanLiang]) {
        [parameter setObject:my_songCanLiang forKey:@"ninSongCL"];
    }
    
    if (![PublicFunction isBlankString:my_songCanJG]) {
        [parameter setObject:my_songCanJG forKey:@"ninRenWP"];
    }
    
    NSArray * my_teShuXQ_keysArray=[my_teShuXQ_Dict allKeys];
    NSMutableString * my_teShuXQ=[[NSMutableString alloc]init];
    for (NSString * str in my_teShuXQ_keysArray) {
        if ([str intValue]!=teShuXQ_Title_Array.count-1) {
            [my_teShuXQ appendFormat:@"%@,",str];
        }
    }
    for (NSString * str in my_teShuXQ_keysArray) {
        if ([str intValue]==teShuXQ_Title_Array.count-1) {
            [my_teShuXQ appendFormat:@"X%@",teShuXQ_Field.text];
        }
    }
    [parameter setObject:my_teShuXQ forKey:@"ninDuiYS"];
    
    if (![PublicFunction isBlankString:BuChongXX_TextView.text]) {
        [parameter setObject:BuChongXX_TextView.text forKey:@"ninDuiYL"];
    }
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:insertResultHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        [KVNProgress dismiss];
        
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
        //NSLog(@"%@",errorCode);
    } WithFailureBlock:^{
        [KVNProgress dismiss];
    }];
}







//获取 ScrollView 滑动距离
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==60000) {
        RootScrollView_contentOffset_y=scrollView.contentOffset.y;
    }
}

#pragma mark 输入完毕
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //收起键盘
    [self tapRootAction];
    
    return YES;
}

#pragma mark 键盘监听方法设置
//当键盘出现时调用
-(void)keyboardWillShow:(NSNotification *)aNotification
{
    //第一个参数写输入view的父view即可，第二个写监听获得的notification，第三个写希望高于键盘的高度(只在被键盘遮挡时才启用,如控件未被遮挡,则无变化)
    //如果想不通输入view获得不同高度，可自己在此方法里分别判断区别
    [[CDPMonitorKeyboard defaultMonitorKeyboard] keyboardWillShowWithSuperView:RootScrollView andNotification:aNotification higherThanKeyboard:0 contentOffsety:RootScrollView_contentOffset_y];
    
}
//当键退出时调用
-(void)keyboardWillHide:(NSNotification *)aNotification
{
    [[CDPMonitorKeyboard defaultMonitorKeyboard] keyboardWillHide];
}
//dealloc中需要移除监听
-(void)dealloc
{
    //移除监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    //移除监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
//收起键盘
-(void)tapRootAction
{
    [RootScrollView endEditing:YES];
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

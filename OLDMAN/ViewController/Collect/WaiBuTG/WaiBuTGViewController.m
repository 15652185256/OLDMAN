//
//  WaiBuTGViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "WaiBuTGViewController.h"
#import "WaiBuTGModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

@interface WaiBuTGViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    UITextField * guWenT_Field;//顾问或情感支持(天)
    
    UITextField * guWenXS_Field;//顾问或情感支持(小时)
    
    UITextField * guWenFZ_Field;//顾问或情感支持(分钟)
    
    UITextField * geRenT_Field;//个人生活照护(天)
    
    UITextField * geRenXS_Field;//个人生活照护(小时)
    
    UITextField * geRenFZ_Field;//个人生活照护(分钟)
    
    UITextField * juJiaT_Field;//居家生活支持(天)
    
    UITextField * juJiaXS_Field;//居家生活支持(小时)
    
    UITextField * juJiaFZ_Field;//居家生活支持(分钟)
    
    UITextField * jiaTingCY5H_Field;//居家照护小时(工作日)
    
    UITextField * jiaTingCY5M_Field;//居家照护分钟(工作日)
    
    UITextField * jiaTingCY2H_Field;//居家照护小时(周末)
    
    UITextField * jiaTingCY2M_Field;//居家照护分钟(周末)
    
    
    NSArray * kanHuMB_Title_Array;//看护目标
    
    NSString * my_kanHuMB;//看护目标
    
    
    NSArray * kanHuXQ_Title_Array;//看护需求改变
    
    NSString * my_kanHuXQ;//看护需求改变
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    WaiBuTGModel * _waiBuTGModel;//数据源
}
@end

@implementation WaiBuTGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    //实列化
    my_kanHuMB=@"";//看护目标
    
    my_kanHuXQ=@"";//看护需求改变
    

    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}


//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _waiBuTGModel=[[WaiBuTGModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _waiBuTGModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //看护目标
    kanHuMB_Title_Array=@[@"达到目标",@"部分达到目标",@"未达到目标"];
    
    //看护需求改变
    kanHuXQ_Title_Array=@[@"恶化-需要更多看护支持",@"改善-看护支持需求减少"];
}

#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"7"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_waiBuTGModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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




#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航背景图
    self.navigationController.navigationBar.barTintColor = Nav_Tabbar_backgroundColor;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"外部提供的专业看护服务";
    
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
    RootScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    [self.view addSubview:RootScrollView];
    RootScrollView.backgroundColor=View_Background_Color;
    RootScrollView.delegate=self;
    
    
    //过去7天里获得的专业服务
    UILabel * kanHu_label=[ZCControl createLabelWithFrame:CGRectMake(15, 20, WIDTH-55, Title_text_font) Font:Title_text_font Text:@"1. 过去7天里获得的专业服务"];
    [RootScrollView addSubview:kanHu_label];
    kanHu_label.textColor=Title_text_color;
    
    
    //顾问或情感支持
    UILabel * guWen_label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(kanHu_label.frame)+10, WIDTH-15, Answer_text_font) Font:Answer_text_font Text:@"(1) 顾问或情感支持"];
    [RootScrollView addSubview:guWen_label];
    guWen_label.textColor=Answer_text_color;
    
    
    //顾问或情感支持 介绍
    UIButton * guWen_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(guWen_label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:guWen_Button];
    guWen_Button.tag=90000;
    
    
    
    //顾问或情感支持(天) 签字框
    guWenT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(guWen_label.frame)+10, 65, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    guWenT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:guWenT_Field];
    guWenT_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.guWenHQD]) {
        guWenT_Field.text=_waiBuTGModel.guWenHQD;
    }
    
    
    //顾问或情感支持(天) 单位
    UILabel * guWen_days_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(guWenT_Field.frame)+Title_Field_WH, CGRectGetMinY(guWenT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"天"];
    [RootScrollView addSubview:guWen_days_label];
    guWen_days_label.textColor=Answer_text_color;
    
    
    
    //顾问或情感支持(小时) 签字框
    guWenXS_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(guWen_days_label.frame), CGRectGetMinY(guWenT_Field.frame), 60, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    guWenXS_Field.textColor=Field_text_color;
    [RootScrollView addSubview:guWenXS_Field];
    guWenXS_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.guWenHQH]) {
        guWenXS_Field.text=_waiBuTGModel.guWenHQH;
    }
    
    
    //顾问或情感支持(小时) 单位
    UILabel * guWen_hours_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(guWenXS_Field.frame)+Title_Field_WH, CGRectGetMinY(guWenT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"小时"];
    [RootScrollView addSubview:guWen_hours_label];
    guWen_hours_label.textColor=Answer_text_color;
    
    

    //顾问或情感支持(分钟) 签字框
    guWenFZ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(guWen_hours_label.frame), CGRectGetMinY(guWenT_Field.frame), 60, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    guWenFZ_Field.textColor=Field_text_color;
    [RootScrollView addSubview:guWenFZ_Field];
    guWenFZ_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.guWenHQM]) {
        guWenFZ_Field.text=_waiBuTGModel.guWenHQM;
    }
   
    

    //顾问或情感支持(分钟) 单位
    UILabel * guWen_minutes_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(guWenFZ_Field.frame)+Title_Field_WH, CGRectGetMinY(guWenT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"分钟"];
    [RootScrollView addSubview:guWen_minutes_label];
    guWen_minutes_label.textColor=Answer_text_color;
    
    
    
    
    
    
    
    
    //个人生活照护
    UILabel * geRen_label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(guWenT_Field.frame)+10, WIDTH-15, Answer_text_font) Font:Answer_text_font Text:@"(2) 个人生活照护"];
    [RootScrollView addSubview:geRen_label];
    geRen_label.textColor=Answer_text_color;
    
    //个人生活照护 介绍
    UIButton * geRen_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(geRen_label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:geRen_Button];
    geRen_Button.tag=90001;
    
    
    //个人生活照护(天) 签字框
    geRenT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(geRen_label.frame)+10, 65, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    geRenT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:geRenT_Field];
    geRenT_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.geRenSSD]) {
        geRenT_Field.text=_waiBuTGModel.geRenSSD;
    }
    
    
    
    //个人生活照护(天) 单位
    UILabel * geRen_days_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(geRenT_Field.frame)+Title_Field_WH, CGRectGetMinY(geRenT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"天"];
    [RootScrollView addSubview:geRen_days_label];
    geRen_days_label.textColor=Answer_text_color;
    
    
    
    //个人生活照护(小时) 签字框
    geRenXS_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(geRen_days_label.frame), CGRectGetMinY(geRenT_Field.frame), 60, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    geRenXS_Field.textColor=Field_text_color;
    [RootScrollView addSubview:geRenXS_Field];
    geRenXS_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.geRenSSH]) {
        geRenXS_Field.text=_waiBuTGModel.geRenSSH;
    }
    
    
    
    //个人生活照护(小时) 单位
    UILabel * geRen_hours_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(geRenXS_Field.frame)+Title_Field_WH, CGRectGetMinY(geRenT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"小时"];
    [RootScrollView addSubview:geRen_hours_label];
    geRen_hours_label.textColor=Answer_text_color;
    
    
    
    //个人生活照护(分钟) 签字框
    geRenFZ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(geRen_hours_label.frame), CGRectGetMinY(geRenT_Field.frame), 60, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    geRenFZ_Field.textColor=Field_text_color;
    [RootScrollView addSubview:geRenFZ_Field];
    geRenFZ_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.geRenSSM]) {
        geRenFZ_Field.text=_waiBuTGModel.geRenSSM;
    }

    
    
    //顾问或情感支持(分钟) 单位
    UILabel * geRen_minutes_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(geRenFZ_Field.frame)+Title_Field_WH, CGRectGetMinY(geRenT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"分钟"];
    [RootScrollView addSubview:geRen_minutes_label];
    geRen_minutes_label.textColor=Answer_text_color;
    
    


    
    
    
    //居家生活支持
    UILabel * juJia_label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(geRenT_Field.frame)+10, WIDTH-15, Answer_text_font) Font:Answer_text_font Text:@"(3) 居家生活支持"];
    [RootScrollView addSubview:juJia_label];
    juJia_label.textColor=Answer_text_color;
    
    //居家生活支持 介绍
    UIButton * juJia_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(juJia_label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:juJia_Button];
    juJia_Button.tag=90002;
    
    
    //居家生活支持(天) 签字框
    juJiaT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(juJia_label.frame)+10, 65, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juJiaT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juJiaT_Field];
    juJiaT_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.juJiaSSD]) {
        juJiaT_Field.text=_waiBuTGModel.juJiaSSD;
    }
    
    
    
    
    //居家生活支持(天) 单位
    UILabel * juJia_days_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(juJiaT_Field.frame)+Title_Field_WH, CGRectGetMinY(juJiaT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"天"];
    [RootScrollView addSubview:juJia_days_label];
    juJia_days_label.textColor=Answer_text_color;
    
    
    
    //居家生活支持小时) 签字框
    juJiaXS_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juJia_days_label.frame), CGRectGetMinY(juJiaT_Field.frame), 60, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juJiaXS_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juJiaXS_Field];
    juJiaXS_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.juJiaSSH]) {
        juJiaXS_Field.text=_waiBuTGModel.juJiaSSH;
    }
    
    
    
    //个人生活照护(小时) 单位
    UILabel * juJia_hours_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(juJiaXS_Field.frame)+Title_Field_WH, CGRectGetMinY(juJiaT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"小时"];
    [RootScrollView addSubview:juJia_hours_label];
    juJia_hours_label.textColor=Answer_text_color;
    
    
    
    
    
    //个人生活照护(分钟) 签字框
    juJiaFZ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juJia_hours_label.frame), CGRectGetMinY(juJiaT_Field.frame), 60, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juJiaFZ_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juJiaFZ_Field];
    juJiaFZ_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_waiBuTGModel.juJiaSSM]) {
        juJiaFZ_Field.text=_waiBuTGModel.juJiaSSM;
    }
    

    
    //顾问或情感支持(分钟) 单位
    UILabel * juJia_minutes_label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(juJiaFZ_Field.frame)+Title_Field_WH, CGRectGetMinY(juJiaT_Field.frame), 44, Field_HE) Font:Answer_text_font Text:@"分钟"];
    [RootScrollView addSubview:juJia_minutes_label];
    juJia_minutes_label.textColor=Answer_text_color;
    
    
    
    
    //看护目标
    UIView * kanHuMB_View=[ZCControl createView:CGRectMake(0, 0, WIDTH, 24*(kanHuMB_Title_Array.count+1))];
    [RootScrollView addSubview:kanHuMB_View];
    
    //看护目标 标题
    UILabel * kanHuMB_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"2. 看护目标"];
    [kanHuMB_View addSubview:kanHuMB_Label];
    kanHuMB_Label.textColor=Title_text_color;
    
    //看护目标 介绍
    UIButton * kanHuMB_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(kanHuMB_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [kanHuMB_View addSubview:kanHuMB_Button];
    kanHuMB_Button.tag=90003;
    
    //起始高度
    float kanHuMB_View_frame_origin_y=CGRectGetMaxY(kanHuMB_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<kanHuMB_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"kanHuMB"];
        [kanHuMB_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, kanHuMB_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=3000+i;
        
        if (![PublicFunction isBlankString:_waiBuTGModel.kanHuMB]) {
            if ([_waiBuTGModel.kanHuMB intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [kanHuMB_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=kanHuMB_Title_Array[i];
    
        kanHuMB_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    kanHuMB_View.frame = CGRectMake(0, CGRectGetMaxY(juJiaT_Field.frame)+20, WIDTH, kanHuMB_View_frame_origin_y);
    
    
    
    //看护需求改变
    UIView * kanHuXQ_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(kanHuMB_View.frame)+10, WIDTH, 24*(kanHuXQ_Title_Array.count+1))];
    [RootScrollView addSubview:kanHuXQ_View];
    
    //看护目标 标题
    UILabel * kanHuXQ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, 44+Title_text_font*5, Title_text_font) Font:Title_text_font Text:@"3. 看护需求改变"];
    [kanHuXQ_View addSubview:kanHuXQ_Label];
    kanHuXQ_Label.textColor=Title_text_color;
    
    //看护目标 介绍
    UIButton * kanHuXQ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(kanHuXQ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [kanHuXQ_View addSubview:kanHuXQ_Button];
    kanHuXQ_Button.tag=90004;
    
    //起始高度
    float kanHuXQ_View_frame_origin_y=CGRectGetMaxY(kanHuXQ_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<kanHuXQ_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"kanHuXQ"];
        [kanHuXQ_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, kanHuXQ_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=4000+i;
        
        if (![PublicFunction isBlankString:_waiBuTGModel.kanHuXQ]) {
            if ([_waiBuTGModel.kanHuXQ intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [kanHuXQ_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=kanHuXQ_Title_Array[i];
    
        kanHuXQ_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    kanHuXQ_View.frame = CGRectMake(0, CGRectGetMaxY(kanHuMB_View.frame)+20, WIDTH, kanHuXQ_View_frame_origin_y);
    
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(kanHuXQ_View.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;

    
    
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.collection intValue]==0 || [self.collection intValue]==1 || [self.collection intValue]==5 || [self.collection intValue]==6) {
            //保存
            Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
            [self.view addSubview:Save_Button];
            [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
            Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
            [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
            
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(kanHuXQ_View.frame)+20+Tabbar_HE);
        }
        
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





#pragma mark 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：顾问或情感支持：包括陪伴、陪聊、心理疏导等服务；\n\n方法：通过向申请人/代理人或其照护者询问，由评估人员汇总计算。\n\n例如可提问“您的XX（外部照护者）在过去7天里，给您提供的顾问或情感支持方面服务一共有几天？每天大概多长时间？”如果答案是有6天，每天大概8小时，则判断（2）的答案为48小时。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：个人生活照护：包括协助进食、大小便控制、如厕、转移、穿衣、洗浴等服务。\n\n方法：通过向申请人/代理人或其他照护者询问，由评估人员汇总计算。\n\n例如可提问：“您的XX（外部看护者）在过去7天里，给您提供的个人生活照护方面的服务一共有几天？每天大概多长时间？”如果答案是有6天，每天大概8小时，则判断答案为48小时。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：居家生活支持：包括帮助购物、陪同外出、做家务、做饭、洗衣、用电话、服药、管钱等服务。\n\n方法： 通过向申请人/代理人或其照护者询问，由评估人员汇总计算。例如可提问：“您的XX（外部看护者）在过去7天里，给您提供的个人生活照护方面的服务一共有几天？每天大概多长时间？”如果答案是有6天，每天大概8小时，则判断答案为48小时"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：判断目前申请人使用外部看护服务在多大程度上能够解决其需求，以及看护服务的功效。\n\n方法：通过与被访者交谈了解，按了解情况如实选择。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：过去90天或自上一次评估到现在申请人生活能力状况的显著变化导致对看护服务需求的改变。\n\n方法：通过向申请人/代理人或其照护者询问过去90天或自上一次评估到现在申请人生活能力有无变化或变化情况，判断对申请人的看护服务是否需要增加或减少。\n\n定义：恶化：过去90天或自上一次评估到现在申请人生活能力的状况有明显变化向不好的方面转化，需要增加看护支持。\n\n改善：过去90天或自上一次评估到现在申请人生活能力的状况有明显变化向好的方面转化，可以增加看护支持。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    if ([groupId isEqualToString:@"kanHuMB"]) {
        my_kanHuMB=[NSString stringWithFormat:@"%ld",radio.tag-3000];
    }
    if ([groupId isEqualToString:@"kanHuXQ"]) {
        my_kanHuXQ=[NSString stringWithFormat:@"%ld",radio.tag-4000];
    }
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if (![PublicFunction isBlankString:guWenT_Field.text] && ![PublicFunction validateNumber:guWenT_Field.text]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“顾问或情感支持天”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:guWenXS_Field.text] && ![PublicFunction validateNumber:guWenXS_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“顾问或情感支持小时”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:guWenFZ_Field.text] && ![PublicFunction validateNumber:guWenFZ_Field.text]) {

        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“顾问或情感支持分钟”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:guWenFZ_Field.text] && [guWenFZ_Field.text intValue]>60) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“顾问或情感支持分钟”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:geRenT_Field.text] && ![PublicFunction validateNumber:geRenT_Field.text]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“个人生活照护天”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:geRenXS_Field.text] && ![PublicFunction validateNumber:geRenXS_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“个人生活照护小时”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:geRenFZ_Field.text] && ![PublicFunction validateNumber:geRenFZ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“个人生活照护分钟”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:geRenFZ_Field.text] && [geRenFZ_Field.text intValue]>60) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“个人生活照护分钟”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:juJiaT_Field.text] && ![PublicFunction validateNumber:juJiaT_Field.text]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“居家生活支持天”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:juJiaXS_Field.text] && ![PublicFunction validateNumber:juJiaXS_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“居家生活支持小时”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:juJiaFZ_Field.text] && ![PublicFunction validateNumber:juJiaFZ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“居家生活支持分钟”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:juJiaFZ_Field.text] && [juJiaFZ_Field.text intValue]>60) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“居家生活支持分钟”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        //更新 外部提供的专业看护服务
        [self update_WaiBuTG];
    }
}


//更新 外部提供的专业看护服务
-(void)update_WaiBuTG
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"7" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    if (![PublicFunction isBlankString:guWenT_Field.text]) {
        [parameter setObject:guWenT_Field.text forKey:@"guWenHQD"];
    }
    
    if (![PublicFunction isBlankString:guWenXS_Field.text]) {
        [parameter setObject:guWenXS_Field.text forKey:@"guWenHQH"];
    }
    
    if (![PublicFunction isBlankString:guWenFZ_Field.text]) {
        [parameter setObject:guWenFZ_Field.text forKey:@"guWenHQM"];
    }
    
    
    
    if (![PublicFunction isBlankString:geRenT_Field.text]) {
        [parameter setObject:geRenT_Field.text forKey:@"geRenSSD"];
    }
    
    if (![PublicFunction isBlankString:geRenXS_Field.text]) {
        [parameter setObject:geRenXS_Field.text forKey:@"geRenSSH"];
    }
    
    if (![PublicFunction isBlankString:geRenFZ_Field.text]) {
        [parameter setObject:geRenFZ_Field.text forKey:@"geRenSSM"];
    }
    
    
    
    if (![PublicFunction isBlankString:juJiaT_Field.text]) {
        [parameter setObject:juJiaT_Field.text forKey:@"juJiaSSD"];
    }
    
    if (![PublicFunction isBlankString:juJiaXS_Field.text]) {
        [parameter setObject:juJiaXS_Field.text forKey:@"juJiaSSH"];
    }
    
    if (![PublicFunction isBlankString:juJiaFZ_Field.text]) {
        [parameter setObject:juJiaFZ_Field.text forKey:@"juJiaSSM"];
    }
    
    
    
    if (![PublicFunction isBlankString:my_kanHuMB]) {
        [parameter setObject:my_kanHuMB forKey:@"kanHuMB"];
    }
    
    if (![PublicFunction isBlankString:my_kanHuXQ]) {
        [parameter setObject:my_kanHuXQ forKey:@"kanHuXQ"];
    }
    
    
    [KVNProgress show];
    
    
    
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
    RootScrollView_contentOffset_y=scrollView.contentOffset.y;
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

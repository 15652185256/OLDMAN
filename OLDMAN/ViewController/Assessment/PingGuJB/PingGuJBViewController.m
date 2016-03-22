//
//  PingGuJBViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/22.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "PingGuJBViewController.h"
#import "PingGuJBModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

@interface PingGuJBViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    
    NSArray * pingGuZ_Title_Array;//评估提供者
    
    NSString * my_pingGuZ;//评估提供者
    
    UIView * pingGuZ_View;//评估提供者
    
    
    
    UILabel * xingMing_Label;//姓名
    
    UITextField * xingMing_Field;//姓名
    
    UIButton * xingMing_Button;//姓名
    
    
    UILabel * nianLing_Label;//年龄
    
    UITextField * nianLing_Field;//年龄
    
    UIButton * nianLing_Button;//年龄
    
    
    UILabel * lianXiDH_Label;//联系电话
    
    UITextField * lianXiDH_Field;//联系电话
    
    UIButton * lianXiDH_Button;//联系电话
    
    
    
    NSArray * yuLaoRG_Title_Array;//与老人关系
    
    NSString * my_yuLaoRG;//与老人关系
    
    UIView * yuLaoRG_View;//与老人关系
    

    
    UIView * pingGuYY_View;//评估原因
    
    NSArray * pingGuYY_Title_Array;//评估原因  标题数组
    
    NSString *  my_pingGuYY;//评估原因
    
    
    //UILabel * pingGuYYQT_Label;//评估原因 其他
    
    UITextField * pingGuYYQT_Field;//评估原因 其他
    
    
    
    UIView * saiCha_View;//筛查
    
    NSArray * saiCha_Title_Array;//筛查 标题数组
    
    NSString * my_saiCha;//筛查
    
    
    UITextField * saiChaQT_Field;//筛查 其他
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    
    PingGuJBModel * _pingGuJBModel;//请求 数据
}
@end

@implementation PingGuJBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _pingGuJBModel=[[PingGuJBModel alloc]init];//请求 数据
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _pingGuJBModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //评估提供者
    pingGuZ_Title_Array=@[@"被评估着本人",@"非本人"];
    
    //评估原因  标题数组
    pingGuYY_Title_Array=@[@"初次评估",@"跟进评估",@"退出服务项目前30天内评估",@"住院后返回评估",@"状况改变",@"其他"];
    
    //筛查 标题数组
    saiCha_Title_Array=@[@"无",@"生活能力／认知能力重度受损（失能）",@"昏迷／神志不清",@"双目失明",@"其他"];
    
    //与老人关系
    yuLaoRG_Title_Array=@[@"配偶",@"子女",@"亲属",@"非亲属"];
}


#pragma mark 请求数据
-(void)loadData
{
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
    self.navigationItem.title = @"评估基本信息";
    
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
    
    
    
    
    //评估提供者
    pingGuZ_View=[ZCControl createView:CGRectMake(0, 20, WIDTH, 24*(pingGuZ_Title_Array.count+1))];
    [RootScrollView addSubview:pingGuZ_View];

    //评估提供者 标题
    UILabel * pingGuZ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"1. 评估提供者"];
    [pingGuZ_View addSubview:pingGuZ_Label];
    pingGuZ_Label.textColor=Title_text_color;
    
    //评估提供者 介绍
    UIButton * pingGuZ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(pingGuZ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [pingGuZ_View addSubview:pingGuZ_Button];
    pingGuZ_Button.tag=90000;
    
    //起始高度
    float pingGuZ_View_frame_origin_y=CGRectGetMaxY(pingGuZ_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<pingGuZ_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"pingGuZ"];
        [pingGuZ_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, pingGuZ_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=3000+i;
        
        if (![PublicFunction isBlankString:_pingGuJBModel.pingGuZ]) {
            if ([_pingGuJBModel.pingGuZ intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [pingGuZ_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=pingGuZ_Title_Array[i];
        
        pingGuZ_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    pingGuZ_View.frame = CGRectMake(0, 20, WIDTH, pingGuZ_View_frame_origin_y);
    

    if ([my_pingGuZ intValue]==0) {
        [self remove_All_View];
        //本人
        [self create_PingGuJB_view];
    } else if ([my_pingGuZ intValue]==1){
        [self remove_All_View];
        //非本人
        [self create_PingGuJB_Fei_view];
    }
    


    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.assessment intValue]==0 || [self.assessment intValue]==1 || [self.assessment intValue]==5 || [self.assessment intValue]==6) {
            //保存
            Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
            [self.view addSubview:Save_Button];
            [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
            Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
            [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
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




#pragma mark 设置 评估者本人 页面
-(void)create_PingGuJB_view
{
    //评估原因  标题数组
    pingGuYY_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(pingGuZ_View.frame)+20, WIDTH, 24*(pingGuYY_Title_Array.count+1))];
    [RootScrollView addSubview:pingGuYY_View];
    
    //评估原因 标题
    UILabel * pingGuYY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"2. 评估原因"];
    [pingGuYY_View addSubview:pingGuYY_Label];
    pingGuYY_Label.textColor=Title_text_color;
    
    //评估原因 介绍
    UIButton * pingGuYY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(pingGuYY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [pingGuYY_View addSubview:pingGuYY_Button];
    pingGuYY_Button.tag=90005;
    
    //起始高度
    float pingGuYY_View_frame_origin_y=CGRectGetMaxY(pingGuYY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<pingGuYY_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"pingGuYY"];
        [pingGuYY_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, pingGuYY_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=5000+i;
        
        if (![PublicFunction isBlankString:_pingGuJBModel.pingGuYY]) {
            if ([[_pingGuJBModel.pingGuYY substringToIndex:1] isEqualToString:@"X"]) {
                if (i==pingGuYY_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_pingGuJBModel.pingGuYY intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [pingGuYY_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=pingGuYY_Title_Array[i];
    
        pingGuYY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    pingGuYY_View.frame = CGRectMake(0, CGRectGetMaxY(pingGuZ_View.frame)+20, WIDTH, pingGuYY_View_frame_origin_y);
    
    
    
    //评估原因 其他 签字框
    pingGuYYQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(pingGuYY_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    pingGuYYQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:pingGuYYQT_Field];
    pingGuYYQT_Field.delegate=self;
    pingGuYYQT_Field.userInteractionEnabled=NO;
    
    
    if (![PublicFunction isBlankString:_pingGuJBModel.pingGuYY]) {
        if ([[_pingGuJBModel.pingGuYY substringToIndex:1] isEqualToString:@"X"]) {
            pingGuYYQT_Field.userInteractionEnabled=YES;
            pingGuYYQT_Field.text=[_pingGuJBModel.pingGuYY substringFromIndex:1];
        }
    }
    
    
    
    
    //筛查 标题数组
    saiCha_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(pingGuYYQT_Field.frame)+20, WIDTH, 24*(saiCha_Title_Array.count+1))];
    [RootScrollView addSubview:saiCha_View];
    
    //筛查 标题
    UILabel * saiCha_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"3. 免评估筛查"];
    [saiCha_View addSubview:saiCha_Label];
    saiCha_Label.textColor=Title_text_color;
    
    //筛查 介绍
    UIButton * saiCha_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(saiCha_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [saiCha_View addSubview:saiCha_Button];
    saiCha_Button.tag=90006;
    
    //起始高度
    float saiCha_View_View_frame_origin_y=CGRectGetMaxY(pingGuYY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<saiCha_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"saiCha"];
        [saiCha_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, saiCha_View_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=6000+i;
        
        if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
            if ([[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
                if (i==saiCha_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_pingGuJBModel.saiCha intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [saiCha_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=saiCha_Title_Array[i];
    
        saiCha_View_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    saiCha_View.frame = CGRectMake(0, CGRectGetMaxY(pingGuYYQT_Field.frame)+20, WIDTH, saiCha_View_View_frame_origin_y);
    

    
    //评估原因 其他 签字框
    saiChaQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(saiCha_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    saiChaQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:saiChaQT_Field];
    saiChaQT_Field.delegate=self;
    saiChaQT_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
        if ([[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
            saiChaQT_Field.userInteractionEnabled=YES;
            saiChaQT_Field.text=[_pingGuJBModel.saiCha substringFromIndex:1];
        }
    }
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(saiChaQT_Field.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.assessment intValue]==0 || [self.assessment intValue]==1 || [self.assessment intValue]==5 || [self.assessment intValue]==6) {
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(saiChaQT_Field.frame)+20+Tabbar_HE);
        }
    }
    
}



#pragma mark 设置 非评估者本人 页面
-(void)create_PingGuJB_Fei_view
{
    //姓名 标题
    xingMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(pingGuZ_View.frame)+20, 44+Title_text_font, Title_text_font) Font:Title_text_font Text:@"2. 姓名"];
    [RootScrollView addSubview:xingMing_Label];
    xingMing_Label.textColor=Title_text_color;
    
    
    //姓名 签字框
    xingMing_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(xingMing_Label.frame)+Title_Field_WH, CGRectGetMinY(xingMing_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-xingMing_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil  rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    xingMing_Field.textColor=Field_text_color;
    [RootScrollView addSubview:xingMing_Field];
    xingMing_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_pingGuJBModel.xingMing]) {
        xingMing_Field.text=_pingGuJBModel.xingMing;
    }
    
    
    //姓名 介绍
    xingMing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(xingMing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:xingMing_Button];
    xingMing_Button.tag=90001;
    
    
    
    
    
    
    
    
    //年龄 标题
    nianLing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(xingMing_Field.frame)+20, 44+Title_text_font, Title_text_font) Font:Title_text_font Text:@"3. 年龄"];
    [RootScrollView addSubview:nianLing_Label];
    nianLing_Label.textColor=Title_text_color;
    
    
    //年龄 签字框
    nianLing_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(nianLing_Label.frame)+Title_Field_WH, CGRectGetMinY(nianLing_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-nianLing_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil  rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    nianLing_Field.textColor=Field_text_color;
    [RootScrollView addSubview:nianLing_Field];
    nianLing_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_pingGuJBModel.nianLing]) {
        nianLing_Field.text=_pingGuJBModel.nianLing;
    }
    
    //年龄 介绍
    nianLing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(nianLing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:nianLing_Button];
    nianLing_Button.tag=90002;
    
    
    
    
    
    
    
    
    
    //联系电话 标题
    lianXiDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(nianLing_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"4. 联系电话"];
    [RootScrollView addSubview:lianXiDH_Label];
    lianXiDH_Label.textColor=Title_text_color;
    
    
    //联系电话 签字框
    lianXiDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(lianXiDH_Label.frame)+Title_Field_WH, CGRectGetMinY(lianXiDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-lianXiDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil  rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    lianXiDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:lianXiDH_Field];
    lianXiDH_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_pingGuJBModel.lianXiDH]) {
        lianXiDH_Field.text=_pingGuJBModel.lianXiDH;
    }
    
    //联系电话 介绍
    lianXiDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(lianXiDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:lianXiDH_Button];
    lianXiDH_Button.tag=90003;
    
    
    
    
    
    //与老人关系
    yuLaoRG_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(lianXiDH_Field.frame)+20, WIDTH, 24*(yuLaoRG_Title_Array.count+1))];
    [RootScrollView addSubview:yuLaoRG_View];
    
    //与老人关系 标题
    UILabel * yuLaoRG_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"5. 与老人关系"];
    [yuLaoRG_View addSubview:yuLaoRG_Label];
    yuLaoRG_Label.textColor=Title_text_color;
    
    //与老人关系 介绍
    UIButton * yuLaoRG_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yuLaoRG_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [yuLaoRG_View addSubview:yuLaoRG_Button];
    yuLaoRG_Button.tag=90004;
    
    //起始高度
    float yuLaoRG_View_frame_origin_y=CGRectGetMaxY(yuLaoRG_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<yuLaoRG_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"yuLaoRG"];
        [yuLaoRG_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, yuLaoRG_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=4000+i;
        
        if (![PublicFunction isBlankString:_pingGuJBModel.yuLaoRG]) {
            if ([_pingGuJBModel.yuLaoRG intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [yuLaoRG_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=yuLaoRG_Title_Array[i];
    
        yuLaoRG_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    yuLaoRG_View.frame = CGRectMake(0, CGRectGetMaxY(lianXiDH_Field.frame)+20, WIDTH, yuLaoRG_View_frame_origin_y);
    
    
    
    
    
    
    //评估原因  标题数组
    pingGuYY_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(yuLaoRG_View.frame)+20, WIDTH, 24*(pingGuYY_Title_Array.count+1))];
    [RootScrollView addSubview:pingGuYY_View];
    
    //评估原因 标题
    UILabel * pingGuYY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"6. 评估原因"];
    [pingGuYY_View addSubview:pingGuYY_Label];
    pingGuYY_Label.textColor=Title_text_color;
    
    //评估原因 介绍
    UIButton * pingGuYY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(pingGuYY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [pingGuYY_View addSubview:pingGuYY_Button];
    pingGuYY_Button.tag=90005;
    
    //起始高度
    float pingGuYY_View_frame_origin_y=CGRectGetMaxY(pingGuYY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<pingGuYY_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"pingGuYY"];
        [pingGuYY_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, pingGuYY_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=5000+i;
        
        if (![PublicFunction isBlankString:_pingGuJBModel.pingGuYY]) {
            if ([[_pingGuJBModel.pingGuYY substringToIndex:1] isEqualToString:@"X"]) {
                if (i==pingGuYY_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_pingGuJBModel.pingGuYY intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [pingGuYY_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=pingGuYY_Title_Array[i];
        
        pingGuYY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    pingGuYY_View.frame = CGRectMake(0, CGRectGetMaxY(yuLaoRG_View.frame)+20, WIDTH, pingGuYY_View_frame_origin_y);
    
    
    
    //评估原因 其他 签字框
    pingGuYYQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(pingGuYY_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    pingGuYYQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:pingGuYYQT_Field];
    pingGuYYQT_Field.delegate=self;
    pingGuYYQT_Field.userInteractionEnabled=NO;
    
    
    if (![PublicFunction isBlankString:_pingGuJBModel.pingGuYY]) {
        if ([[_pingGuJBModel.pingGuYY substringToIndex:1] isEqualToString:@"X"]) {
            pingGuYYQT_Field.userInteractionEnabled=YES;
            pingGuYYQT_Field.text=[_pingGuJBModel.pingGuYY substringFromIndex:1];
        }
    }
    
    
    
    
    //筛查 标题数组
    saiCha_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(pingGuYYQT_Field.frame)+20, WIDTH, 24*(saiCha_Title_Array.count+1))];
    [RootScrollView addSubview:saiCha_View];
    
    //筛查 标题
    UILabel * saiCha_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"7. 免评估筛查"];
    [saiCha_View addSubview:saiCha_Label];
    saiCha_Label.textColor=Title_text_color;
    
    //筛查 介绍
    UIButton * saiCha_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(saiCha_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [saiCha_View addSubview:saiCha_Button];
    saiCha_Button.tag=90006;
    
    //起始高度
    float saiCha_View_View_frame_origin_y=CGRectGetMaxY(pingGuYY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<saiCha_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"saiCha"];
        [saiCha_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, saiCha_View_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=6000+i;
        
        if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
            if ([[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
                if (i==saiCha_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_pingGuJBModel.saiCha intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [saiCha_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=saiCha_Title_Array[i];
        
        saiCha_View_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    saiCha_View.frame = CGRectMake(0, CGRectGetMaxY(pingGuYYQT_Field.frame)+20, WIDTH, saiCha_View_View_frame_origin_y);
    
    
    
    //评估原因 其他 签字框
    saiChaQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(saiCha_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    saiChaQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:saiChaQT_Field];
    saiChaQT_Field.delegate=self;
    saiChaQT_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
        if ([[_pingGuJBModel.saiCha substringToIndex:1] isEqualToString:@"X"]) {
            saiChaQT_Field.userInteractionEnabled=YES;
            saiChaQT_Field.text=[_pingGuJBModel.saiCha substringFromIndex:1];
        }
    }
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(saiChaQT_Field.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.assessment intValue]==0 || [self.assessment intValue]==1 || [self.assessment intValue]==5 || [self.assessment intValue]==6) {

            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(saiChaQT_Field.frame)+20+Tabbar_HE);
        }
    }
    
    
}



#pragma mark 移除控件
-(void)remove_All_View
{
    [xingMing_Label removeFromSuperview];//姓名
    
    [xingMing_Field removeFromSuperview];//姓名
    
    [xingMing_Button removeFromSuperview];//姓名
    
    
    [nianLing_Label removeFromSuperview];//年龄
    
    [nianLing_Field removeFromSuperview];//年龄
    
    [nianLing_Button removeFromSuperview];//年龄
    
    
    [lianXiDH_Label removeFromSuperview];//联系电话
    
    [lianXiDH_Field removeFromSuperview];//联系电话
    
    [lianXiDH_Button removeFromSuperview];//联系电话
    
    
    
    [yuLaoRG_View removeFromSuperview];//与老人关系
    
    
    
    [pingGuYY_View removeFromSuperview];//评估原因
    
    
    
    [pingGuYYQT_Field removeFromSuperview];//评估原因 其他
    
    
    
    [saiCha_View removeFromSuperview];//筛查
    


    
    [saiChaQT_Field removeFromSuperview];//筛查 其他
}





#pragma mark - 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：被评估者即申请人（受访老人），即“本人”；在申请人无法正常沟通（如失能等）的情况下，信息提供者可以是当时在场的其他人，即“非本人”。\n\n记录：如果信息提供者为被评估者本人，则无需填写信息提供的其他信息。如果是“非本人”，则需要完成其相关信息。\n\n定义：本人：被评估者即申请人（受访老人），即“本人”。\n\n非本人：在申请人无法正常沟通（如失能等）的情况下，信息提供者可以是当时在场的其他人，即“非本人”。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"如信息提供者选项为非评估者本人，该项为必填项。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"如信息提供者选项为非评估者本人，该项为必填项。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"如信息提供者选项为非评估者本人，该项为必填项。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"如信息提供者选项为非评估者本人，该项为必填项。\n\n定义：亲属指的是非老人配偶或子女的其他亲属。非亲属是指邻居、朋友、同事、社工、照护者等。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：评估原因一般会在评估发起时确定，评估人员可在现场再次与申请人进行确认。\n\n记录：评估人员与申请人/代理人现场确认后选择对应的答案。\n\n定义：\n初次评估：申请人以前从来没有使用《北京市养老服务需求评估表》进行过评估，本次是第一次进行该评估。\n\n跟进评估：申请人之前已经进行过评估，因为需要补充信息或计划服务等原因，安排本次评估，作为跟进。\n\n退出服务项目前30天内评估：申请人已经在使用相关养老服务，但因为主观或客观原因不再使用该服务项目，在退出服务项目30天内安排本次评估。\n\n住院后返回评估：老年人的各项情况在住院后一般会发生各种变化，为了服务始终贴合老人需求，每次发生住院，出院返回家中都会安排的复评。\n\n状况改变：申请人或照护者如果注意到老人的健康或其他状况发生改变，特别是相关改变对服务需求可能产生影响，会发起复评，即“状况改变”的评估。"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"凡经申请人提交证据并经合格评估人员家访确认，申请人属于政府规定的困难人群，并符合下列条件之一，则该申请人原则上无需再进行除必要信息采集和确认之外的系统性评估，直接进入服务计划。\n\n方法：通过现场观察并依据相关证明文件确认。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {

    if ([groupId isEqualToString:@"pingGuZ"]) {
        
        if ([my_pingGuZ intValue]!=radio.tag-3000) {
            //NSLog(@"my_pingGuZ:%@ tag:%ld",my_pingGuZ,radio.tag-3000);
            if (radio.tag-3000==0) {
                [self remove_All_View];
                [self create_PingGuJB_view];
            } else if (radio.tag-3000==1) {
                [self remove_All_View];
                [self create_PingGuJB_Fei_view];
            }
        }

        my_pingGuZ=[NSString stringWithFormat:@"%ld",radio.tag-3000];
    }
    
    if ([groupId isEqualToString:@"yuLaoRG"]) {
        my_yuLaoRG=[NSString stringWithFormat:@"%ld",radio.tag-4000];
    }
    
    if ([groupId isEqualToString:@"pingGuYY"]) {
        if (radio.tag-5000==pingGuYY_Title_Array.count-1) {
            pingGuYYQT_Field.userInteractionEnabled=YES;
        } else {
            pingGuYYQT_Field.userInteractionEnabled=NO;
            pingGuYYQT_Field.text=@"";
        }
        my_pingGuYY=[NSString stringWithFormat:@"%ld",radio.tag-5000];
    }
    
    if ([groupId isEqualToString:@"saiCha"]) {
        if (radio.tag-6000==saiCha_Title_Array.count-1) {
            saiChaQT_Field.userInteractionEnabled=YES;
        } else {
            saiChaQT_Field.userInteractionEnabled=NO;
            saiChaQT_Field.text=@"";
        }
        my_saiCha=[NSString stringWithFormat:@"%ld",radio.tag-6000];
    }
    

}



#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_pingGuZ]) {
#pragma mark - 评估提供者
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“评估提供者”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([my_pingGuZ intValue]==0) {
        
        //更新 评估基本信息
        [self update_PingGuJB];
    } else if ([my_pingGuZ intValue]==1) {
        
        if ([PublicFunction isBlankString:xingMing_Field.text]) {
#pragma mark - 姓名
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“姓名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }else if ([PublicFunction isBlankString:nianLing_Field.text]) {
#pragma mark - 年龄
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“年龄”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }else if ([nianLing_Field.text intValue]<=0 || [nianLing_Field.text intValue]>150) {
#pragma mark - 年龄
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“年龄”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }else if (![PublicFunction validateMobile:lianXiDH_Field.text]) {
#pragma mark - 联系电话
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“联系电话号码”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }else if ([PublicFunction isBlankString:my_yuLaoRG]) {
#pragma mark - 与老人关系
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“与老人关系”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        } else {
            
            //更新 评估基本信息
            [self update_PingGuJB];
        }
    }
    
}




//更新 评估基本信息
-(void)update_PingGuJB
{
    if ([PublicFunction isBlankString:my_pingGuYY]) {
#pragma mark - 评估原因
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“评估原因”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([my_pingGuYY intValue]==pingGuYY_Title_Array.count-1 && [PublicFunction isBlankString:pingGuYYQT_Field.text]) {
#pragma mark - 评估原因 其他
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“评估原因的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_saiCha]) {
#pragma mark - 筛查
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“筛查”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([my_saiCha intValue]==saiCha_Title_Array.count-1 && [PublicFunction isBlankString:saiChaQT_Field.text]) {
#pragma mark - 筛查 其他
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“筛查的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
        
        [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
        
        [parameter setObject:@"10" forKey:@"tableFlag"];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
        
        if (![PublicFunction isBlankString:my_pingGuZ]) {
            [parameter setObject:my_pingGuZ forKey:@"pingGuZ"];
        }
        
        if (![PublicFunction isBlankString:xingMing_Field.text]) {
            [parameter setObject:xingMing_Field.text forKey:@"xingMing"];
        }
        
        if (![PublicFunction isBlankString:nianLing_Field.text]) {
            [parameter setObject:nianLing_Field.text forKey:@"nianLing"];
        }
        
        if (![PublicFunction isBlankString:lianXiDH_Field.text]) {
            [parameter setObject:lianXiDH_Field.text forKey:@"lianXiDH"];
        }
        
        if (![PublicFunction isBlankString:my_yuLaoRG]) {
            [parameter setObject:my_yuLaoRG forKey:@"yuLaoRG"];
        }
        
        
        
        if (![PublicFunction isBlankString:my_pingGuYY]) {
            if ([my_pingGuYY integerValue]==pingGuYY_Title_Array.count-1) {
                [parameter setObject:[NSString stringWithFormat:@"X%@",pingGuYYQT_Field.text] forKey:@"pingGuYY"];
            } else {
                [parameter setObject:my_pingGuYY forKey:@"pingGuYY"];
            }
        }
        
        if (![PublicFunction isBlankString:my_saiCha]) {
            if ([my_saiCha integerValue]==saiCha_Title_Array.count-1) {
                [parameter setObject:[NSString stringWithFormat:@"X%@",saiChaQT_Field.text] forKey:@"saiCha"];
            } else {
                [parameter setObject:my_saiCha forKey:@"saiCha"];
            }
        }
        
        
        
        
        [KVNProgress show];
        
        
        
        //发送请求
        [NetRequestClass NetRequestLoginRegWithRequestURL:insertResultHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
            
            //NSLog(@"%@",returnValue);
            
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
            NSLog(@"%@",errorCode);
        } WithFailureBlock:^{
            [KVNProgress dismiss];
        }];
    }
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

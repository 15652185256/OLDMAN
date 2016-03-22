//
//  JianHuRenXXViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "JianHuRenXXViewController.h"
#import "JianHuRenXXModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

#import "ZHPickView.h"//选择器

@interface JianHuRenXXViewController ()<UITextFieldDelegate,UIScrollViewDelegate,ZHPickViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    UITextField * jianHuRX_Field;//监护人 姓名
    
    
    
    NSArray * yuLaoRG_Title_Array;//与老人关系
    
    NSString * yuLaoRG;//与老人关系
    
    
    
    NSMutableDictionary * Sheng_code_dict;// 省 编号
    
    NSMutableDictionary * Sheng_name_dict;//省 名称
    
    NSMutableArray * Sheng_name_array;//省 名称
    
    
    
    UITextField * juZhuSheng_Field;//居住 省 30
    
    UILabel * my_juZhuSheng_Label;//居住 省
    
    
    
    UITextField * juZhuShi_Field;//居住 市 31
    
    UILabel * my_juZhuShi_Label;//居住 市
    
    NSMutableDictionary * juZhuShi_code_dict;//居住 市
    
    NSMutableDictionary * juZhuShi_name_dict;//居住 市
    
    NSMutableArray * juZhuShi_name_array;//居住 市
    
    
    
    UITextField * juZhuQu_Field;//居住 区 32
    
    UILabel * my_juZhuQu_Label;//居住 区
    
    NSMutableDictionary * juZhuQu_code_dict;//居住 区
    
    NSMutableDictionary * juZhuQu_name_dict;//居住 区
    
    NSMutableArray * juZhuQu_name_array;//居住 区
    
    
    
    
    UITextField * juZhuJie_Field;//居住 街道 33
    
    UILabel * my_juZhuJie_Label;//居住 街道
    
    NSMutableDictionary * juZhuJie_code_dict;//居住 街道
    
    NSMutableDictionary * juZhuJie_name_dict;//居住 街道
    
    NSMutableArray * juZhuJie_name_array;//居住 街道
    
    
    
    
    UITextField * juZhuSheQu_Field;//居住 社区 34
    
    UILabel * my_juZhuSheQu_Label;//居住 社区
    
    NSMutableDictionary * juZhuSheQu_code_dict;//居住 社区
    
    NSMutableDictionary * juZhuSheQu_name_dict;//居住 社区
    
    NSMutableArray * juZhuSheQu_name_array;//居住 社区
    
    
    UITextField * juZhuAddress_Field;//居住 地址
    
    
    
    
    UITextField * zhuZhaiDH_Field;//居住电话
    
    UITextField * yiDongDH_Field;//移动电话
    
    UITextField * youZhengBM_Field;//邮政编码
    
    UITextField * dianZiYX_Field;//电子邮箱
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    
    ZHPickView * _pickview;//选择器
    
    JianHuRenXXModel * _jianHuRenXXModel;//数据源
}
@end

@implementation JianHuRenXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //居住 省
    Sheng_code_dict=[[NSMutableDictionary alloc]init];
    Sheng_name_dict=[[NSMutableDictionary alloc]init];
    Sheng_name_array=[[NSMutableArray alloc]init];
    //居住 市
    juZhuShi_code_dict=[[NSMutableDictionary alloc]init];
    juZhuShi_name_dict=[[NSMutableDictionary alloc]init];
    juZhuShi_name_array=[[NSMutableArray alloc]init];
    //居住 区
    juZhuQu_code_dict=[[NSMutableDictionary alloc]init];
    juZhuQu_name_dict=[[NSMutableDictionary alloc]init];
    juZhuQu_name_array=[[NSMutableArray alloc]init];
    //居住 街道
    juZhuJie_code_dict=[[NSMutableDictionary alloc]init];
    juZhuJie_name_dict=[[NSMutableDictionary alloc]init];
    juZhuJie_name_array=[[NSMutableArray alloc]init];
    //居住 社区
    juZhuSheQu_code_dict=[[NSMutableDictionary alloc]init];
    juZhuSheQu_name_dict=[[NSMutableDictionary alloc]init];
    juZhuSheQu_name_array=[[NSMutableArray alloc]init];
    
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
    
    //获取地址 省
    [self getShengArea];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _jianHuRenXXModel=[[JianHuRenXXModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _jianHuRenXXModel=nil;
    
    [juZhuShi_code_dict removeAllObjects];
    [juZhuShi_name_dict removeAllObjects];
    [juZhuShi_name_array removeAllObjects];
    
    [juZhuQu_code_dict removeAllObjects];
    [juZhuQu_name_dict removeAllObjects];
    [juZhuQu_name_array removeAllObjects];
    
    [juZhuJie_code_dict removeAllObjects];
    [juZhuJie_name_dict removeAllObjects];
    [juZhuJie_name_array removeAllObjects];
    
    [juZhuSheQu_code_dict removeAllObjects];
    [juZhuSheQu_name_dict removeAllObjects];
    [juZhuSheQu_name_array removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //与老人关系
    yuLaoRG_Title_Array=@[@"配偶",@"子女",@"亲属",@"非亲属"];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"3"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_jianHuRenXXModel setValuesForKeysWithDictionary:returnValue[@"data"]];
                
                
                //获取 居住 省
                if (![PublicFunction isBlankString:_jianHuRenXXModel.juZhuSheng]) {
                    [self getAreaByCurrentCode:_jianHuRenXXModel.juZhuSheng type:30];
                }
                //获取 居住 市
                if (![PublicFunction isBlankString:_jianHuRenXXModel.juZhuShi]) {
                    [self getAreaByCurrentCode:_jianHuRenXXModel.juZhuShi type:31];
                }
                //获取 居住 区
                if (![PublicFunction isBlankString:_jianHuRenXXModel.juZhuQu]) {
                    [self getAreaByCurrentCode:_jianHuRenXXModel.juZhuQu type:32];
                }
                //获取 居住 街道
                if (![PublicFunction isBlankString:_jianHuRenXXModel.juZhuJie]) {
                    [self getAreaByCurrentCode:_jianHuRenXXModel.juZhuJie type:33];
                }
                //获取 居住 社区
                if (![PublicFunction isBlankString:_jianHuRenXXModel.juZhuSheQu]) {
                    [self getAreaByCurrentCode:_jianHuRenXXModel.juZhuSheQu type:34];
                }
            }
            
            //设置页面
            [self createView];
            
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



#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航背景图
    self.navigationController.navigationBar.barTintColor = Nav_Tabbar_backgroundColor;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"监护人信息";
    
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
    

    
    //姓名 标题
    UILabel * jianHuRX_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 30, 44+Title_text_font, Title_text_font) Font:Title_text_font Text:@"1. 姓名"];
    [RootScrollView addSubview:jianHuRX_Label];
    jianHuRX_Label.textColor=Title_text_color;
    
    //姓名 签字框
    jianHuRX_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(jianHuRX_Label.frame)+Title_Field_WH, CGRectGetMinY(jianHuRX_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-jianHuRX_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    jianHuRX_Field.textColor=Field_text_color;
    [RootScrollView addSubview:jianHuRX_Field];
    jianHuRX_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_jianHuRenXXModel.jianHuRX]) {
        jianHuRX_Field.text=_jianHuRenXXModel.jianHuRX;
    }
    
    //姓名 介绍
    UIButton * jianHuRX_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(jianHuRX_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:jianHuRX_Button];
    jianHuRX_Button.tag=90000;
    
    
    
    
    
    //与老人关系
    UIView * yuLaoRG_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(jianHuRX_Field.frame)+20, WIDTH, 24*(yuLaoRG_Title_Array.count+1))];
    [RootScrollView addSubview:yuLaoRG_View];
    
    //与老人关系 标题
    UILabel * yuLaoRG_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0,  WIDTH-60, Title_text_font) Font:Title_text_font Text:@"2. 与老人关系"];
    [yuLaoRG_View addSubview:yuLaoRG_Label];
    yuLaoRG_Label.textColor=Title_text_color;
    
    //与老人关系 介绍
    UIButton * yuLaoRG_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yuLaoRG_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [yuLaoRG_View addSubview:yuLaoRG_Button];
    yuLaoRG_Button.tag=90001;
    
    //起始高度
    float yuLaoRG_View_frame_origin_y=CGRectGetMaxY(yuLaoRG_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<yuLaoRG_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"yuLaoRG"];
        [yuLaoRG_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, yuLaoRG_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=3000+i;
        
        if (![PublicFunction isBlankString:_jianHuRenXXModel.yuLaoRG]) {
            if ([_jianHuRenXXModel.yuLaoRG intValue]==i) {
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
    
    yuLaoRG_View.frame = CGRectMake(0, CGRectGetMaxY(jianHuRX_Field.frame)+20, WIDTH, yuLaoRG_View_frame_origin_y);
    
    
    
#pragma mark 居住
    
    
    
    //居住 省
    UILabel * juZhuSheng_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(yuLaoRG_View.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"3. 居住(省)"];
    [RootScrollView addSubview:juZhuSheng_Label];
    juZhuSheng_Label.textColor=Title_text_color;
    
    //居住 省 签字框
    juZhuSheng_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuSheng_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuSheng_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuSheng_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juZhuSheng_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juZhuSheng_Field];
    juZhuSheng_Field.delegate=self;
    juZhuSheng_Field.userInteractionEnabled=NO;
    
    //居住 省
    my_juZhuSheng_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(juZhuSheng_Label.frame)+8+Title_Field_WH, CGRectGetMinY(juZhuSheng_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuSheng_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_juZhuSheng_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_juZhuSheng_Label];
    my_juZhuSheng_Label.userInteractionEnabled=YES;
    my_juZhuSheng_Label.tag=30000;
    
    //居住 省 触发事件
    UITapGestureRecognizer * tap_huJiSheng = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_juZhuSheng_Label addGestureRecognizer:tap_huJiSheng];
    
    //居住 介绍
    UIButton * juZhuAddress_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(juZhuSheng_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:juZhuAddress_Button];
    juZhuAddress_Button.tag=90002;
    
    
    
    
    //居住 市
    UILabel * juZhuShi_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuSheng_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"居住(市)"];
    [RootScrollView addSubview:juZhuShi_Label];
    juZhuShi_Label.textColor=Title_text_color;
    
    //居住 市 签字框
    juZhuShi_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuShi_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuShi_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuShi_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juZhuShi_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juZhuShi_Field];
    juZhuShi_Field.delegate=self;
    juZhuShi_Field.userInteractionEnabled=NO;
    
    //居住 市
    my_juZhuShi_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(juZhuShi_Label.frame)+8+Title_Field_WH, CGRectGetMinY(juZhuShi_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuShi_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_juZhuShi_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_juZhuShi_Label];
    my_juZhuShi_Label.userInteractionEnabled=YES;
    my_juZhuShi_Label.tag=31000;
    
    //居住 市 触发事件
    UITapGestureRecognizer * tap_huJiShi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_juZhuShi_Label addGestureRecognizer:tap_huJiShi];
    
    
    
    //居住 区县
    UILabel * juZhuQu_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuShi_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"居住(区县)"];
    [RootScrollView addSubview:juZhuQu_Label];
    juZhuQu_Label.textColor=Title_text_color;
    
    //居住 区县 签字框
    juZhuQu_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuQu_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuQu_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juZhuQu_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juZhuQu_Field];
    juZhuQu_Field.delegate=self;
    juZhuQu_Field.userInteractionEnabled=NO;
    
    //居住 区县
    my_juZhuQu_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(juZhuQu_Label.frame)+8+Title_Field_WH, CGRectGetMinY(juZhuQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuQu_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_juZhuQu_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_juZhuQu_Label];
    my_juZhuQu_Label.userInteractionEnabled=YES;
    my_juZhuQu_Label.tag=32000;
    
    //居住 区县 触发事件
    UITapGestureRecognizer * tap_huJiQu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_juZhuQu_Label addGestureRecognizer:tap_huJiQu];
    
    
    
    
    
    //居住 街道
    UILabel * juZhuJie_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuQu_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"居住(街道)"];
    [RootScrollView addSubview:juZhuJie_Label];
    juZhuJie_Label.textColor=Title_text_color;
    
    //居住 街道 签字框
    juZhuJie_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuJie_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuJie_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuJie_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:juZhuJie_Field];
    juZhuJie_Field.delegate=self;
    juZhuJie_Field.userInteractionEnabled=NO;
    
    //居住 街道
    my_juZhuJie_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(juZhuJie_Label.frame)+8+Title_Field_WH, CGRectGetMinY(juZhuJie_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuJie_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_juZhuJie_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_juZhuJie_Label];
    my_juZhuJie_Label.userInteractionEnabled=YES;
    my_juZhuJie_Label.tag=33000;
    
    //居住 街道 触发事件
    UITapGestureRecognizer * tap_juZhuJie = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_juZhuJie_Label addGestureRecognizer:tap_juZhuJie];
    
    
    
    
    
    
    //居住 社区
    UILabel * juZhuSheQu_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuJie_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"居住(社区)"];
    [RootScrollView addSubview:juZhuSheQu_Label];
    juZhuSheQu_Label.textColor=Title_text_color;
    
    //居住 社区 签字框
    juZhuSheQu_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuSheQu_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuSheQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuSheQu_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:juZhuSheQu_Field];
    juZhuSheQu_Field.delegate=self;
    juZhuSheQu_Field.userInteractionEnabled=NO;
    
    //居住 社区
    my_juZhuSheQu_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(juZhuSheQu_Label.frame)+8+Title_Field_WH, CGRectGetMinY(juZhuSheQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuSheQu_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_juZhuSheQu_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_juZhuSheQu_Label];
    my_juZhuSheQu_Label.userInteractionEnabled=YES;
    my_juZhuSheQu_Label.tag=34000;
    
    //居住 社区 触发事件
    UITapGestureRecognizer * tap_juZhuSheQu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_juZhuSheQu_Label addGestureRecognizer:tap_juZhuSheQu];
    
    
    
    //居住 详细
    UILabel * juZhuAddress_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuSheQu_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"居住(详细)"];
    [RootScrollView addSubview:juZhuAddress_Label];
    juZhuAddress_Label.textColor=Title_text_color;
    
    //居住 详细 签字框
    juZhuAddress_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuAddress_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuAddress_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuAddress_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juZhuAddress_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juZhuAddress_Field];
    juZhuAddress_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_jianHuRenXXModel.juZhuAddress]) {
        juZhuAddress_Field.text=_jianHuRenXXModel.juZhuAddress;
    }
    
    
#pragma mark 电话
    
    
    //地址 居住电话 标题
    UILabel * zhuZhaiDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuAddress_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"4. 住宅电话"];
    [RootScrollView addSubview:zhuZhaiDH_Label];
    zhuZhaiDH_Label.textColor=Title_text_color;
    
    //地址 居住电话 签字框
    zhuZhaiDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(zhuZhaiDH_Label.frame)+Title_Field_WH, CGRectGetMinY(zhuZhaiDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-zhuZhaiDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    zhuZhaiDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:zhuZhaiDH_Field];
    zhuZhaiDH_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_jianHuRenXXModel.zhuZhaiDH]) {
        zhuZhaiDH_Field.text=_jianHuRenXXModel.zhuZhaiDH;
    }
    
    //居住电话 介绍
    UIButton * zhuZhaiDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(zhuZhaiDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:zhuZhaiDH_Button];
    zhuZhaiDH_Button.tag=90003;
    
    
    
    
    //地址 移动电话 标题
    UILabel * yiDongDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(zhuZhaiDH_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"5. 移动电话"];
    [RootScrollView addSubview:yiDongDH_Label];
    yiDongDH_Label.textColor=Title_text_color;
    
    //地址 移动电话 签字框
    yiDongDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(yiDongDH_Label.frame)+Title_Field_WH, CGRectGetMinY(yiDongDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-yiDongDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    yiDongDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:yiDongDH_Field];
    yiDongDH_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_jianHuRenXXModel.yiDongDH]) {
        yiDongDH_Field.text=_jianHuRenXXModel.yiDongDH;
    }
    
    //移动电话 介绍
    UIButton * yiDongDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yiDongDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:yiDongDH_Button];
    yiDongDH_Button.tag=90004;
    
    
    
    
    //地址 邮政编码 标题
    UILabel * youZhengBM_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(yiDongDH_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"6. 邮政编码"];
    [RootScrollView addSubview:youZhengBM_Label];
    youZhengBM_Label.textColor=Title_text_color;
    
    //地址 邮政编码 签字框
    youZhengBM_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(youZhengBM_Label.frame)+Title_Field_WH, CGRectGetMinY(youZhengBM_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-youZhengBM_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    youZhengBM_Field.textColor=Field_text_color;
    [RootScrollView addSubview:youZhengBM_Field];
    youZhengBM_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_jianHuRenXXModel.youZhengBM]) {
        youZhengBM_Field.text=_jianHuRenXXModel.youZhengBM;
    }
    
    //邮政编码 介绍
    UIButton * youZhengBM_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(youZhengBM_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:youZhengBM_Button];
    youZhengBM_Button.tag=90005;
    
    
    
    
    //地址 电子邮箱 标题
    UILabel * dianZiYX_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(youZhengBM_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"7. 电子邮箱"];
    [RootScrollView addSubview:dianZiYX_Label];
    dianZiYX_Label.textColor=Title_text_color;
    
    //地址 电子邮箱 签字框
    dianZiYX_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(dianZiYX_Label.frame)+Title_Field_WH, CGRectGetMinY(dianZiYX_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-dianZiYX_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    dianZiYX_Field.textColor=Field_text_color;
    [RootScrollView addSubview:dianZiYX_Field];
    dianZiYX_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_jianHuRenXXModel.dianZiYX]) {
        dianZiYX_Field.text=_jianHuRenXXModel.dianZiYX;
    }
    
    //电子邮箱 介绍
    UIButton * dianZiYX_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(dianZiYX_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:dianZiYX_Button];
    dianZiYX_Button.tag=90006;
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(dianZiYX_Field.frame)+20);
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
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(dianZiYX_Field.frame)+20+Tabbar_HE);
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



#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    //与老人关系
    if ([groupId isEqualToString:@"yuLaoRG"]) {
        yuLaoRG=[NSString stringWithFormat:@"%ld",radio.tag-3000];
    }
}


#pragma mark - 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：亲属指的是非老人配偶或子女的其他亲属。非亲属是指邻居、朋友、同事、社工、照护者等。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须向被访者询问其监护人的真实住宅电话，如实填写，无需填写区号，直接填写电话号码为7或8位数字。填写后须向被访者进行确认，确保填写准确无误。住宅和移动电话至少填写一项。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须向被访者询问其监护人的真实移动电话，如实填写，直接填写11位数字号码。填写后须向被访者进行确认，确保填写准确无误。住宅和移动电话至少填写一项。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：如有监护人则为必填项，须按被访者监护人现住址如实填写。填写后须向被访者进行确认，确保填写准确无误。"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须向被访者监护人询问其最常用电子邮箱，如实填写。填写后须向被访者监护人进行确认，确保填写准确无误。如没有可以不用填写。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
    
}







#pragma mark 地区 点击事件
-(void)tap_diQu_GestureAction:(UITapGestureRecognizer*)tap
{
    NSInteger tag=tap.view.tag;
    
    switch (tag/1000) {
            
            //居住
        case 30:
            [self showPickview:tag];
            break;
        case 31:
            if (![PublicFunction isBlankString:[Sheng_code_dict objectForKey:my_juZhuSheng_Label.text]]) {
                [self getArea:[Sheng_code_dict objectForKey:my_juZhuSheng_Label.text] type:31];
            }
            break;
        case 32:
            if (![PublicFunction isBlankString:[juZhuShi_code_dict objectForKey:my_juZhuShi_Label.text]]) {
                [self getArea:[juZhuShi_code_dict objectForKey:my_juZhuShi_Label.text] type:32];
            }
            break;
        case 33:
            if (![PublicFunction isBlankString:[juZhuQu_code_dict objectForKey:my_juZhuQu_Label.text]]) {
                [self getArea:[juZhuQu_code_dict objectForKey:my_juZhuQu_Label.text] type:33];
            }
            break;
        case 34:
            if (![PublicFunction isBlankString:[juZhuJie_code_dict objectForKey:my_juZhuJie_Label.text]]) {
                [self getArea:[juZhuJie_code_dict objectForKey:my_juZhuJie_Label.text] type:34];
            }
            break;
            
        default:
            break;
    }
}




#pragma mark 弹出 选择器
-(void)showPickview:(NSInteger)tag
{
    [_pickview remove];
    
    NSArray * keys_array;
    
    switch (tag/1000) {
            
        case 30:
            if (Sheng_name_array.count!=0) {
                keys_array=Sheng_name_array;
            }
            break;
        case 31:
            if (juZhuShi_name_array.count!=0) {
                keys_array=juZhuShi_name_array;
            }
            break;
        case 32:
            if (juZhuQu_name_array.count!=0) {
                keys_array=juZhuQu_name_array;
            }
            break;
        case 33:
            if (juZhuJie_name_array.count!=0) {
                keys_array=juZhuJie_name_array;
            }
            break;
        case 34:
            if (juZhuSheQu_name_array.count!=0) {
                keys_array=juZhuSheQu_name_array;
            }
            break;
            
            
        default:
            break;
    }
    
    if (keys_array.count!=0) {
        
        _pickview=[[ZHPickView alloc] initPickviewWithArray:keys_array isHaveNavControler:NO];
        
        _pickview.tag=tag;
        
        _pickview.delegate=self;
        
        [_pickview show];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_pickview remove];
}


#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    switch (pickView.tag/1000) {
            
        case 30:
        {
            //省改变
            if (![my_juZhuSheng_Label.text isEqualToString:resultString]) {
                //对应清空
                my_juZhuShi_Label.text=@"";
                my_juZhuQu_Label.text=@"";
                my_juZhuJie_Label.text=@"";
                my_juZhuSheQu_Label.text=@"";
            }
            my_juZhuSheng_Label.text = resultString;
        }
            break;
        case 31:
        {
            //市改变
            if (![my_juZhuShi_Label.text isEqualToString:resultString]) {
                //对应清空
                my_juZhuQu_Label.text=@"";
                my_juZhuJie_Label.text=@"";
                my_juZhuSheQu_Label.text=@"";
            }
            my_juZhuShi_Label.text = resultString;
        }
            break;
        case 32:
        {
            //区县改变
            if (![my_juZhuQu_Label.text isEqualToString:resultString]) {
                //对应清空
                my_juZhuJie_Label.text=@"";
                my_juZhuSheQu_Label.text=@"";
            }
            my_juZhuQu_Label.text = resultString;
        }
            break;
        case 33:
        {
            //街改变
            if (![my_juZhuJie_Label.text isEqualToString:resultString]) {
                //对应清空
                my_juZhuSheQu_Label.text=@"";
            }
            my_juZhuJie_Label.text = resultString;
        }
            break;
        case 34:
            my_juZhuSheQu_Label.text = resultString;
            break;
            
            
        default:
            break;
    }
    
}



#pragma mark 获取 省 地址信息
-(void)getShengArea
{
    //省
    [Sheng_code_dict removeAllObjects];
    [Sheng_name_dict removeAllObjects];
    [Sheng_name_array removeAllObjects];
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:@"" forKey:@"code"];
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:getAreaHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                
                NSArray * data=returnValue[@"data"];
                
                for (NSDictionary * dict in data) {
                    NSString * code=[dict objectForKey:@"code"];
                    NSString * name=[dict objectForKey:@"name"];
                    
                    [Sheng_code_dict setValue:code forKey:name];
                    [Sheng_name_dict setValue:name forKey:code];
                    
                    [Sheng_name_array addObject:name];
                }
            }
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    
}

#pragma mark 进入页面  获取 对应 地址信息
-(void)getAreaByCurrentCode:(NSString*)code type:(int)type
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:code forKey:@"code"];
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:getAreaByCurrentCodeHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                
                NSArray * data=returnValue[@"data"];
                
                if (data.count!=0) {
                    
                    switch (type) {
                            
                        case 30:
                            //居住 省
                            my_juZhuSheng_Label.text=[data[0] objectForKey:@"name"];
                            break;
                        case 31:
                        {
                            //居住 市
                            [juZhuShi_code_dict removeAllObjects];
                            [juZhuShi_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [juZhuShi_code_dict setValue:code forKey:name];
                            [juZhuShi_name_dict setValue:name forKey:code];
                            
                            my_juZhuShi_Label.text=name;
                        }
                            break;
                        case 32:
                        {
                            //居住 区县
                            [juZhuQu_code_dict removeAllObjects];
                            [juZhuQu_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [juZhuQu_code_dict setValue:code forKey:name];
                            [juZhuQu_name_dict setValue:name forKey:code];
                            
                            my_juZhuQu_Label.text=name;
                        }
                            break;
                        case 33:
                        {
                            //居住 街道
                            [juZhuJie_code_dict removeAllObjects];
                            [juZhuJie_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [juZhuJie_code_dict setValue:code forKey:name];
                            [juZhuJie_name_dict setValue:name forKey:code];
                            
                            my_juZhuJie_Label.text=name;
                        }
                            break;
                        case 34:
                        {
                            //居住 社区
                            [juZhuSheQu_code_dict removeAllObjects];
                            [juZhuSheQu_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [juZhuSheQu_code_dict setValue:code forKey:name];
                            [juZhuSheQu_name_dict setValue:name forKey:code];
                            
                            my_juZhuSheQu_Label.text=name;
                        }
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
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}



#pragma mark 获取地址信息
-(void)getArea:(NSString*)code type:(int)type
{
    //NSLog(@"%@",code);
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:code forKey:@"code"];
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:getAreaHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                
                NSArray * data=returnValue[@"data"];
                
                switch (type) {
                        
                    case 31:
                    {
                        //居住 市
                        [juZhuShi_code_dict removeAllObjects];
                        [juZhuShi_name_dict removeAllObjects];
                        [juZhuShi_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [juZhuShi_code_dict setValue:code forKey:name];
                            [juZhuShi_name_dict setValue:name forKey:code];
                            [juZhuShi_name_array addObject:name];
                        }
                        
                        [self showPickview:31*1000];
                    }
                        break;
                    case 32:
                    {
                        //居住 区县
                        [juZhuQu_code_dict removeAllObjects];
                        [juZhuQu_name_dict removeAllObjects];
                        [juZhuQu_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [juZhuQu_code_dict setValue:code forKey:name];
                            [juZhuQu_name_dict setValue:name forKey:code];
                            [juZhuQu_name_array addObject:name];
                        }
                        
                        [self showPickview:32*1000];
                    }
                        break;
                    case 33:
                    {
                        //居住 街道
                        [juZhuJie_code_dict removeAllObjects];
                        [juZhuJie_name_dict removeAllObjects];
                        [juZhuJie_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [juZhuJie_code_dict setValue:code forKey:name];
                            [juZhuJie_name_dict setValue:name forKey:code];
                            [juZhuJie_name_array addObject:name];
                        }
                        
                        [self showPickview:33*1000];
                        
                    }
                        break;
                    case 34:
                    {
                        //居住 社区
                        [juZhuSheQu_code_dict removeAllObjects];
                        [juZhuSheQu_name_dict removeAllObjects];
                        [juZhuSheQu_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [juZhuSheQu_code_dict setValue:code forKey:name];
                            [juZhuSheQu_name_dict setValue:name forKey:code];
                            [juZhuSheQu_name_array addObject:name];
                        }
                        
                        [self showPickview:34*1000];
                        
                    }
                        break;
                        
                        
                    default:
                        break;
                }
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}









#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:jianHuRX_Field.text]) {
#pragma mark - 监护人名
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“监护人姓名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:yuLaoRG]) {
#pragma mark - 与老人关系
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“与老人关系”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_juZhuSheng_Label.text]) {
#pragma mark - 居住省
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“居住地址(省)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_juZhuShi_Label.text]) {
#pragma mark - 居住 市
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“居住地址(市)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_juZhuQu_Label.text]) {
#pragma mark - 居住 区
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“居住地址(区县)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_juZhuJie_Label.text]) {
#pragma mark - 居住 街
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“居住地址(街道)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:juZhuAddress_Field.text]) {
#pragma mark - 居住 详细
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“居住地址(详细)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:zhuZhaiDH_Field.text] && ![PublicFunction validateNumber:zhuZhaiDH_Field.text]) {
#pragma mark - 住宅电话
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“住宅电话号码”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:zhuZhaiDH_Field.text] && [PublicFunction validateNumber:zhuZhaiDH_Field.text] && zhuZhaiDH_Field.text.length<7) {
#pragma mark - 住宅电话
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“住宅电话号码”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:zhuZhaiDH_Field.text] && [PublicFunction validateNumber:zhuZhaiDH_Field.text] && zhuZhaiDH_Field.text.length>8) {
#pragma mark - 住宅电话
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“住宅电话号码”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:zhuZhaiDH_Field.text] && [PublicFunction isBlankString:yiDongDH_Field.text]) {
#pragma mark - 移动电话
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“住宅电话或移动电话”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:yiDongDH_Field.text] && ![PublicFunction validateMobile:yiDongDH_Field.text]) {
#pragma mark - 移动电话
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“移动电话号码”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:youZhengBM_Field.text] && ![PublicFunction validateZipCode:youZhengBM_Field.text]) {
#pragma mark - 邮政编码
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“邮政编码”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:dianZiYX_Field.text] && ![PublicFunction validateEmail:dianZiYX_Field.text]) {
#pragma mark - 电子邮箱
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的“电子邮箱”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //跟新 监护人信息
        [self update_JianHuRenXX];
    }
    
}



//跟新 监护人信息
-(void)update_JianHuRenXX
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"3" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
#pragma mark - 监护人名
    if (![PublicFunction isBlankString:jianHuRX_Field.text]) {
        [parameter setObject:jianHuRX_Field.text forKey:@"jianHuRX"];
    }
#pragma mark - 与老人关系
    if (![PublicFunction isBlankString:yuLaoRG]) {
        [parameter setObject:yuLaoRG forKey:@"yuLaoRG"];
    }
    
    
    
    
#pragma mark - 居住省
    if (![PublicFunction isBlankString:my_juZhuSheng_Label.text]) {
        if (Sheng_code_dict.count!=0) {
            [parameter setObject:[Sheng_code_dict objectForKey:my_juZhuSheng_Label.text] forKey:@"juZhuSheng"];
        }
    }
#pragma mark - 居住 市
    if (![PublicFunction isBlankString:my_juZhuShi_Label.text]) {
        if (juZhuShi_code_dict.count!=0) {
            [parameter setObject:[juZhuShi_code_dict objectForKey:my_juZhuShi_Label.text] forKey:@"juZhuShi"];
        }
    }
#pragma mark - 居住 区
    if (![PublicFunction isBlankString:my_juZhuQu_Label.text]) {
        if (juZhuQu_code_dict.count!=0) {
            [parameter setObject:[juZhuQu_code_dict objectForKey:my_juZhuQu_Label.text] forKey:@"juZhuQu"];
        }
    }
    
#pragma mark - 居住 街道
    if (![PublicFunction isBlankString:my_juZhuJie_Label.text]) {
        if (juZhuJie_code_dict.count!=0) {
            [parameter setObject:[juZhuJie_code_dict objectForKey:my_juZhuJie_Label.text] forKey:@"juZhuJie"];
        }
    }
#pragma mark - 居住 社区
    if (![PublicFunction isBlankString:my_juZhuSheQu_Label.text]) {
        if (juZhuSheQu_code_dict.count!=0) {
            [parameter setObject:[juZhuSheQu_code_dict objectForKey:my_juZhuSheQu_Label.text] forKey:@"juZhuSheQu"];
        }
    }
#pragma mark - 居住 详细地址
    if (![PublicFunction isBlankString:juZhuAddress_Field.text]) {
        [parameter setObject:juZhuAddress_Field.text forKey:@"juZhuAddress"];
    }
    
    
    
    
#pragma mark - 住宅电话
    if (![PublicFunction isBlankString:zhuZhaiDH_Field.text]) {
        [parameter setObject:zhuZhaiDH_Field.text forKey:@"zhuZhaiDH"];
    }
#pragma mark - 移动电话
    if (![PublicFunction isBlankString:yiDongDH_Field.text]) {
        [parameter setObject:yiDongDH_Field.text forKey:@"yiDongDH"];
    }
#pragma mark - 邮政编码
    if (![PublicFunction isBlankString:youZhengBM_Field.text]) {
        [parameter setObject:youZhengBM_Field.text forKey:@"youZhengBM"];
    }
#pragma mark - 电子邮箱
    if (![PublicFunction isBlankString:dianZiYX_Field.text]) {
        [parameter setObject:dianZiYX_Field.text forKey:@"dianZiYX"];
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

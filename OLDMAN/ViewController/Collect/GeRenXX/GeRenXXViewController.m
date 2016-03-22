//
//  GeRenXXViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "GeRenXXViewController.h"
#import "MuQianZKModel.h"
#import "GeRenXXModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

#import "ZHPickView.h"//选择器

@interface GeRenXXViewController ()<UITextFieldDelegate,UIScrollViewDelegate,ZHPickViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    
    NSArray * xingBie_Title_Array;//性别
    
    NSString * my_xingBie;//性别
    
    
    UITextField * chuShengRQ_Field;//出生日期
    
    UILabel * shengRi_Label;//生日
    
    
    
    UITextField * minZu_Field;//民族
    
    UILabel * my_minZu_Label;//民族
    
    
    
    NSArray * zhongJiangXY_Title_Array;//宗教信仰
    
    NSString * my_zhongJiaoXY;//宗教信仰 选项
    
    UITextField * xinYangJP_Field;//信仰教派
    
    UILabel * my_xinYangJP_Label;//信仰教派
    
    

    NSArray * hunYinZK_Title_Array;//婚姻状况
    
    int hunYinZK;//婚姻状况
    
    NSString * my_hunYinZK;//婚姻状况
    
    
    
    NSArray * wenHuaCD_Title_Array;//文化程度
    
    NSString * my_wenHuaCD;//文化程度
    
    
    
    NSMutableDictionary * Sheng_code_dict;// 省 编号
    
    NSMutableDictionary * Sheng_name_dict;//省 名称
    
    NSMutableArray * Sheng_name_array;//省 名称
    
    
    
    UITextField * jiGuanSheng_Field;//籍贯 省 10
    
    UILabel * my_jiGuanSheng_Label;//籍贯 省
    
    
    UITextField * jiGuanShi_Field;//籍贯 市 11
    
    UILabel * my_jiGuanShi_Label;//籍贯 市
    
    NSMutableDictionary * jiGuanShi_code_dict;//籍贯 市
    
    NSMutableDictionary * jiGuanShi_name_dict;//籍贯 市
    
    NSMutableArray * jiGuanShi_name_array;//籍贯 市
    
    
    
    NSArray * shiYongYY_Title_Array;//使用语言
    
    NSString * my_shiYongYY;//使用语言
    
    
    
    UITextField * huJiSheng_Field;//户籍 省 20
    
    UILabel * my_huJiSheng_Label;//户籍 省
    
    
    UITextField * huJiShi_Field;//户籍 市 21
    
    UILabel * my_huJiShi_Label;//户籍 市
    
    NSMutableDictionary * huJiShi_code_dict;//户籍 市
    
    NSMutableDictionary * huJiShi_name_dict;//户籍 市
    
    NSMutableArray * huJiShi_name_array;//户籍 市
    
    
    UITextField * huJiQu_Field;//户籍 区 22
    
    UILabel * my_huJiQu_Label;//户籍 区
    
    NSMutableDictionary * huJiQu_code_dict;//户籍 区
    
    NSMutableDictionary * huJiQu_name_dict;//户籍 区
    
    NSMutableArray * huJiQu_name_array;//户籍 区
    
    
    UITextField * huJiJie_Field;//户籍 街道 23
    
    UILabel * my_huJiJie_Label;//户籍 街道
    
    NSMutableDictionary * huJiJie_code_dict;//户籍 街道
    
    NSMutableDictionary * huJiJie_name_dict;//户籍 街道
    
    NSMutableArray * huJiJie_name_array;//户籍 街道
    
    
    UITextField * huJiSheQu_Field;//户籍 社区 24
    
    UILabel * my_huJiSheQu_Label;//户籍 社区
    
    NSMutableDictionary * huJiSheQu_code_dict;//户籍 社区
    
    NSMutableDictionary * huJiSheQu_name_dict;//户籍 社区
    
    NSMutableArray * huJiSheQu_name_array;//户籍 社区
    
    
    UITextField * huJiAddress_Field;//户籍地址
    
    
    
    UITextField * juZhuSheng_Field;//居住 省 30
    
    UITextField * juZhuShi_Field;//居住 市 31
    
    UITextField * juZhuQu_Field;//居住 区 32
    
    
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
    
    GeRenXXModel * _geRenXXModel;//数据源
    
    MuQianZKModel * _muQianZKModel;//目前生活状况
}
@end

@implementation GeRenXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    
    //省
    Sheng_code_dict=[[NSMutableDictionary alloc]init];
    Sheng_name_dict=[[NSMutableDictionary alloc]init];
    Sheng_name_array=[[NSMutableArray alloc]init];
    //籍贯 市
    jiGuanShi_code_dict=[[NSMutableDictionary alloc]init];
    jiGuanShi_name_dict=[[NSMutableDictionary alloc]init];
    jiGuanShi_name_array=[[NSMutableArray alloc]init];
    
    
    //户籍 市
    huJiShi_code_dict=[[NSMutableDictionary alloc]init];
    huJiShi_name_dict=[[NSMutableDictionary alloc]init];
    huJiShi_name_array=[[NSMutableArray alloc]init];
    //户籍 区
    huJiQu_code_dict=[[NSMutableDictionary alloc]init];
    huJiQu_name_dict=[[NSMutableDictionary alloc]init];
    huJiQu_name_array=[[NSMutableArray alloc]init];
    //户籍 街道
    huJiJie_code_dict=[[NSMutableDictionary alloc]init];
    huJiJie_name_dict=[[NSMutableDictionary alloc]init];
    huJiJie_name_array=[[NSMutableArray alloc]init];
    //户籍 社区
    huJiSheQu_code_dict=[[NSMutableDictionary alloc]init];
    huJiSheQu_name_dict=[[NSMutableDictionary alloc]init];
    huJiSheQu_name_array=[[NSMutableArray alloc]init];
    
    
    
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
    _geRenXXModel=[[GeRenXXModel alloc]init];//数据源
    
    _muQianZKModel=[[MuQianZKModel alloc]init];//目前生活状况
    
    //请求数据
    [self loadData];
    
    //请求 目前生活状况
    [self load_MuQianZK_Data];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _geRenXXModel=nil;
    
    _muQianZKModel=nil;
    
    [jiGuanShi_code_dict removeAllObjects];
    [jiGuanShi_name_dict removeAllObjects];
    [jiGuanShi_name_array removeAllObjects];
    
    
    
    [huJiShi_code_dict removeAllObjects];
    [huJiShi_name_dict removeAllObjects];
    [huJiShi_name_array removeAllObjects];
    
    [huJiQu_code_dict removeAllObjects];
    [huJiQu_name_dict removeAllObjects];
    [huJiQu_name_array removeAllObjects];
    
    [huJiJie_code_dict removeAllObjects];
    [huJiJie_name_dict removeAllObjects];
    [huJiJie_name_array removeAllObjects];
    
    [huJiSheQu_code_dict removeAllObjects];
    [huJiSheQu_name_dict removeAllObjects];
    [huJiSheQu_name_array removeAllObjects];
    
    
    
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
    //性别
    xingBie_Title_Array=@[@"男",@"女"];
    
    //宗教信仰
    zhongJiangXY_Title_Array=@[@"有",@"无"];
    
    //婚姻状况
    hunYinZK_Title_Array=@[@"未婚",@"已婚",@"丧偶",@"分居",@"离婚",@"不详"];
    
    //文化程度
    wenHuaCD_Title_Array=@[@"未受过正式教育",@"初中或小学",@"高中/技校/中专",@"大专",@"本科及以上",@"不详"];
    
    //使用语言
    shiYongYY_Title_Array=@[@"普通话",@"地方语言"];
}


#pragma mark 请求数据
-(void)loadData
{
    //请求数据
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"2"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
       // NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                
            
                [_geRenXXModel setValuesForKeysWithDictionary:returnValue[@"data"]];
                
                //获取籍贯 省
                if (![PublicFunction isBlankString:_geRenXXModel.jiGuanSheng]) {
                    [self getAreaByCurrentCode:_geRenXXModel.jiGuanSheng type:10];
                }
                //获取籍贯 市
                if (![PublicFunction isBlankString:_geRenXXModel.jiGuanShi]) {
                    [self getAreaByCurrentCode:_geRenXXModel.jiGuanShi type:11];
                }
                
                
                
                //获取 户籍 省
                if (![PublicFunction isBlankString:_geRenXXModel.huJiSheng]) {
                    [self getAreaByCurrentCode:_geRenXXModel.huJiSheng type:20];
                }
                //获取 户籍 市
                if (![PublicFunction isBlankString:_geRenXXModel.huJiShi]) {
                    [self getAreaByCurrentCode:_geRenXXModel.huJiShi type:21];
                }
                //获取 户籍 区
                if (![PublicFunction isBlankString:_geRenXXModel.huJiQu]) {
                    [self getAreaByCurrentCode:_geRenXXModel.huJiQu type:22];
                }
                //获取 户籍 街道
                if (![PublicFunction isBlankString:_geRenXXModel.huJiJie]) {
                    [self getAreaByCurrentCode:_geRenXXModel.huJiJie type:23];
                }
                //获取 户籍 社区
                if (![PublicFunction isBlankString:_geRenXXModel.huJiSheQu]) {
                    [self getAreaByCurrentCode:_geRenXXModel.huJiSheQu type:24];
                }
                
                
                
                
                //获取 居住 街道
                if (![PublicFunction isBlankString:_geRenXXModel.juZhuJie]) {
                    [self getAreaByCurrentCode:_geRenXXModel.juZhuJie type:33];
                }
                //获取 居住 社区
                if (![PublicFunction isBlankString:_geRenXXModel.juZhuSheQu]) {
                    [self getAreaByCurrentCode:_geRenXXModel.juZhuSheQu type:34];
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




#pragma mark 目前生活状况
-(void)load_MuQianZK_Data
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"4"];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                
                
                [_muQianZKModel setValuesForKeysWithDictionary:returnValue[@"data"]];
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } WithErrorBlock:^(id errorCode) {

    } WithFailureBlock:^{

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
    self.navigationItem.title = @"个人信息";
    
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
    
    
    
    //性别
    UIView * xingBie_View=[ZCControl createView:CGRectMake(0, 20, WIDTH, 40)];
    [RootScrollView addSubview:xingBie_View];
    
    //性别 标题
    UILabel * xingBie_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"1. 性别"];
    [xingBie_View addSubview:xingBie_Label];
    xingBie_Label.textColor=Title_text_color;
    
    //性别 介绍
    UIButton * xingBie_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(xingBie_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [xingBie_View addSubview:xingBie_Button];
    xingBie_Button.tag=90000;
    
    //起始高度
    float xingBie_View_frame_origin_y=CGRectGetMaxY(xingBie_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<xingBie_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"xingBie"];
        [xingBie_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, xingBie_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=3000+i;
        
        if (![PublicFunction isBlankString:_geRenXXModel.xingBie]) {
            if ([_geRenXXModel.xingBie intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [xingBie_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=xingBie_Title_Array[i];
        
        xingBie_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    xingBie_View.frame = CGRectMake(0, 20, WIDTH, xingBie_View_frame_origin_y);

    
    
    
    //出生日期 标题
    UILabel * chuShengRQ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(xingBie_View.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"2. 出生日期"];
    [RootScrollView addSubview:chuShengRQ_Label];
    chuShengRQ_Label.textColor=Title_text_color;
    
    
    //出生日期 签字框
    chuShengRQ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(chuShengRQ_Label.frame)+Title_Field_WH, CGRectGetMinY(chuShengRQ_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-chuShengRQ_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil  rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:chuShengRQ_Field];
    chuShengRQ_Field.userInteractionEnabled=NO;
    
    //生日
    shengRi_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(chuShengRQ_Label.frame)+8+Title_Field_WH, CGRectGetMinY(chuShengRQ_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-chuShengRQ_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    shengRi_Label.textColor=Field_text_color;
    [RootScrollView addSubview:shengRi_Label];
    shengRi_Label.userInteractionEnabled=YES;
    
    if (![PublicFunction isBlankString:_geRenXXModel.chuShengRQ]) {
        shengRi_Label.text=_geRenXXModel.chuShengRQ;
    } else {
        
        NSRange range_nian=NSMakeRange(6,4);
        NSString * str_nian=[self.shenFenZJ substringWithRange:range_nian];
        
        NSRange range_yue=NSMakeRange(10,2);
        NSString * str_yue=[self.shenFenZJ substringWithRange:range_yue];
        
        NSRange range_ri=NSMakeRange(12,2);
        NSString * str_ri=[self.shenFenZJ substringWithRange:range_ri];

        shengRi_Label.text=[NSString stringWithFormat:@"%@-%@-%@",str_nian,str_yue,str_ri];
    }
    
    //生日触发事件
    UITapGestureRecognizer * tap_shengRi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_shengRi_GestureAction)];
    [shengRi_Label addGestureRecognizer:tap_shengRi];
    
    
    //出生日期 介绍
    UIButton * chuShengRQ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(chuShengRQ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:chuShengRQ_Button];
    chuShengRQ_Button.tag=90001;
    
    
    
    
    
    //民族 标题
    UILabel * minZu_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(chuShengRQ_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"3. 民族"];
    [RootScrollView addSubview:minZu_Label];
    minZu_Label.textColor=Title_text_color;
    
    //民族 签字框
    minZu_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(minZu_Label.frame)+Title_Field_WH, CGRectGetMinY(minZu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-minZu_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    minZu_Field.textColor=CREATECOLOR(153, 153, 153, 1);
    [RootScrollView addSubview:minZu_Field];
    minZu_Field.delegate=self;
    minZu_Field.userInteractionEnabled=NO;
    
    //民族
    my_minZu_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(minZu_Label.frame)+8+Title_Field_WH, CGRectGetMinY(minZu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-minZu_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_minZu_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_minZu_Label];
    my_minZu_Label.userInteractionEnabled=YES;
    
    if (![PublicFunction isBlankString:_geRenXXModel.minZu]) {
        my_minZu_Label.text=_geRenXXModel.minZu;
    }
    
    //民族触发事件
    UITapGestureRecognizer * tap_minZu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_minZu_GestureAction)];
    [my_minZu_Label addGestureRecognizer:tap_minZu];
    
    //民族 介绍
    UIButton * minZu_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(minZu_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:minZu_Button];
    minZu_Button.tag=90002;
    
    
    
    
    
    //宗教信仰
    UIView * zhongJiangXY_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(minZu_Field.frame)+20, WIDTH, 24*(zhongJiangXY_Title_Array.count+1))];
    [RootScrollView addSubview:zhongJiangXY_View];
    
    //宗教信仰 标题
    UILabel * zhongJiangXY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"4. 宗教信仰"];
    [zhongJiangXY_View addSubview:zhongJiangXY_Label];
    zhongJiangXY_Label.textColor=Title_text_color;
    
    //宗教信仰 介绍
    UIButton * zhongJiangXY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(zhongJiangXY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [zhongJiangXY_View addSubview:zhongJiangXY_Button];
    zhongJiangXY_Button.tag=90003;
    
    //起始高度
    float zhongJiangXY_View_frame_origin_y=CGRectGetMaxY(zhongJiangXY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<zhongJiangXY_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"zhongJiaoXY"];
        [zhongJiangXY_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, zhongJiangXY_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=4000+i;
        
        if (![PublicFunction isBlankString:_geRenXXModel.zhongJiaoXY]) {
            if ([_geRenXXModel.zhongJiaoXY intValue]==1) {
                if (i==1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if (i==0) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [zhongJiangXY_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=zhongJiangXY_Title_Array[i];
        
        zhongJiangXY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    zhongJiangXY_View.frame = CGRectMake(0, CGRectGetMaxY(minZu_Field.frame)+20, WIDTH, zhongJiangXY_View_frame_origin_y);
    
    
    
    //信仰教派
    UILabel * xinYangJP_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(zhongJiangXY_View.frame)+20, 44+Title_text_font*2, Title_text_font) Font:Title_text_font Text:@"信仰教派"];
    [RootScrollView addSubview:xinYangJP_Label];
    xinYangJP_Label.textColor=Title_text_color;
    
    //信仰教派 签字框
    xinYangJP_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(xinYangJP_Label.frame)+Title_Field_WH, CGRectGetMinY(xinYangJP_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-xinYangJP_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    xinYangJP_Field.textColor=CREATECOLOR(153, 153, 153, 1);
    [RootScrollView addSubview:xinYangJP_Field];
    xinYangJP_Field.delegate=self;
    xinYangJP_Field.userInteractionEnabled=NO;
    
    
    //信仰教派
    my_xinYangJP_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xinYangJP_Label.frame)+8+Title_Field_WH, CGRectGetMinY(xinYangJP_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-xinYangJP_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_xinYangJP_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_xinYangJP_Label];
    my_xinYangJP_Label.userInteractionEnabled=NO;
    
    
    //信仰教派 触发事件
    UITapGestureRecognizer * tap_xinYangJP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_xinYangJP_GestureAction)];
    [my_xinYangJP_Label addGestureRecognizer:tap_xinYangJP];
    

    if (![PublicFunction isBlankString:_geRenXXModel.zhongJiaoXY]) {
        if ([_geRenXXModel.zhongJiaoXY intValue]==1) {
            my_xinYangJP_Label.userInteractionEnabled=NO;
        } else {
            my_xinYangJP_Label.userInteractionEnabled=YES;
            my_xinYangJP_Label.text = [_geRenXXModel.zhongJiaoXY substringFromIndex:1];
        }
    }
    
    
    //信仰教派 介绍
    UIButton * xinYangJP_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(xinYangJP_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:xinYangJP_Button];
    xinYangJP_Button.tag=90004;
    
    
    
    
    //婚姻状况
    UIView * hunYinZK_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(xinYangJP_Field.frame)+20, WIDTH, 24*(hunYinZK_Title_Array.count+1))];
    [RootScrollView addSubview:hunYinZK_View];
    
    //婚姻状况 标题
    UILabel * hunYinZK_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"5. 婚姻状况"];
    [hunYinZK_View addSubview:hunYinZK_Label];
    hunYinZK_Label.textColor=Title_text_color;
    
    //婚姻状况 介绍
    UIButton * hunYinZK_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(hunYinZK_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [hunYinZK_View addSubview:hunYinZK_Button];
    hunYinZK_Button.tag=90005;
    
    //起始高度
    float hunYinZK_View_frame_origin_y=CGRectGetMaxY(hunYinZK_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<hunYinZK_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"hunYinZK"];
        [hunYinZK_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, hunYinZK_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=5000+i;
        
        if (![PublicFunction isBlankString:_geRenXXModel.hunYinZK]) {
            if ([_geRenXXModel.hunYinZK intValue]==i) {
                [xuanXiang_Button setChecked:YES];
                hunYinZK=i;
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [hunYinZK_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=hunYinZK_Title_Array[i];
    
        hunYinZK_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    hunYinZK_View.frame = CGRectMake(0, CGRectGetMaxY(xinYangJP_Field.frame)+20, WIDTH, hunYinZK_View_frame_origin_y);

    
    
    
    //文化程度
    UIView * wenHuaCD_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(hunYinZK_View.frame)+20, WIDTH, 24*(wenHuaCD_Title_Array.count+1))];
    [RootScrollView addSubview:wenHuaCD_View];
    
    //文化程度 标题
    UILabel * wenHuaCD_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"6. 文化程度"];
    [wenHuaCD_View addSubview:wenHuaCD_Label];
    wenHuaCD_Label.textColor=Title_text_color;
    
    //文化程度 介绍
    UIButton * wenHuaCD_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(wenHuaCD_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [wenHuaCD_View addSubview:wenHuaCD_Button];
    wenHuaCD_Button.tag=90006;
    
    //起始高度
    float wenHuaCD_View_frame_origin_y=CGRectGetMaxY(wenHuaCD_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<wenHuaCD_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"wenHuaCD"];
        [wenHuaCD_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, wenHuaCD_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=6000+i;
        
        if (![PublicFunction isBlankString:_geRenXXModel.wenHuaCD]) {
            if ([_geRenXXModel.wenHuaCD intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [wenHuaCD_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=wenHuaCD_Title_Array[i];
    
        wenHuaCD_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    wenHuaCD_View.frame = CGRectMake(0, CGRectGetMaxY(hunYinZK_View.frame)+20, WIDTH, wenHuaCD_View_frame_origin_y);
    
    
#pragma mark 籍贯
    
    //籍贯 省
    UILabel * jiGuanSheng_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(wenHuaCD_View.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"7. 籍贯(省)"];
    [RootScrollView addSubview:jiGuanSheng_Label];
    jiGuanSheng_Label.textColor=Title_text_color;
    
    //籍贯 签字框
    jiGuanSheng_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(jiGuanSheng_Label.frame)+Title_Field_WH, CGRectGetMinY(jiGuanSheng_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-jiGuanSheng_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:jiGuanSheng_Field];
    jiGuanSheng_Field.delegate=self;
    jiGuanSheng_Field.userInteractionEnabled=NO;
    
    //籍贯 省
    my_jiGuanSheng_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(jiGuanSheng_Label.frame)+8+Title_Field_WH, CGRectGetMinY(jiGuanSheng_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-jiGuanSheng_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_jiGuanSheng_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_jiGuanSheng_Label];
    my_jiGuanSheng_Label.userInteractionEnabled=YES;
    my_jiGuanSheng_Label.tag=10000;
    
    //籍贯 省 触发事件
    UITapGestureRecognizer * tap_jiGuanSheng = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_jiGuanSheng_Label addGestureRecognizer:tap_jiGuanSheng];
 
    //籍贯 介绍
    UIButton * jiGuan_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(jiGuanSheng_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:jiGuan_Button];
    jiGuan_Button.tag=90007;
    
    
    
    //籍贯 市
    UILabel * jiGuanShi_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(jiGuanSheng_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"籍贯(市)"];
    [RootScrollView addSubview:jiGuanShi_Label];
    jiGuanShi_Label.textColor=Title_text_color;
    
    //籍贯 签字框
    jiGuanShi_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(jiGuanShi_Label.frame)+Title_Field_WH, CGRectGetMinY(jiGuanShi_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-jiGuanShi_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:jiGuanShi_Field];
    jiGuanShi_Field.delegate=self;
    jiGuanShi_Field.userInteractionEnabled=NO;
    
    //籍贯 市
    my_jiGuanShi_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(jiGuanShi_Label.frame)+8+Title_Field_WH, CGRectGetMinY(jiGuanShi_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-jiGuanShi_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_jiGuanShi_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_jiGuanShi_Label];
    my_jiGuanShi_Label.userInteractionEnabled=YES;
    my_jiGuanShi_Label.tag=11000;
    
    //籍贯 市 触发事件
    UITapGestureRecognizer * tap_jiGuanShi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_jiGuanShi_Label addGestureRecognizer:tap_jiGuanShi];
    

    
    
    
#pragma mark 使用语言
    
    
    //使用语言
    UIView * shiYongYY_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(jiGuanShi_Field.frame)+20, WIDTH, 24*(shiYongYY_Title_Array.count+1))];
    [RootScrollView addSubview:shiYongYY_View];
    
    //使用语言 标题
    UILabel * shiYongYY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"8. 使用语言"];
    [shiYongYY_View addSubview:shiYongYY_Label];
    shiYongYY_Label.textColor=Title_text_color;
    
    //使用语言 介绍
    UIButton * shiYongYY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(shiYongYY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [shiYongYY_View addSubview:shiYongYY_Button];
    shiYongYY_Button.tag=90008;
    
    //起始高度
    float shiYongYY_View_frame_origin_y=CGRectGetMaxY(shiYongYY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<shiYongYY_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"shiYongYY"];
        [shiYongYY_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, shiYongYY_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=7000+i;
        
        if (![PublicFunction isBlankString:_geRenXXModel.shiYongYY]) {
            if ([_geRenXXModel.shiYongYY intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [shiYongYY_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=shiYongYY_Title_Array[i];
    
        shiYongYY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    shiYongYY_View.frame = CGRectMake(0, CGRectGetMaxY(jiGuanShi_Field.frame)+20, WIDTH, shiYongYY_View_frame_origin_y);

    
    
    
#pragma mark 户籍
    
    
    
    //户籍 省
    UILabel * huJiSheng_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(shiYongYY_View.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"9. 户籍(省)"];
    [RootScrollView addSubview:huJiSheng_Label];
    huJiSheng_Label.textColor=Title_text_color;
    
    //户籍 省 签字框
    huJiSheng_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(huJiSheng_Label.frame)+Title_Field_WH, CGRectGetMinY(huJiSheng_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiSheng_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:huJiSheng_Field];
    huJiSheng_Field.delegate=self;
    huJiSheng_Field.userInteractionEnabled=NO;
    
    //户籍 省
    my_huJiSheng_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(huJiSheng_Label.frame)+8+Title_Field_WH, CGRectGetMinY(huJiSheng_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiSheng_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_huJiSheng_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_huJiSheng_Label];
    my_huJiSheng_Label.userInteractionEnabled=YES;
    my_huJiSheng_Label.tag=20000;
    
    //户籍 省 触发事件
    UITapGestureRecognizer * tap_huJiSheng = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_huJiSheng_Label addGestureRecognizer:tap_huJiSheng];
    
    //户籍 介绍
    UIButton * huJiAddress_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(huJiSheng_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:huJiAddress_Button];
    huJiAddress_Button.tag=90009;
    
    
    
    
    //户籍 市
    UILabel * huJiShi_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(huJiSheng_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"户籍(市)"];
    [RootScrollView addSubview:huJiShi_Label];
    huJiShi_Label.textColor=Title_text_color;
    
    //户籍 市 签字框
    huJiShi_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(huJiShi_Label.frame)+Title_Field_WH, CGRectGetMinY(huJiShi_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiShi_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:huJiShi_Field];
    huJiShi_Field.delegate=self;
    huJiShi_Field.userInteractionEnabled=NO;
    
    //户籍 市
    my_huJiShi_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(huJiShi_Label.frame)+8+Title_Field_WH, CGRectGetMinY(huJiShi_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiShi_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_huJiShi_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_huJiShi_Label];
    my_huJiShi_Label.userInteractionEnabled=YES;
    my_huJiShi_Label.tag=21000;
    
    //户籍 市 触发事件
    UITapGestureRecognizer * tap_huJiShi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_huJiShi_Label addGestureRecognizer:tap_huJiShi];
    
    
    
    
    
    //户籍 区县
    UILabel * huJiQu_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(huJiShi_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"户籍(区县)"];
    [RootScrollView addSubview:huJiQu_Label];
    huJiQu_Label.textColor=Title_text_color;
    
    //户籍 区县 签字框
    huJiQu_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(huJiQu_Label.frame)+Title_Field_WH, CGRectGetMinY(huJiQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiQu_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:huJiQu_Field];
    huJiQu_Field.delegate=self;
    huJiQu_Field.userInteractionEnabled=NO;
    
    //户籍 区县
    my_huJiQu_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(huJiQu_Label.frame)+8+Title_Field_WH, CGRectGetMinY(huJiQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiQu_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_huJiQu_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_huJiQu_Label];
    my_huJiQu_Label.userInteractionEnabled=YES;
    my_huJiQu_Label.tag=22000;
    
    //户籍 区县 触发事件
    UITapGestureRecognizer * tap_huJiQu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_huJiQu_Label addGestureRecognizer:tap_huJiQu];
    
    
    
    
    
    
    //户籍 街道
    UILabel * huJiJie_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(huJiQu_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"户籍(街道)"];
    [RootScrollView addSubview:huJiJie_Label];
    huJiJie_Label.textColor=Title_text_color;
    
    //户籍 街道 签字框
    huJiJie_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(huJiJie_Label.frame)+Title_Field_WH, CGRectGetMinY(huJiJie_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiJie_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:huJiJie_Field];
    huJiJie_Field.delegate=self;
    huJiJie_Field.userInteractionEnabled=NO;
    
    //户籍 街道
    my_huJiJie_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(huJiJie_Label.frame)+8+Title_Field_WH, CGRectGetMinY(huJiJie_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiJie_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_huJiJie_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_huJiJie_Label];
    my_huJiJie_Label.userInteractionEnabled=YES;
    my_huJiJie_Label.tag=23000;
    
    //户籍 街道 触发事件
    UITapGestureRecognizer * tap_huJiJie = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_huJiJie_Label addGestureRecognizer:tap_huJiJie];
    
    
    
    
    
    
    //户籍 社区
    UILabel * huJiSheQu_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(huJiJie_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"户籍(社区)"];
    [RootScrollView addSubview:huJiSheQu_Label];
    huJiSheQu_Label.textColor=Title_text_color;
    
    //户籍 社区 签字框
    huJiSheQu_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(huJiSheQu_Label.frame)+Title_Field_WH, CGRectGetMinY(huJiSheQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiSheQu_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    [RootScrollView addSubview:huJiSheQu_Field];
    huJiSheQu_Field.delegate=self;
    huJiSheQu_Field.userInteractionEnabled=NO;
    
    //户籍 社区
    my_huJiSheQu_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(huJiSheQu_Label.frame)+8+Title_Field_WH, CGRectGetMinY(huJiSheQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiSheQu_Label.frame.size.width-55, Field_HE) Font:Field_text_font Text:nil];
    my_huJiSheQu_Label.textColor=Field_text_color;
    [RootScrollView addSubview:my_huJiSheQu_Label];
    my_huJiSheQu_Label.userInteractionEnabled=YES;
    my_huJiSheQu_Label.tag=24000;
    
    //户籍 社区 触发事件
    UITapGestureRecognizer * tap_huJiSheQu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_diQu_GestureAction:)];
    [my_huJiSheQu_Label addGestureRecognizer:tap_huJiSheQu];
    
    
    
    
    //户籍 详细
    UILabel * huJiAddress_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(huJiSheQu_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"户籍(详细)"];
    [RootScrollView addSubview:huJiAddress_Label];
    huJiAddress_Label.textColor=Title_text_color;
    
    //户籍 详细 签字框
    huJiAddress_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(huJiAddress_Label.frame)+Title_Field_WH, CGRectGetMinY(huJiAddress_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-huJiAddress_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    huJiAddress_Field.textColor=Field_text_color;
    [RootScrollView addSubview:huJiAddress_Field];
    huJiAddress_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_geRenXXModel.huJiAddress]) {
        huJiAddress_Field.text=_geRenXXModel.huJiAddress;
    }
    
    
    
#pragma mark 居住
    
    
    
    //居住 省
    UILabel * juZhuSheng_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(huJiAddress_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"10.居住(省)"];
    [RootScrollView addSubview:juZhuSheng_Label];
    juZhuSheng_Label.textColor=Title_text_color;
    
    //居住 省 签字框
    juZhuSheng_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuSheng_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuSheng_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuSheng_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juZhuSheng_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juZhuSheng_Field];
    juZhuSheng_Field.delegate=self;
    juZhuSheng_Field.userInteractionEnabled=NO;
    
    juZhuSheng_Field.text=@"北京市";
    
    //居住 介绍
    UIButton * juZhuAddress_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(juZhuSheng_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:juZhuAddress_Button];
    juZhuAddress_Button.tag=90010;
    
    
    
    
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
    
    juZhuShi_Field.text=@"市辖区";
    
    
    
    //居住 区县
    UILabel * juZhuQu_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuShi_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"居住(区县)"];
    [RootScrollView addSubview:juZhuQu_Label];
    juZhuQu_Label.textColor=Title_text_color;
    
    //居住 省 签字框
    juZhuQu_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuQu_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuQu_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuQu_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juZhuQu_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juZhuQu_Field];
    juZhuQu_Field.delegate=self;
    juZhuQu_Field.userInteractionEnabled=NO;
    
    juZhuQu_Field.text=@"海淀区";
    
    
    
    
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
    
    if (![PublicFunction isBlankString:_geRenXXModel.juZhuAddress]) {
        juZhuAddress_Field.text=_geRenXXModel.juZhuAddress;
    }
    
    
    
    
    
#pragma mark 电话
    
    
    // 居住电话 标题
    UILabel * zhuZhaiDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuAddress_Field.frame)+20, 44+Title_text_font*4, Title_text_font) Font:Title_text_font Text:@"11. 住宅电话"];
    [RootScrollView addSubview:zhuZhaiDH_Label];
    zhuZhaiDH_Label.textColor=Title_text_color;
    
    // 居住电话 签字框
    zhuZhaiDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(zhuZhaiDH_Label.frame)+Title_Field_WH, CGRectGetMinY(zhuZhaiDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-zhuZhaiDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    zhuZhaiDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:zhuZhaiDH_Field];
    zhuZhaiDH_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_geRenXXModel.zhuZhaiDH]) {
        zhuZhaiDH_Field.text=_geRenXXModel.zhuZhaiDH;
    }
    
    //居住电话 介绍
    UIButton * zhuZhaiDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(zhuZhaiDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:zhuZhaiDH_Button];
    zhuZhaiDH_Button.tag=90011;
    
    
    
    
    //地址 移动电话 标题
    UILabel * yiDongDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(zhuZhaiDH_Field.frame)+20, 44+Title_text_font*4, Title_text_font) Font:Title_text_font Text:@"12. 移动电话"];
    [RootScrollView addSubview:yiDongDH_Label];
    yiDongDH_Label.textColor=Title_text_color;
    
    //地址 移动电话 签字框
    yiDongDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(yiDongDH_Label.frame)+Title_Field_WH, CGRectGetMinY(yiDongDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-yiDongDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    yiDongDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:yiDongDH_Field];
    yiDongDH_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_geRenXXModel.yiDongDH]) {
        yiDongDH_Field.text=_geRenXXModel.yiDongDH;
    }
    
    //移动电话 介绍
    UIButton * yiDongDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yiDongDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:yiDongDH_Button];
    yiDongDH_Button.tag=90012;
    
    
    
    
    //地址 邮政编码 标题
    UILabel * youZhengBM_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(yiDongDH_Field.frame)+20, 44+Title_text_font*4, Title_text_font) Font:Title_text_font Text:@"13. 邮政编码"];
    [RootScrollView addSubview:youZhengBM_Label];
    youZhengBM_Label.textColor=Title_text_color;
    
    //地址 邮政编码 签字框
    youZhengBM_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(youZhengBM_Label.frame)+Title_Field_WH, CGRectGetMinY(youZhengBM_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-youZhengBM_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    youZhengBM_Field.textColor=Field_text_color;
    [RootScrollView addSubview:youZhengBM_Field];
    youZhengBM_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_geRenXXModel.youZhengBM]) {
        youZhengBM_Field.text=_geRenXXModel.youZhengBM;
    }
    
    //邮政编码 介绍
    UIButton * youZhengBM_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(youZhengBM_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:youZhengBM_Button];
    youZhengBM_Button.tag=90013;
    
    
    
    
    //地址 电子邮箱 标题
    UILabel * dianZiYX_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(youZhengBM_Field.frame)+20, 44+Title_text_font*4, Title_text_font) Font:Title_text_font Text:@"14. 电子邮箱"];
    [RootScrollView addSubview:dianZiYX_Label];
    dianZiYX_Label.textColor=Title_text_color;
    
    //地址 电子邮箱 签字框
    dianZiYX_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(dianZiYX_Label.frame)+Title_Field_WH, CGRectGetMinY(dianZiYX_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-dianZiYX_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    dianZiYX_Field.textColor=Field_text_color;
    [RootScrollView addSubview:dianZiYX_Field];
    dianZiYX_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_geRenXXModel.dianZiYX]) {
        dianZiYX_Field.text=_geRenXXModel.dianZiYX;
    }
    
    //电子邮箱 介绍
    UIButton * dianZiYX_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(dianZiYX_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:dianZiYX_Button];
    dianZiYX_Button.tag=90014;
    
    
    
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


#pragma mark 生日
-(void)tap_shengRi_GestureAction
{
    
    [_pickview remove];
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date=[formatter dateFromString:@"1970-01-01"];
    
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    
    _pickview.tag=3000;
    
    _pickview.delegate=self;
    
    [_pickview show];
}


#pragma mark 民族
-(void)tap_minZu_GestureAction
{
    [_pickview remove];
    
    NSArray * array=@[@"汉族",@"壮族",@"满族",@"回族",@"苗族",@"维吾尔族",@"土家族",@"彝族",@"蒙古族",@"藏族",@"布依族",@"侗族",@"瑶族",@"朝鲜族",@"白族",@"哈尼族",@"哈萨克族",@"黎族",@"傣族",@"畲族",@"傈僳族",@"仡佬族",@"东乡族",@"高山族",@"拉祜族",@"水族",@"佤族",@"纳西族",@"羌族",@"土族",@"仫佬族",@"锡伯族",@"柯尔克孜族",@"达斡尔族",@"景颇族",@"毛南族",@"撒拉族",@"布朗族",@"塔吉克族",@"阿昌族",@"普米族",@"鄂温克族",@"怒族",@"京族",@"基诺族",@"德昂族",@"保安族",@"俄罗斯族",@"裕固族",@"乌兹别克族",@"门巴族",@"鄂伦春族",@"独龙族",@"塔塔尔族",@"赫哲族",@"珞巴族"];
    
    _pickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    
    _pickview.tag=4000;
    
    _pickview.delegate=self;
    
    [_pickview show];
}



#pragma mark 信仰教派
-(void)tap_xinYangJP_GestureAction
{
    [_pickview remove];
    
    NSArray * array=@[@"基督教",@"佛教",@"伊斯兰教",@"其他"];
    
    _pickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    
    _pickview.tag=5000;
    
    _pickview.delegate=self;
    
    [_pickview show];
}




#pragma mark 地区 点击事件
-(void)tap_diQu_GestureAction:(UITapGestureRecognizer*)tap
{
    NSInteger tag=tap.view.tag;
    
    switch (tag/1000) {
        //籍贯
        case 10:
            [self showPickview:tag];
            break;
        case 11:
            if (![PublicFunction isBlankString:[Sheng_code_dict objectForKey:my_jiGuanSheng_Label.text]]) {
                [self getArea:[Sheng_code_dict objectForKey:my_jiGuanSheng_Label.text] type:11];
            }
            break;
            
        //户籍
        case 20:
            [self showPickview:tag];
            break;
        case 21:
            if (![PublicFunction isBlankString:[Sheng_code_dict objectForKey:my_huJiSheng_Label.text]]) {
                [self getArea:[Sheng_code_dict objectForKey:my_huJiSheng_Label.text] type:21];
            }
            break;
        case 22:
            if (![PublicFunction isBlankString:[huJiShi_code_dict objectForKey:my_huJiShi_Label.text]]) {
                [self getArea:[huJiShi_code_dict objectForKey:my_huJiShi_Label.text] type:22];
            }
            break;
        case 23:
            if (![PublicFunction isBlankString:[huJiQu_code_dict objectForKey:my_huJiQu_Label.text]]) {
                [self getArea:[huJiQu_code_dict objectForKey:my_huJiQu_Label.text] type:23];
            }
            break;
        case 24:
            if (![PublicFunction isBlankString:[huJiJie_code_dict objectForKey:my_huJiJie_Label.text]]) {
                [self getArea:[huJiJie_code_dict objectForKey:my_huJiJie_Label.text] type:24];
            }
            break;
            
        //居住
        case 33:
            [self getArea:@"110108" type:33];
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
        case 10:
            if (Sheng_name_array.count!=0) {
                keys_array=Sheng_name_array;
            }
            break;
        case 11:
            if (jiGuanShi_name_array.count!=0) {
                keys_array=jiGuanShi_name_array;
            }
            break;
            
            
        case 20:
            if (Sheng_name_array.count!=0) {
                keys_array=Sheng_name_array;
            }
            break;
        case 21:
            if (huJiShi_name_array.count!=0) {
                keys_array=huJiShi_name_array;
            }
            break;
        case 22:
            if (huJiQu_name_array.count!=0) {
                keys_array=huJiQu_name_array;
            }
            break;
        case 23:
            if (huJiJie_name_array.count!=0) {
                keys_array=huJiJie_name_array;
            }
            break;
        case 24:
            if (huJiSheQu_name_array.count!=0) {
                keys_array=huJiSheQu_name_array;
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
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    if (pickView.tag==3000) {
        shengRi_Label.text = resultString;
    } else if (pickView.tag==4000) {
        my_minZu_Label.text = resultString;
    } else if (pickView.tag==5000) {
        my_xinYangJP_Label.text = resultString;
    }
    
    switch (pickView.tag/1000) {
        //籍贯
        case 10:
        {
            //省改变
            if (![my_jiGuanSheng_Label.text isEqualToString:resultString]) {
                //对应清空
                my_jiGuanShi_Label.text=@"";
            }
            my_jiGuanSheng_Label.text = resultString;
        }
            break;
        case 11:
            my_jiGuanShi_Label.text = resultString;
            break;
            
        //户籍
        case 20:
        {
            //省改变
            if (![my_huJiSheng_Label.text isEqualToString:resultString]) {
                //对应清空
                my_huJiShi_Label.text=@"";
                my_huJiQu_Label.text=@"";
                my_huJiJie_Label.text=@"";
                my_huJiSheQu_Label.text=@"";
            }
            my_huJiSheng_Label.text = resultString;
        }
            break;
        case 21:
        {
            //市改变
            if (![my_huJiShi_Label.text isEqualToString:resultString]) {
                //对应清空
                my_huJiQu_Label.text=@"";
                my_huJiJie_Label.text=@"";
                my_huJiSheQu_Label.text=@"";
            }
            my_huJiShi_Label.text = resultString;
        }
            break;
        case 22:
        {
            //区县改变
            if (![my_huJiQu_Label.text isEqualToString:resultString]) {
                //对应清空
                my_huJiJie_Label.text=@"";
                my_huJiSheQu_Label.text=@"";
            }
            my_huJiQu_Label.text = resultString;
        }
            break;
        case 23:
        {
            //街 改变
            if (![my_huJiJie_Label.text isEqualToString:resultString]) {
                //对应清空
                my_huJiSheQu_Label.text=@"";
            }
            my_huJiJie_Label.text = resultString;
        }
            break;
        case 24:
            my_huJiSheQu_Label.text = resultString;
            break;
            
            
        //居住
        case 33:
        {
            //街 改变
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
                            
                        case 10:
                        {
                            //籍贯 省
                            my_jiGuanSheng_Label.text=[data[0] objectForKey:@"name"];
                            break;
                        }
                        case 11:
                        {
                            //籍贯 市
                            [jiGuanShi_code_dict removeAllObjects];
                            [jiGuanShi_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [jiGuanShi_code_dict setValue:code forKey:name];
                            [jiGuanShi_name_dict setValue:name forKey:code];
                            
                            my_jiGuanShi_Label.text=name;
                        }
                            break;
                            
                            
                        case 20:
                        {
                            //户籍 省
                            my_huJiSheng_Label.text=[data[0] objectForKey:@"name"];
                            break;
                        }
                        case 21:
                        {
                            //户籍 市
                            [huJiShi_code_dict removeAllObjects];
                            [huJiShi_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [huJiShi_code_dict setValue:code forKey:name];
                            [huJiShi_name_dict setValue:name forKey:code];
                            
                            my_huJiShi_Label.text=name;
                        }
                            break;
                        case 22:
                        {
                            //户籍 区县
                            [huJiQu_code_dict removeAllObjects];
                            [huJiQu_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [huJiQu_code_dict setValue:code forKey:name];
                            [huJiQu_name_dict setValue:name forKey:code];
                            
                            my_huJiQu_Label.text=name;
                        }
                            break;
                        case 23:
                        {
                            //户籍 街道
                            [huJiJie_code_dict removeAllObjects];
                            [huJiJie_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [huJiJie_code_dict setValue:code forKey:name];
                            [huJiJie_name_dict setValue:name forKey:code];
                            
                            my_huJiJie_Label.text=name;
                        }
                            break;
                        case 24:
                        {
                            //户籍 社区
                            [huJiSheQu_code_dict removeAllObjects];
                            [huJiSheQu_name_dict removeAllObjects];
                            
                            NSDictionary * dict=data[0];
                            
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [huJiSheQu_code_dict setValue:code forKey:name];
                            [huJiSheQu_name_dict setValue:name forKey:code];
                            
                            my_huJiSheQu_Label.text=name;
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

                    case 11:
                    {
                        //籍贯 市
                        [jiGuanShi_code_dict removeAllObjects];
                        [jiGuanShi_name_dict removeAllObjects];
                        [jiGuanShi_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [jiGuanShi_code_dict setValue:code forKey:name];
                            [jiGuanShi_name_dict setValue:name forKey:code];
                            [jiGuanShi_name_array addObject:name];
                        }
                        
                        [self showPickview:11*1000];
                    }
                        break;
                        
                        
                        
                    case 21:
                    {
                        //户籍 市
                        [huJiShi_code_dict removeAllObjects];
                        [huJiShi_name_dict removeAllObjects];
                        [huJiShi_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [huJiShi_code_dict setValue:code forKey:name];
                            [huJiShi_name_dict setValue:name forKey:code];
                            [huJiShi_name_array addObject:name];
                        }
                        
                        [self showPickview:21*1000];
                    }
                        break;
                    case 22:
                    {
                        //户籍 区县
                        [huJiQu_code_dict removeAllObjects];
                        [huJiQu_name_dict removeAllObjects];
                        [huJiQu_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [huJiQu_code_dict setValue:code forKey:name];
                            [huJiQu_name_dict setValue:name forKey:code];
                            [huJiQu_name_array addObject:name];
                        }
                        
                        [self showPickview:22*1000];
                    }
                        break;
                    case 23:
                    {
                        //户籍 街道
                        [huJiJie_code_dict removeAllObjects];
                        [huJiJie_name_dict removeAllObjects];
                        [huJiJie_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [huJiJie_code_dict setValue:code forKey:name];
                            [huJiJie_name_dict setValue:name forKey:code];
                            [huJiJie_name_array addObject:name];
                        }
                        
                        [self showPickview:23*1000];
                    }
                        break;
                    case 24:
                    {
                        //户籍 社区
                        [huJiSheQu_code_dict removeAllObjects];
                        [huJiSheQu_name_dict removeAllObjects];
                        [huJiSheQu_name_array removeAllObjects];
                        
                        for (NSDictionary * dict in data) {
                            NSString * code=[dict objectForKey:@"code"];
                            NSString * name=[dict objectForKey:@"name"];
                            
                            [huJiSheQu_code_dict setValue:code forKey:name];
                            [huJiSheQu_name_dict setValue:name forKey:code];
                            [huJiSheQu_name_array addObject:name];
                        }
                        
                        [self showPickview:24*1000];
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









#pragma mark - 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：必填项，须按被访者性别如实填写"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：民族须以被访者身份证或户口本中的信息为准，如实填写。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：选择最恰当描述申请人婚姻状况的答案。如果申请人曾经丧偶或离婚，但已经再婚，选择“（2）已婚”"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90007:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90008:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：确定与申请人沟通是否可以使用汉语普通话，用于后续服务计划中人员安排和跟进沟通。"];
            
            [modal show];
        }
            break;
            
        case 90009:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：必填项，须以被访者身份证/户口本中的信息为准，如实填写。"];
            
            [modal show];
        }
            break;
            
        case 90010:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：向申请人及照护者提问，逐级记录申请人现在居住地址的信息，也可征得对方同意，查看最近在本地址收到的邮寄物品（例如账单）收件人地址信息，予以确认。\n\n记录：须按被访者现住址如实填写，填写后须向被访者进行确认，确保填写准确无误。"];
            
            [modal show];
        }
            break;
            
        case 90011:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须向被访者询问其真实住宅电话，如实填写，无需填写区号，直接填写电话号码为7或8位数字。填写后须向被访者进行确认，确保填写准确无误。"];
            
            [modal show];
        }
            break;
            
        case 90012:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须向被访者询问其真实移动电话，如实填写，直接填写11位数字号码。填写后须向被访者进行确认，确保填写准确无误。"];
            
            [modal show];
        }
            break;
            
        case 90013:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：邮政编码体现着申请人现在常住地址的所属社区或区域信息，可用于后续转诊至综合医院、康复机构、养老机构等的服务安排。\n\n方法：向申请人及照护者提问，逐个数字完整记录其现在居住地址的邮政编码，也可征得对方同意，查看最近在本地址收到的邮寄物品（例如账单）收件人地址信息中的邮政编码，予以确认。\n\n记录：须按被访者现住址如实填写。填写后续向被访者进行确认，确保填写准确无误。"];
            
            [modal show];
        }
            break;
            
        case 90014:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须向被访者询问其最常用电子邮箱，如实填写。填写后须向被访者进行确认，确保填写准确无误。如没有可以不用填写。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
    
}




#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    if ([groupId isEqualToString:@"xingBie"]) {
        my_xingBie=[NSString stringWithFormat:@"%ld",radio.tag-3000];
    }
    if ([groupId isEqualToString:@"zhongJiaoXY"]) {
        if (radio.tag-4000==0) {
            my_xinYangJP_Label.userInteractionEnabled=YES;
        } else {
            my_xinYangJP_Label.userInteractionEnabled=NO;
            my_xinYangJP_Label.text=@"";
        }
        my_zhongJiaoXY=[NSString stringWithFormat:@"%ld",radio.tag-4000];
    }
    if ([groupId isEqualToString:@"hunYinZK"]) {
        my_hunYinZK=[NSString stringWithFormat:@"%ld",radio.tag-5000];
    }
    if ([groupId isEqualToString:@"wenHuaCD"]) {
        my_wenHuaCD=[NSString stringWithFormat:@"%ld",radio.tag-6000];
    }
    if ([groupId isEqualToString:@"shiYongYY"]) {
        my_shiYongYY=[NSString stringWithFormat:@"%ld",radio.tag-7000];
    }
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_xingBie]) {
#pragma mark - 性别
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“性别”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:shengRi_Label.text]) {
#pragma mark - 生日
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“出生日期”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_minZu_Label.text]) {
#pragma mark - 民族
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“民族”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_zhongJiaoXY]) {
#pragma mark - 宗教信仰
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“宗教信仰”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([my_zhongJiaoXY intValue]==0 && [PublicFunction isBlankString:my_xinYangJP_Label.text]) {
#pragma mark - 信仰教派
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“信仰教派”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_hunYinZK]) {
#pragma mark - 婚姻
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“婚姻状况”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_wenHuaCD]) {
#pragma mark - 文化
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“文化程度”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_jiGuanSheng_Label.text]) {
#pragma mark - 籍贯省
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“籍贯(省)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }
//    else if ([PublicFunction isBlankString:my_jiGuanShi_Label.text]) {
//#pragma mark - 籍贯市
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“籍贯(市)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//        
//    }
    else if ([PublicFunction isBlankString:my_shiYongYY]) {
#pragma mark - 使用语言
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“使用语言”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_huJiSheng_Label.text]) {
#pragma mark - 户籍省
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“户籍地址(省)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_huJiShi_Label.text]) {
#pragma mark - 户籍 市
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“户籍地址(市)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_huJiQu_Label.text]) {
#pragma mark - 户籍 区
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“户籍地址(区县)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_huJiJie_Label.text]) {
#pragma mark - 户籍 街
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“户籍地址(街道)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:huJiAddress_Field.text]) {
#pragma mark - 户籍 详细
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“户籍地址(详细)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_juZhuJie_Label.text]) {
#pragma mark - 居住 街
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“居住地址(街道)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:juZhuAddress_Field.text]) {
#pragma mark - 居住 详细
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“居住地址(详细)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_juZhuSheQu_Label.text]) {
#pragma mark - 居住 社区
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“居住地址(社区)”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
        
    }else {
        //更新 个人信息
        [self update_GeRenXX];
    }
    
}




//更新 个人信息
-(void)update_GeRenXX
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"2" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
#pragma mark - 性别
    if (![PublicFunction isBlankString:my_xingBie]) {
        [parameter setObject:my_xingBie forKey:@"xingBie"];
    }
#pragma mark - 生日
    if (![PublicFunction isBlankString:shengRi_Label.text]) {
        [parameter setObject:shengRi_Label.text forKey:@"chuShengRQ"];
    }
#pragma mark - 民族
    if (![PublicFunction isBlankString:my_minZu_Label.text]) {
        [parameter setObject:my_minZu_Label.text forKey:@"minZu"];
    }
#pragma mark - 宗教
    if (![PublicFunction isBlankString:my_zhongJiaoXY]) {
        if ([my_zhongJiaoXY intValue]==1) {
            [parameter setObject:my_zhongJiaoXY forKey:@"zhongJiaoXY"];
        } else {
            [parameter setObject:[NSString stringWithFormat:@"X%@",my_xinYangJP_Label.text] forKey:@"zhongJiaoXY"];
        }
    }
#pragma mark - 婚姻
    if (![PublicFunction isBlankString:my_hunYinZK]) {
        [parameter setObject:my_hunYinZK forKey:@"hunYinZK"];
    }
#pragma mark - 文化
    if (![PublicFunction isBlankString:my_wenHuaCD]) {
        [parameter setObject:my_wenHuaCD forKey:@"wenHuaCD"];
    }
    
    
#pragma mark - 籍贯省
    if (![PublicFunction isBlankString:my_jiGuanSheng_Label.text]) {
        if (Sheng_code_dict.count!=0) {
            [parameter setObject:[Sheng_code_dict objectForKey:my_jiGuanSheng_Label.text] forKey:@"jiGuanSheng"];
        }
    }
#pragma mark - 籍贯市
    if (![PublicFunction isBlankString:my_jiGuanShi_Label.text]) {
        if (jiGuanShi_code_dict.count!=0) {
            [parameter setObject:[jiGuanShi_code_dict objectForKey:my_jiGuanShi_Label.text] forKey:@"jiGuanShi"];
        }
    }
    
    
#pragma mark - 使用语言
    if (![PublicFunction isBlankString:my_shiYongYY]) {
        [parameter setObject:my_shiYongYY forKey:@"shiYongYY"];
    }
    
    
#pragma mark - 户籍省
    if (![PublicFunction isBlankString:my_huJiSheng_Label.text]) {
        if (Sheng_code_dict.count!=0) {
            [parameter setObject:[Sheng_code_dict objectForKey:my_huJiSheng_Label.text] forKey:@"huJiSheng"];
        }
    }
#pragma mark - 户籍 市
    if (![PublicFunction isBlankString:my_huJiShi_Label.text]) {
        if (huJiShi_code_dict.count!=0) {
            [parameter setObject:[huJiShi_code_dict objectForKey:my_huJiShi_Label.text] forKey:@"huJiShi"];
        }
    }
#pragma mark - 户籍 区
    if (![PublicFunction isBlankString:my_huJiQu_Label.text]) {
        if (huJiQu_code_dict.count!=0) {
            [parameter setObject:[huJiQu_code_dict objectForKey:my_huJiQu_Label.text] forKey:@"huJiQu"];
        }
    }
#pragma mark - 户籍 街
    if (![PublicFunction isBlankString:my_huJiJie_Label.text]) {
        if (huJiJie_code_dict.count!=0) {
            [parameter setObject:[huJiJie_code_dict objectForKey:my_huJiJie_Label.text] forKey:@"huJiJie"];
        }
    }
#pragma mark - 户籍 社区
    if (![PublicFunction isBlankString:my_huJiSheQu_Label.text]) {
        if (huJiSheQu_code_dict.count!=0) {
            [parameter setObject:[huJiSheQu_code_dict objectForKey:my_huJiSheQu_Label.text] forKey:@"huJiSheQu"];
        }
    }
#pragma mark - 户籍 详细地址
    if (![PublicFunction isBlankString:huJiAddress_Field.text]) {
        [parameter setObject:huJiAddress_Field.text forKey:@"huJiAddress"];
    }
    
    
    
#pragma mark - 居住 省
    if (![PublicFunction isBlankString:juZhuSheng_Field.text]) {
        [parameter setObject:@"11" forKey:@"juZhuSheng"];
    }
#pragma mark - 居住 市
    if (![PublicFunction isBlankString:juZhuShi_Field.text]) {
        [parameter setObject:@"1101" forKey:@"juZhuShi"];
    }
#pragma mark - 居住 区县
    if (![PublicFunction isBlankString:juZhuQu_Field.text]) {
        [parameter setObject:@"110108" forKey:@"juZhuQu"];
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
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] intValue]==1) {
                
                //目前生活状况 已采集
                if (![PublicFunction isBlankString:_muQianZKModel.jingJiLY] && ![PublicFunction isBlankString:_muQianZKModel.ziJinKN]) {
                    //婚姻状况 修改
                    if (hunYinZK!=[my_hunYinZK intValue]) {
                        //更新 目前生活状况
                        [self update_MuQianZK];
                    }
                }
                
                
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





//更新 目前生活状况
-(void)update_MuQianZK
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"4" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    
    [parameter setObject:@"" forKey:@"juZhuQK"];
    
    if (![PublicFunction isBlankString:_muQianZKModel.jingJiLY]) {
        [parameter setObject:_muQianZKModel.jingJiLY forKey:@"jingJiLY"];
    }

    [parameter setObject:@"" forKey:@"tongZhuPO"];
    
    if (![PublicFunction isBlankString:_muQianZKModel.ziJinKN]) {
        [parameter setObject:_muQianZKModel.ziJinKN forKey:@"ziJinKN"];
    }
    
    if (![PublicFunction isBlankString:_muQianZKModel.juZhuHJ]) {
        [parameter setObject:_muQianZKModel.juZhuHJ forKey:@"juZhuHJ"];
    }
    
    if (![PublicFunction isBlankString:_muQianZKModel.yiLiaoZF]) {
        [parameter setObject:_muQianZKModel.yiLiaoZF forKey:@"yiLiaoZF"];
    }
    
    if (![PublicFunction isBlankString:_muQianZKModel.qiTaZK]) {
        [parameter setObject:_muQianZKModel.qiTaZK forKey:@"qiTaZK"];
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

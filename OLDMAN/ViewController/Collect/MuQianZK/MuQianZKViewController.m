//
//  MuQianZKViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "MuQianZKViewController.h"
#import "MuQianZKModel.h"
#import "GeRenXXModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QCheckBox.h"//复选

#import "QRadioButton.h"//单选

@interface MuQianZKViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * juZhuQK_Title_Array;//居住情况 标题数组
    
    NSString * my_juZhuQK;//居住情况 选项
    
    UITextField * juZhuQKQT_Field;//居住情况(其他)
    
    
    
    
    NSArray * jingJiLY_Title_Array;//经济来源 标题数组
    
    NSMutableDictionary * my_jingJiLY_Dict;//经济来源 选项
    
    UITextField * jingJiLYQT_Field;//经济来源(其他)
    
    
    
    UIView * tongZhuPO_View;//配偶健康状况
    
    NSArray * tongZhuPO_Title_Array;//配偶健康状况 标题数组
    
    NSString * my_tongZhuPO;//配偶健康状况
    
    UITextField * tongZhuPOQT_Field;//配偶健康状况(其他)
    
    
    
    NSArray * ziJinKN_Title_Array;//资金困难 标题数组
    
    NSMutableDictionary * my_ziJinKN_Dict;//资金困难 选项
    
    
    
    NSArray * juZhuHJ_Title_Array;//居住环境 标题数组
    
    NSMutableDictionary * my_juZhuHJ_Dict;//居住环境 选项
    
    
    
    NSArray * yiLiaoZF_Title_Array;//医疗支付 标题数组
    
    NSString * my_yiLiaoZF;//医疗支付
    
    UITextField * yiLiaoZFQT_Field;//医疗支付(其他)
    
    
    
    NSArray * qiTaZK_Title_Array;//其他状况 标题数组
    
    NSMutableDictionary * my_qiTaZK_Dict;//其他状况 选项
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    
    GeRenXXModel * _geRenXXModel;//个人信息
    
    MuQianZKModel * _muQianZKModel;//数据源
}

@end

@implementation MuQianZKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    //实列化
    my_jingJiLY_Dict=[[NSMutableDictionary alloc]init];//经济来源 选项
    
    my_ziJinKN_Dict=[[NSMutableDictionary alloc]init];//资金困难 选项
    
    my_juZhuHJ_Dict=[[NSMutableDictionary alloc]init];//居住环境 选项
    
    my_qiTaZK_Dict=[[NSMutableDictionary alloc]init];//其他状况 选项
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}


//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _geRenXXModel=[[GeRenXXModel alloc]init];//个人信息
    
    _muQianZKModel=[[MuQianZKModel alloc]init];//数据源
    //请求个人信息
    [self load_geRenXX_Data];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _geRenXXModel=nil;
    
    _muQianZKModel=nil;
    
    [my_jingJiLY_Dict removeAllObjects];
    [my_ziJinKN_Dict removeAllObjects];
    [my_juZhuHJ_Dict removeAllObjects];
    [my_qiTaZK_Dict removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}

#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //居住情况 标题数组
    juZhuQK_Title_Array=@[@"独自居住（独居）",@"与配偶同住（空巢）",@"与父母同住（纯老年家庭）",@"与子女同住",@"与配偶及子女同住",@"与其他亲属同住",@"与保姆同住",@"住养老机构",@"其他"];
    
    //经济来源 标题数组
    jingJiLY_Title_Array=@[@"退休金／养老金",@"子女补贴",@"亲友资助",@"低保费",@"残疾补助",@"其他补贴"];
    
    //配偶健康状况 标题数组
    tongZhuPO_Title_Array=@[@"不佳",@"很糟糕",@"独立照护配偶",@"子女帮助照护配偶",@"需要外部帮助",@"其他"];
    
    //资金困难 标题数组
    ziJinKN_Title_Array=@[@"充足的食物",@"就医",@"处方药",@"必需的居家看护"];
    
    //居住环境 标题数组
    juZhuHJ_Title_Array=@[@"晚上的灯光不足或没有照明，包括客厅，卧室，厨房，卫生间，走廊",@"老年人经常行走的地面走道有破损、电线或小地毯",@"浴室和厕所开关失灵，管道漏水，浴缸不防滑，户外厕所",@"厨房炉灶处于危险工作状态，无冰箱／无法正常工作，鼠害虫害侵扰",@"冷热水水温控制困难／无法正常使用",@"楼房无电梯",@"老年人进出家门或房间困难，包括台阶、门栏货或楼梯"];
    
    //医疗支付 标题数组
    yiLiaoZF_Title_Array=@[@"城镇职工基本医疗保险",@"城镇居民基本医疗保险",@"新型农村合作医疗",@"贫困救助",@"商业医疗保险",@"全公费",@"全自费",@"其他"];
    
    //其他状况
    qiTaZK_Title_Array=@[@"害怕家人或照顾者",@"异常恶劣的卫生条件",@"不明原因的损伤、骨折或烧伤",@"被疏于照顾或被虐待",@"物理约束（例如，肢体约束、使用床栏或在坐下时使用约束带）"];
}


#pragma mark 请求个人信息
-(void)load_geRenXX_Data
{
    //请求数据
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"2"];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_geRenXXModel setValuesForKeysWithDictionary:returnValue[@"data"]];
                
                if ([PublicFunction isBlankString:_geRenXXModel.hunYinZK]) {
                    
                    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请选择“婚姻状况”" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alertview.tag=30000;
                    [alertview show];
                    
                } else {
                    
                    //请求数据
                    [self loadData];
                }
                
            } else {
                
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请选择“婚姻状况”" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertview.tag=30000;
                [alertview show];
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


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"4"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_muQianZKModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"目前生活状况";
    
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
        
        //当婚姻状况为 0 2 3 4 时，不能 选居住情况的 1 4项 ，婚姻状况为 1 5 时 不限
        if ([_geRenXXModel.hunYinZK intValue]!=1 && [_geRenXXModel.hunYinZK intValue]!=5) {
            if (i==1 || i==4) {
                xuanXiang_Button.userInteractionEnabled=NO;
            }
        }
        
        xuanXiang_Button.tag=3000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.juZhuQK]) {
            if ([[_muQianZKModel.juZhuQK substringToIndex:1] isEqualToString:@"X"]) {
                if (i==juZhuQK_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_muQianZKModel.juZhuQK intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [juZhuQK_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=juZhuQK_Title_Array[i];
        
        
        //当婚姻状况为 0 2 3 4 时，不能 选居住情况的 1 4项 ，婚姻状况为 1 5 时 不限
        if ([_geRenXXModel.hunYinZK intValue]!=1 && [_geRenXXModel.hunYinZK intValue]!=5) {
            if (i==1 || i==4) {
                xuanXiang_Label.textColor=MuQianZK_xuanXiang_Label_color;
            }
        }
    
        juZhuQK_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    juZhuQK_View.frame = CGRectMake(0, 20, WIDTH, juZhuQK_View_frame_origin_y);

    
    
    //居住情况 签字框
    juZhuQKQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuQK_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juZhuQKQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juZhuQKQT_Field];
    juZhuQKQT_Field.delegate=self;
    juZhuQKQT_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_muQianZKModel.juZhuQK]) {
        if ([[_muQianZKModel.juZhuQK substringToIndex:1] isEqualToString:@"X"]) {
            juZhuQKQT_Field.userInteractionEnabled=YES;
            juZhuQKQT_Field.text=[_muQianZKModel.juZhuQK substringFromIndex:1];
        }
    }
    
    
    
    
    
    
    
    //经济来源 标题数组
    UIView * jingJiLY_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(juZhuQKQT_Field.frame)+20, WIDTH, 24*(jingJiLY_Title_Array.count+1))];
    [RootScrollView addSubview:jingJiLY_View];
    
    //经济来源 标题
    UILabel * jingJiLY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"2. 经济来源"];
    [jingJiLY_View addSubview:jingJiLY_Label];
    jingJiLY_Label.textColor=Title_text_color;
    
    //经济来源 介绍
    UIButton * jingJiLY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(jingJiLY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [jingJiLY_View addSubview:jingJiLY_Button];
    jingJiLY_Button.tag=90001;
    
    //请求数据 数组
    NSArray * jingJiLY_strArray;
    if (![PublicFunction isBlankString:_muQianZKModel.jingJiLY]) {
        jingJiLY_strArray=[_muQianZKModel.jingJiLY componentsSeparatedByString:@","];
    }
    
    //起始高度
    float jingJiLY_View_frame_origin_y=CGRectGetMaxY(jingJiLY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<jingJiLY_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, jingJiLY_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [jingJiLY_View addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=4000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.jingJiLY]) {
            int n=0;
            for (int j=0; j<jingJiLY_strArray.count; j++) {
                if (![PublicFunction isBlankString:jingJiLY_strArray[j]]) {
                    if (![[jingJiLY_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
                        if ([jingJiLY_strArray[j] intValue]==i) {
                            [xuanXiang_Check setChecked:YES];
                        }
                        n++;
                    } else {
                        if (i==jingJiLY_Title_Array.count-1) {
                            [xuanXiang_Check setChecked:YES];
                        }
                        break;
                    }
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [jingJiLY_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=jingJiLY_Title_Array[i];
    
        jingJiLY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    jingJiLY_View.frame = CGRectMake(0, CGRectGetMaxY(juZhuQKQT_Field.frame)+20, WIDTH, jingJiLY_View_frame_origin_y);
    
    

    
    //经济来源 签字框
    jingJiLYQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(jingJiLY_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    jingJiLYQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:jingJiLYQT_Field];
    jingJiLYQT_Field.delegate=self;
    jingJiLYQT_Field.userInteractionEnabled=NO;
    
    
    if (![PublicFunction isBlankString:_muQianZKModel.jingJiLY]) {
        int n=0;
        NSString * qiTa=@"";
        for (int j=0; j<jingJiLY_strArray.count; j++) {
            if (![PublicFunction isBlankString:jingJiLY_strArray[j]]) {
                if (![[jingJiLY_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
                    n++;
                } else {
                    jingJiLYQT_Field.userInteractionEnabled=YES;
                    break;
                }
            }
        }
        for (int j=n; j<jingJiLY_strArray.count; j++) {
            if (![PublicFunction isBlankString:jingJiLY_strArray[j]]) {
                if (j!=jingJiLY_strArray.count-1) {
                    qiTa=[qiTa stringByAppendingFormat:@"%@,",jingJiLY_strArray[j]];
                } else {
                    qiTa=[qiTa stringByAppendingFormat:@"%@",jingJiLY_strArray[j]];
                }
            }
        }
        if (![PublicFunction isBlankString:qiTa]) {
            jingJiLYQT_Field.text=[qiTa substringFromIndex:1];
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    //配偶健康状况 标题数组
    tongZhuPO_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(jingJiLYQT_Field.frame)+20, WIDTH, 24*(tongZhuPO_Title_Array.count+1))];
    [RootScrollView addSubview:tongZhuPO_View];
    
    //配偶健康状况 标题
    UILabel * tongZhuPO_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"3. 配偶健康状况"];
    [tongZhuPO_View addSubview:tongZhuPO_Label];
    tongZhuPO_Label.textColor=Title_text_color;
    
    //配偶健康状况 介绍
    UIButton * tongZhuPO_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(tongZhuPO_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [tongZhuPO_View addSubview:tongZhuPO_Button];
    tongZhuPO_Button.tag=90002;
    
    //起始高度
    float tongZhuPO_View_frame_origin_y=CGRectGetMaxY(tongZhuPO_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<tongZhuPO_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"tongZhuPO"];
        [tongZhuPO_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, tongZhuPO_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=YES;
        
        //当婚姻状况为 0 2 3 4 时，配偶健康状况 只能选 5 项 ，婚姻状况为 1 5 时 不限
        if ([_geRenXXModel.hunYinZK intValue]!=1 && [_geRenXXModel.hunYinZK intValue]!=5) {
            if (i!=5) {
                xuanXiang_Button.userInteractionEnabled=NO;
            }
        }
        
        
        xuanXiang_Button.tag=5000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.tongZhuPO]) {
            if ([[_muQianZKModel.tongZhuPO substringToIndex:1] isEqualToString:@"X"]) {
                if (i==tongZhuPO_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_muQianZKModel.tongZhuPO intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [tongZhuPO_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=tongZhuPO_Title_Array[i];
        
        
        //当婚姻状况为 0 2 3 4 时，配偶健康状况 只能选 5 项 ，婚姻状况为 1 5 时 不限
        if ([_geRenXXModel.hunYinZK intValue]!=1 && [_geRenXXModel.hunYinZK intValue]!=5) {
            if (i!=5) {
                xuanXiang_Label.textColor=MuQianZK_xuanXiang_Label_color;
            }
        }
        
   
        tongZhuPO_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    tongZhuPO_View.frame = CGRectMake(0, CGRectGetMaxY(jingJiLYQT_Field.frame)+20, WIDTH, tongZhuPO_View_frame_origin_y);

    
    
    //配偶健康状况 签字框
    tongZhuPOQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(tongZhuPO_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    tongZhuPOQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:tongZhuPOQT_Field];
    tongZhuPOQT_Field.delegate=self;
    tongZhuPOQT_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_muQianZKModel.tongZhuPO]) {
        if ([[_muQianZKModel.tongZhuPO substringToIndex:1] isEqualToString:@"X"]) {
            tongZhuPOQT_Field.userInteractionEnabled=YES;
            tongZhuPOQT_Field.text=[_muQianZKModel.tongZhuPO substringFromIndex:1];
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //资金困难 标题数组
    UIView * ziJinKN_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(tongZhuPOQT_Field.frame)+20, WIDTH, 24*(ziJinKN_Title_Array.count+1))];
    [RootScrollView addSubview:ziJinKN_View];
    
    //资金困难 标题
    UILabel * ziJinKN_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:nil];
    [ziJinKN_View addSubview:ziJinKN_Label];
    ziJinKN_Label.textColor=Title_text_color;
    ziJinKN_Label.numberOfLines=0;
    
    NSString * labelText = @"4. 资金困难(在过去一个月内，由于资金问题导致未能获得必要的)";
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    ziJinKN_Label.attributedText = attributedString;
    [ziJinKN_Label sizeToFit];
    
    //资金困难 介绍
    UIButton * ziJinKN_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(ziJinKN_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [ziJinKN_View addSubview:ziJinKN_Button];
    ziJinKN_Button.tag=90003;
    
    //请求数据 数组
    NSArray * ziJinKN_strArray;
    if (![PublicFunction isBlankString:_muQianZKModel.ziJinKN]) {
        ziJinKN_strArray=[_muQianZKModel.ziJinKN componentsSeparatedByString:@","];
    }
    
    //起始高度
    float ziJinKN_View_frame_origin_y=CGRectGetMaxY(ziJinKN_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<ziJinKN_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, ziJinKN_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [ziJinKN_View addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=6000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.ziJinKN]) {
            for (int j=0; j<ziJinKN_strArray.count; j++) {
                if ([ziJinKN_strArray[j] intValue]==i) {
                    [xuanXiang_Check setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [ziJinKN_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=ziJinKN_Title_Array[i];
        
        ziJinKN_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    ziJinKN_View.frame = CGRectMake(0, CGRectGetMaxY(tongZhuPOQT_Field.frame)+20, WIDTH, ziJinKN_View_frame_origin_y);
    
    
    
    
    
    
    
    
    
    //居住环境 标题数组
    UIView * juZhuHJ_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(ziJinKN_View.frame)+20, WIDTH, 40)];
    [RootScrollView addSubview:juZhuHJ_View];
    
    //居住环境 标题
    UILabel * juZhuHJ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"5. 居住环境"];
    [juZhuHJ_View addSubview:juZhuHJ_Label];
    juZhuHJ_Label.textColor=Title_text_color;
    
    //居住环境 介绍
    UIButton * juZhuHJ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(juZhuHJ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [juZhuHJ_View addSubview:juZhuHJ_Button];
    juZhuHJ_Button.tag=90004;
    
    //起始高度
    float juZhuHJ_View_frame_origin_y=CGRectGetMaxY(juZhuHJ_Label.frame)+Q_ICON_HE;
    
    //请求数据 数组
    NSArray * juZhuHJ_strArray;
    if (![PublicFunction isBlankString:_muQianZKModel.juZhuHJ]) {
        juZhuHJ_strArray=[_muQianZKModel.juZhuHJ componentsSeparatedByString:@","];
    }
    
    for (int i=0; i<juZhuHJ_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, juZhuHJ_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [juZhuHJ_View addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=7000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.juZhuHJ]) {
            for (int j=0; j<juZhuHJ_strArray.count; j++) {
                if ([juZhuHJ_strArray[j] intValue]==i) {
                    [xuanXiang_Check setChecked:YES];
                }
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [juZhuHJ_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        
        NSString * labelText = juZhuHJ_Title_Array[i];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:Answer_HE];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        xuanXiang_Label.attributedText = attributedString;
        [xuanXiang_Label sizeToFit];
        juZhuHJ_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Label.frame)+Q_ICON_HE;
    }
    
    juZhuHJ_View.frame = CGRectMake(0, CGRectGetMaxY(ziJinKN_View.frame)+20, WIDTH, juZhuHJ_View_frame_origin_y);
    
    
    
    
    
    
    //医疗支付 标题数组
    UIView * yiLiaoZF_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(juZhuHJ_View.frame)+20, WIDTH, 24*(yiLiaoZF_Title_Array.count+1))];
    [RootScrollView addSubview:yiLiaoZF_View];
    
    //医疗支付 标题
    UILabel * yiLiaoZF_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"6. 医疗支付"];
    [yiLiaoZF_View addSubview:yiLiaoZF_Label];
    yiLiaoZF_Label.textColor=Title_text_color;
    
    //医疗支付 介绍
    UIButton * yiLiaoZF_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yiLiaoZF_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [juZhuQK_View addSubview:yiLiaoZF_Button];
    yiLiaoZF_Button.tag=90005;
    
    //起始高度
    float yiLiaoZF_View_frame_origin_y=CGRectGetMaxY(yiLiaoZF_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<yiLiaoZF_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"yiLiaoZF"];
        [yiLiaoZF_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, yiLiaoZF_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=8000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.yiLiaoZF]) {
            if ([[_muQianZKModel.yiLiaoZF substringToIndex:1] isEqualToString:@"X"]) {
                if (i==yiLiaoZF_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_muQianZKModel.yiLiaoZF intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [yiLiaoZF_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=yiLiaoZF_Title_Array[i];
    
        yiLiaoZF_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    yiLiaoZF_View.frame = CGRectMake(0, CGRectGetMaxY(juZhuHJ_View.frame)+20, WIDTH, yiLiaoZF_View_frame_origin_y);
    
    

    
    //医疗支付 签字框
    yiLiaoZFQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(yiLiaoZF_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    yiLiaoZFQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:yiLiaoZFQT_Field];
    yiLiaoZFQT_Field.delegate=self;
    yiLiaoZFQT_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_muQianZKModel.yiLiaoZF]) {
        if ([[_muQianZKModel.yiLiaoZF substringToIndex:1] isEqualToString:@"X"]) {
            yiLiaoZFQT_Field.userInteractionEnabled=YES;
            yiLiaoZFQT_Field.text=[_muQianZKModel.yiLiaoZF substringFromIndex:1];
        }
    }
    
    
    
    
    
    
    //其他状况
    UIView * qiTaZK_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(yiLiaoZFQT_Field.frame)+20, WIDTH, 24*(qiTaZK_Title_Array.count+1))];
    [RootScrollView addSubview:qiTaZK_View];
    
    //其他状况 标题
    UILabel * qiTaZK_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"7. 其他状况"];
    [qiTaZK_View addSubview:qiTaZK_Label];
    qiTaZK_Label.textColor=Title_text_color;
    
    //其他状况 介绍
    UIButton * qiTaZK_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(qiTaZK_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [qiTaZK_View addSubview:qiTaZK_Button];
    qiTaZK_Button.tag=90006;
    
    //起始高度
    float qiTaZK_View_frame_origin_y=CGRectGetMaxY(qiTaZK_Label.frame)+Q_ICON_HE;
    
    //请求数据 数组
    NSArray * qiTaZK_strArray;
    if (![PublicFunction isBlankString:_muQianZKModel.qiTaZK]) {
        qiTaZK_strArray=[_muQianZKModel.qiTaZK componentsSeparatedByString:@","];
    }
    
    for (int i=0; i<qiTaZK_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, qiTaZK_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [qiTaZK_View addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=9000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.qiTaZK]) {
            for (int j=0; j<qiTaZK_strArray.count; j++) {
                if ([qiTaZK_strArray[j] intValue]==i) {
                    [xuanXiang_Check setChecked:YES];
                }
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame)-1, WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [qiTaZK_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        
        NSString * labelText = qiTaZK_Title_Array[i];
        
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:Answer_HE];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        xuanXiang_Label.attributedText = attributedString;
        [xuanXiang_Label sizeToFit];
        
        qiTaZK_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Label.frame)+Q_ICON_HE;
    }
    
    qiTaZK_View.frame = CGRectMake(0, CGRectGetMaxY(yiLiaoZFQT_Field.frame)+20, WIDTH, qiTaZK_View_frame_origin_y);
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(qiTaZK_View.frame)+20);
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
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(qiTaZK_View.frame)+20+Tabbar_HE);
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



#pragma mark - 配偶健康状况 不限
-(void)create_tongZhuPO_View
{
    //配偶健康状况 标题数组
    tongZhuPO_Title_Array=@[@"不佳",@"很糟糕",@"独立照护配偶",@"子女帮助照护配偶",@"需要外部帮助",@"其他"];
    tongZhuPO_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(jingJiLYQT_Field.frame)+20, WIDTH, 24*(tongZhuPO_Title_Array.count+1))];
    [RootScrollView addSubview:tongZhuPO_View];
    
    //配偶健康状况 标题
    UILabel * tongZhuPO_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"3. 配偶健康状况"];
    [tongZhuPO_View addSubview:tongZhuPO_Label];
    tongZhuPO_Label.textColor=Title_text_color;
    
    //配偶健康状况 介绍
    UIButton * tongZhuPO_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(tongZhuPO_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [tongZhuPO_View addSubview:tongZhuPO_Button];
    tongZhuPO_Button.tag=90002;
    
    //起始高度
    float tongZhuPO_View_frame_origin_y=CGRectGetMaxY(tongZhuPO_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<tongZhuPO_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"tongZhuPO"];
        [tongZhuPO_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, tongZhuPO_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=YES;
        
        
        xuanXiang_Button.tag=5000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.tongZhuPO]) {
            if ([[_muQianZKModel.tongZhuPO substringToIndex:1] isEqualToString:@"X"]) {
                if (i==tongZhuPO_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_muQianZKModel.tongZhuPO intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [tongZhuPO_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=tongZhuPO_Title_Array[i];
    
        tongZhuPO_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    tongZhuPO_View.frame = CGRectMake(0, CGRectGetMaxY(jingJiLYQT_Field.frame)+20, WIDTH, tongZhuPO_View_frame_origin_y);
}


#pragma mark - 配偶健康状况  只能选 其他
-(void)create_tongZhuPO_QT_View
{
    //配偶健康状况 标题数组
    tongZhuPO_Title_Array=@[@"不佳",@"很糟糕",@"独立照护配偶",@"子女帮助照护配偶",@"需要外部帮助",@"其他"];
    tongZhuPO_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(jingJiLYQT_Field.frame)+20, WIDTH, 24*(tongZhuPO_Title_Array.count+1))];
    [RootScrollView addSubview:tongZhuPO_View];
    
    //配偶健康状况 标题
    UILabel * tongZhuPO_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"3. 配偶健康状况"];
    [tongZhuPO_View addSubview:tongZhuPO_Label];
    tongZhuPO_Label.textColor=Title_text_color;
    
    //配偶健康状况 介绍
    UIButton * tongZhuPO_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(tongZhuPO_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [tongZhuPO_View addSubview:tongZhuPO_Button];
    tongZhuPO_Button.tag=90002;
    
    //起始高度
    float tongZhuPO_View_frame_origin_y=CGRectGetMaxY(tongZhuPO_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<tongZhuPO_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"tongZhuPO"];
        [tongZhuPO_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, tongZhuPO_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=NO;
        
        if (i==5) {
            xuanXiang_Button.userInteractionEnabled=YES;
        }
        
        
        xuanXiang_Button.tag=5000+i;
        
        if (![PublicFunction isBlankString:_muQianZKModel.tongZhuPO]) {
            if ([[_muQianZKModel.tongZhuPO substringToIndex:1] isEqualToString:@"X"]) {
                if (i==tongZhuPO_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_muQianZKModel.tongZhuPO intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [tongZhuPO_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=tongZhuPO_Title_Array[i];
        
        if (i!=5) {
            xuanXiang_Label.textColor=MuQianZK_xuanXiang_Label_color;
        }
    
        tongZhuPO_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    tongZhuPO_View.frame = CGRectMake(0, CGRectGetMaxY(jingJiLYQT_Field.frame)+20, WIDTH, tongZhuPO_View_frame_origin_y);
}




#pragma mark - 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：如没有合适选项，请选“其他”并在横线处注明实际居住情况。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：“子女补贴”和“亲友资助”中，间断性的慰问金、红包等不计入经济来源。\n\n记录：如有其他未列入情况，请选“（6）其他来源”并在横线处标明实际情况（例：兼职经营）。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：\n\n不佳：处于失能或半失能状况，部分生活起居需要他人照料。\n\n很糟糕：处于卧床或完全失能状况，全部生活起居需要他人照料。\n\n独立照护配偶：指同住配偶自己独立的向申请者（受访老人）提供照护和支持。\n\n子女帮助照护配偶：指子女帮助申请者同住配偶向申请者（受访老人）提供照护和支持。\n\n需要外部帮助：指同住配偶自己向申请者（受访老人）提供照护和支持，但需要外部帮助，如照护技能指导、替换、情绪疏导等。\n\n其他：不符合上述情况，例如正在住院、无同住配偶等。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：在过去1月内，由于资金问题导致未能获得必要的。\n\n记录：通过与被访者进行交谈，按被访者实际情况如实选择。\n\n充足的食物：因为钱不够而存在吃不饱的情况。\n\n就医：因为钱不够而存在有病不能去就医、或者不能彻底医治的情况。\n\n处方药：因为钱不够而存在不能按医嘱买药或不能买足处方分量的药的情况。\n\n必须的居家看护：因为钱不够而在需要雇请居家看护人员的时候无法做到。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：评估人员主要根据对申请人居住环境的观察进行判断，如果要进入评估场地以外的房间，应事先征得申请人/代理人同意。对于无法观察的情况，通过向申请人及照护者提问获取答案。\n\n记录：通过对被访者家庭居住环境的观察及与被访者进行交谈，按被访者居住环境实际情况如实选择。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：其他：如有其他未列明情况，请选“其他”并在横线处注明实际情况。（例：**保险中 断）"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：如果观察或了解到这些情况，应及时向评估机构主管反映，以便进一步调查和安排根据。\n\n记录：通过与被访者沟通观察，按了解情况如实选择。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - 复选
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    
    switch (checkbox.tag/1000) {
        case 4:
        {
            if (checked==1) {
                [my_jingJiLY_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-4000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-4000]];
            } else {
                [my_jingJiLY_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-4000]];
            }
            if (checked==1) {
                if (checkbox.tag-4000==jingJiLY_Title_Array.count-1) {
                    jingJiLYQT_Field.userInteractionEnabled=YES;
                }
            } else {
                jingJiLYQT_Field.userInteractionEnabled=NO;
                jingJiLYQT_Field.text=@"";
            }
        }
            break;
        case 6:
        {
            if (checked==1) {
                [my_ziJinKN_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-6000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-6000]];
            } else {
                [my_ziJinKN_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-6000]];
            }
        }
            break;
        case 7:
        {
            if (checked==1) {
                [my_juZhuHJ_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-7000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-7000]];
            } else {
                [my_juZhuHJ_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-7000]];
            }
        }
            break;
        case 9:
        {
            if (checked==1) {
                [my_qiTaZK_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-9000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-9000]];
            } else {
                [my_qiTaZK_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-9000]];
            }
        }
            break;
        default:
            break;
    }
}







#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    
    if ([groupId isEqualToString:@"juZhuQK"]) {
    
        //当婚姻状况为 0 2 3 4 时，不能 选居住情况的 1 4项 ，婚姻状况为 1 5 时 不限
        if ([_geRenXXModel.hunYinZK intValue]==1 || [_geRenXXModel.hunYinZK intValue]==5) {
            if (![PublicFunction isBlankString:my_juZhuQK]) {
                //居住情况 切换
                if (radio.tag-3000!=[my_juZhuQK intValue]) {
                    //当居住情况为 2 5 时，不限，否则，同住配偶只能选 5 项
                    if (radio.tag-3000!=1 && radio.tag-3000!=4) {
                        [tongZhuPO_View removeFromSuperview];
                        [self create_tongZhuPO_QT_View];
                    } else {
                        [tongZhuPO_View removeFromSuperview];
                        [self create_tongZhuPO_View];
                    }
                }
            }
        }
    
        
        if (radio.tag-3000==juZhuQK_Title_Array.count-1) {
            juZhuQKQT_Field.userInteractionEnabled=YES;
        } else {
            juZhuQKQT_Field.userInteractionEnabled=NO;
            juZhuQKQT_Field.text=@"";
        }
        my_juZhuQK=[NSString stringWithFormat:@"%ld",radio.tag-3000];
    }
    
    if ([groupId isEqualToString:@"tongZhuPO"]) {
        if (radio.tag-5000==tongZhuPO_Title_Array.count-1) {
            tongZhuPOQT_Field.userInteractionEnabled=YES;
        } else {
            tongZhuPOQT_Field.userInteractionEnabled=NO;
            tongZhuPOQT_Field.text=@"";
        }
        my_tongZhuPO=[NSString stringWithFormat:@"%ld",radio.tag-5000];
    }
    
    if ([groupId isEqualToString:@"yiLiaoZF"]) {
        if (radio.tag-8000==yiLiaoZF_Title_Array.count-1) {
            yiLiaoZFQT_Field.userInteractionEnabled=YES;
        } else {
            yiLiaoZFQT_Field.userInteractionEnabled=NO;
            yiLiaoZFQT_Field.text=@"";
        }
        my_yiLiaoZF=[NSString stringWithFormat:@"%ld",radio.tag-8000];
    }
}








#pragma mark - 保存
-(void)Save_Button_Click
{
    
    if ([PublicFunction isBlankString:my_juZhuQK]) {
#pragma mark - 居住情况
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“居住情况”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([my_juZhuQK intValue]==juZhuQK_Title_Array.count-1 && [PublicFunction isBlankString:juZhuQKQT_Field.text]) {
#pragma mark - 居住情况 其他
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“居住情况的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (my_jingJiLY_Dict.count==0) {
#pragma mark - 经济来源
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“经济来源”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isRangeOfString:my_jingJiLY_Dict num:jingJiLY_Title_Array.count-1] && [PublicFunction isBlankString:jingJiLYQT_Field.text]) {
#pragma mark - 经济来源 其他
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“经济来源的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_tongZhuPO]) {
#pragma mark - 配偶健康状况
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“配偶健康状况”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([my_tongZhuPO intValue]==tongZhuPO_Title_Array.count-1 && [PublicFunction isBlankString:tongZhuPOQT_Field.text]) {
#pragma mark - 配偶健康状况 其他
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“配偶健康状况的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_yiLiaoZF]) {
#pragma mark - 医疗支付
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“医疗支付”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([my_yiLiaoZF intValue]==yiLiaoZF_Title_Array.count-1 && [PublicFunction isBlankString:yiLiaoZFQT_Field.text]) {
#pragma mark - 医疗支付 其他
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“医疗支付的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        
        //更新 目前生活状况
        [self update_MuQianZK];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==30000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//更新 目前生活状况
-(void)update_MuQianZK
{
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"4" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    
    
    
    if (![PublicFunction isBlankString:my_juZhuQK]) {
        if ([my_juZhuQK integerValue]==juZhuQK_Title_Array.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",juZhuQKQT_Field.text] forKey:@"juZhuQK"];
        } else {
            [parameter setObject:my_juZhuQK forKey:@"juZhuQK"];
        }
    }
    
    
    
    NSArray * my_jingJiLY_keysArray=[my_jingJiLY_Dict allKeys];
    NSMutableString * my_jingJiLY=[[NSMutableString alloc]init];
    for (NSString * str in my_jingJiLY_keysArray) {
        if ([str intValue]!=jingJiLY_Title_Array.count-1) {
            [my_jingJiLY appendFormat:@"%@,",str];
        }
    }
    for (NSString * str in my_jingJiLY_keysArray) {
        if ([str intValue]==jingJiLY_Title_Array.count-1) {
            [my_jingJiLY appendFormat:@"X%@",jingJiLYQT_Field.text];
        }
    }
    [parameter setObject:my_jingJiLY forKey:@"jingJiLY"];
    
    
    
    if (![PublicFunction isBlankString:my_tongZhuPO]) {
        if ([my_tongZhuPO integerValue]==tongZhuPO_Title_Array.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",tongZhuPOQT_Field.text] forKey:@"tongZhuPO"];
        } else {
            [parameter setObject:my_tongZhuPO forKey:@"tongZhuPO"];
        }
    }
    
    
    
    NSArray * my_ziJinKN_keysArray=[my_ziJinKN_Dict allKeys];
    NSMutableString * my_ziJinKN=[[NSMutableString alloc]init];
    for (int i=0; i<my_ziJinKN_keysArray.count; i++) {
        if (i==my_ziJinKN_keysArray.count-1) {
            [my_ziJinKN appendFormat:@"%@",my_ziJinKN_keysArray[i]];
        } else {
            [my_ziJinKN appendFormat:@"%@,",my_ziJinKN_keysArray[i]];
        }
    }
    [parameter setObject:my_ziJinKN forKey:@"ziJinKN"];
    
    
    
    
    NSArray * my_juZhuHJ_keysArray=[my_juZhuHJ_Dict allKeys];
    NSMutableString * my_juZhuHJ=[[NSMutableString alloc]init];
    for (int i=0; i<my_juZhuHJ_keysArray.count; i++) {
        if (i==my_juZhuHJ_keysArray.count-1) {
            [my_juZhuHJ appendFormat:@"%@",my_juZhuHJ_keysArray[i]];
        } else {
            [my_juZhuHJ appendFormat:@"%@,",my_juZhuHJ_keysArray[i]];
        }
    }
    [parameter setObject:my_juZhuHJ forKey:@"juZhuHJ"];
    
    
    if (![PublicFunction isBlankString:my_yiLiaoZF]) {
        if ([my_yiLiaoZF integerValue]==yiLiaoZF_Title_Array.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",yiLiaoZFQT_Field.text] forKey:@"yiLiaoZF"];
        } else {
            [parameter setObject:my_yiLiaoZF forKey:@"yiLiaoZF"];
        }
    }
    
    
    
    NSArray * my_qiTaZK_keysArray=[my_qiTaZK_Dict allKeys];
    NSMutableString * my_qiTaZK=[[NSMutableString alloc]init];
    for (int i=0; i<my_qiTaZK_keysArray.count; i++) {
        if (i==my_qiTaZK_keysArray.count-1) {
            [my_qiTaZK appendFormat:@"%@",my_qiTaZK_keysArray[i]];
        } else {
            [my_qiTaZK appendFormat:@"%@,",my_qiTaZK_keysArray[i]];
        }
    }
    [parameter setObject:my_qiTaZK forKey:@"qiTaZK"];
    
    
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

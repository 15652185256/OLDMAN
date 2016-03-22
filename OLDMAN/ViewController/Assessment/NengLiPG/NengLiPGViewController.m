//
//  NengLiPGViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/22.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "NengLiPGViewController.h"


#import "NengLiPGModel.h"//能力评估结论

#import "BuChongPGModel.h"//补充评估信息

#import "PingGuJBModel.h"//评估基本信息

#import "ZhuZePGModel.h"//采集人员信息


#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

#import "PopSignUtil.h"//写字框

@interface NengLiPGViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    float nav_height;//导航高度
    
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存按钮
    
    
    
    NSArray * riChangSH_Title_Array;//日常生活分级 标题数组
    
    NSArray * nengLiDJ_Title_Array;//能力等级初评 标题数组
    
    NSArray * dengJiBG_Title_Array;//等级变更依据
    
    
    NSString * my_nengLiDJ;//能力等级初评
    
    NSString * my_dengJiBG;//等级变更依据
    
    NSString * my_nengLiZZ;//能力最终等级
    
    
    
    UITextField * caiJi_xingMing_Field;//采集评估员姓名
    
    UITextField * caiJi_yiDongDH_Field;//采集评估员联系电话
    
    UIButton * caiJi_qianMing_button;//采集评估员 签名
    
    NSString * my_caiJi_qianMing;//采集评估员 签名
    
    
    UITextField * zhuZe_xingMing_Field;//主责评估员姓名
    
    UITextField * zhuZe_yiDongDH_Field;//主责评估员联系电话
    
    UIButton * zhuZe_qianMing_button;//主责评估员 签名
    
    NSString * my_zhuZe_qianMing;//主责评估员 签名
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    NengLiPGModel * _nengLiPGModel;//能力评估结论
    
    BuChongPGModel * _buChongPGModel;//补充评估信息
    
    PingGuJBModel * _pingGuJBModel;//评估基本信息
    
    ZhuZePGModel * _caiJiModel;//采集 信息
    
    ZhuZePGModel * _zhuZeModel;//初审 信息
    
    
}

@end

@implementation NengLiPGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    my_caiJi_qianMing=nil;
    
    my_zhuZe_qianMing=nil;
    
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _pingGuJBModel=[[PingGuJBModel alloc]init];//评估基本信息
    
    _nengLiPGModel=[[NengLiPGModel alloc]init];//能力评估结论
    
    _buChongPGModel=[[BuChongPGModel alloc]init];//评估基本信息
    
    _caiJiModel=[[ZhuZePGModel alloc]init];//采集 信息
    
    _zhuZeModel=[[ZhuZePGModel alloc]init];//初审 信息
    //请求数据
    [self get_pingGuJB_Data];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _pingGuJBModel=nil;
    
    _nengLiPGModel=nil;
    
    _buChongPGModel=nil;
    
    _caiJiModel=nil;
    
    _zhuZeModel=nil;
    
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}

#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //日常生活分级 标题数组
    riChangSH_Title_Array=@[@"能力完好",@"轻度受损",@"中度受损",@"重度受损"];
    
    //能力等级初评 标题数组
    nengLiDJ_Title_Array=@[@"能力完好",@"轻度失能",@"中度失能",@"重度失能"];
    
    //等级变更依据
    dengJiBG_Title_Array=@[@"有认知障碍／痴呆、精神疾病者，在原有能力级别上提高一个等级",@"近30天内发生过2次以上跌倒、噎食、自杀、走失，在原有能力级别上提高一个等级",@"处于昏迷状态者，直接评定为重度失能",@"若初步等级确定为“3重度失能”，则不考虑上述1-3中各情况，等级不再提高"];
}


//状态查询
-(void)get_pingGuJB_Data
{
    
    //请求数据
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"10"];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_pingGuJBModel setValuesForKeysWithDictionary:returnValue[@"data"]];
                
                
                if (![PublicFunction isBlankString:_pingGuJBModel.saiCha]) {
                    if ([_pingGuJBModel.saiCha intValue]==0) {
                        
                        //查询功能等级评估结果
                        [self get_GradeAssessment_Result];
                        
                    } else {
                        
                        my_nengLiDJ=@"3";
                        
                        my_dengJiBG=@"3";
                        
                        my_nengLiZZ=@"3";
                        
                        //获取采集初审终审信息
                        [self get_ServiceUser];
                    }
                    
                } else {
                
                    [KVNProgress dismiss];
                    
                    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"“评估基本信息“采集错误，无法正确算出结果，请重新采集。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alertview.tag=30000;
                    [alertview show];
                }
            } else {
            
                [KVNProgress dismiss];
                
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"“评估基本信息“采集错误，无法正确算出结果，请重新采集。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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





//查询功能等级评估结果
-(void)get_GradeAssessment_Result
{
    NSDictionary * parameter = @{@"shenFenZJ":self.shenFenZJ};
    
    [KVNProgress show];
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getGradeAssessmentResultHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);

        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_nengLiPGModel setValuesForKeysWithDictionary:returnValue[@"data"]];
                
                
                //获取 能力等级初评
                my_nengLiDJ=[PublicFunction getNengLiDJ:_nengLiPGModel.riChangSSHDFJ jingShenZT:_nengLiPGModel.jingShenZTFJ ganZhiJ:_nengLiPGModel.ganZhiJYGTFJ sheHuiCY:_nengLiPGModel.sheHuiCYFJ];
                
                if ([my_nengLiDJ intValue]==-1) {
                    
                    [KVNProgress dismiss];
                    
                    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"“评估信息”采集错误，无法正确算出结果，请重新采集。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alertview.tag=30000;
                    [alertview show];
                    
                } else {
                    
                    //查询补充评估信息
                    [self get_buChongPG];
                }
            } else {
            
                [KVNProgress dismiss];
                
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"“评估信息”采集错误，无法正确算出结果，请重新采集。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertview.tag=30000;
                [alertview show];
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


//查询补充评估信息
-(void)get_buChongPG
{
    //请求数据
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"15"];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_buChongPGModel setValuesForKeysWithDictionary:returnValue[@"data"]];
                
                //获取采集初审终审信息
                [self get_ServiceUser];
                
            } else {
            
                [KVNProgress dismiss];
                
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"“补充评估信息”采集错误，无法正确算出结果，请重新采集。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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




//获取采集初审终审信息
-(void)get_ServiceUser
{
    NSDictionary * parameter = @{@"shenFenZJ":self.shenFenZJ};
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getServiceUserHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                
                for (int i=0; i<[returnValue[@"data"] count]; i++) {
                    
                    NSDictionary * Dict=returnValue[@"data"][i];
                    
                    NSString * IDENTITY=[Dict objectForKey:@"IDENTITY"];
                    
                    if ([IDENTITY intValue]==1) {

                        [_caiJiModel setValuesForKeysWithDictionary:Dict];
                        
                    } else if([IDENTITY intValue]==2) {
                        
                        [_zhuZeModel setValuesForKeysWithDictionary:Dict];
                    }
                }
                
                //设置页面
                [self createView];
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




#pragma mark 设置导航
-(void)createNav
{
    nav_height=64;
    
    //背景
    UIView * navView=[ZCControl createView:CGRectMake(0, 0, WIDTH, nav_height)];
    [self.view addSubview:navView];
    navView.backgroundColor=Nav_Tabbar_backgroundColor;
    
    //返回按钮
    UIButton * returnButton=[ZCControl createButtonWithFrame:CGRectMake(15, 20+(44-18)/2, 100, 18) Text:nil ImageName:@"reg_return@2x.png" bgImageName:nil Target:self Method:@selector(returnButtonClick)];
    [navView addSubview:returnButton];
    returnButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 100/10*8);
    
    //标题
    UILabel * titleLabel=[ZCControl createLabelWithFrame:CGRectMake(15, 20, WIDTH-30, 44) Font:Title_text_font Text:@"能力评估信息"];
    titleLabel.font=[UIFont boldSystemFontOfSize:Title_text_font];
    [navView addSubview:titleLabel];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=CREATECOLOR(255, 255, 255, 1);
}

//返回
-(void)returnButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark 设置页面
-(void)createView
{
    RootScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, nav_height, WIDTH, HEIGHT-64)];
    [self.view addSubview:RootScrollView];
    RootScrollView.backgroundColor=View_Background_Color;
    RootScrollView.delegate=self;
    
    
    
    //日常生活分级 标题数组
    UIView * riChangSH_View=[ZCControl createView:CGRectMake(0, 20, WIDTH, 24*(riChangSH_Title_Array.count+1))];
    [RootScrollView addSubview:riChangSH_View];
    
    //日常生活分级 标题
    UILabel * riChangSH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, 16) Font:Title_text_font Text:@"1. 日常生活分级"];
    [riChangSH_View addSubview:riChangSH_Label];
    riChangSH_Label.textColor=Title_text_color;
    
    //日常生活分级 介绍
    UIButton * riChangSH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(riChangSH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [riChangSH_View addSubview:riChangSH_Button];
    riChangSH_Button.tag=90000;
    
    //起始高度
    float riChangSH_View_frame_origin_y=CGRectGetMaxY(riChangSH_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<riChangSH_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"riChangSSHDFJ"];
        [riChangSH_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, riChangSH_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=NO;
        
        
        if ([_pingGuJBModel.saiCha intValue]==0) {
            
            if (![PublicFunction isBlankString:_nengLiPGModel.riChangSSHDFJ]) {
                if ([_nengLiPGModel.riChangSSHDFJ intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
            
        } else {
            if (i==3) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        
        

        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [riChangSH_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=riChangSH_Title_Array[i];
    
        riChangSH_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    riChangSH_View.frame = CGRectMake(0, 20, WIDTH, riChangSH_View_frame_origin_y);
    
    
    
    
    //精神状态分级
    UIView * jingShenZT_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(riChangSH_View.frame)+10, WIDTH, 24*(riChangSH_Title_Array.count+1))];
    [RootScrollView addSubview:jingShenZT_View];
    
    
    //精神状态分级 标题
    UILabel * jingShenZT_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, 16) Font:Title_text_font Text:@"2. 精神状态分级"];
    [jingShenZT_View addSubview:jingShenZT_Label];
    jingShenZT_Label.textColor=Title_text_color;
    
    //精神状态分级 介绍
    UIButton * jingShenZT_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(jingShenZT_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [jingShenZT_View addSubview:jingShenZT_Button];
    jingShenZT_Button.tag=90001;
    
    //起始高度
    float jingShenZT_View_frame_origin_y=CGRectGetMaxY(jingShenZT_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<riChangSH_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"jingShenZTFJ"];
        [jingShenZT_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, jingShenZT_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=NO;
        
        if ([_pingGuJBModel.saiCha intValue]==0) {
            
            if (![PublicFunction isBlankString:_nengLiPGModel.jingShenZTFJ]) {
                if ([_nengLiPGModel.jingShenZTFJ intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
            
        } else {
            if (i==3) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [jingShenZT_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=riChangSH_Title_Array[i];
    
        jingShenZT_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    jingShenZT_View.frame = CGRectMake(0, CGRectGetMaxY(riChangSH_View.frame)+20, WIDTH, jingShenZT_View_frame_origin_y);
    
    
    
    
    
    //感知觉于沟通分级
    UIView * ganZhiJY_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(jingShenZT_View.frame)+10, WIDTH, 24*(riChangSH_Title_Array.count+1))];
    [RootScrollView addSubview:ganZhiJY_View];
    
    
    //感知觉于沟通分级 标题
    UILabel * ganZhiJY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"3. 感知觉与沟通分级"];
    [ganZhiJY_View addSubview:ganZhiJY_Label];
    ganZhiJY_Label.textColor=Title_text_color;
    
    //感知觉于沟通分级 介绍
    UIButton * ganZhiJY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(ganZhiJY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [ganZhiJY_View addSubview:ganZhiJY_Button];
    ganZhiJY_Button.tag=90002;
    
    //起始高度
    float ganZhiJY_View_frame_origin_y=CGRectGetMaxY(ganZhiJY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<riChangSH_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"ganZhiJYGTFJ"];
        [ganZhiJY_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, ganZhiJY_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=NO;
        
        
        if ([_pingGuJBModel.saiCha intValue]==0) {
            
            if (![PublicFunction isBlankString:_nengLiPGModel.ganZhiJYGTFJ]) {
                if ([_nengLiPGModel.ganZhiJYGTFJ intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
            
        } else {
            if (i==3) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [ganZhiJY_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=riChangSH_Title_Array[i];
    
        ganZhiJY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    ganZhiJY_View.frame = CGRectMake(0, CGRectGetMaxY(jingShenZT_View.frame)+20, WIDTH, ganZhiJY_View_frame_origin_y);
    
    
    
    
    
    //社会参与分级
    UIView * sheHuiCY_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(ganZhiJY_View.frame)+10, WIDTH, 24*(riChangSH_Title_Array.count+1))];
    [RootScrollView addSubview:sheHuiCY_View];
    
    
    //社会参与分级 标题
    UILabel * sheHuiCY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"4. 社会参与分级"];
    [sheHuiCY_View addSubview:sheHuiCY_Label];
    sheHuiCY_Label.textColor=Title_text_color;
    
    //社会参与分级 介绍
    UIButton * sheHuiCY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(sheHuiCY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [sheHuiCY_View addSubview:sheHuiCY_Button];
    sheHuiCY_Button.tag=90003;
    
    //起始高度
    float sheHuiCY_View_frame_origin_y=CGRectGetMaxY(sheHuiCY_Label.frame)+Q_ICON_HE;
    
    
    for (int i=0; i<riChangSH_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"sheHuiCYFJ"];
        [sheHuiCY_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, sheHuiCY_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=NO;
        
        
        if ([_pingGuJBModel.saiCha intValue]==0) {
            
            if (![PublicFunction isBlankString:_nengLiPGModel.sheHuiCYFJ]) {
                if ([_nengLiPGModel.sheHuiCYFJ intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
            
        } else {
            if (i==3) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [sheHuiCY_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=riChangSH_Title_Array[i];
    
        sheHuiCY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    sheHuiCY_View.frame = CGRectMake(0, CGRectGetMaxY(ganZhiJY_View.frame)+20, WIDTH, sheHuiCY_View_frame_origin_y);
    
    
#pragma mark 能力等级初评
    
    
    //能力等级初评 标题数组
    UIView * nengLiDJ_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(sheHuiCY_View.frame)+10, WIDTH, 24*(nengLiDJ_Title_Array.count+1))];
    [RootScrollView addSubview:nengLiDJ_View];
    
    //能力等级初评 标题
    UILabel * nengLiDJ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"5. 能力等级初评"];
    [nengLiDJ_View addSubview:nengLiDJ_Label];
    nengLiDJ_Label.textColor=Title_text_color;
    
    //能力等级初评 介绍
    UIButton * nengLiDJ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(nengLiDJ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [nengLiDJ_View addSubview:nengLiDJ_Button];
    nengLiDJ_Button.tag=90004;
    
    //起始高度
    float nengLiDJ_View_frame_origin_y=CGRectGetMaxY(nengLiDJ_Label.frame)+Q_ICON_HE;
    
    
    for (int i=0; i<nengLiDJ_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"nengLiDJ"];
        [nengLiDJ_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, nengLiDJ_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=NO;
        
        if (![PublicFunction isBlankString:my_nengLiDJ]) {
            if ([my_nengLiDJ intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [nengLiDJ_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=nengLiDJ_Title_Array[i];
    
        nengLiDJ_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    nengLiDJ_View.frame = CGRectMake(0, CGRectGetMaxY(sheHuiCY_View.frame)+20, WIDTH, nengLiDJ_View_frame_origin_y);
    
    
#pragma mark 等级变更依据
    
    
    
    
    //等级变更依据
    UIView * dengJiBG_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(nengLiDJ_View.frame)+10, WIDTH, 24*(dengJiBG_Title_Array.count+1))];
    [RootScrollView addSubview:dengJiBG_View];
    
    //等级变更依据 标题
    UILabel * dengJiBG_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"6. 等级变更依据"];
    [dengJiBG_View addSubview:dengJiBG_Label];
    dengJiBG_Label.textColor=Title_text_color;
    
    //等级变更依据 介绍
    UIButton * dengJiBG_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(dengJiBG_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [dengJiBG_View addSubview:dengJiBG_Button];
    dengJiBG_Button.tag=90005;
    
    //起始高度
    float dengJiBG_View_frame_origin_y=CGRectGetMaxY(dengJiBG_Label.frame)+Q_ICON_HE;
    
    //获取等级变更
    if ([_pingGuJBModel.saiCha intValue]==0) {
        
        [self get_dengJiBG];
    }
    
    for (int i=0; i<dengJiBG_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"dengJiBG"];
        [dengJiBG_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, dengJiBG_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=NO;
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [dengJiBG_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        
        
        if (![PublicFunction isBlankString:my_dengJiBG]) {
            if ([my_dengJiBG intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        
        
        NSString * labelText = dengJiBG_Title_Array[i];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:Answer_HE];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        xuanXiang_Label.attributedText = attributedString;
        [xuanXiang_Label sizeToFit];
        dengJiBG_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Label.frame)+Q_ICON_HE;
    }
    
    dengJiBG_View.frame = CGRectMake(0, CGRectGetMaxY(nengLiDJ_View.frame)+10, WIDTH, dengJiBG_View_frame_origin_y);
    
    
    
    
#pragma mark 能力最终等级
    
    //能力最终等级
    UIView * nengLiZZ_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(dengJiBG_View.frame)+10, WIDTH, 24*(nengLiDJ_Title_Array.count+1))];
    [RootScrollView addSubview:nengLiZZ_View];
    
    //能力最终等级 标题
    UILabel * nengLiZZ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"7. 能力最终等级"];
    [nengLiZZ_View addSubview:nengLiZZ_Label];
    nengLiZZ_Label.textColor=Title_text_color;
    
    //能力最终等级 介绍
    UIButton * nengLiZZ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(nengLiZZ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [nengLiZZ_View addSubview:nengLiZZ_Button];
    nengLiZZ_Button.tag=90006;
    
    //获取能力最终等级
    if ([_pingGuJBModel.saiCha intValue]==0) {
        
        [self get_nengLiZZ];
    }
    
    //起始高度
    float nengLiZZ_View_frame_origin_y=CGRectGetMaxY(nengLiZZ_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<nengLiDJ_Title_Array.count; i++) {
        
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"nengLiZZ"];
        [nengLiZZ_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, nengLiZZ_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        xuanXiang_Button.userInteractionEnabled=NO;
        

        if (![PublicFunction isBlankString:my_nengLiZZ]) {
            if ([my_nengLiZZ intValue]==i) {
                [xuanXiang_Button setChecked:YES];
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [nengLiZZ_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=nengLiDJ_Title_Array[i];
    
        nengLiZZ_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    nengLiZZ_View.frame = CGRectMake(0, CGRectGetMaxY(dengJiBG_View.frame)+20, WIDTH, nengLiZZ_View_frame_origin_y);
    
    
    
#pragma mark 采集评估员
    
    //采集评估员 姓名 标题
    UILabel * caiJi_xingMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(nengLiZZ_View.frame)+10, 44+Title_text_font*6, Title_text_font) Font:Title_text_font Text:@"8. 采集评估员姓名"];
    [RootScrollView addSubview:caiJi_xingMing_Label];
    caiJi_xingMing_Label.textColor=Title_text_color;
    
    //采集评估员 姓名 签字框
    caiJi_xingMing_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(caiJi_xingMing_Label.frame), CGRectGetMinY(caiJi_xingMing_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-caiJi_xingMing_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    caiJi_xingMing_Field.textColor=Field_text_color;
    [RootScrollView addSubview:caiJi_xingMing_Field];
    caiJi_xingMing_Field.delegate=self;
    caiJi_xingMing_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_caiJiModel.DOC_NAME]) {
        caiJi_xingMing_Field.text=_caiJiModel.DOC_NAME;
    }
    
    //采集评估员 姓名 介绍
    UIButton * caiJi_xingMing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(caiJi_xingMing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:caiJi_xingMing_Button];
    caiJi_xingMing_Button.tag=90007;
    
    
    
    
    
    
    //采集评估员联系电话 标题
    UILabel * caiJi_yiDongDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(caiJi_xingMing_Field.frame)+20, 44+Title_text_font*8, Title_text_font) Font:Title_text_font Text:@"9. 采集评估员联系电话"];
    [RootScrollView addSubview:caiJi_yiDongDH_Label];
    caiJi_yiDongDH_Label.textColor=Title_text_color;
    
    //采集评估员联系电话 签字框
    caiJi_yiDongDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(caiJi_yiDongDH_Label.frame), CGRectGetMinY(caiJi_yiDongDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-caiJi_yiDongDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    caiJi_yiDongDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:caiJi_yiDongDH_Field];
    caiJi_yiDongDH_Field.delegate=self;
    caiJi_yiDongDH_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_caiJiModel.PHONE]) {
        caiJi_yiDongDH_Field.text=_caiJiModel.PHONE;
    }
    
    //采集评估员联系电话 介绍
    UIButton * caiJi_yiDongDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(caiJi_yiDongDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:caiJi_yiDongDH_Button];
    caiJi_yiDongDH_Button.tag=90008;
    
    
    
    //签名按钮 宽度
    float qianMing_button_width=90;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    //采集评估员签名 标题
    UILabel * caiJi_qianMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(caiJi_yiDongDH_Field.frame)+20, 44+Title_text_font*7, Title_text_font) Font:Title_text_font Text:@"10. 采集评估员签名"];
    [RootScrollView addSubview:caiJi_qianMing_Label];
    caiJi_qianMing_Label.textColor=Title_text_color;
    
    //采集评估员签名 签字框
    caiJi_qianMing_button=[ZCControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(caiJi_qianMing_Label.frame), CGRectGetMinY(caiJi_qianMing_Label.frame)-(Field_HE-Title_text_font)/2, qianMing_button_width, qianMing_button_width/5*3) Text:nil ImageName:nil bgImageName:nil Target:self Method:@selector(qianMing_button_click:)];
    [RootScrollView addSubview:caiJi_qianMing_button];
    caiJi_qianMing_button.layer.masksToBounds=YES;
    caiJi_qianMing_button.layer.cornerRadius=5.0;
    caiJi_qianMing_button.layer.borderWidth=0.1;
    [caiJi_qianMing_button setBackgroundColor:[UIColor whiteColor]];
    caiJi_qianMing_button.userInteractionEnabled=NO;
    
    if ([[user objectForKey:idenity] intValue]==1) {
        caiJi_qianMing_button.userInteractionEnabled=YES;
    }
    
    caiJi_qianMing_button.tag=10000;
    
    if (![PublicFunction isBlankString:_caiJiModel.QIANMING]) {
        
        my_caiJi_qianMing=_caiJiModel.QIANMING;
        
        NSData * ImageData = [[NSData alloc] initWithBase64EncodedString:_caiJiModel.QIANMING options:1];
        
        UIImage * Image = [UIImage imageWithData:ImageData];
        
        [caiJi_qianMing_button setImage:Image forState:UIControlStateNormal];
        
        //NSLog(@"%ld",my_caiJi_qianMing.length/1024);
    }
    
    
    //采集评估员签名 介绍
    UIButton * caiJi_qianMing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(caiJi_qianMing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:caiJi_qianMing_Button];
    caiJi_qianMing_Button.tag=90009;
    
    
    
    
    
    
    //主责评估员姓名 标题
    UILabel * zhuZe_xingMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(caiJi_qianMing_button.frame)+20, 44+Title_text_font*7, Title_text_font) Font:Title_text_font Text:@"11. 主责评估员姓名"];
    [RootScrollView addSubview:zhuZe_xingMing_Label];
    zhuZe_xingMing_Label.textColor=Title_text_color;
    
    //主责评估员姓名 签字框
    zhuZe_xingMing_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(zhuZe_xingMing_Label.frame), CGRectGetMinY(zhuZe_xingMing_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-zhuZe_xingMing_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    zhuZe_xingMing_Field.textColor=Field_text_color;
    [RootScrollView addSubview:zhuZe_xingMing_Field];
    zhuZe_xingMing_Field.delegate=self;
    zhuZe_xingMing_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.DOC_NAME]) {
        zhuZe_xingMing_Field.text=_zhuZeModel.DOC_NAME;
    }
    
    //主责评估员姓名 介绍
    UIButton * zhuZe_xingMing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(zhuZe_xingMing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:zhuZe_xingMing_Button];
    zhuZe_xingMing_Button.tag=90010;
    
    
    
    
    
    
    //主责评估员联系电话 标题
    UILabel * zhuZe_yiDongDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(zhuZe_xingMing_Field.frame)+20, 44+Title_text_font*9, Title_text_font) Font:Title_text_font Text:@"12. 主责评估员联系电话"];
    [RootScrollView addSubview:zhuZe_yiDongDH_Label];
    zhuZe_yiDongDH_Label.textColor=Title_text_color;
    
    //主责评估员联系电话 签字框
    zhuZe_yiDongDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(zhuZe_yiDongDH_Label.frame), CGRectGetMinY(zhuZe_yiDongDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-zhuZe_yiDongDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    zhuZe_yiDongDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:zhuZe_yiDongDH_Field];
    zhuZe_yiDongDH_Field.delegate=self;
    zhuZe_yiDongDH_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.PHONE]) {
        zhuZe_yiDongDH_Field.text=_zhuZeModel.PHONE;
    }
    
    //主责评估员联系电话 介绍
    UIButton * zhuZe_yiDongDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(zhuZe_yiDongDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:zhuZe_yiDongDH_Button];
    zhuZe_yiDongDH_Button.tag=90011;
    
    
    
    
    
    
    //主责评估员签名 标题
    UILabel * zhuZe_qianMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(zhuZe_yiDongDH_Field.frame)+20, 44+Title_text_font*7, Title_text_font) Font:Title_text_font Text:@"13. 主责评估员签名"];
    [RootScrollView addSubview:zhuZe_qianMing_Label];
    zhuZe_qianMing_Label.textColor=Title_text_color;
    
    //主责评估员签名 签字框
    zhuZe_qianMing_button=[ZCControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(zhuZe_qianMing_Label.frame), CGRectGetMinY(zhuZe_qianMing_Label.frame)-(Field_HE-Title_text_font)/2, qianMing_button_width, qianMing_button_width/5*3) Text:nil ImageName:nil bgImageName:nil Target:self Method:@selector(qianMing_button_click:)];
    [RootScrollView addSubview:zhuZe_qianMing_button];
    zhuZe_qianMing_button.layer.masksToBounds=YES;
    zhuZe_qianMing_button.layer.cornerRadius=5.0;
    zhuZe_qianMing_button.layer.borderWidth=0.1;
    [zhuZe_qianMing_button setBackgroundColor:[UIColor whiteColor]];
    zhuZe_qianMing_button.userInteractionEnabled=NO;
    
    if ([[user objectForKey:idenity] intValue]==2) {
        zhuZe_qianMing_button.userInteractionEnabled=YES;
    }
    
    zhuZe_qianMing_button.tag=20000;
    
    if (![PublicFunction isBlankString:_zhuZeModel.QIANMING]) {
        
        my_zhuZe_qianMing=_zhuZeModel.QIANMING;
        
        NSData * ImageData = [[NSData alloc] initWithBase64EncodedString:_zhuZeModel.QIANMING options:1];
        
        UIImage * Image = [UIImage imageWithData:ImageData];
        
        [zhuZe_qianMing_button setImage:Image forState:UIControlStateNormal];
        
        //NSLog(@"%ld",qianMing.length/1024);
    }
    
    //主责评估员签名 介绍
    UIButton * zhuZe_qianMing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(zhuZe_qianMing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:zhuZe_qianMing_Button];
    zhuZe_qianMing_Button.tag=90012;
    
    
    
    
    //保存按钮
    Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
    [self.view addSubview:Save_Button];
    [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(zhuZe_qianMing_button.frame)+20+Tabbar_HE);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    
    
    
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

#pragma mark - 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：无需评估中填写，系统会根据等级评定逻辑自动计算并显示结论。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：无需评估中填写，系统会根据等级评定逻辑自动计算并显示结论。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：无需评估中填写，系统会根据等级评定逻辑自动计算并显示结论。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：无需评估中填写，系统会根据等级评定逻辑自动计算并显示结论。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：无需评估中填写，系统会根据等级评定逻辑自动计算并显示结论。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：无需评估中填写，系统会根据等级评定逻辑自动计算并显示结论。"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：无需评估中填写，系统会根据等级变更依据情况，来确定是否修改能力等级，自动显示最终结论。"];
            
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90009:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"系统自动代出上次签名的图片，可以使用上次签名，也可以重新签名。"];
            
            [modal show];
        }
            break;
            
        case 90010:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90011:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90012:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"系统自动代出上次签名的图片，可以使用上次签名，也可以重新签名。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - 获取等级变更
-(void)get_dengJiBG
{
    my_dengJiBG=@"10";
    
    
    //有老年痴呆
    if ([_buChongPGModel.laoNianCZ intValue]>0) {
        my_dengJiBG=@"0";
    }
    //精神疾病患者
    if ([_buChongPGModel.jingShenJB intValue]>0) {
        my_dengJiBG=@"0";
    }
    
    
    //2次及以上 跌倒
    if ([_buChongPGModel.dieDao intValue]>1) {
        my_dengJiBG=@"1";
    }
    //2次及以上 噎食
    if ([_buChongPGModel.yeShi intValue]>1) {
        my_dengJiBG=@"1";
    }
    //2次及以上 走失
    if ([_buChongPGModel.zouShi intValue]>1) {
        my_dengJiBG=@"1";
    }
    //2次及以上 自杀
    if ([_buChongPGModel.ziSha intValue]>1) {
        my_dengJiBG=@"1";
    }
    
    //筛查 昏迷
    if ([_pingGuJBModel.saiCha intValue]==2) {
        my_dengJiBG=@"2";
    }
    
    //初步等级 为重度失能
    if ([my_nengLiDJ intValue]==3) {
        my_dengJiBG=@"3";
    }
    
    //NSLog(@"%@",my_dengJiBG);
}


#pragma mark - 获取能力最终等级
-(void)get_nengLiZZ
{
    my_nengLiZZ=@"10";
    
    if ([my_dengJiBG intValue]==10) {
        my_nengLiZZ=my_nengLiDJ;
    }
    
    //等级变更 依据 0
    if ([my_dengJiBG intValue]==0) {
        my_nengLiZZ=[NSString stringWithFormat:@"%d",[my_nengLiDJ intValue]+1];
    }
    
    //等级变更 依据 1
    if ([my_dengJiBG intValue]==1) {
        my_nengLiZZ=[NSString stringWithFormat:@"%d",[my_nengLiDJ intValue]+1];
    }
    
    //等级变更 依据 2
    if ([my_dengJiBG intValue]==2) {
        my_nengLiZZ=@"3";
    }
    
    //等级变更 依据 3
    if ([my_dengJiBG intValue]==3) {
        my_nengLiZZ=@"3";
    }
}






#pragma mark - 签名
-(void)qianMing_button_click:(UIButton*)button
{
    [PopSignUtil getSignWithVC:self withOk:^(UIImage * image) {
        
        NSData * data = UIImageJPEGRepresentation(image, 0.1);
        
        switch (button.tag/10000) {
            case 1:
            {
                my_caiJi_qianMing = [data base64EncodedStringWithOptions:1];
                
                [caiJi_qianMing_button setImage:nil forState:UIControlStateNormal];
                
                [caiJi_qianMing_button setBackgroundImage:image forState:UIControlStateNormal];
            }
                break;
                
            case 2:
            {
                my_zhuZe_qianMing = [data base64EncodedStringWithOptions:1];
                
                [zhuZe_qianMing_button setImage:nil forState:UIControlStateNormal];
                
                [zhuZe_qianMing_button setBackgroundImage:image forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
        [PopSignUtil closePop];
    } withCancel:^{
        [PopSignUtil closePop];
    }];
}







#pragma mark - 保存
-(void)Save_Button_Click
{
    //更新能力评估结论
    [self update_NengLiPG_Result];
    
    //判断能力评估结论
    [self panduan_QianMing];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==30000) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}


//更新能力评估结论
-(void)update_NengLiPG_Result
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"16" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    
    #pragma mark - 日常生活分级
    if (![PublicFunction isBlankString:_nengLiPGModel.riChangSSHDFJ]) {
        [parameter setObject:_nengLiPGModel.riChangSSHDFJ forKey:@"riChangSH"];
    }
    #pragma mark - 精神状态分级
    if (![PublicFunction isBlankString:_nengLiPGModel.jingShenZTFJ]) {
        [parameter setObject:_nengLiPGModel.jingShenZTFJ forKey:@"jingShenZT"];
    }
    #pragma mark - 感知觉与沟通分级
    if (![PublicFunction isBlankString:_nengLiPGModel.ganZhiJYGTFJ]) {
        [parameter setObject:_nengLiPGModel.ganZhiJYGTFJ forKey:@"ganZhiJY"];
    }
    #pragma mark - 社会参与分级
    if (![PublicFunction isBlankString:_nengLiPGModel.sheHuiCYFJ]) {
        [parameter setObject:_nengLiPGModel.sheHuiCYFJ forKey:@"sheHuiCY"];
    }
    
    
    #pragma mark - 能力等级初评
    if (![PublicFunction isBlankString:my_nengLiDJ]) {
        [parameter setObject:my_nengLiDJ forKey:@"nengLiDJ"];
    }
    #pragma mark - 能力等级初评
    if (![PublicFunction isBlankString:my_dengJiBG]) {
        [parameter setObject:my_dengJiBG forKey:@"dengJiBG"];
    }
    #pragma mark - 能力等级初评
    if (![PublicFunction isBlankString:my_nengLiZZ]) {
        [parameter setObject:my_nengLiZZ forKey:@"nengLiZZ"];
    }
    
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:insertResultHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] intValue]==1) {
                
                
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


//判断 签名
-(void)panduan_QianMing
{
    //NSLog(@"%@",my_caiJi_qianMing);
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        if ([PublicFunction isBlankString:my_caiJi_qianMing]) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请填写“采集评估员签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if (WIDTH==320  && my_caiJi_qianMing.length<4500) {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“采集评估员签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if (WIDTH==375  && my_caiJi_qianMing.length<5000) {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“采集评估员签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if (WIDTH==414  && my_caiJi_qianMing.length<6200) {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“采集评估员签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else {
            //更新签名
            [self update_QianMing];
        }
    } else if ([[user objectForKey:idenity] intValue]==2) {
        if ([PublicFunction isBlankString:my_zhuZe_qianMing]) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请填写“主责评估员签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if (WIDTH==320  && my_zhuZe_qianMing.length<4500) {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“主责评估员签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if (WIDTH==375  && my_zhuZe_qianMing.length<5000) {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“主责评估员签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if (WIDTH==414  && my_zhuZe_qianMing.length<6200) {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“主责评估员签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else {
            //更新签名
            [self update_QianMing];
        }
    }
}

//更新签名
-(void)update_QianMing
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        if (![PublicFunction isBlankString:my_caiJi_qianMing]) {
            [parameter setObject:my_caiJi_qianMing forKey:@"qianming"];
        }
    } else if ([[user objectForKey:idenity] intValue]==2) {
        if (![PublicFunction isBlankString:my_zhuZe_qianMing]) {
            [parameter setObject:my_zhuZe_qianMing forKey:@"qianming"];
        }
    }
    
    [KVNProgress show];
    
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:updateDocSignatureHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        [KVNProgress dismiss];
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] intValue]==1) {
                
                [self dismissViewControllerAnimated:YES completion:^{}];
                
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

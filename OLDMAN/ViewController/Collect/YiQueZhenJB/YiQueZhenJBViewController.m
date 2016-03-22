//
//  YiQueZhenJBViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "YiQueZhenJBViewController.h"
#import "YiQueZhenJBModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QCheckBox.h"//复选

@interface YiQueZhenJBViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    NSArray * chuanRanJB_Title_Array;//传染疾病 标题数组
    NSMutableDictionary * my_chuanRanJB_Dict;//传染疾病
    UIView * chuanRanJB_View;
    
    NSArray * fengXianGW_Title_Array;//标题数组
    NSMutableDictionary * my_fengXianGW_Dict;//风险高位疾病
    UIView * fengXianGW_View;
    
    NSArray * yinShiXZ_Title_Array;//标题数组
    NSMutableDictionary * my_yinShiXZ_Dict;//饮食限制性疾病
    UIView * yinShiXZ_View;
    
    
    NSArray * qiTaJB_Title_Array;//其他状况 标题数组
    
    NSMutableDictionary * my_qiTaJB_Dict;//其他疾病
    UIView * qiTaJB_View;
    
    
    
    
    UITextField * qiTaJBQT_Field;//其他疾病(其他)
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    
    YiQueZhenJBModel * _yiQueZhenJBModel;//数据源
}
@end

@implementation YiQueZhenJBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //实列化
    my_chuanRanJB_Dict=[[NSMutableDictionary alloc]init];//传染疾病
    
    my_fengXianGW_Dict=[[NSMutableDictionary alloc]init];//风险高位疾病
    
    my_yinShiXZ_Dict=[[NSMutableDictionary alloc]init];//饮食限制性疾病
    
    my_qiTaJB_Dict=[[NSMutableDictionary alloc]init];//其他疾病
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}


//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _yiQueZhenJBModel=[[YiQueZhenJBModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _yiQueZhenJBModel=nil;
    
    [my_chuanRanJB_Dict removeAllObjects];
    [my_fengXianGW_Dict removeAllObjects];
    [my_yinShiXZ_Dict removeAllObjects];
    [my_qiTaJB_Dict removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //传染疾病
    chuanRanJB_Title_Array=@[@"无",@"肺结核",@"病毒性肝炎"];
    
    //风险高位疾病
    fengXianGW_Title_Array=@[@"无",@"冠心病",@"高血压",@"脑卒中",@"肺癌晚期",@"肝癌晚期",@"认知障碍，如老年痴呆",@"脑血管后遗症",@"帕金森病",@"颈、腰椎病",@"股骨颈骨折",@"退行性关节病",@"骨质疏松"];
    
    //饮食限制性疾病
    yinShiXZ_Title_Array=@[@"无",@"糖尿病综合症",@"肾病后期",@"尿毒症",@"消化性溃疡",@"严重营养不良",@"便秘",@"脑血管后遗症",@"甲状腺疾病"];
    
    //其他疾病 标题数组
    qiTaJB_Title_Array=@[@"无",@"白内障",@"青光眼",@"压疮",@"皮肤瘙痒",@"多发性疱疹",@"严重过敏哮喘",@"其他"];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"5"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_yiQueZhenJBModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"已确诊的疾病";
    
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
    
    
    
    //传染疾病
    chuanRanJB_View=[ZCControl createView:CGRectMake(0, 20, WIDTH, 24*(chuanRanJB_Title_Array.count+1))];
    [RootScrollView addSubview:chuanRanJB_View];
    
    //传染疾病 标题
    UILabel * jiaTingZHZT_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"1. 传染疾病"];
    [chuanRanJB_View addSubview:jiaTingZHZT_Label];
    jiaTingZHZT_Label.textColor=Title_text_color;
    
    //传染疾病 介绍
    UIButton * chuanRanJB_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(jiaTingZHZT_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [chuanRanJB_View addSubview:chuanRanJB_Button];
    chuanRanJB_Button.tag=90000;
    
    //请求数据 数组
    NSArray * chuanRanJB_strArray;
    if (![PublicFunction isBlankString:_yiQueZhenJBModel.chuanRanJB]) {
        chuanRanJB_strArray=[_yiQueZhenJBModel.chuanRanJB componentsSeparatedByString:@","];
    }
    
    //起始高度
    float chuanRanJB_View_frame_origin_y=CGRectGetMaxY(jiaTingZHZT_Label.frame)+Q_ICON_HE;
    
    //是否 选无
    int is_chuanRanJB=0;
    
    if (![PublicFunction isBlankString:_yiQueZhenJBModel.chuanRanJB]) {
        for (int j=0; j<chuanRanJB_strArray.count; j++) {
            if ([chuanRanJB_strArray[j] intValue]==0) {
                is_chuanRanJB=1;
            }
        }
    }
    
    for (int i=0; i<chuanRanJB_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15,chuanRanJB_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [chuanRanJB_View addSubview:xuanXiang_Check];

        xuanXiang_Check.tag=3000+i;
        
        if (is_chuanRanJB==1) {
            if (i==0) {
                [xuanXiang_Check setChecked:YES];
            } else {
                [xuanXiang_Check setChecked:NO];
                xuanXiang_Check.userInteractionEnabled=NO;
            }
        } else {
            if (![PublicFunction isBlankString:_yiQueZhenJBModel.chuanRanJB]) {
                for (int j=0; j<chuanRanJB_strArray.count; j++) {
                    if ([chuanRanJB_strArray[j] intValue]==i) {
                        [xuanXiang_Check setChecked:YES];
                    }
                }
            }
        }
        
        
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [chuanRanJB_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=chuanRanJB_Title_Array[i];
    
        chuanRanJB_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    chuanRanJB_View.frame = CGRectMake(0, 20, WIDTH, chuanRanJB_View_frame_origin_y);
    
    
    
    
    
    //风险高位疾病
    fengXianGW_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(chuanRanJB_View.frame)+10, WIDTH, 24*(fengXianGW_Title_Array.count+1))];
    [RootScrollView addSubview:fengXianGW_View];
    
    //风险高位疾病 标题
    UILabel * fengXianGW_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"2. 风险高位疾病"];
    [fengXianGW_View addSubview:fengXianGW_Label];
    fengXianGW_Label.textColor=Title_text_color;
    
    //风险高位疾病 介绍
    UIButton * fengXianGW_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(fengXianGW_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [fengXianGW_View addSubview:fengXianGW_Button];
    fengXianGW_Button.tag=90001;
    
    //请求数据 数组
    NSArray * fengXianGW_strArray;
    if (![PublicFunction isBlankString:_yiQueZhenJBModel.fengXianGW]) {
        fengXianGW_strArray=[_yiQueZhenJBModel.fengXianGW componentsSeparatedByString:@","];
    }
    
    //起始高度
    float fengXianGW_View_frame_origin_y=CGRectGetMaxY(fengXianGW_Label.frame)+Q_ICON_HE;
    
    //是否 选无
    int is_fengXianGW=0;
    
    if (![PublicFunction isBlankString:_yiQueZhenJBModel.fengXianGW]) {
        for (int j=0; j<fengXianGW_strArray.count; j++) {
            if ([fengXianGW_strArray[j] intValue]==0) {
                is_fengXianGW=1;
            }
        }
    }
    
    
    for (int i=0; i<fengXianGW_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, fengXianGW_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [fengXianGW_View addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=4000+i;
        
        
        
        if (is_fengXianGW==1) {
            if (i==0) {
                [xuanXiang_Check setChecked:YES];
            } else {
                [xuanXiang_Check setChecked:NO];
                xuanXiang_Check.userInteractionEnabled=NO;
            }
        } else {
            if (![PublicFunction isBlankString:_yiQueZhenJBModel.fengXianGW]) {
                for (int j=0; j<fengXianGW_strArray.count; j++) {
                    if ([fengXianGW_strArray[j] intValue]==i) {
                        [xuanXiang_Check setChecked:YES];
                    }
                }
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [fengXianGW_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=fengXianGW_Title_Array[i];
    
        fengXianGW_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    fengXianGW_View.frame = CGRectMake(0, CGRectGetMaxY(chuanRanJB_View.frame)+20, WIDTH, fengXianGW_View_frame_origin_y);
    
    
    
    
    
    
    
    //饮食限制性疾病
    yinShiXZ_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(fengXianGW_View.frame)+10, WIDTH, 24*(yinShiXZ_Title_Array.count+1))];
    [RootScrollView addSubview:yinShiXZ_View];
    
    //饮食限制性疾病 标题
    UILabel * yinShiXZ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"3. 饮食限制性疾病"];
    [yinShiXZ_View addSubview:yinShiXZ_Label];
    yinShiXZ_Label.textColor=Title_text_color;
    
    //饮食限制性疾病 介绍
    UIButton * yinShiXZ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yinShiXZ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [yinShiXZ_View addSubview:yinShiXZ_Button];
    yinShiXZ_Button.tag=90002;
    
    //请求数据 数组
    NSArray * yinShiXZ_strArray;
    if (![PublicFunction isBlankString:_yiQueZhenJBModel.yinShiXZ]) {
        yinShiXZ_strArray=[_yiQueZhenJBModel.yinShiXZ componentsSeparatedByString:@","];
    }
    
    //起始高度
    float yinShiXZ_View_frame_origin_y=CGRectGetMaxY(yinShiXZ_Label.frame)+Q_ICON_HE;
    
    //是否 选无
    int is_yinShiXZ=0;
    
    if (![PublicFunction isBlankString:_yiQueZhenJBModel.yinShiXZ]) {
        for (int j=0; j<yinShiXZ_strArray.count; j++) {
            if ([yinShiXZ_strArray[j] intValue]==0) {
                is_yinShiXZ=1;
            }
        }
    }
    
    for (int i=0; i<yinShiXZ_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, yinShiXZ_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [yinShiXZ_View addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=5000+i;
        
        
        
        if (is_yinShiXZ==1) {
            if (i==0) {
                [xuanXiang_Check setChecked:YES];
            } else {
                [xuanXiang_Check setChecked:NO];
                xuanXiang_Check.userInteractionEnabled=NO;
            }
        } else {
            if (![PublicFunction isBlankString:_yiQueZhenJBModel.yinShiXZ]) {
                for (int j=0; j<yinShiXZ_strArray.count; j++) {
                    if ([yinShiXZ_strArray[j] intValue]==i) {
                        [xuanXiang_Check setChecked:YES];
                    }
                }
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
        [yinShiXZ_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=yinShiXZ_Title_Array[i];
    
        yinShiXZ_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    yinShiXZ_View.frame = CGRectMake(0, CGRectGetMaxY(fengXianGW_View.frame)+20, WIDTH, yinShiXZ_View_frame_origin_y);
    
    
    
    
    
    
    //其他疾病 标题数组
    qiTaJB_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(yinShiXZ_View.frame)+10, WIDTH, 24*(qiTaJB_Title_Array.count+1))];
    [RootScrollView addSubview:qiTaJB_View];
    
    //其他疾病 标题
    UILabel * qiTaJB_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"4. 其他疾病"];
    [qiTaJB_View addSubview:qiTaJB_Label];
    qiTaJB_Label.textColor=Title_text_color;
    
    //其他疾病 介绍
    UIButton * qiTaJB_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(qiTaJB_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [qiTaJB_View addSubview:qiTaJB_Button];
    qiTaJB_Button.tag=90003;
    
    //请求数据 数组
    NSArray * qiTaJB_strArray;
    if (![PublicFunction isBlankString:_yiQueZhenJBModel.qiTaJB]) {
        qiTaJB_strArray=[_yiQueZhenJBModel.qiTaJB componentsSeparatedByString:@","];
    }
    
    //起始高度
    float qiTaJB_View_frame_origin_y=CGRectGetMaxY(qiTaJB_Label.frame)+Q_ICON_HE;
    
    //是否 选无
    int is_qiTaJB=0;
    
    if (![PublicFunction isBlankString:_yiQueZhenJBModel.qiTaJB]) {
        for (int j=0; j<qiTaJB_strArray.count-1; j++) {
            if ([qiTaJB_strArray[j] intValue]==0) {
                is_qiTaJB=1;
            }
        }
    }
    
    for (int i=0; i<qiTaJB_Title_Array.count; i++) {
        
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, qiTaJB_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [qiTaJB_View addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=6000+i;
        
        
        if (is_qiTaJB==1) {
            if (i==0) {
                [xuanXiang_Check setChecked:YES];
            } else {
                [xuanXiang_Check setChecked:NO];
                xuanXiang_Check.userInteractionEnabled=NO;
            }
        } else {
            if (![PublicFunction isBlankString:_yiQueZhenJBModel.qiTaJB]) {
                int n=0;
                for (int j=0; j<qiTaJB_strArray.count; j++) {
                    if (![PublicFunction isBlankString:qiTaJB_strArray[j]]) {
                        if (![[qiTaJB_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
                            if ([qiTaJB_strArray[j] intValue]==i) {
                                [xuanXiang_Check setChecked:YES];
                            }
                            n++;
                        } else {
                            if (i==qiTaJB_Title_Array.count-1) {
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
        [qiTaJB_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=qiTaJB_Title_Array[i];
    
        qiTaJB_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    qiTaJB_View.frame = CGRectMake(0, CGRectGetMaxY(yinShiXZ_View.frame)+20, WIDTH, qiTaJB_View_frame_origin_y);
    
    

    
    //其他疾病(其他) 签字框
    qiTaJBQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(qiTaJB_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    qiTaJBQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:qiTaJBQT_Field];
    qiTaJBQT_Field.delegate=self;
    qiTaJBQT_Field.userInteractionEnabled=NO;
    
    
    if (is_qiTaJB==1) {
        qiTaJBQT_Field.text=@"";
    } else {
        if (![PublicFunction isBlankString:_yiQueZhenJBModel.qiTaJB]) {
            int n=0;
            NSString * qiTa=@"";
            for (int j=0; j<qiTaJB_strArray.count; j++) {
                if (![PublicFunction isBlankString:qiTaJB_strArray[j]]) {
                    if (![[qiTaJB_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
                        n++;
                    } else {
                        qiTaJBQT_Field.userInteractionEnabled=YES;
                        break;
                    }
                }
            }
            for (int j=n; j<qiTaJB_strArray.count; j++) {
                if (![PublicFunction isBlankString:qiTaJB_strArray[j]]) {
                    if (j!=qiTaJB_strArray.count-1) {
                        qiTa=[qiTa stringByAppendingFormat:@"%@,",qiTaJB_strArray[j]];
                    } else {
                        qiTa=[qiTa stringByAppendingFormat:@"%@",qiTaJB_strArray[j]];
                    }
                }
            }
            if (![PublicFunction isBlankString:qiTa]) {
                qiTaJBQT_Field.text=[qiTa substringFromIndex:1];
            }
        }
    }
    
    
    
    
    
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(qiTaJBQT_Field.frame)+20);
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
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(qiTaJBQT_Field.frame)+20+Tabbar_HE);
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





#pragma mark - 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须依据申请人提供的索取医院证明、病历、处方等证明文件，结合询问或查看到的实际情况记录。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须依据申请人提供的索取医院证明、病历、处方等证明文件，结合询问或查看到的实际情况记录。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须依据申请人提供的索取医院证明、病历、处方等证明文件，结合询问或查看到的实际情况记录。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须依据申请人提供的索取医院证明、病历、处方等证明文件，结合询问或查看到的实际情况记录。"];
            
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
        case 3:
        {
            if (checked==1) {
                if (checkbox.tag==3000) {
                    [my_chuanRanJB_Dict removeAllObjects];
                    
                    for (int i=1; i<chuanRanJB_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[chuanRanJB_View viewWithTag:3000+i];
                        xuanXiang_Check.userInteractionEnabled=NO;
                        [xuanXiang_Check setChecked:NO];
                    }
                }
                
                [my_chuanRanJB_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-3000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-3000]];
            } else {
                if (checkbox.tag==3000) {
                    
                    for (int i=1; i<chuanRanJB_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[chuanRanJB_View viewWithTag:3000+i];
                        xuanXiang_Check.userInteractionEnabled=YES;
                    }
                }
                
                [my_chuanRanJB_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-3000]];
            }
        }
            break;
        case 4:
        {
            if (checked==1) {
                if (checkbox.tag==4000) {
                    [my_fengXianGW_Dict removeAllObjects];
                    
                    for (int i=1; i<fengXianGW_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[fengXianGW_View viewWithTag:4000+i];
                        xuanXiang_Check.userInteractionEnabled=NO;
                        [xuanXiang_Check setChecked:NO];
                    }
                }
                
                
                [my_fengXianGW_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-4000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-4000]];
            } else {
                if (checkbox.tag==4000) {
                    
                    for (int i=1; i<fengXianGW_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[fengXianGW_View viewWithTag:4000+i];
                        xuanXiang_Check.userInteractionEnabled=YES;
                    }
                }
                
                [my_fengXianGW_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-4000]];
            }
        }
            break;
        case 5:
        {
            if (checked==1) {
                if (checkbox.tag==5000) {
                    [my_yinShiXZ_Dict removeAllObjects];
                    
                    for (int i=1; i<yinShiXZ_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[yinShiXZ_View viewWithTag:5000+i];
                        xuanXiang_Check.userInteractionEnabled=NO;
                        [xuanXiang_Check setChecked:NO];
                    }
                }
                
                [my_yinShiXZ_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-5000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-5000]];
            } else {
                if (checkbox.tag==5000) {
                    
                    for (int i=1; i<yinShiXZ_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[yinShiXZ_View viewWithTag:5000+i];
                        xuanXiang_Check.userInteractionEnabled=YES;
                    }
                }
                
                [my_yinShiXZ_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-5000]];
            }
        }
            break;
        case 6:
        {
            if (checked==1) {
                if (checkbox.tag==6000) {
                    [my_qiTaJB_Dict removeAllObjects];
                    
                    for (int i=1; i<qiTaJB_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[qiTaJB_View viewWithTag:6000+i];
                        xuanXiang_Check.userInteractionEnabled=NO;
                        [xuanXiang_Check setChecked:NO];
                    }
                }
                
                [my_qiTaJB_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-6000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-6000]];
            } else {
                if (checkbox.tag==6000) {
                    
                    for (int i=1; i<qiTaJB_Title_Array.count; i++) {
                        QCheckBox * xuanXiang_Check=(QCheckBox*)[qiTaJB_View viewWithTag:6000+i];
                        xuanXiang_Check.userInteractionEnabled=YES;
                    }
                }
                
                
                [my_qiTaJB_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-6000]];
            }
            
            if (checked==1) {
                if (checkbox.tag-6000==qiTaJB_Title_Array.count-1) {
                    qiTaJBQT_Field.userInteractionEnabled=YES;
                }
            } else {
                qiTaJBQT_Field.userInteractionEnabled=NO;
                qiTaJBQT_Field.text=@"";
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
    if (my_chuanRanJB_Dict.count==0) {
#pragma mark - 传染疾病
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“传染疾病”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (my_fengXianGW_Dict.count==0) {
#pragma mark - 风险高位疾病
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“风险高位疾病”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (my_yinShiXZ_Dict.count==0) {
#pragma mark - 饮食限制性疾病
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“饮食限制性疾病”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (my_qiTaJB_Dict.count==0) {
#pragma mark - 其他疾病
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“其他疾病”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isRangeOfString:my_qiTaJB_Dict num:qiTaJB_Title_Array.count-1] && [PublicFunction isBlankString:qiTaJBQT_Field.text]) {
#pragma mark - 其他疾病
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“其他疾病的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 已确诊疾病
        [self update_YiQueZhenJB];
    }
}

//更新 已确诊疾病
-(void)update_YiQueZhenJB
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"5" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    
    NSArray * my_chuanRanJB_keysArray=[my_chuanRanJB_Dict allKeys];
    NSMutableString * my_chuanRanJB=[[NSMutableString alloc]init];
    for (int i=0; i<my_chuanRanJB_keysArray.count; i++) {
        if (i==my_chuanRanJB_keysArray.count-1) {
            [my_chuanRanJB appendFormat:@"%@",my_chuanRanJB_keysArray[i]];
        } else {
            [my_chuanRanJB appendFormat:@"%@,",my_chuanRanJB_keysArray[i]];
        }
    }
    [parameter setObject:my_chuanRanJB forKey:@"chuanRanJB"];
    
    
    NSArray * my_fengXianGW_keysArray=[my_fengXianGW_Dict allKeys];
    NSMutableString * my_fengXianGW=[[NSMutableString alloc]init];
    for (int i=0; i<my_fengXianGW_keysArray.count; i++) {
        if (i==my_fengXianGW_keysArray.count-1) {
            [my_fengXianGW appendFormat:@"%@",my_fengXianGW_keysArray[i]];
        } else {
            [my_fengXianGW appendFormat:@"%@,",my_fengXianGW_keysArray[i]];
        }
    }
    [parameter setObject:my_fengXianGW forKey:@"fengXianGW"];
    
    
    NSArray * my_yinShiXZ_keysArray=[my_yinShiXZ_Dict allKeys];
    NSMutableString * my_yinShiXZ=[[NSMutableString alloc]init];
    for (int i=0; i<my_yinShiXZ_keysArray.count; i++) {
        if (i==my_yinShiXZ_keysArray.count-1) {
            [my_yinShiXZ appendFormat:@"%@",my_yinShiXZ_keysArray[i]];
        } else {
            [my_yinShiXZ appendFormat:@"%@,",my_yinShiXZ_keysArray[i]];
        }
    }
    [parameter setObject:my_yinShiXZ forKey:@"yinShiXZ"];
    
    
    NSArray * my_qiTaJB_keysArray=[my_qiTaJB_Dict allKeys];
    NSMutableString * my_qiTaJB=[[NSMutableString alloc]init];
    for (NSString * str in my_qiTaJB_keysArray) {
        if ([str intValue]!=qiTaJB_Title_Array.count-1) {
            [my_qiTaJB appendFormat:@"%@,",str];
        }
    }
    for (NSString * str in my_qiTaJB_keysArray) {
        if ([str intValue]==qiTaJB_Title_Array.count-1) {
            [my_qiTaJB appendFormat:@"X%@",qiTaJBQT_Field.text];
        }
    }
    [parameter setObject:my_qiTaJB forKey:@"qiTaJB"];
    
    
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

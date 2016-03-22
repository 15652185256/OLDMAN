//
//  XinXiCJViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "XinXiCJViewController.h"
#import "XinXiCJModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QCheckBox.h"//复选

#import "QRadioButton.h"//单选

@interface XinXiCJViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * chuBuYX_Title_Array;//初步印象 标题数组
    
    NSMutableDictionary * my_chuBuYX_Dict;//初步印象
    
    UITextField * chuBuYXQT_Field;//初步印象 其他
    
    
    
    NSArray * chuPingJY_Title_Array;//调查建议 标题数组
    
    NSString * my_chuPingJY;//调查建议
    
    UITextField * chuPingJYQT_Field;//调查建议 其他
    
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    XinXiCJModel * _xinXiCJModel;//数据源
}
@end

@implementation XinXiCJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    my_chuBuYX_Dict=[[NSMutableDictionary alloc]init];//初步印象

    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}


//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _xinXiCJModel=[[XinXiCJModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _xinXiCJModel=nil;
    
    [my_chuBuYX_Dict removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}

#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //初步印象 标题数组
    chuBuYX_Title_Array=@[@"城市特困人员",@"农村五保户",@"低保家庭",@"低收入家庭",@"计划生育特殊家庭",@"生活/认知能力重度受损/神智不清",@"神智不清",@"视力丧失",@"其他"];
    
    //调查建议 标题数组
    chuPingJY_Title_Array=@[@"待补充相关证据",@"持续跟进",@"继续进行能力评估",@"其他"];
}

#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"8"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_xinXiCJModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"信息采集初步结果";
    
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
    
    
    //初步印象 标题数组
    UIView * chuBuYX_View=[ZCControl createView:CGRectMake(0, 20, WIDTH, 24*(chuBuYX_Title_Array.count+1))];
    [RootScrollView addSubview:chuBuYX_View];
    
    //初步印象 标题
    UILabel * chuBuYX_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"1. 初步印象"];
    [chuBuYX_View addSubview:chuBuYX_Label];
    chuBuYX_Label.textColor=Title_text_color;
    
    //初步印象 介绍
    UIButton * chuBuYX_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(chuBuYX_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [chuBuYX_View addSubview:chuBuYX_Button];
    chuBuYX_Button.tag=90000;
    
    //请求数据 数组
    NSArray * chuBuYX_strArray;
    if (![PublicFunction isBlankString:_xinXiCJModel.chuBuYX]) {
        chuBuYX_strArray=[_xinXiCJModel.chuBuYX componentsSeparatedByString:@","];
    }
    
    
    //起始高度
    float chuBuYX_View_frame_origin_y=CGRectGetMaxY(chuBuYX_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<chuBuYX_Title_Array.count; i++) {
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15,chuBuYX_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [chuBuYX_View addSubview:xuanXiang_Check];
        
        xuanXiang_Check.tag=3000+i;
        
        if (![PublicFunction isBlankString:_xinXiCJModel.chuBuYX]) {
            int n=0;
            for (int j=0; j<chuBuYX_strArray.count; j++) {
                if (![PublicFunction isBlankString:chuBuYX_strArray[j]]) {
                    if (![[chuBuYX_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
                        if ([chuBuYX_strArray[j] intValue]==i) {
                            [xuanXiang_Check setChecked:YES];
                        }
                        n++;
                    } else {
                        if (i==chuBuYX_Title_Array.count-1) {
                            [xuanXiang_Check setChecked:YES];
                        }
                        break;
                    }
                }
            }
        }
        
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [chuBuYX_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=chuBuYX_Title_Array[i];
    
        chuBuYX_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Check.frame)+Q_ICON_HE;
    }
    
    chuBuYX_View.frame = CGRectMake(0, 20, WIDTH, chuBuYX_View_frame_origin_y);
    
    
    
    //初步印象 其他 签字框
    chuBuYXQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(chuBuYX_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    chuBuYXQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:chuBuYXQT_Field];
    chuBuYXQT_Field.delegate=self;
    chuBuYXQT_Field.userInteractionEnabled=NO;
    

    if (![PublicFunction isBlankString:_xinXiCJModel.chuBuYX]) {
        int n=0;
        NSString * qiTa=@"";
        for (int j=0; j<chuBuYX_strArray.count; j++) {
            if (![PublicFunction isBlankString:chuBuYX_strArray[j]]) {
                if (![[chuBuYX_strArray[j] substringToIndex:1] isEqualToString:@"X"]) {
                    n++;
                } else {
                    chuBuYXQT_Field.userInteractionEnabled=YES;
                    break;
                }
            }
        }
        for (int j=n; j<chuBuYX_strArray.count; j++) {
            if (![PublicFunction isBlankString:chuBuYX_strArray[j]]) {
                if (j!=chuBuYX_strArray.count-1) {
                    qiTa=[qiTa stringByAppendingFormat:@"%@,",chuBuYX_strArray[j]];
                } else {
                    qiTa=[qiTa stringByAppendingFormat:@"%@",chuBuYX_strArray[j]];
                }
            }
        }
        if (![PublicFunction isBlankString:qiTa]) {
            chuBuYXQT_Field.text=[qiTa substringFromIndex:1];
        }
    }
    
    
    
    
    
    
    //调查建议 标题数组
    UIView * diaoChaJY_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(chuBuYXQT_Field.frame)+5, WIDTH, 24*(chuPingJY_Title_Array.count+1))];
    [RootScrollView addSubview:diaoChaJY_View];
    
    //调查建议 标题
    UILabel * diaoChaJY_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"2. 初评建议"];
    [diaoChaJY_View addSubview:diaoChaJY_Label];
    diaoChaJY_Label.textColor=Title_text_color;
    
    //初步印象 介绍
    UIButton * diaoChaJY_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(diaoChaJY_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [diaoChaJY_View addSubview:diaoChaJY_Button];
    diaoChaJY_Button.tag=90001;
    
    //起始高度
    float diaoChaJY_View_frame_origin_y=CGRectGetMaxY(diaoChaJY_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<chuPingJY_Title_Array.count; i++) {
        //选框
        QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"chuPingJY"];
        [diaoChaJY_View addSubview:xuanXiang_Button];
        xuanXiang_Button.frame=CGRectMake(15, diaoChaJY_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
        
        xuanXiang_Button.tag=4000+i;
        
        if (![PublicFunction isBlankString:_xinXiCJModel.chuPingJY]) {
            if ([[_xinXiCJModel.chuPingJY substringToIndex:1] isEqualToString:@"X"]) {
                if (i==chuPingJY_Title_Array.count-1) {
                    [xuanXiang_Button setChecked:YES];
                }
            } else {
                if ([_xinXiCJModel.chuPingJY intValue]==i) {
                    [xuanXiang_Button setChecked:YES];
                }
            }
        }
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [diaoChaJY_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.text=chuPingJY_Title_Array[i];
        
        diaoChaJY_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Button.frame)+Q_ICON_HE;
    }
    
    diaoChaJY_View.frame = CGRectMake(0, CGRectGetMaxY(chuBuYXQT_Field.frame)+20, WIDTH, diaoChaJY_View_frame_origin_y);
    
    
    
    
    //调查建议 其他 签字框
    chuPingJYQT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, CGRectGetMaxY(diaoChaJY_View.frame)+10, WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    chuPingJYQT_Field.textColor=Field_text_color;
    [RootScrollView addSubview:chuPingJYQT_Field];
    chuPingJYQT_Field.delegate=self;
    chuPingJYQT_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_xinXiCJModel.chuPingJY]) {
        if ([[_xinXiCJModel.chuPingJY substringToIndex:1] isEqualToString:@"X"]) {
            chuPingJYQT_Field.userInteractionEnabled=YES;
            chuPingJYQT_Field.text=[_xinXiCJModel.chuPingJY substringFromIndex:1];
        }
    }
    
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(chuPingJYQT_Field.frame)+20);
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
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(chuPingJYQT_Field.frame)+20+Tabbar_HE);
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：为申请人身份特征方法：由评估人员根据与申请人/代理人的沟通及自己的观察得出初步印象或与社区沟通确认。\n\n如有其他未列明情况，请选择“其他”并在横线处注明实际情况。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：经过初步信息采集，得出进一步工作的建议。\n\n定义：（1）待补充相关证件，指的是到目前为止的信息采集尚且不完整，还需要补充一些相关证件才能完成；（2）持续跟进，指的是申请人目前各方面生活自理，暂不需要进行能力评估；（3）继续进行能力评估，指的是评估人员初步判断申请人确实存在部分或完全丧失生活自理能力的情况，可继续完成后续评估表。\n\n记录：本地为单选，须根据调查情况作出判断。"];
            
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
                [my_chuBuYX_Dict setObject:[NSString stringWithFormat:@"%ld",checkbox.tag-3000] forKey:[NSString stringWithFormat:@"%ld",checkbox.tag-3000]];
            } else {
                [my_chuBuYX_Dict removeObjectForKey:[NSString stringWithFormat:@"%ld",checkbox.tag-3000]];
            }
            if (checked==1) {
                if (checkbox.tag-3000==chuBuYX_Title_Array.count-1) {
                    chuBuYXQT_Field.userInteractionEnabled=YES;
                }
            } else {
                chuBuYXQT_Field.userInteractionEnabled=NO;
                chuBuYXQT_Field.text=@"";
            }
        }
            break;
        default:
            break;
    }
}




#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    if ([groupId isEqualToString:@"chuPingJY"]) {
        if (radio.tag-4000==chuPingJY_Title_Array.count-1) {
            chuPingJYQT_Field.userInteractionEnabled=YES;
        } else {
            chuPingJYQT_Field.userInteractionEnabled=NO;
            chuPingJYQT_Field.text=@"";
        }
        my_chuPingJY=[NSString stringWithFormat:@"%ld",radio.tag-4000];
    }
}




#pragma mark - 保存
-(void)Save_Button_Click
{
    
    if (my_chuBuYX_Dict.count==0) {
#pragma mark - 初步印象
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“初步印象”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isRangeOfString:my_chuBuYX_Dict num:chuBuYX_Title_Array.count-1] && [PublicFunction isBlankString:chuBuYXQT_Field.text]) {
#pragma mark - 初步印象 其他
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“初步印象的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_chuPingJY]) {
#pragma mark - 初评建议
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“初评建议”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([my_chuPingJY intValue]==chuPingJY_Title_Array.count-1 && [PublicFunction isBlankString:chuPingJYQT_Field.text]) {
#pragma mark - 初评建议 其他
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“初评建议的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        
        //更新 信息采集初步结果
        [self update_XinXiCJ];
    }
}


//更新 信息采集初步结果
-(void)update_XinXiCJ
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"8" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];

    
    NSArray * my_chuBuYX_keysArray=[my_chuBuYX_Dict allKeys];
    NSMutableString * my_chuBuYX=[[NSMutableString alloc]init];
    for (NSString * str in my_chuBuYX_keysArray) {
        if ([str intValue]!=chuBuYX_Title_Array.count-1) {
            [my_chuBuYX appendFormat:@"%@,",str];
        }
    }
    for (NSString * str in my_chuBuYX_keysArray) {
        if ([str intValue]==chuBuYX_Title_Array.count-1) {
            [my_chuBuYX appendFormat:@"X%@",chuBuYXQT_Field.text];
        }
    }
    [parameter setObject:my_chuBuYX forKey:@"chuBuYX"];
    
    
    
    
    if (![PublicFunction isBlankString:my_chuPingJY]) {
        if ([my_chuPingJY integerValue]==chuPingJY_Title_Array.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",chuPingJYQT_Field.text] forKey:@"chuPingJY"];
        } else {
            [parameter setObject:my_chuPingJY forKey:@"chuPingJY"];
        }
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

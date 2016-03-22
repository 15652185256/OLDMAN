//
//  AdviseJinJiJYViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/7.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseJinJiJYViewController.h"
#import "JinJiJYModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选
@interface AdviseJinJiJYViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * titleArray;//分组标题
    
    NSArray * titleArr;//选项题目数组
    
    
    NSString * anZhuangAQ;//安装安全防护设施
    
    NSString * dingQiJT;//定期家庭安全访视
    
    NSString * jiaTingKJ;//家庭可居住维护
    
    NSString * yuanChengAQ;//远程安全监护
    
    NSString * yingJiJY;//应急救援
    
    
    UITextField * anZhuangAQ_Field;
    
    UITextField * dingQiJT_Field;
    
    UITextField * jiaTingKJ_Field;
    
    UITextField * yuanChengAQ_Field;
    
    UITextField * yingJiJY_Field;
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    JinJiJYModel * _jinJiJYModel;//数据源
}
@end

@implementation AdviseJinJiJYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadDataSource];
}


//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _jinJiJYModel=[[JinJiJYModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _jinJiJYModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}



#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"31"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_jinJiJYModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"紧急救援";
    
    //设置导航背景图
    self.navigationController.navigationBar.barTintColor = Nav_Tabbar_backgroundColor;
    
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

#pragma mark 加载数据
-(void)loadDataSource
{
    titleArray=@[@"1. 安装安全防护设施",@"2. 定期家庭安全访视",@"3. 家庭可居住维护",@"4. 远程安全监护",@"5. 应急救援"];
    
    titleArr=@[@"每天",@"工作日",@"周末",@"每周",@"一次性",@"其他"];
    
}


#pragma mark 设置页面
-(void)createView
{
    RootScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    [self.view addSubview:RootScrollView];
    RootScrollView.backgroundColor=View_Background_Color;
    RootScrollView.delegate=self;
    
    
    
    //root_View 的初始高度
    float RootScrollView_contentSize=20;
    
    
    for (int j=0; j<titleArray.count; j++) {
        
        float rootView_height=40+Q_RADIO_WH*(titleArr.count)+60;
        
        
        //标题
        UILabel * title_Label=[ZCControl createLabelWithFrame:CGRectMake(15, RootScrollView_contentSize, WIDTH-15-55, 16) Font:Title_text_font Text:titleArray[j]];
        [RootScrollView addSubview:title_Label];
        title_Label.textColor=Title_text_color;
        
        
        
        //介绍
        UIButton * JieShao_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(title_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
        [RootScrollView addSubview:JieShao_Button];
        switch (j) {
            case 0:
                JieShao_Button.tag=90000;
                break;
                
            case 1:
                JieShao_Button.tag=90001;
                break;
                
            case 2:
                JieShao_Button.tag=90002;
                break;
                
            case 3:
                JieShao_Button.tag=90003;
                break;
                
            case 4:
                JieShao_Button.tag=90004;
                break;
                
            default:
                break;
        }
        
        for (int n=0; n<titleArr.count; n++) {
            
            //选框
            QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"juZhuQK"];
            [RootScrollView addSubview:xuanXiang_Button];
            xuanXiang_Button.frame=CGRectMake(15, RootScrollView_contentSize+Q_RADIO_WH*(n+1), Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
            
            xuanXiang_Button.tag=n;
            
            
#pragma mark - 紧急救援
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"anZhuangAQ"];
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.anZhuangAQ]) {
                        if ([[_jinJiJYModel.anZhuangAQ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jinJiJYModel.anZhuangAQ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"dingQiJT"];
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.dingQiJT]) {
                        if ([[_jinJiJYModel.dingQiJT substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jinJiJYModel.dingQiJT intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"jiaTingKJ"];
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.jiaTingKJ]) {
                        if ([[_jinJiJYModel.jiaTingKJ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jinJiJYModel.jiaTingKJ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"yuanChengAQ"];
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.yuanChengAQ]) {
                        if ([[_jinJiJYModel.yuanChengAQ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jinJiJYModel.yuanChengAQ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"yingJiJY"];
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.yingJiJY]) {
                        if ([[_jinJiJYModel.yingJiJY substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jinJiJYModel.yingJiJY intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            
            //其他 输入框
            
            switch (j) {
                case 0:
                {
                    anZhuangAQ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    anZhuangAQ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:anZhuangAQ_Field];
                    anZhuangAQ_Field.delegate=self;
                    anZhuangAQ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.anZhuangAQ]) {
                        if ([[_jinJiJYModel.anZhuangAQ substringToIndex:1] isEqualToString:@"X"]) {
                            anZhuangAQ_Field.userInteractionEnabled=YES;
                            anZhuangAQ_Field.text=[_jinJiJYModel.anZhuangAQ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    dingQiJT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    dingQiJT_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:dingQiJT_Field];
                    dingQiJT_Field.delegate=self;
                    dingQiJT_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.dingQiJT]) {
                        if ([[_jinJiJYModel.dingQiJT substringToIndex:1] isEqualToString:@"X"]) {
                            dingQiJT_Field.userInteractionEnabled=YES;
                            dingQiJT_Field.text=[_jinJiJYModel.dingQiJT substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    jiaTingKJ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    jiaTingKJ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:jiaTingKJ_Field];
                    jiaTingKJ_Field.delegate=self;
                    jiaTingKJ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.jiaTingKJ]) {
                        if ([[_jinJiJYModel.jiaTingKJ substringToIndex:1] isEqualToString:@"X"]) {
                            jiaTingKJ_Field.userInteractionEnabled=YES;
                            jiaTingKJ_Field.text=[_jinJiJYModel.jiaTingKJ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    yuanChengAQ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    yuanChengAQ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:yuanChengAQ_Field];
                    yuanChengAQ_Field.delegate=self;
                    yuanChengAQ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.yuanChengAQ]) {
                        if ([[_jinJiJYModel.yuanChengAQ substringToIndex:1] isEqualToString:@"X"]) {
                            yuanChengAQ_Field.userInteractionEnabled=YES;
                            yuanChengAQ_Field.text=[_jinJiJYModel.yuanChengAQ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    yingJiJY_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    yingJiJY_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:yingJiJY_Field];
                    yingJiJY_Field.delegate=self;
                    yingJiJY_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jinJiJYModel.yingJiJY]) {
                        if ([[_jinJiJYModel.yingJiJY substringToIndex:1] isEqualToString:@"X"]) {
                            yingJiJY_Field.userInteractionEnabled=YES;
                            yingJiJY_Field.text=[_jinJiJYModel.yingJiJY substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            
            //选项标题
            UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
            [RootScrollView addSubview:xuanXiang_Label];
            xuanXiang_Label.textColor=Answer_text_color;
            xuanXiang_Label.numberOfLines=0;
            xuanXiang_Label.text=titleArr[n];
        }
        RootScrollView_contentSize=RootScrollView_contentSize+rootView_height;
    }
    
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, RootScrollView_contentSize);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.jianyi intValue]==0 || [self.jianyi intValue]==1 || [self.jianyi intValue]==5 || [self.jianyi intValue]==6) {
            //保存
            Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
            [self.view addSubview:Save_Button];
            [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
            Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
            [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
            
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, RootScrollView_contentSize+Tabbar_HE);
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指根据需要安装扶手、防滑地垫、无障碍通道等设施，以保障老人居家生活安全。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指由专业人员定期上门探访，并对老人居室中的安全状况进行检视，提醒消除安全隐患。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指帮助老人维修维护门窗、检查维护水电煤等设施等，确保日常居住条件齐备、完好。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指由服务机构通过远程监控设备，及时获取老人在家中的安全状况，在发现异常（例如发生入室盗窃等犯罪行为，或老人出现跌倒等意外情况等）后及时响应。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指无论由老人发起（例如通过紧急呼叫设备）或者通过远程安全监护系统，发现紧急情况时，提供及时响应，包括派出救援人员、通知急救机构、通知紧急联系人等。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
#pragma mark - 紧急救援
    
    if ([groupId isEqualToString:@"anZhuangAQ"]) {
        if (radio.tag==titleArr.count-1) {
            anZhuangAQ_Field.userInteractionEnabled=YES;
        } else {
            anZhuangAQ_Field.userInteractionEnabled=NO;
            anZhuangAQ_Field.text=@"";
        }
        anZhuangAQ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"dingQiJT"]) {
        if (radio.tag==titleArr.count-1) {
            dingQiJT_Field.userInteractionEnabled=YES;
        } else {
            dingQiJT_Field.userInteractionEnabled=NO;
            dingQiJT_Field.text=@"";
        }
        dingQiJT=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"jiaTingKJ"]) {
        if (radio.tag==titleArr.count-1) {
            jiaTingKJ_Field.userInteractionEnabled=YES;
        } else {
            jiaTingKJ_Field.userInteractionEnabled=NO;
            jiaTingKJ_Field.text=@"";
        }
        jiaTingKJ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"yuanChengAQ"]) {
        if (radio.tag==titleArr.count-1) {
            yuanChengAQ_Field.userInteractionEnabled=YES;
        } else {
            yuanChengAQ_Field.userInteractionEnabled=NO;
            yuanChengAQ_Field.text=@"";
        }
        yuanChengAQ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"yingJiJY"]) {
        if (radio.tag==titleArr.count-1) {
            yingJiJY_Field.userInteractionEnabled=YES;
        } else {
            yingJiJY_Field.userInteractionEnabled=NO;
            yingJiJY_Field.text=@"";
        }
        yingJiJY=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([anZhuangAQ intValue]==titleArr.count-1 && [PublicFunction isBlankString:anZhuangAQ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“安装安全防护设施的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([dingQiJT intValue]==titleArr.count-1 && [PublicFunction isBlankString:dingQiJT_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“定期家庭安全访视的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([jiaTingKJ intValue]==titleArr.count-1 && [PublicFunction isBlankString:jiaTingKJ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“家庭可居住维护的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([yuanChengAQ intValue]==titleArr.count-1 && [PublicFunction isBlankString:yuanChengAQ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“远程安全监护的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([yingJiJY intValue]==titleArr.count-1 && [PublicFunction isBlankString:yingJiJY_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“应急救援的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 紧急救援
        [self update_JinJiJY];
    }
    
}




#pragma mark - 紧急救援
-(void)update_JinJiJY
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"31" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    

    
    if (![PublicFunction isBlankString:anZhuangAQ]) {
        if ([anZhuangAQ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",anZhuangAQ_Field.text] forKey:@"anZhuangAQ"];
        } else {
            [parameter setObject:anZhuangAQ forKey:@"anZhuangAQ"];
        }
    }
    
    if (![PublicFunction isBlankString:dingQiJT]) {
        if ([dingQiJT integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",dingQiJT_Field.text] forKey:@"dingQiJT"];
        } else {
            [parameter setObject:dingQiJT forKey:@"dingQiJT"];
        }
    }
    
    if (![PublicFunction isBlankString:jiaTingKJ]) {
        if ([jiaTingKJ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",jiaTingKJ_Field.text] forKey:@"jiaTingKJ"];
        } else {
            [parameter setObject:jiaTingKJ forKey:@"jiaTingKJ"];
        }
    }
    
    if (![PublicFunction isBlankString:yuanChengAQ]) {
        if ([yuanChengAQ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",yuanChengAQ_Field.text] forKey:@"yuanChengAQ"];
        } else {
            [parameter setObject:yuanChengAQ forKey:@"yuanChengAQ"];
        }
    }
    
    if (![PublicFunction isBlankString:yingJiJY]) {
        if ([yingJiJY integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",yingJiJY_Field.text] forKey:@"yingJiJY"];
        } else {
            [parameter setObject:yingJiJY forKey:@"yingJiJY"];
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

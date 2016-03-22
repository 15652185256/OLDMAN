//
//  AdviseYiLiaoWSViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/7.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseYiLiaoWSViewController.h"
#import "YiLiaoWSModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选
@interface AdviseYiLiaoWSViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * titleArray;//分组标题
    
    NSArray * titleArr;//选项题目数组
    
    
    NSString * shengLiZB;//生理指标监测及健康干预提示
    
    NSString * dingQiJX;//定期进行健康体检和能力评估
    
    NSString * dingQiJC;//定期检查/装填处方药服药盒
    
    NSString * kangFuDL;//康复锻炼/护理
    
    NSString * dingQiPT;//定期陪同就医/领取处方药
    
    
    UITextField * shengLiZB_Field;
    
    UITextField * dingQiJX_Field;
    
    UITextField * dingQiJC_Field;
    
    UITextField * kangFuDL_Field;
    
    UITextField * dingQiPT_Field;
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    YiLiaoWSModel * _yiLiaoWSModel;//数据源
}
@end

@implementation AdviseYiLiaoWSViewController

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
    _yiLiaoWSModel=[[YiLiaoWSModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _yiLiaoWSModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"29"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_yiLiaoWSModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"医疗卫生";
    
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
    titleArray=@[@"1. 生理指标监测及健康干预提示",@"2. 定期进行健康体检和能力评估",@"3. 定期检查/装填处方药服药盒",@"4. 康复锻炼/护理",@"5. 定期陪同就医/领取处方药"];
    
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
        UILabel * title_Label=[ZCControl createLabelWithFrame:CGRectMake(15, RootScrollView_contentSize, WIDTH-15-55, Title_text_font) Font:Title_text_font Text:titleArray[j]];
        [RootScrollView addSubview:title_Label];
        title_Label.textColor=Title_text_color;
        title_Label.numberOfLines=1;
        
        
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
            
            
#pragma mark - 医疗卫生
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"shengLiZB"];
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.shengLiZB]) {
                        if ([[_yiLiaoWSModel.shengLiZB substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yiLiaoWSModel.shengLiZB intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"dingQiJX"];
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.dingQiJX]) {
                        if ([[_yiLiaoWSModel.dingQiJX substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yiLiaoWSModel.dingQiJX intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"dingQiJC"];
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.dingQiJC]) {
                        if ([[_yiLiaoWSModel.dingQiJC substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yiLiaoWSModel.dingQiJC intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"kangFuDL"];
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.kangFuDL]) {
                        if ([[_yiLiaoWSModel.kangFuDL substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yiLiaoWSModel.kangFuDL intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"dingQiPT"];
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.dingQiPT]) {
                        if ([[_yiLiaoWSModel.dingQiPT substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yiLiaoWSModel.dingQiPT intValue]==n) {
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
                    shengLiZB_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    shengLiZB_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:shengLiZB_Field];
                    shengLiZB_Field.delegate=self;
                    shengLiZB_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.shengLiZB]) {
                        if ([[_yiLiaoWSModel.shengLiZB substringToIndex:1] isEqualToString:@"X"]) {
                            shengLiZB_Field.userInteractionEnabled=YES;
                            shengLiZB_Field.text=[_yiLiaoWSModel.shengLiZB substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    dingQiJX_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    dingQiJX_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:dingQiJX_Field];
                    dingQiJX_Field.delegate=self;
                    dingQiJX_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.dingQiJX]) {
                        if ([[_yiLiaoWSModel.dingQiJX substringToIndex:1] isEqualToString:@"X"]) {
                            dingQiJX_Field.userInteractionEnabled=YES;
                            dingQiJX_Field.text=[_yiLiaoWSModel.dingQiJX substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    dingQiJC_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    dingQiJC_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:dingQiJC_Field];
                    dingQiJC_Field.delegate=self;
                    dingQiJC_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.dingQiJC]) {
                        if ([[_yiLiaoWSModel.dingQiJC substringToIndex:1] isEqualToString:@"X"]) {
                            dingQiJC_Field.userInteractionEnabled=YES;
                            dingQiJC_Field.text=[_yiLiaoWSModel.dingQiJC substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    kangFuDL_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    kangFuDL_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:kangFuDL_Field];
                    kangFuDL_Field.delegate=self;
                    kangFuDL_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.kangFuDL]) {
                        if ([[_yiLiaoWSModel.kangFuDL substringToIndex:1] isEqualToString:@"X"]) {
                            kangFuDL_Field.userInteractionEnabled=YES;
                            kangFuDL_Field.text=[_yiLiaoWSModel.kangFuDL substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    dingQiPT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    dingQiPT_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:dingQiPT_Field];
                    dingQiPT_Field.delegate=self;
                    dingQiPT_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yiLiaoWSModel.dingQiPT]) {
                        if ([[_yiLiaoWSModel.dingQiPT substringToIndex:1] isEqualToString:@"X"]) {
                            dingQiPT_Field.userInteractionEnabled=YES;
                            dingQiPT_Field.text=[_yiLiaoWSModel.dingQiPT substringFromIndex:1];
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指给申请人测量体温、脉搏、血压、护膝等指标，提醒老人遵医嘱进行治疗或用药的服务。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指体检和对老人生活自理能力进行评估，就像今天这样的评估。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指按医生的要求把要分装到服药盒里，还有检查服药盒里的药装的对不对、有没有按要求服用。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指由专业的康复护理人员来给老人进行康复锻炼和护理。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指有专人来陪着老人去医院看病，或者陪老人去开药、取药。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
#pragma mark - 医疗卫生
    
    if ([groupId isEqualToString:@"shengLiZB"]) {
        if (radio.tag==titleArr.count-1) {
            shengLiZB_Field.userInteractionEnabled=YES;
        } else {
            shengLiZB_Field.userInteractionEnabled=NO;
            shengLiZB_Field.text=@"";
        }
        shengLiZB=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"dingQiJX"]) {
        if (radio.tag==titleArr.count-1) {
            dingQiJX_Field.userInteractionEnabled=YES;
        } else {
            dingQiJX_Field.userInteractionEnabled=NO;
            dingQiJX_Field.text=@"";
        }
        dingQiJX=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"dingQiJC"]) {
        if (radio.tag==titleArr.count-1) {
            dingQiJC_Field.userInteractionEnabled=YES;
        } else {
            dingQiJC_Field.userInteractionEnabled=NO;
            dingQiJC_Field.text=@"";
        }
        dingQiJC=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"kangFuDL"]) {
        if (radio.tag==titleArr.count-1) {
            kangFuDL_Field.userInteractionEnabled=YES;
        } else {
            kangFuDL_Field.userInteractionEnabled=NO;
            kangFuDL_Field.text=@"";
        }
        kangFuDL=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"dingQiPT"]) {
        if (radio.tag==titleArr.count-1) {
            dingQiPT_Field.userInteractionEnabled=YES;
        } else {
            dingQiPT_Field.userInteractionEnabled=NO;
            dingQiPT_Field.text=@"";
        }
        dingQiPT=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([shengLiZB intValue]==titleArr.count-1 && [PublicFunction isBlankString:shengLiZB_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“生理指标监测及健康干预提示的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([dingQiJX intValue]==titleArr.count-1 && [PublicFunction isBlankString:dingQiJX_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“定期进行健康体检和能力评估的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([dingQiJC intValue]==titleArr.count-1 && [PublicFunction isBlankString:dingQiJC_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“定期检查/装填处方药服药盒的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([kangFuDL intValue]==titleArr.count-1 && [PublicFunction isBlankString:kangFuDL_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“康复锻炼/护理的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([dingQiPT intValue]==titleArr.count-1 && [PublicFunction isBlankString:dingQiPT_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“定期陪同就医/领取处方药的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 医疗卫生
        [self update_YiLiaoWS];
    }
    
}



//更新 医疗卫生
-(void)update_YiLiaoWS
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"29" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
#pragma mark - 医疗卫生
    
    if (![PublicFunction isBlankString:shengLiZB]) {
        if ([shengLiZB integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",shengLiZB_Field.text] forKey:@"shengLiZB"];
        } else {
            [parameter setObject:shengLiZB forKey:@"shengLiZB"];
        }
    }
    
    if (![PublicFunction isBlankString:dingQiJX]) {
        if ([dingQiJX integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",dingQiJX_Field.text] forKey:@"dingQiJX"];
        } else {
            [parameter setObject:dingQiJX forKey:@"dingQiJX"];
        }
    }
    
    if (![PublicFunction isBlankString:dingQiJC]) {
        if ([dingQiJC integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",dingQiJC_Field.text] forKey:@"dingQiJC"];
        } else {
            [parameter setObject:dingQiJC forKey:@"dingQiJC"];
        }
    }
    
    if (![PublicFunction isBlankString:kangFuDL]) {
        if ([kangFuDL integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",kangFuDL_Field.text] forKey:@"kangFuDL"];
        } else {
            [parameter setObject:kangFuDL forKey:@"kangFuDL"];
        }
    }
    
    if (![PublicFunction isBlankString:dingQiPT]) {
        if ([dingQiPT integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",dingQiPT_Field.text] forKey:@"dingQiPT"];
        } else {
            [parameter setObject:dingQiPT forKey:@"dingQiPT"];
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

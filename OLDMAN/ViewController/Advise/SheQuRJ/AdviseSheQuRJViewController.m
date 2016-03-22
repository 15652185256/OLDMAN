//
//  AdviseSheQuRJViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/7.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseSheQuRJViewController.h"
#import "SheQuRJModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选
@interface AdviseSheQuRJViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * titleArray;//分组标题
    
    NSArray * titleArr;//选项题目数组
    
    
    NSString * yingYangSS2;//营养膳食
    
    NSString * geRenSS;//个人修饰
    
    NSString * fuYaoGL;//服药管理
    
    NSString * kangFuXL;//康复训练
    
    NSString * yiWuXD;//衣物洗涤
    
    NSString * xinLiSD;//心理疏导
    
    NSString * sheJiaoYL;//社交娱乐
    
    
    UITextField * yingYangSS2_Field;
    
    UITextField * geRenSS_Field;
    
    UITextField * fuYaoGL_Field;
    
    UITextField * kangFuXL_Field;
    
    UITextField * yiWuXD_Field;
    
    UITextField * xinLiSD_Field;
    
    UITextField * sheJiaoYL_Field;
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    SheQuRJModel * _sheQuRJModel;//数据源
}
@end

@implementation AdviseSheQuRJViewController

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
    _sheQuRJModel=[[SheQuRJModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _sheQuRJModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}

#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"32"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_sheQuRJModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"社区日间照料";
    
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
    titleArray=@[@"1. 营养膳食",@"2. 个人修饰",@"3. 服药管理",@"4. 康复训练",@"5. 衣物洗涤",@"6. 心理疏导",@"7. 社交娱乐"];
    
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
                
            case 5:
                JieShao_Button.tag=90005;
                break;
                
            case 6:
                JieShao_Button.tag=90006;
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
            
            
#pragma mark - 社区日间照料
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"yingYangSS2"];
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.yingYangSS]) {
                        if ([[_sheQuRJModel.yingYangSS substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_sheQuRJModel.yingYangSS intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"geRenSS"];
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.geRenSS]) {
                        if ([[_sheQuRJModel.geRenSS substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_sheQuRJModel.geRenSS intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"fuYaoGL"];
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.fuYaoGL]) {
                        if ([[_sheQuRJModel.fuYaoGL substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_sheQuRJModel.fuYaoGL intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"kangFuXL"];
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.kangFuXL]) {
                        if ([[_sheQuRJModel.kangFuXL substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_sheQuRJModel.kangFuXL intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"yiWuXD"];
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.yiWuXD]) {
                        if ([[_sheQuRJModel.yiWuXD substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_sheQuRJModel.yiWuXD intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 5:
                {
                    [xuanXiang_Button getGroupId:@"xinLiSD"];
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.xinLiSD]) {
                        if ([[_sheQuRJModel.xinLiSD substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_sheQuRJModel.xinLiSD intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 6:
                {
                    [xuanXiang_Button getGroupId:@"sheJiaoYL"];
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.sheJiaoYL]) {
                        if ([[_sheQuRJModel.sheJiaoYL substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_sheQuRJModel.sheJiaoYL intValue]==n) {
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
                    yingYangSS2_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    yingYangSS2_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:yingYangSS2_Field];
                    yingYangSS2_Field.delegate=self;
                    yingYangSS2_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.yingYangSS]) {
                        if ([[_sheQuRJModel.yingYangSS substringToIndex:1] isEqualToString:@"X"]) {
                            yingYangSS2_Field.userInteractionEnabled=YES;
                            yingYangSS2_Field.text=[_sheQuRJModel.yingYangSS substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    geRenSS_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    geRenSS_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:geRenSS_Field];
                    geRenSS_Field.delegate=self;
                    geRenSS_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.geRenSS]) {
                        if ([[_sheQuRJModel.geRenSS substringToIndex:1] isEqualToString:@"X"]) {
                            geRenSS_Field.userInteractionEnabled=YES;
                            geRenSS_Field.text=[_sheQuRJModel.geRenSS substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    fuYaoGL_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    fuYaoGL_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:fuYaoGL_Field];
                    fuYaoGL_Field.delegate=self;
                    fuYaoGL_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.fuYaoGL]) {
                        if ([[_sheQuRJModel.fuYaoGL substringToIndex:1] isEqualToString:@"X"]) {
                            fuYaoGL_Field.userInteractionEnabled=YES;
                            fuYaoGL_Field.text=[_sheQuRJModel.fuYaoGL substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    kangFuXL_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    kangFuXL_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:kangFuXL_Field];
                    kangFuXL_Field.delegate=self;
                    kangFuXL_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.kangFuXL]) {
                        if ([[_sheQuRJModel.kangFuXL substringToIndex:1] isEqualToString:@"X"]) {
                            kangFuXL_Field.userInteractionEnabled=YES;
                            kangFuXL_Field.text=[_sheQuRJModel.kangFuXL substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    yiWuXD_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    yiWuXD_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:yiWuXD_Field];
                    yiWuXD_Field.delegate=self;
                    yiWuXD_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.yiWuXD]) {
                        if ([[_sheQuRJModel.yiWuXD substringToIndex:1] isEqualToString:@"X"]) {
                            yiWuXD_Field.userInteractionEnabled=YES;
                            yiWuXD_Field.text=[_sheQuRJModel.yiWuXD substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 5:
                {
                    xinLiSD_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    xinLiSD_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:xinLiSD_Field];
                    xinLiSD_Field.delegate=self;
                    xinLiSD_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.xinLiSD]) {
                        if ([[_sheQuRJModel.xinLiSD substringToIndex:1] isEqualToString:@"X"]) {
                            xinLiSD_Field.userInteractionEnabled=YES;
                            xinLiSD_Field.text=[_sheQuRJModel.xinLiSD substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 6:
                {
                    sheJiaoYL_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    sheJiaoYL_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:sheJiaoYL_Field];
                    sheJiaoYL_Field.delegate=self;
                    sheJiaoYL_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_sheQuRJModel.sheJiaoYL]) {
                        if ([[_sheQuRJModel.sheJiaoYL substringToIndex:1] isEqualToString:@"X"]) {
                            sheJiaoYL_Field.userInteractionEnabled=YES;
                            sheJiaoYL_Field.text=[_sheQuRJModel.sheJiaoYL substringFromIndex:1];
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指在社区老年人日间照料中心根据每个老人的身体健康状况和疾病特殊要求，提供营养、健康、全面、适宜的膳食，一般可能包括早餐、午餐。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定制：指在社区老年人日间照料中心向老人提供理发（美发）、美容等服务，让老人保持良好的个人形象。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指在社区老年人日间照料中心向老人提供服药体现、协助服药、摆药等服务，确保老人遵医嘱安全、及时合理用药。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指在社区老年人日间照料中心针对每个老人的疾病和功能状况，提供老年人康复锻炼的服务。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指就是在社区老年人日间照料中心向老人提供所需要的洗衣、干衣、熨烫等服务。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指在社区老年人日间照料中心向老人提供心理状况评估和有的放矢的疏导、开解服务。"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指在社区老年人日间照料中心组织老人开展各种社交和娱乐活动，可能包括但不限于棋牌类、书画类、歌舞类、园艺类活动。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
#pragma mark - 社区日间照料
    
    if ([groupId isEqualToString:@"yingYangSS2"]) {
        if (radio.tag==titleArr.count-1) {
            yingYangSS2_Field.userInteractionEnabled=YES;
        } else {
            yingYangSS2_Field.userInteractionEnabled=NO;
            yingYangSS2_Field.text=@"";
        }
        yingYangSS2=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"geRenSS"]) {
        if (radio.tag==titleArr.count-1) {
            geRenSS_Field.userInteractionEnabled=YES;
        } else {
            geRenSS_Field.userInteractionEnabled=NO;
            geRenSS_Field.text=@"";
        }
        geRenSS=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"fuYaoGL"]) {
        if (radio.tag==titleArr.count-1) {
            fuYaoGL_Field.userInteractionEnabled=YES;
        } else {
            fuYaoGL_Field.userInteractionEnabled=NO;
            fuYaoGL_Field.text=@"";
        }
        fuYaoGL=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"kangFuXL"]) {
        if (radio.tag==titleArr.count-1) {
            kangFuXL_Field.userInteractionEnabled=YES;
        } else {
            kangFuXL_Field.userInteractionEnabled=NO;
            kangFuXL_Field.text=@"";
        }
        kangFuXL=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"yiWuXD"]) {
        if (radio.tag==titleArr.count-1) {
            yiWuXD_Field.userInteractionEnabled=YES;
        } else {
            yiWuXD_Field.userInteractionEnabled=NO;
            yiWuXD_Field.text=@"";
        }
        yiWuXD=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"xinLiSD"]) {
        if (radio.tag==titleArr.count-1) {
            xinLiSD_Field.userInteractionEnabled=YES;
        } else {
            xinLiSD_Field.userInteractionEnabled=NO;
            xinLiSD_Field.text=@"";
        }
        xinLiSD=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"sheJiaoYL"]) {
        if (radio.tag==titleArr.count-1) {
            sheJiaoYL_Field.userInteractionEnabled=YES;
        } else {
            sheJiaoYL_Field.userInteractionEnabled=NO;
            sheJiaoYL_Field.text=@"";
        }
        sheJiaoYL=[NSString stringWithFormat:@"%ld",radio.tag];
    }
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([yingYangSS2 intValue]==titleArr.count-1 && [PublicFunction isBlankString:yingYangSS2_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“营养膳食的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([geRenSS intValue]==titleArr.count-1 && [PublicFunction isBlankString:geRenSS_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“个人修饰的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([fuYaoGL intValue]==titleArr.count-1 && [PublicFunction isBlankString:fuYaoGL_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“服药管理的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([kangFuXL intValue]==titleArr.count-1 && [PublicFunction isBlankString:kangFuXL_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“康复训练的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([yiWuXD intValue]==titleArr.count-1 && [PublicFunction isBlankString:yiWuXD_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“衣物洗涤的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([xinLiSD intValue]==titleArr.count-1 && [PublicFunction isBlankString:xinLiSD_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“心理疏导的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([sheJiaoYL intValue]==titleArr.count-1 && [PublicFunction isBlankString:sheJiaoYL_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“社交娱乐的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 社区日间照料
        [self update_SheQuRJ];
    }
    
}



#pragma mark - 社区日间照料
-(void)update_SheQuRJ
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"32" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    

    
    if (![PublicFunction isBlankString:yingYangSS2]) {
        if ([yingYangSS2 integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",yingYangSS2_Field.text] forKey:@"yingYangSS"];
        } else {
            [parameter setObject:yingYangSS2 forKey:@"yingYangSS"];
        }
    }
    
    if (![PublicFunction isBlankString:geRenSS]) {
        if ([geRenSS integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",geRenSS_Field.text] forKey:@"geRenSS"];
        } else {
            [parameter setObject:geRenSS forKey:@"geRenSS"];
        }
    }
    
    if (![PublicFunction isBlankString:fuYaoGL]) {
        if ([fuYaoGL integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",fuYaoGL_Field.text] forKey:@"fuYaoGL"];
        } else {
            [parameter setObject:fuYaoGL forKey:@"fuYaoGL"];
        }
    }
    
    if (![PublicFunction isBlankString:kangFuXL]) {
        if ([kangFuXL integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",kangFuXL_Field.text] forKey:@"kangFuXL"];
        } else {
            [parameter setObject:kangFuXL forKey:@"kangFuXL"];
        }
    }
    
    if (![PublicFunction isBlankString:yiWuXD]) {
        if ([yiWuXD integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",yiWuXD_Field.text] forKey:@"yiWuXD"];
        } else {
            [parameter setObject:yiWuXD forKey:@"yiWuXD"];
        }
    }
    
    if (![PublicFunction isBlankString:xinLiSD]) {
        if ([xinLiSD integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",xinLiSD_Field.text] forKey:@"xinLiSD"];
        } else {
            [parameter setObject:xinLiSD forKey:@"xinLiSD"];
        }
    }
    
    if (![PublicFunction isBlankString:sheJiaoYL]) {
        if ([sheJiaoYL integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",sheJiaoYL_Field.text] forKey:@"sheJiaoYL"];
        } else {
            [parameter setObject:sheJiaoYL forKey:@"sheJiaoYL"];
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

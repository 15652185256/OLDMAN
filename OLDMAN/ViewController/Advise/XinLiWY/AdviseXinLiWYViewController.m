//
//  AdviseXinLiWYViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/7.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseXinLiWYViewController.h"
#import "XinLiWYModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选
@interface AdviseXinLiWYViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * titleArray;//分组标题
    
    NSArray * titleArr;//选项题目数组
    
    
    NSString * shengHuoJN;//生活技能指导
    
    NSString * guanHuanFS;//关怀访视/情感支援
    
    NSString * sheJiaoSS;//社交/生活陪伴
    
    NSString * jiaTingWH;//家庭文化活动及娱乐规划
    
    NSString * xinLiZX;//心理咨询
    
    NSString * buLiangQX;//不良情绪预防及干预
    
    NSString * chuXingJH;//出行规划及交通协助
    
    
    UITextField * shengHuoJN_Field;
    
    UITextField * guanHuanFS_Field;
    
    UITextField * sheJiaoSS_Field;
    
    UITextField * jiaTingWH_Field;
    
    UITextField * xinLiZX_Field;
    
    UITextField * buLiangQX_Field;
    
    UITextField * chuXingJH_Field;
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    XinLiWYModel * _xinLiWYModel;//数据源
}

@end

@implementation AdviseXinLiWYViewController

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
    _xinLiWYModel=[[XinLiWYModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _xinLiWYModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"34"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_xinLiWYModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"心理及文娱活动";
    
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
    titleArray=@[@"1. 生活技能指导",@"2. 关怀访视/情感支援",@"3. 社交/生活陪伴",@"4. 家庭文化活动及娱乐规划",@"5. 心理咨询",@"6. 不良情绪预防及干预",@"7. 出行规划及交通协助"];
    
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
            
            
#pragma mark - 心理及文娱活动
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"shengHuoJN"];
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.shengHuoJN]) {
                        if ([[_xinLiWYModel.shengHuoJN substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_xinLiWYModel.shengHuoJN intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"guanHuanFS"];
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.guanHuanFS]) {
                        if ([[_xinLiWYModel.guanHuanFS substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_xinLiWYModel.guanHuanFS intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"sheJiaoSS"];
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.sheJiaoSS]) {
                        if ([[_xinLiWYModel.sheJiaoSS substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_xinLiWYModel.sheJiaoSS intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"jiaTingWH"];
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.jiaTingWH]) {
                        if ([[_xinLiWYModel.jiaTingWH substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_xinLiWYModel.jiaTingWH intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"xinLiZX"];
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.xinLiZX]) {
                        if ([[_xinLiWYModel.xinLiZX substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_xinLiWYModel.xinLiZX intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 5:
                {
                    [xuanXiang_Button getGroupId:@"buLiangQX"];
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.buLiangQX]) {
                        if ([[_xinLiWYModel.buLiangQX substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_xinLiWYModel.buLiangQX intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 6:
                {
                    [xuanXiang_Button getGroupId:@"chuXingJH"];
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.chuXingJH]) {
                        if ([[_xinLiWYModel.chuXingJH substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_xinLiWYModel.chuXingJH intValue]==n) {
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
                    shengHuoJN_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    shengHuoJN_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:shengHuoJN_Field];
                    shengHuoJN_Field.delegate=self;
                    shengHuoJN_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.shengHuoJN]) {
                        if ([[_xinLiWYModel.shengHuoJN substringToIndex:1] isEqualToString:@"X"]) {
                            shengHuoJN_Field.userInteractionEnabled=YES;
                            shengHuoJN_Field.text=[_xinLiWYModel.shengHuoJN substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    guanHuanFS_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    guanHuanFS_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:guanHuanFS_Field];
                    guanHuanFS_Field.delegate=self;
                    guanHuanFS_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.guanHuanFS]) {
                        if ([[_xinLiWYModel.guanHuanFS substringToIndex:1] isEqualToString:@"X"]) {
                            guanHuanFS_Field.userInteractionEnabled=YES;
                            guanHuanFS_Field.text=[_xinLiWYModel.guanHuanFS substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    sheJiaoSS_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    sheJiaoSS_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:sheJiaoSS_Field];
                    sheJiaoSS_Field.delegate=self;
                    sheJiaoSS_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.sheJiaoSS]) {
                        if ([[_xinLiWYModel.sheJiaoSS substringToIndex:1] isEqualToString:@"X"]) {
                            sheJiaoSS_Field.userInteractionEnabled=YES;
                            sheJiaoSS_Field.text=[_xinLiWYModel.sheJiaoSS substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    jiaTingWH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    jiaTingWH_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:jiaTingWH_Field];
                    jiaTingWH_Field.delegate=self;
                    jiaTingWH_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.jiaTingWH]) {
                        if ([[_xinLiWYModel.jiaTingWH substringToIndex:1] isEqualToString:@"X"]) {
                            jiaTingWH_Field.userInteractionEnabled=YES;
                            jiaTingWH_Field.text=[_xinLiWYModel.jiaTingWH substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    xinLiZX_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    xinLiZX_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:xinLiZX_Field];
                    xinLiZX_Field.delegate=self;
                    xinLiZX_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.xinLiZX]) {
                        if ([[_xinLiWYModel.xinLiZX substringToIndex:1] isEqualToString:@"X"]) {
                            xinLiZX_Field.userInteractionEnabled=YES;
                            xinLiZX_Field.text=[_xinLiWYModel.xinLiZX substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 5:
                {
                    buLiangQX_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    buLiangQX_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:buLiangQX_Field];
                    buLiangQX_Field.delegate=self;
                    buLiangQX_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.buLiangQX]) {
                        if ([[_xinLiWYModel.buLiangQX substringToIndex:1] isEqualToString:@"X"]) {
                            buLiangQX_Field.userInteractionEnabled=YES;
                            buLiangQX_Field.text=[_xinLiWYModel.buLiangQX substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 6:
                {
                    chuXingJH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    chuXingJH_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:chuXingJH_Field];
                    chuXingJH_Field.delegate=self;
                    chuXingJH_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_xinLiWYModel.chuXingJH]) {
                        if ([[_xinLiWYModel.chuXingJH substringToIndex:1] isEqualToString:@"X"]) {
                            chuXingJH_Field.userInteractionEnabled=YES;
                            chuXingJH_Field.text=[_xinLiWYModel.chuXingJH substringFromIndex:1];
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指的是由专业人员向老人提供当前状况下（例如半失能）解决生活中可能存在的困难所需要的技能指导和帮助。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指的是由专业人员上门探访老人，提供关怀，对老人进行情感方面的支援。"];
            
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指由专业人员提供的心理辅导工作。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指的是对于经过评估发现存在不同程度焦虑、抑郁等负面心理状态的老人，由专业人员给予关注，提前预防心理问题的发生，并对已经发生的不良情绪进行安抚，疏导等干预服务。"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指的是对于行动不便的老人，由专业人员帮助其规划处行路线、工具，并在必要时给予陪伴护送、预订交通工具等服务。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
#pragma mark - 心理及文娱活动
    
    if ([groupId isEqualToString:@"shengHuoJN"]) {
        if (radio.tag==titleArr.count-1) {
            shengHuoJN_Field.userInteractionEnabled=YES;
        } else {
            shengHuoJN_Field.userInteractionEnabled=NO;
            shengHuoJN_Field.text=@"";
        }
        shengHuoJN=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"guanHuanFS"]) {
        if (radio.tag==titleArr.count-1) {
            guanHuanFS_Field.userInteractionEnabled=YES;
        } else {
            guanHuanFS_Field.userInteractionEnabled=NO;
            guanHuanFS_Field.text=@"";
        }
        guanHuanFS=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"sheJiaoSS"]) {
        if (radio.tag==titleArr.count-1) {
            sheJiaoSS_Field.userInteractionEnabled=YES;
        } else {
            sheJiaoSS_Field.userInteractionEnabled=NO;
            sheJiaoSS_Field.text=@"";
        }
        sheJiaoSS=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"jiaTingWH"]) {
        if (radio.tag==titleArr.count-1) {
            jiaTingWH_Field.userInteractionEnabled=YES;
        } else {
            jiaTingWH_Field.userInteractionEnabled=NO;
            jiaTingWH_Field.text=@"";
        }
        jiaTingWH=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"xinLiZX"]) {
        if (radio.tag==titleArr.count-1) {
            xinLiZX_Field.userInteractionEnabled=YES;
        } else {
            xinLiZX_Field.userInteractionEnabled=NO;
            xinLiZX_Field.text=@"";
        }
        xinLiZX=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"buLiangQX"]) {
        if (radio.tag==titleArr.count-1) {
            buLiangQX_Field.userInteractionEnabled=YES;
        } else {
            buLiangQX_Field.userInteractionEnabled=NO;
            buLiangQX_Field.text=@"";
        }
        buLiangQX=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"chuXingJH"]) {
        if (radio.tag==titleArr.count-1) {
            chuXingJH_Field.userInteractionEnabled=YES;
        } else {
            chuXingJH_Field.userInteractionEnabled=NO;
            chuXingJH_Field.text=@"";
        }
        chuXingJH=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
}



#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([shengHuoJN intValue]==titleArr.count-1 && [PublicFunction isBlankString:shengHuoJN_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“生活技能指导的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([guanHuanFS intValue]==titleArr.count-1 && [PublicFunction isBlankString:guanHuanFS_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“关怀访视/情感支援的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([sheJiaoSS intValue]==titleArr.count-1 && [PublicFunction isBlankString:sheJiaoSS_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“社交/生活陪伴的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([jiaTingWH intValue]==titleArr.count-1 && [PublicFunction isBlankString:jiaTingWH_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“家庭文化活动及娱乐规划的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([xinLiZX intValue]==titleArr.count-1 && [PublicFunction isBlankString:xinLiZX_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“心理咨询的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([buLiangQX intValue]==titleArr.count-1 && [PublicFunction isBlankString:buLiangQX_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“不良情绪预防及干预的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([chuXingJH intValue]==titleArr.count-1 && [PublicFunction isBlankString:chuXingJH_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“出行规划及交通协助的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 心理及文娱活动
        [self update_XinLiWY];
    }
    
}




#pragma mark - 心理及文娱活动
-(void)update_XinLiWY
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"34" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    

    
    if (![PublicFunction isBlankString:shengHuoJN]) {
        if ([shengHuoJN integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",shengHuoJN_Field.text] forKey:@"shengHuoJN"];
        } else {
            [parameter setObject:shengHuoJN forKey:@"shengHuoJN"];
        }
    }
    
    if (![PublicFunction isBlankString:guanHuanFS]) {
        if ([guanHuanFS integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",guanHuanFS_Field.text] forKey:@"guanHuanFS"];
        } else {
            [parameter setObject:guanHuanFS forKey:@"guanHuanFS"];
        }
    }
    
    if (![PublicFunction isBlankString:sheJiaoSS]) {
        if ([sheJiaoSS integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",sheJiaoSS_Field.text] forKey:@"sheJiaoSS"];
        } else {
            [parameter setObject:sheJiaoSS forKey:@"sheJiaoSS"];
        }
    }
    
    if (![PublicFunction isBlankString:jiaTingWH]) {
        if ([jiaTingWH integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",jiaTingWH_Field.text] forKey:@"jiaTingWH"];
        } else {
            [parameter setObject:jiaTingWH forKey:@"jiaTingWH"];
        }
    }
    
    if (![PublicFunction isBlankString:xinLiZX]) {
        if ([xinLiZX integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",xinLiZX_Field.text] forKey:@"xinLiZX"];
        } else {
            [parameter setObject:xinLiZX forKey:@"xinLiZX"];
        }
    }
    
    if (![PublicFunction isBlankString:buLiangQX]) {
        if ([buLiangQX integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",buLiangQX_Field.text] forKey:@"buLiangQX"];
        } else {
            [parameter setObject:buLiangQX forKey:@"buLiangQX"];
        }
    }
    
    if (![PublicFunction isBlankString:chuXingJH]) {
        if ([chuXingJH integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",chuXingJH_Field.text] forKey:@"chuXingJH"];
        } else {
            [parameter setObject:chuXingJH forKey:@"chuXingJH"];
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

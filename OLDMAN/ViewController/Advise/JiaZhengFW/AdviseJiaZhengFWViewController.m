//
//  AdviseJiaZhengFWViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/7.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseJiaZhengFWViewController.h"
#import "JiaZhengFWModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选
@interface AdviseJiaZhengFWViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * titleArray;//分组标题
    
    NSArray * titleArr;//选项题目数组

    
    
    NSString * caiGouRC;//采购日常生活用品/食品
    
    NSString * jiaTingQJ;//家庭清洁卫生/消毒
    
    NSString * chuangShangYP;//床上用品及大件物品洗涤
    
    NSString * xiDiZL;//洗涤整理个人衣物
    
    NSString * duLiSS;//独立生活辅助用品定制
    
    
    UITextField * caiGouRC_Field;
    
    UITextField * jiaTingQJ_Field;
    
    UITextField * chuangShangYP_Field;
    
    UITextField * xiDiZL_Field;
    
    UITextField * duLiSS_Field;
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    JiaZhengFWModel * _jiaZhengFWModel;//数据源
}
@end

@implementation AdviseJiaZhengFWViewController

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
    _jiaZhengFWModel=[[JiaZhengFWModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _jiaZhengFWModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}



#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"33"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
   
                [_jiaZhengFWModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"家政服务";
    
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
    titleArray=@[@"1. 采购日常生活用品/食品",@"2. 家庭清洁卫生/消毒",@"3. 床上用品及大件物品洗涤",@"4. 洗涤整理个人衣物",@"5. 独立生活辅助用品定制"];
    
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
            
            
#pragma mark - 家政服务
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"caiGouRC"];
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.caiGouRC]) {
                        if ([[_jiaZhengFWModel.caiGouRC substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaZhengFWModel.caiGouRC intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"jiaTingQJ"];
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.jiaTingQJ]) {
                        if ([[_jiaZhengFWModel.jiaTingQJ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaZhengFWModel.jiaTingQJ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"chuangShangYP"];
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.chuangShangYP]) {
                        if ([[_jiaZhengFWModel.chuangShangYP substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaZhengFWModel.chuangShangYP intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"xiDiZL"];
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.xiDiZL]) {
                        if ([[_jiaZhengFWModel.xiDiZL substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaZhengFWModel.xiDiZL intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"duLiSS"];
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.duLiSS]) {
                        if ([[_jiaZhengFWModel.duLiSS substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaZhengFWModel.duLiSS intValue]==n) {
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
                    caiGouRC_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    caiGouRC_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:caiGouRC_Field];
                    caiGouRC_Field.delegate=self;
                    caiGouRC_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.caiGouRC]) {
                        if ([[_jiaZhengFWModel.caiGouRC substringToIndex:1] isEqualToString:@"X"]) {
                            caiGouRC_Field.userInteractionEnabled=YES;
                            caiGouRC_Field.text=[_jiaZhengFWModel.caiGouRC substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    jiaTingQJ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    jiaTingQJ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:jiaTingQJ_Field];
                    jiaTingQJ_Field.delegate=self;
                    jiaTingQJ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.jiaTingQJ]) {
                        if ([[_jiaZhengFWModel.jiaTingQJ substringToIndex:1] isEqualToString:@"X"]) {
                            jiaTingQJ_Field.userInteractionEnabled=YES;
                            jiaTingQJ_Field.text=[_jiaZhengFWModel.jiaTingQJ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    chuangShangYP_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    chuangShangYP_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:chuangShangYP_Field];
                    chuangShangYP_Field.delegate=self;
                    chuangShangYP_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.chuangShangYP]) {
                        if ([[_jiaZhengFWModel.chuangShangYP substringToIndex:1] isEqualToString:@"X"]) {
                            chuangShangYP_Field.userInteractionEnabled=YES;
                            chuangShangYP_Field.text=[_jiaZhengFWModel.chuangShangYP substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    xiDiZL_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    xiDiZL_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:xiDiZL_Field];
                    xiDiZL_Field.delegate=self;
                    xiDiZL_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.xiDiZL]) {
                        if ([[_jiaZhengFWModel.xiDiZL substringToIndex:1] isEqualToString:@"X"]) {
                            xiDiZL_Field.userInteractionEnabled=YES;
                            xiDiZL_Field.text=[_jiaZhengFWModel.xiDiZL substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    duLiSS_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    duLiSS_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:duLiSS_Field];
                    duLiSS_Field.delegate=self;
                    duLiSS_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaZhengFWModel.duLiSS]) {
                        if ([[_jiaZhengFWModel.duLiSS substringToIndex:1] isEqualToString:@"X"]) {
                            duLiSS_Field.userInteractionEnabled=YES;
                            duLiSS_Field.text=[_jiaZhengFWModel.duLiSS substringFromIndex:1];
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指的是根据每个老人的情况，定制能够最大限度支持老人继续独立生活的辅助用品，例如餐具、助行器、穿衣/鞋辅助用具等。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
#pragma mark - 家政服务
    
    if ([groupId isEqualToString:@"caiGouRC"]) {
        if (radio.tag==titleArr.count-1) {
            caiGouRC_Field.userInteractionEnabled=YES;
        } else {
            caiGouRC_Field.userInteractionEnabled=NO;
            caiGouRC_Field.text=@"";
        }
        caiGouRC=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"jiaTingQJ"]) {
        if (radio.tag==titleArr.count-1) {
            jiaTingQJ_Field.userInteractionEnabled=YES;
        } else {
            jiaTingQJ_Field.userInteractionEnabled=NO;
            jiaTingQJ_Field.text=@"";
        }
        jiaTingQJ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"chuangShangYP"]) {
        if (radio.tag==titleArr.count-1) {
            chuangShangYP_Field.userInteractionEnabled=YES;
        } else {
            chuangShangYP_Field.userInteractionEnabled=NO;
            chuangShangYP_Field.text=@"";
        }
        chuangShangYP=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"xiDiZL"]) {
        if (radio.tag==titleArr.count-1) {
            xiDiZL_Field.userInteractionEnabled=YES;
        } else {
            xiDiZL_Field.userInteractionEnabled=NO;
            xiDiZL_Field.text=@"";
        }
        xiDiZL=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"duLiSS"]) {
        if (radio.tag==titleArr.count-1) {
            duLiSS_Field.userInteractionEnabled=YES;
        } else {
            duLiSS_Field.userInteractionEnabled=NO;
            duLiSS_Field.text=@"";
        }
        duLiSS=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([caiGouRC intValue]==titleArr.count-1 && [PublicFunction isBlankString:caiGouRC_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“采购日常生活用品/食品的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([jiaTingQJ intValue]==titleArr.count-1 && [PublicFunction isBlankString:jiaTingQJ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“家庭清洁卫生/消毒的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([chuangShangYP intValue]==titleArr.count-1 && [PublicFunction isBlankString:chuangShangYP_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“床上用品及大件物品洗涤的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([xiDiZL intValue]==titleArr.count-1 && [PublicFunction isBlankString:xiDiZL_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“洗涤整理个人衣物的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([duLiSS intValue]==titleArr.count-1 && [PublicFunction isBlankString:duLiSS_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“独立生活辅助用品定制的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 家政服务
        [self update_JiaZhengFW];
    }
    
}


#pragma mark - 家政服务
-(void)update_JiaZhengFW
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"33" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];

    
    if (![PublicFunction isBlankString:caiGouRC]) {
        if ([caiGouRC integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",caiGouRC_Field.text] forKey:@"caiGouRC"];
        } else {
            [parameter setObject:caiGouRC forKey:@"caiGouRC"];
        }
    }
    
    if (![PublicFunction isBlankString:jiaTingQJ]) {
        if ([jiaTingQJ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",jiaTingQJ_Field.text] forKey:@"jiaTingQJ"];
        } else {
            [parameter setObject:jiaTingQJ forKey:@"jiaTingQJ"];
        }
    }
    
    if (![PublicFunction isBlankString:chuangShangYP]) {
        if ([chuangShangYP integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",chuangShangYP_Field.text] forKey:@"chuangShangYP"];
        } else {
            [parameter setObject:chuangShangYP forKey:@"chuangShangYP"];
        }
    }
    
    if (![PublicFunction isBlankString:xiDiZL]) {
        if ([xiDiZL integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",xiDiZL_Field.text] forKey:@"xiDiZL"];
        } else {
            [parameter setObject:xiDiZL forKey:@"xiDiZL"];
        }
    }
    
    if (![PublicFunction isBlankString:duLiSS]) {
        if ([duLiSS integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",duLiSS_Field.text] forKey:@"duLiSS"];
        } else {
            [parameter setObject:duLiSS forKey:@"duLiSS"];
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

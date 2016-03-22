//
//  AdviseYingYangSSViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/7.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseYingYangSSViewController.h"
#import "YingYangSSModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选
@interface AdviseYingYangSSViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * titleArray;//分组标题
    
    NSArray * titleArr;//选项题目数组
    
    
    
    NSString * yingYangSSPG;//营养膳食评估及膳食运动规划
    
    NSString * sanShiZB;//膳食制备
    
    NSString * songCan;//送餐
    
    NSString * jinShiFW;//进食服务
    
    
    UITextField * yingYangSSPG_Field;
    
    UITextField * sanShiZB_Field;
    
    UITextField * songCan_Field;
    
    UITextField * jinShiFW_Field;
    
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    YingYangSSModel * _yingYangSSModel;//数据源
}
@end

@implementation AdviseYingYangSSViewController

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
    _yingYangSSModel=[[YingYangSSModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _yingYangSSModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}

#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"28"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_yingYangSSModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"营养膳食";
    
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
    titleArray=@[@"1. 营养膳食评估及膳食运动规划",@"2. 膳食制备",@"3. 送餐",@"4. 进食服务(二次加工/喂食)"];
    
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
        UILabel * title_Label=[ZCControl createLabelWithFrame:CGRectMake(15, RootScrollView_contentSize, WIDTH-55, Title_text_font) Font:Title_text_font Text:titleArray[j]];
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
                
            default:
                break;
        }
        
        
        for (int n=0; n<titleArr.count; n++) {
            
            //选框
            QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"juZhuQK"];
            [RootScrollView addSubview:xuanXiang_Button];
            xuanXiang_Button.frame=CGRectMake(15, RootScrollView_contentSize+Q_RADIO_WH*(n+1), Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
            
            xuanXiang_Button.tag=n;
            
            
#pragma mark - 营养膳食
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"yingYangSSPG"];
                    
                    if (![PublicFunction isBlankString:_yingYangSSModel.yingYangSS]) {
                        if ([[_yingYangSSModel.yingYangSS substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yingYangSSModel.yingYangSS intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"sanShiZB"];
                    
                    if (![PublicFunction isBlankString:_yingYangSSModel.sanShiZB]) {
                        if ([[_yingYangSSModel.sanShiZB substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yingYangSSModel.sanShiZB intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"songCan"];
                    
                    if (![PublicFunction isBlankString:_yingYangSSModel.songCan]) {
                        if ([[_yingYangSSModel.songCan substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yingYangSSModel.songCan intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"jinShiFW"];
                    
                    if (![PublicFunction isBlankString:_yingYangSSModel.jinShiFW]) {
                        if ([[_yingYangSSModel.jinShiFW substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_yingYangSSModel.jinShiFW intValue]==n) {
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
                    yingYangSSPG_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    yingYangSSPG_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:yingYangSSPG_Field];
                    yingYangSSPG_Field.delegate=self;
                    yingYangSSPG_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yingYangSSModel.yingYangSS]) {
                        if ([[_yingYangSSModel.yingYangSS substringToIndex:1] isEqualToString:@"X"]) {
                            yingYangSSPG_Field.userInteractionEnabled=YES;
                            yingYangSSPG_Field.text=[_yingYangSSModel.yingYangSS substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    sanShiZB_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    sanShiZB_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:sanShiZB_Field];
                    sanShiZB_Field.delegate=self;
                    sanShiZB_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yingYangSSModel.sanShiZB]) {
                        if ([[_yingYangSSModel.sanShiZB substringToIndex:1] isEqualToString:@"X"]) {
                            sanShiZB_Field.userInteractionEnabled=YES;
                            sanShiZB_Field.text=[_yingYangSSModel.sanShiZB substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    songCan_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    songCan_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:songCan_Field];
                    songCan_Field.delegate=self;
                    songCan_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yingYangSSModel.songCan]) {
                        if ([[_yingYangSSModel.songCan substringToIndex:1] isEqualToString:@"X"]) {
                            songCan_Field.userInteractionEnabled=YES;
                            songCan_Field.text=[_yingYangSSModel.songCan substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    jinShiFW_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    jinShiFW_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:jinShiFW_Field];
                    jinShiFW_Field.delegate=self;
                    jinShiFW_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_yingYangSSModel.jinShiFW]) {
                        if ([[_yingYangSSModel.jinShiFW substringToIndex:1] isEqualToString:@"X"]) {
                            jinShiFW_Field.userInteractionEnabled=YES;
                            jinShiFW_Field.text=[_yingYangSSModel.jinShiFW substringFromIndex:1];
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指对申请人的身体和疾病状况及相应的营养膳食要求进行评估，并根据其个人情况，规划申请人在膳食和运动方面活动的服务。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指做饭的服务，可以是上门在申请人家里做饭，或者在其他场所为申请人做好饭。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指把做好的饭送到老人家里的服务。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指二次加工、热饭，或者喂食的服务"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
#pragma mark - 营养膳食
    
    if ([groupId isEqualToString:@"yingYangSSPG"]) {
        if (radio.tag==titleArr.count-1) {
            yingYangSSPG_Field.userInteractionEnabled=YES;
        } else {
            yingYangSSPG_Field.userInteractionEnabled=NO;
            yingYangSSPG_Field.text=@"";
        }
        yingYangSSPG=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"sanShiZB"]) {
        if (radio.tag==titleArr.count-1) {
            sanShiZB_Field.userInteractionEnabled=YES;
        } else {
            sanShiZB_Field.userInteractionEnabled=NO;
            sanShiZB_Field.text=@"";
        }
        sanShiZB=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"songCan"]) {
        if (radio.tag==titleArr.count-1) {
            songCan_Field.userInteractionEnabled=YES;
        } else {
            songCan_Field.userInteractionEnabled=NO;
            songCan_Field.text=@"";
        }
        songCan=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"jinShiFW"]) {
        if (radio.tag==titleArr.count-1) {
            jinShiFW_Field.userInteractionEnabled=YES;
        } else {
            jinShiFW_Field.userInteractionEnabled=NO;
            jinShiFW_Field.text=@"";
        }
        jinShiFW=[NSString stringWithFormat:@"%ld",radio.tag];
    }
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([yingYangSSPG intValue]==titleArr.count-1 && [PublicFunction isBlankString:yingYangSSPG_Field.text]) {
#pragma mark - 营养膳食评估及膳食运动规划
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“营养膳食评估及膳食运动规划的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([sanShiZB intValue]==titleArr.count-1 && [PublicFunction isBlankString:sanShiZB_Field.text]) {
#pragma mark - 膳食制备
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“膳食制备的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([songCan intValue]==titleArr.count-1 && [PublicFunction isBlankString:songCan_Field.text]) {
#pragma mark - 送餐
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“送餐的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([jinShiFW intValue]==titleArr.count-1 && [PublicFunction isBlankString:jinShiFW_Field.text]) {
#pragma mark - 进食服务
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“进食服务的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 营养膳食
        [self update_YingYangSS];
    }
    
}




//更新 营养膳食
-(void)update_YingYangSS
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"28" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
#pragma mark - 营养膳食
    
    if (![PublicFunction isBlankString:yingYangSSPG]) {
        if ([yingYangSSPG integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",yingYangSSPG_Field.text] forKey:@"yingYangSS"];
        } else {
            [parameter setObject:yingYangSSPG forKey:@"yingYangSS"];
        }
    }
    
    if (![PublicFunction isBlankString:sanShiZB]) {
        if ([sanShiZB integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",sanShiZB_Field.text] forKey:@"sanShiZB"];
        } else {
            [parameter setObject:sanShiZB forKey:@"sanShiZB"];
        }
    }
    
    if (![PublicFunction isBlankString:songCan]) {
        if ([songCan integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",songCan_Field.text] forKey:@"songCan"];
        } else {
            [parameter setObject:songCan forKey:@"songCan"];
        }
    }
    
    if (![PublicFunction isBlankString:jinShiFW]) {
        if ([jinShiFW integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",jinShiFW_Field.text] forKey:@"jinShiFW"];
        } else {
            [parameter setObject:jinShiFW forKey:@"jinShiFW"];
        }
    }
    
    [KVNProgress show];
    
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:insertResultHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        [KVNProgress dismiss];
        
        //NSLog(@"%@",returnValue);
        
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

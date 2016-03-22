//
//  AdviseJiaTingHLViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/7.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseJiaTingHLViewController.h"
#import "JiaTingHLModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选
@interface AdviseJiaTingHLViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * titleArray;//分组标题
    
    NSArray * titleArr;//选项题目数组
    
    
    
    NSString * qiChuangJQ;//起床及就寝(
    
    NSString * zhuYu;//助浴/全身清洁
    
    NSString * geRenXS;//个人修饰
    
    NSString * ruCeTX;//如厕提醒
    
    NSString * dingQiGH;//定期更换尿布
    
    NSString * daXiaoPB;//大小便排泄控制训练
    
    NSString * fuYaoJC;//服药监测
    
    NSString * yaChuangHL;//压疮护理
    
    NSString * jiaTingZHZJ;//家庭照护者技能
    
    NSString * jiaTingZHZT;//家庭照护者替换
    
    NSString * jiaTingZHFW;//家庭照护服务协调
    
    
    UITextField * qiChuangJQ_Field;
    
    UITextField * zhuYu_Field;
    
    UITextField * geRenXS_Field;
    
    UITextField * ruCeTX_Field;
    
    UITextField * dingQiGH_Field;
    
    UITextField * daXiaoPB_Field;
    
    UITextField * fuYaoJC_Field;
    
    UITextField * yaChuangHL_Field;
    
    UITextField * jiaTingZHZJ_Field;
    
    UITextField * jiaTingZHZT_Field;
    
    UITextField * jiaTingZHFW_Field;
    
    
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    JiaTingHLModel * _jiaTingHLModel;//数据源
}
@end

@implementation AdviseJiaTingHLViewController

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
    _jiaTingHLModel=[[JiaTingHLModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _jiaTingHLModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"30"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_jiaTingHLModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"家庭护理";
    
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
    titleArray=@[@"1. 起床及就寝(床椅转移)",@"2. 助浴/全身清洁",@"3. 个人修饰(理发/修脚)",@"4. 如厕提醒",@"5. 定期更换尿布/清洁私密处",@"6. 大小便排泄控制训练",@"7. 服药监测/提示",@"8. 压疮护理(翻身/清洁/用药)",@"9. 家庭照护者技能/心理支持",@"10. 家庭照护者替换服务",@"11. 家庭照护服务协调"];
    
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
                
            case 7:
                JieShao_Button.tag=90007;
                break;
                
            case 8:
                JieShao_Button.tag=90008;
                break;
                
            case 9:
                JieShao_Button.tag=90009;
                break;
                
            case 10:
                JieShao_Button.tag=90010;
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
            
            
#pragma mark - 家庭护理
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"qiChuangJQ"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.qiChuangJQ]) {
                        if ([[_jiaTingHLModel.qiChuangJQ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.qiChuangJQ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"zhuYu"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.zhuYu]) {
                        if ([[_jiaTingHLModel.zhuYu substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.zhuYu intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"geRenXS"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.geRenXS]) {
                        if ([[_jiaTingHLModel.geRenXS substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.geRenXS intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"ruCeTX"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.ruCeTX]) {
                        if ([[_jiaTingHLModel.ruCeTX substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.ruCeTX intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"dingQiGH"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.dingQiGH]) {
                        if ([[_jiaTingHLModel.dingQiGH substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.dingQiGH intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 5:
                {
                    [xuanXiang_Button getGroupId:@"daXiaoPB"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.daXiaoPB]) {
                        if ([[_jiaTingHLModel.daXiaoPB substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.daXiaoPB intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 6:
                {
                    [xuanXiang_Button getGroupId:@"fuYaoJC"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.fuYaoJC]) {
                        if ([[_jiaTingHLModel.fuYaoJC substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.fuYaoJC intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 7:
                {
                    [xuanXiang_Button getGroupId:@"yaChuangHL"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.yaChuangHL]) {
                        if ([[_jiaTingHLModel.yaChuangHL substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.yaChuangHL intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 8:
                {
                    [xuanXiang_Button getGroupId:@"jiaTingZHZJ"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.jiaTingZHZJ]) {
                        if ([[_jiaTingHLModel.jiaTingZHZJ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.jiaTingZHZJ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 9:
                {
                    [xuanXiang_Button getGroupId:@"jiaTingZHZT"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.jiaTingZHZT]) {
                        if ([[_jiaTingHLModel.jiaTingZHZT substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.jiaTingZHZT intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 10:
                {
                    [xuanXiang_Button getGroupId:@"jiaTingZHFW"];
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.jiaTingZHFW]) {
                        if ([[_jiaTingHLModel.jiaTingZHFW substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_jiaTingHLModel.jiaTingZHFW intValue]==n) {
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
                    qiChuangJQ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    qiChuangJQ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:qiChuangJQ_Field];
                    qiChuangJQ_Field.delegate=self;
                    qiChuangJQ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.qiChuangJQ]) {
                        if ([[_jiaTingHLModel.qiChuangJQ substringToIndex:1] isEqualToString:@"X"]) {
                            qiChuangJQ_Field.userInteractionEnabled=YES;
                            qiChuangJQ_Field.text=[_jiaTingHLModel.qiChuangJQ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    zhuYu_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    zhuYu_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:zhuYu_Field];
                    zhuYu_Field.delegate=self;
                    zhuYu_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.zhuYu]) {
                        if ([[_jiaTingHLModel.zhuYu substringToIndex:1] isEqualToString:@"X"]) {
                            zhuYu_Field.userInteractionEnabled=YES;
                            zhuYu_Field.text=[_jiaTingHLModel.zhuYu substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    geRenXS_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    geRenXS_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:geRenXS_Field];
                    geRenXS_Field.delegate=self;
                    geRenXS_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.geRenXS]) {
                        if ([[_jiaTingHLModel.geRenXS substringToIndex:1] isEqualToString:@"X"]) {
                            geRenXS_Field.userInteractionEnabled=YES;
                            geRenXS_Field.text=[_jiaTingHLModel.geRenXS substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    ruCeTX_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    ruCeTX_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:ruCeTX_Field];
                    ruCeTX_Field.delegate=self;
                    ruCeTX_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.ruCeTX]) {
                        if ([[_jiaTingHLModel.ruCeTX substringToIndex:1] isEqualToString:@"X"]) {
                            ruCeTX_Field.userInteractionEnabled=YES;
                            ruCeTX_Field.text=[_jiaTingHLModel.ruCeTX substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    dingQiGH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    dingQiGH_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:dingQiGH_Field];
                    dingQiGH_Field.delegate=self;
                    dingQiGH_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.dingQiGH]) {
                        if ([[_jiaTingHLModel.dingQiGH substringToIndex:1] isEqualToString:@"X"]) {
                            dingQiGH_Field.userInteractionEnabled=YES;
                            dingQiGH_Field.text=[_jiaTingHLModel.dingQiGH substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 5:
                {
                    daXiaoPB_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    daXiaoPB_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:daXiaoPB_Field];
                    daXiaoPB_Field.delegate=self;
                    daXiaoPB_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.daXiaoPB]) {
                        if ([[_jiaTingHLModel.daXiaoPB substringToIndex:1] isEqualToString:@"X"]) {
                            daXiaoPB_Field.userInteractionEnabled=YES;
                            daXiaoPB_Field.text=[_jiaTingHLModel.daXiaoPB substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 6:
                {
                    fuYaoJC_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    fuYaoJC_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:fuYaoJC_Field];
                    fuYaoJC_Field.delegate=self;
                    fuYaoJC_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.fuYaoJC]) {
                        if ([[_jiaTingHLModel.fuYaoJC substringToIndex:1] isEqualToString:@"X"]) {
                            fuYaoJC_Field.userInteractionEnabled=YES;
                            fuYaoJC_Field.text=[_jiaTingHLModel.fuYaoJC substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 7:
                {
                    yaChuangHL_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    yaChuangHL_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:yaChuangHL_Field];
                    yaChuangHL_Field.delegate=self;
                    yaChuangHL_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.yaChuangHL]) {
                        if ([[_jiaTingHLModel.yaChuangHL substringToIndex:1] isEqualToString:@"X"]) {
                            yaChuangHL_Field.userInteractionEnabled=YES;
                            yaChuangHL_Field.text=[_jiaTingHLModel.yaChuangHL substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 8:
                {
                    jiaTingZHZJ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    jiaTingZHZJ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:jiaTingZHZJ_Field];
                    jiaTingZHZJ_Field.delegate=self;
                    jiaTingZHZJ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.jiaTingZHZJ]) {
                        if ([[_jiaTingHLModel.jiaTingZHZJ substringToIndex:1] isEqualToString:@"X"]) {
                            jiaTingZHZJ_Field.userInteractionEnabled=YES;
                            jiaTingZHZJ_Field.text=[_jiaTingHLModel.jiaTingZHZJ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 9:
                {
                    jiaTingZHZT_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    jiaTingZHZT_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:jiaTingZHZT_Field];
                    jiaTingZHZT_Field.delegate=self;
                    jiaTingZHZT_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.jiaTingZHZT]) {
                        if ([[_jiaTingHLModel.jiaTingZHZT substringToIndex:1] isEqualToString:@"X"]) {
                            jiaTingZHZT_Field.userInteractionEnabled=YES;
                            jiaTingZHZT_Field.text=[_jiaTingHLModel.jiaTingZHZT substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 10:
                {
                    jiaTingZHFW_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    jiaTingZHFW_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:jiaTingZHFW_Field];
                    jiaTingZHFW_Field.delegate=self;
                    jiaTingZHFW_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_jiaTingHLModel.jiaTingZHFW]) {
                        if ([[_jiaTingHLModel.jiaTingZHFW substringToIndex:1] isEqualToString:@"X"]) {
                            jiaTingZHFW_Field.userInteractionEnabled=YES;
                            jiaTingZHFW_Field.text=[_jiaTingHLModel.jiaTingZHFW substringFromIndex:1];
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指帮助申请人起床时从床上移动到轮椅或者其他座位上。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指协助申请人洗澡，或者帮申请人全身擦洗。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指协助申请人修面、理发、化淡妆、修脚等。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指就是提醒申请人上厕所、大小便。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指定期更换尿裤、尿布、尿袋并清洁私密处。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指经过训练的合格按专门方法指导申请人训练，控制大小便。"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指由专业人员检测申请人是否按照医嘱服药和提醒申请人到时候应该服务哪些药物，并且观察申请人服药以后的情况。"];
            
            [modal show];
        }
            break;
            
        case 90007:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指由专业人员帮助申请人及时翻身防止压疮，或者对于已经发生的压疮进行伤口的清洁、用药等护理服务。"];
            
            [modal show];
        }
            break;
            
        case 90008:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指由专业人员对家庭照护者提供技能培训、心理疏导、减压等服务。"];
            
            [modal show];
        }
            break;
            
        case 90009:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指由专业人员上门服务，让家庭照护者替换下来，得到一定的休息。"];
            
            [modal show];
        }
            break;
            
        case 90010:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指协助对家庭成员及雇请的专业人员提供的照护服务进行协调的服务。"];
            
            [modal show];
        }
            break;
            
            
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
#pragma mark - 家庭护理
    
    if ([groupId isEqualToString:@"qiChuangJQ"]) {
        if (radio.tag==titleArr.count-1) {
            qiChuangJQ_Field.userInteractionEnabled=YES;
        } else {
            qiChuangJQ_Field.userInteractionEnabled=NO;
            qiChuangJQ_Field.text=@"";
        }
        qiChuangJQ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"zhuYu"]) {
        if (radio.tag==titleArr.count-1) {
            zhuYu_Field.userInteractionEnabled=YES;
        } else {
            zhuYu_Field.userInteractionEnabled=NO;
            zhuYu_Field.text=@"";
        }
        zhuYu=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"geRenXS"]) {
        if (radio.tag==titleArr.count-1) {
            geRenXS_Field.userInteractionEnabled=YES;
        } else {
            geRenXS_Field.userInteractionEnabled=NO;
            geRenXS_Field.text=@"";
        }
        geRenXS=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"ruCeTX"]) {
        if (radio.tag==titleArr.count-1) {
            ruCeTX_Field.userInteractionEnabled=YES;
        } else {
            ruCeTX_Field.userInteractionEnabled=NO;
            ruCeTX_Field.text=@"";
        }
        ruCeTX=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"dingQiGH"]) {
        if (radio.tag==titleArr.count-1) {
            dingQiGH_Field.userInteractionEnabled=YES;
        } else {
            dingQiGH_Field.userInteractionEnabled=NO;
            dingQiGH_Field.text=@"";
        }
        dingQiGH=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"daXiaoPB"]) {
        if (radio.tag==titleArr.count-1) {
            daXiaoPB_Field.userInteractionEnabled=YES;
        } else {
            daXiaoPB_Field.userInteractionEnabled=NO;
            daXiaoPB_Field.text=@"";
        }
        daXiaoPB=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"fuYaoJC"]) {
        if (radio.tag==titleArr.count-1) {
            fuYaoJC_Field.userInteractionEnabled=YES;
        } else {
            fuYaoJC_Field.userInteractionEnabled=NO;
            fuYaoJC_Field.text=@"";
        }
        fuYaoJC=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"yaChuangHL"]) {
        if (radio.tag==titleArr.count-1) {
            yaChuangHL_Field.userInteractionEnabled=YES;
        } else {
            yaChuangHL_Field.userInteractionEnabled=NO;
            yaChuangHL_Field.text=@"";
        }
        yaChuangHL=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"jiaTingZHZJ"]) {
        if (radio.tag==titleArr.count-1) {
            jiaTingZHZJ_Field.userInteractionEnabled=YES;
        } else {
            jiaTingZHZJ_Field.userInteractionEnabled=NO;
            jiaTingZHZJ_Field.text=@"";
        }
        jiaTingZHZJ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"jiaTingZHZT"]) {
        if (radio.tag==titleArr.count-1) {
            jiaTingZHZT_Field.userInteractionEnabled=YES;
        } else {
            jiaTingZHZT_Field.userInteractionEnabled=NO;
            jiaTingZHZT_Field.text=@"";
        }
        jiaTingZHZT=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"jiaTingZHFW"]) {
        if (radio.tag==titleArr.count-1) {
            jiaTingZHFW_Field.userInteractionEnabled=YES;
        } else {
            jiaTingZHFW_Field.userInteractionEnabled=NO;
            jiaTingZHFW_Field.text=@"";
        }
        jiaTingZHFW=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([qiChuangJQ intValue]==titleArr.count-1 && [PublicFunction isBlankString:qiChuangJQ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“起床及就寝的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([zhuYu intValue]==titleArr.count-1 && [PublicFunction isBlankString:zhuYu_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“助浴/全身清洁的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([geRenXS intValue]==titleArr.count-1 && [PublicFunction isBlankString:geRenXS_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“个人修饰的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([ruCeTX intValue]==titleArr.count-1 && [PublicFunction isBlankString:ruCeTX_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“如厕提醒的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([dingQiGH intValue]==titleArr.count-1 && [PublicFunction isBlankString:dingQiGH_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“定期更换尿布/清洁私密处的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([daXiaoPB intValue]==titleArr.count-1 && [PublicFunction isBlankString:daXiaoPB_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“大小便排泄控制训练的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([fuYaoJC intValue]==titleArr.count-1 && [PublicFunction isBlankString:fuYaoJC_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“服药监测/提示的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([yaChuangHL intValue]==titleArr.count-1 && [PublicFunction isBlankString:yaChuangHL_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“压疮护理的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([jiaTingZHZJ intValue]==titleArr.count-1 && [PublicFunction isBlankString:jiaTingZHZJ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“家庭照护者技能/心理支持的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([jiaTingZHZT intValue]==titleArr.count-1 && [PublicFunction isBlankString:jiaTingZHZT_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“家庭照护者替换服务的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([jiaTingZHFW intValue]==titleArr.count-1 && [PublicFunction isBlankString:jiaTingZHFW_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“家庭照护服务协调的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 家庭护理
        [self update_JiaTingHL];
    }
    
}




#pragma mark - 家庭护理
-(void)update_JiaTingHL
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"30" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    

    
    
    if (![PublicFunction isBlankString:qiChuangJQ]) {
        if ([qiChuangJQ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",qiChuangJQ_Field.text] forKey:@"qiChuangJQ"];
        } else {
            [parameter setObject:qiChuangJQ forKey:@"qiChuangJQ"];
        }
    }
    
    if (![PublicFunction isBlankString:zhuYu]) {
        if ([zhuYu integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",zhuYu_Field.text] forKey:@"zhuYu"];
        } else {
            [parameter setObject:zhuYu forKey:@"zhuYu"];
        }
    }
    
    if (![PublicFunction isBlankString:geRenXS]) {
        if ([geRenXS integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",geRenXS_Field.text] forKey:@"geRenXS"];
        } else {
            [parameter setObject:geRenXS forKey:@"geRenXS"];
        }
    }
    
    if (![PublicFunction isBlankString:ruCeTX]) {
        if ([ruCeTX integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",ruCeTX_Field.text] forKey:@"ruCeTX"];
        } else {
            [parameter setObject:ruCeTX forKey:@"ruCeTX"];
        }
    }
    
    if (![PublicFunction isBlankString:dingQiGH]) {
        if ([dingQiGH integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",dingQiGH_Field.text] forKey:@"dingQiGH"];
        } else {
            [parameter setObject:dingQiGH forKey:@"dingQiGH"];
        }
    }
    
    
    if (![PublicFunction isBlankString:daXiaoPB]) {
        if ([daXiaoPB integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",daXiaoPB_Field.text] forKey:@"daXiaoPB"];
        } else {
            [parameter setObject:daXiaoPB forKey:@"daXiaoPB"];
        }
    }
    
    if (![PublicFunction isBlankString:fuYaoJC]) {
        if ([fuYaoJC integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",fuYaoJC_Field.text] forKey:@"fuYaoJC"];
        } else {
            [parameter setObject:fuYaoJC forKey:@"fuYaoJC"];
        }
    }
    
    if (![PublicFunction isBlankString:yaChuangHL]) {
        if ([yaChuangHL integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",yaChuangHL_Field.text] forKey:@"yaChuangHL"];
        } else {
            [parameter setObject:yaChuangHL forKey:@"yaChuangHL"];
        }
    }
    
    if (![PublicFunction isBlankString:jiaTingZHZJ]) {
        if ([jiaTingZHZJ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",jiaTingZHZJ_Field.text] forKey:@"jiaTingZHZJ"];
        } else {
            [parameter setObject:jiaTingZHZJ forKey:@"jiaTingZHZJ"];
        }
    }
    
    if (![PublicFunction isBlankString:jiaTingZHZT]) {
        if ([jiaTingZHZT integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",jiaTingZHZT_Field.text] forKey:@"jiaTingZHZT"];
        } else {
            [parameter setObject:jiaTingZHZT forKey:@"jiaTingZHZT"];
        }
    }
    
    if (![PublicFunction isBlankString:jiaTingZHFW]) {
        if ([jiaTingZHFW integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",jiaTingZHFW_Field.text] forKey:@"jiaTingZHFW"];
        } else {
            [parameter setObject:jiaTingZHFW forKey:@"jiaTingZHFW"];
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

//
//  AdviseQiTaViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/7.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseQiTaViewController.h"
#import "QiTaModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选
@interface AdviseQiTaViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSArray * titleArray;//分组标题
    
    NSArray * titleArr;//选项题目数组
    
    
    NSString * ruZhuYL;//入住养老机构/托老所
    
    NSString * duanQiSQ;//短期社区照料中心托管
    
    NSString * fuJuPZ;//辅具配置
    
    NSString * gouMaiCQ;//购买长期护理保险
    
    NSString * gouMaiYW;//购买意外伤害责任保险
    
    
    UITextField * ruZhuYL_Field;
    
    UITextField * duanQiSQ_Field;
    
    UITextField * fuJuPZ_Field;
    
    UITextField * gouMaiCQ_Field;
    
    UITextField * gouMaiYW_Field;
    
    
    
    
//    UITextField * TeShuFW_Field;//特殊服务需求
//    
//    UITextView * BuChongXX_TextView;//补充信息
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    QiTaModel * _qiTaModel;//数据源
}
@end

@implementation AdviseQiTaViewController

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
    _qiTaModel=[[QiTaModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _qiTaModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"35"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_qiTaModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"其他";
    
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
    titleArray=@[@"1. 入住养老机构/托老所",@"2. 短期社区照料中心托管",@"3. 辅具配置",@"4. 购买长期护理保险",@"5. 购买意外伤害责任保险"];
    
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
            
            
#pragma mark - 其他
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"ruZhuYL"];
                    
                    if (![PublicFunction isBlankString:_qiTaModel.ruZhuYL]) {
                        if ([[_qiTaModel.ruZhuYL substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_qiTaModel.ruZhuYL intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"duanQiSQ"];
                    
                    if (![PublicFunction isBlankString:_qiTaModel.duanQiSQ]) {
                        if ([[_qiTaModel.duanQiSQ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_qiTaModel.duanQiSQ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"fuJuPZ"];
                    
                    if (![PublicFunction isBlankString:_qiTaModel.fuJuPZ]) {
                        if ([[_qiTaModel.fuJuPZ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_qiTaModel.fuJuPZ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"gouMaiCQ"];
                    
                    if (![PublicFunction isBlankString:_qiTaModel.gouMaiCQ]) {
                        if ([[_qiTaModel.gouMaiCQ substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_qiTaModel.gouMaiCQ intValue]==n) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"gouMaiYW"];
                    
                    if (![PublicFunction isBlankString:_qiTaModel.gouMaiYW]) {
                        if ([[_qiTaModel.gouMaiYW substringToIndex:1] isEqualToString:@"X"]) {
                            if (n==titleArr.count-1) {
                                [xuanXiang_Button setChecked:YES];
                            }
                        } else {
                            if ([_qiTaModel.gouMaiYW intValue]==n) {
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
                    ruZhuYL_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    ruZhuYL_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:ruZhuYL_Field];
                    ruZhuYL_Field.delegate=self;
                    ruZhuYL_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_qiTaModel.ruZhuYL]) {
                        if ([[_qiTaModel.ruZhuYL substringToIndex:1] isEqualToString:@"X"]) {
                            ruZhuYL_Field.userInteractionEnabled=YES;
                            ruZhuYL_Field.text=[_qiTaModel.ruZhuYL substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    duanQiSQ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    duanQiSQ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:duanQiSQ_Field];
                    duanQiSQ_Field.delegate=self;
                    duanQiSQ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_qiTaModel.duanQiSQ]) {
                        if ([[_qiTaModel.duanQiSQ substringToIndex:1] isEqualToString:@"X"]) {
                            duanQiSQ_Field.userInteractionEnabled=YES;
                            duanQiSQ_Field.text=[_qiTaModel.duanQiSQ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    fuJuPZ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    fuJuPZ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:fuJuPZ_Field];
                    fuJuPZ_Field.delegate=self;
                    fuJuPZ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_qiTaModel.fuJuPZ]) {
                        if ([[_qiTaModel.fuJuPZ substringToIndex:1] isEqualToString:@"X"]) {
                            fuJuPZ_Field.userInteractionEnabled=YES;
                            fuJuPZ_Field.text=[_qiTaModel.fuJuPZ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    gouMaiCQ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    gouMaiCQ_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:gouMaiCQ_Field];
                    gouMaiCQ_Field.delegate=self;
                    gouMaiCQ_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_qiTaModel.gouMaiCQ]) {
                        if ([[_qiTaModel.gouMaiCQ substringToIndex:1] isEqualToString:@"X"]) {
                            gouMaiCQ_Field.userInteractionEnabled=YES;
                            gouMaiCQ_Field.text=[_qiTaModel.gouMaiCQ substringFromIndex:1];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    gouMaiYW_Field=[ZCControl createTextFieldWithFrame:CGRectMake(15, RootScrollView_contentSize+10+Q_RADIO_WH*(titleArr.count+1), WIDTH-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
                    gouMaiYW_Field.textColor=Field_text_color;
                    [RootScrollView addSubview:gouMaiYW_Field];
                    gouMaiYW_Field.delegate=self;
                    gouMaiYW_Field.userInteractionEnabled=NO;
                    
                    
                    if (![PublicFunction isBlankString:_qiTaModel.gouMaiYW]) {
                        if ([[_qiTaModel.gouMaiYW substringToIndex:1] isEqualToString:@"X"]) {
                            gouMaiYW_Field.userInteractionEnabled=YES;
                            gouMaiYW_Field.text=[_qiTaModel.gouMaiYW substringFromIndex:1];
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


#pragma mark - 文本输入高度变化

-(void)textViewDidChange:(UITextView *)textView
{
    float currentLineNum=1;//默认文本框显示一行文字
    float textViewWidth=textView.frame.size.width-10;//取得文本框高度
    NSString * content=textView.text;
    NSDictionary * dict=@{NSFontAttributeName:[UIFont systemFontOfSize:PAGESIZE(17)]};
    CGSize contentSize=[content sizeWithAttributes:dict];//计算文字长度
    int numLine=ceilf(contentSize.width/textViewWidth); //计算当前文字长度对应的行数
    
    float heightText=Field_HE;
    
    if(numLine>currentLineNum ){
        //如果发现当前文字长度对应的行数超过。 文本框高度，则先调整当前view的高度和位置，然后调整输入框的高度，最后修改currentLineNum的值
        textView.frame=CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, Field_HE+heightText*(numLine-currentLineNum));
        
        
        RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(textView.frame)+110+Tabbar_HE);
    }else if (numLine<currentLineNum ){
        //次数为删除的时候检测文字行数减少的时候
        textView.frame=CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, Field_HE-heightText*(currentLineNum-numLine));
        
        
        RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(textView.frame)+110+Tabbar_HE);
    }
    
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：指的是根据申请人(受访人)的状况和需求，帮助其建议、购置、适配辅助用品和用具的服务。"];
            
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
#pragma mark - 其他
    
    if ([groupId isEqualToString:@"ruZhuYL"]) {
        if (radio.tag==titleArr.count-1) {
            ruZhuYL_Field.userInteractionEnabled=YES;
        } else {
            ruZhuYL_Field.userInteractionEnabled=NO;
            ruZhuYL_Field.text=@"";
        }
        ruZhuYL=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"duanQiSQ"]) {
        if (radio.tag==titleArr.count-1) {
            duanQiSQ_Field.userInteractionEnabled=YES;
        } else {
            duanQiSQ_Field.userInteractionEnabled=NO;
            duanQiSQ_Field.text=@"";
        }
        duanQiSQ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"fuJuPZ"]) {
        if (radio.tag==titleArr.count-1) {
            fuJuPZ_Field.userInteractionEnabled=YES;
        } else {
            fuJuPZ_Field.userInteractionEnabled=NO;
            fuJuPZ_Field.text=@"";
        }
        fuJuPZ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"gouMaiCQ"]) {
        if (radio.tag==titleArr.count-1) {
            gouMaiCQ_Field.userInteractionEnabled=YES;
        } else {
            gouMaiCQ_Field.userInteractionEnabled=NO;
            gouMaiCQ_Field.text=@"";
        }
        gouMaiCQ=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
    if ([groupId isEqualToString:@"gouMaiYW"]) {
        if (radio.tag==titleArr.count-1) {
            gouMaiYW_Field.userInteractionEnabled=YES;
        } else {
            gouMaiYW_Field.userInteractionEnabled=NO;
            gouMaiYW_Field.text=@"";
        }
        gouMaiYW=[NSString stringWithFormat:@"%ld",radio.tag];
    }
    
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    
    if ([ruZhuYL intValue]==titleArr.count-1 && [PublicFunction isBlankString:ruZhuYL_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“入住养老机构/托老所的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([duanQiSQ intValue]==titleArr.count-1 && [PublicFunction isBlankString:duanQiSQ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“短期社区照料中心托管的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([fuJuPZ intValue]==titleArr.count-1 && [PublicFunction isBlankString:fuJuPZ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“辅具配置的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([gouMaiCQ intValue]==titleArr.count-1 && [PublicFunction isBlankString:gouMaiCQ_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“购买长期护理保险的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([gouMaiYW intValue]==titleArr.count-1 && [PublicFunction isBlankString:gouMaiYW_Field.text]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入“购买意外伤害责任保险的其他项”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新 其他
        [self update_QiTa];
    }
    
}

#pragma mark - 其他
-(void)update_QiTa
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"35" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    

    
    if (![PublicFunction isBlankString:ruZhuYL]) {
        if ([ruZhuYL integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",ruZhuYL_Field.text] forKey:@"ruZhuYL"];
        } else {
            [parameter setObject:ruZhuYL forKey:@"ruZhuYL"];
        }
    }
    
    if (![PublicFunction isBlankString:duanQiSQ]) {
        if ([duanQiSQ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",duanQiSQ_Field.text] forKey:@"duanQiSQ"];
        } else {
            [parameter setObject:duanQiSQ forKey:@"duanQiSQ"];
        }
    }
    
    if (![PublicFunction isBlankString:fuJuPZ]) {
        if ([fuJuPZ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",fuJuPZ_Field.text] forKey:@"fuJuPZ"];
        } else {
            [parameter setObject:fuJuPZ forKey:@"fuJuPZ"];
        }
    }
    
    if (![PublicFunction isBlankString:gouMaiCQ]) {
        if ([gouMaiCQ integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",gouMaiCQ_Field.text] forKey:@"gouMaiCQ"];
        } else {
            [parameter setObject:gouMaiCQ forKey:@"gouMaiCQ"];
        }
    }
    
    if (![PublicFunction isBlankString:gouMaiYW]) {
        if ([gouMaiYW integerValue]==titleArr.count-1) {
            [parameter setObject:[NSString stringWithFormat:@"X%@",gouMaiYW_Field.text] forKey:@"gouMaiYW"];
        } else {
            [parameter setObject:gouMaiYW forKey:@"gouMaiYW"];
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

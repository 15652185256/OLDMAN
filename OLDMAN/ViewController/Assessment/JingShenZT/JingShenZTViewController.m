//
//  JingShenZTViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/22.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "JingShenZTViewController.h"
#import "JingShenZTModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

@interface JingShenZTViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    NSString * my_renZhiGN;//认知功能
    
    NSString * my_gongJiXW;//攻击行为
    
    NSString * my_yiYuZZ;//抑郁症状
    
    UITextField * jingShenZTZF_Field;//精神状态总分
    
    NSString * my_jingShenZTFJ;//精神状态分级
    
    NSArray * titleArray;//标题数组
    
    
    NSMutableDictionary * zongFen_dict;//精神状态总分
    
    int zongFen;//精神状态总分
    
    
    
    NSArray * fenJi_Title_Array;//精神状态分级 标题数组
    
    QRadioButton * fenJi_Button0;//精神状态分级 选项 0
    
    QRadioButton * fenJi_Button1;//精神状态分级 选项 1
    
    QRadioButton * fenJi_Button2;//精神状态分级 选项 2
    
    QRadioButton * fenJi_Button3;//精神状态分级 选项 3
    
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    JingShenZTModel * _jingShenZTModel;//请求 数据
}
@property(nonatomic,retain)NSMutableArray * dataSourse;
@end

@implementation JingShenZTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //精神状态总分
    zongFen_dict=[[NSMutableDictionary alloc]init];
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _jingShenZTModel=[[JingShenZTModel alloc]init];//请求 数据
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _jingShenZTModel=nil;
    
    [zongFen_dict removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    titleArray=@[@"1. 认知功能 \n (1) 我说三样东西，请重复一遍并记住，一会儿会问您：苹果、手表、国旗 \n (2) 画钟测验：请在这儿画一个圆形时钟，在时钟上标出10点45分 \n (3) 回忆词语：现在请您告诉我，刚才我要您记住的三样东西是什么？",@"2. 攻击行为",@"3. 抑郁症状"];
    
    _dataSourse=[[NSMutableArray alloc]initWithCapacity:titleArray.count];
    for (int i=0; i<titleArray.count; i++) {
        NSArray * titleArr=nil;
        switch (i) {
            case 0:
                titleArr=@[@"画钟正确（画出一个闭锁圆,指针确认准确），并且能回忆出2~3个词",@"画钟错误（画的圆不闭锁，或指针位置不准确），或只回忆出0~1个词",@"已确诊为认知障碍，如老年痴呆"];
                break;
            case 1:
                titleArr=@[@"无身体攻击行为（如打／踢／推／咬／抓／摔东西）和语言攻击行为（如骂人、语言威胁、尖叫），可自己独立完成洗澡过程",@"每月有几次身体攻击行为，或每周有几次语言攻击行为",@"每周有几次身体攻击行为，或每日有语言攻击行为"];
                break;
            case 2:
                titleArr=@[@"无",@"情绪低落、不爱说话、不爱梳洗、不爱活动",@"有自杀念头或自杀行为"];
                break;
            default:
                break;
        }
        if (titleArr.count!=0) {
            [_dataSourse addObject:titleArr];
        }
    }
    
    //精神状态分级 标题数组
    fenJi_Title_Array=@[@"能力完好：总分为0分",@"轻度受损：总分为1分",@"中度受损：总分为2~3分",@"重度受损：总分为4~6分"];
}

#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"12"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_jingShenZTModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"精神状态";
    
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
    
    
    
    
    
    
    
    //root_View 的初始高度
    float RootScrollView_contentSize=20;
    
    for (int j=0; j<titleArray.count; j++) {
        
        NSArray * Title_Array=_dataSourse[j];
        UIView * root_View=[ZCControl createView:CGRectMake(0, RootScrollView_contentSize, WIDTH, 24*(Title_Array.count+1))];
        [RootScrollView addSubview:root_View];
        
        //标题
        UILabel * title_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-15-55, Title_text_font) Font:Title_text_font Text:nil];
        [root_View addSubview:title_Label];
        title_Label.textColor=Title_text_color;
        title_Label.numberOfLines=0;
        
        NSString * labelText1 = titleArray[j];
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:labelText1];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:3];//调整行间距
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [labelText1 length])];
        title_Label.attributedText = attributedString1;
        [title_Label sizeToFit];
        
        //介绍
        UIButton * JieShao_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(title_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
        [root_View addSubview:JieShao_Button];
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
        
        //起始高度
        float root_View_frame_origin_y=CGRectGetMaxY(title_Label.frame)+Q_ICON_HE;
        
        for (int i=0; i<Title_Array.count; i++) {
            //选框
            QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@"xingBie"];
            [root_View addSubview:xuanXiang_Button];
            xuanXiang_Button.frame=CGRectMake(15, root_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
            [xuanXiang_Button setChecked:NO];
            
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"renZhiGN"];
                    xuanXiang_Button.tag=3000+i;
                    
                    if (![PublicFunction isBlankString:_jingShenZTModel.renZhiGN]) {
                        if ([_jingShenZTModel.renZhiGN intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"gongJiXW"];
                    xuanXiang_Button.tag=4000+i;
                    
                    if (![PublicFunction isBlankString:_jingShenZTModel.gongJiXW]) {
                        if ([_jingShenZTModel.gongJiXW intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"yiYuZZ"];
                    xuanXiang_Button.tag=5000+i;
                    
                    if (![PublicFunction isBlankString:_jingShenZTModel.yiYuZZ]) {
                        if ([_jingShenZTModel.yiYuZZ intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            
            //选项标题
            UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame)-1.5, WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
            [root_View addSubview:xuanXiang_Label];
            xuanXiang_Label.textColor=Answer_text_color;
            xuanXiang_Label.numberOfLines=0;
            
            NSString * labelText = Title_Array[i];
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:2];//调整行间距
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
            xuanXiang_Label.attributedText = attributedString;
            [xuanXiang_Label sizeToFit];
            root_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Label.frame)+Q_ICON_HE;
        }
        
        root_View.frame = CGRectMake(0, RootScrollView_contentSize, WIDTH, root_View_frame_origin_y);
        
        
        RootScrollView_contentSize=RootScrollView_contentSize+root_View_frame_origin_y+10;
    }
    
    
    
    
    
    //精神状态总分 标题
    UILabel * jingShenZTZF_Label=[ZCControl createLabelWithFrame:CGRectMake(15, RootScrollView_contentSize+10, 44+Title_text_font*6, Title_text_font) Font:Title_text_font Text:@"4. 精神状态总分"];
    [RootScrollView addSubview:jingShenZTZF_Label];
    jingShenZTZF_Label.textColor=Title_text_color;
    
    //精神状态总分 签字框
    jingShenZTZF_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(jingShenZTZF_Label.frame)+Title_Field_WH, CGRectGetMinY(jingShenZTZF_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-jingShenZTZF_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    jingShenZTZF_Field.textColor=Field_text_color;
    [RootScrollView addSubview:jingShenZTZF_Field];
    jingShenZTZF_Field.delegate=self;
    jingShenZTZF_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_jingShenZTModel.jingShenZTZF]) {
        jingShenZTZF_Field.text=_jingShenZTModel.jingShenZTZF;
    }
    
    //介绍
    UIButton * jingShenZTZF_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(jingShenZTZF_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:jingShenZTZF_Button];
    jingShenZTZF_Button.tag=90003;
    
    

    
    
    
    
    //精神状态分级 标题数组
    UIView * fenJi_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(jingShenZTZF_Field.frame)+20, WIDTH, Q_RADIO_WH*(fenJi_Title_Array.count+1))];
    [RootScrollView addSubview:fenJi_View];
    
    //日常生活活动分级 标题
    UILabel * fenJi_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"5. 精神状态分级"];
    [fenJi_View addSubview:fenJi_Label];
    fenJi_Label.textColor=Title_text_color;
    
    //日常生活活动分级 介绍
    UIButton * fenJi_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(fenJi_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [fenJi_View addSubview:fenJi_Button];
    fenJi_Button.tag=90004;
    
    
    
    //精神状态分级 选项 0
    
    fenJi_Button0=[[QRadioButton alloc]initWithDelegate:self groupId:@"jingShenZTFJ"];
    [fenJi_View addSubview:fenJi_Button0];
    fenJi_Button0.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button0 setChecked:NO];
    fenJi_Button0.userInteractionEnabled=NO;
    
    
    
    //精神状态分级 选项 1
    
    fenJi_Button1=[[QRadioButton alloc]initWithDelegate:self groupId:@"jingShenZTFJ"];
    [fenJi_View addSubview:fenJi_Button1];
    fenJi_Button1.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button1 setChecked:NO];
    fenJi_Button1.userInteractionEnabled=NO;
    
    
    
    //精神状态分级 选项 2
    
    fenJi_Button2=[[QRadioButton alloc]initWithDelegate:self groupId:@"jingShenZTFJ"];
    [fenJi_View addSubview:fenJi_Button2];
    fenJi_Button2.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH*2, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button2 setChecked:NO];
    fenJi_Button2.userInteractionEnabled=NO;
    
    
    
    //精神状态分级 选项 3
    
    fenJi_Button3=[[QRadioButton alloc]initWithDelegate:self groupId:@"jingShenZTFJ"];
    [fenJi_View addSubview:fenJi_Button3];
    fenJi_Button3.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH*3, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button3 setChecked:NO];
    fenJi_Button3.userInteractionEnabled=NO;
    
    
    
    //选项标题
    for (int i=0; i<fenJi_Title_Array.count; i++) {
        
        if (![PublicFunction isBlankString:_jingShenZTModel.jingShenZTFJ]) {
            switch (i) {
                case 0:
                    [fenJi_Button0 setChecked:YES];
                    break;
                    
                case 1:
                    [fenJi_Button1 setChecked:YES];
                    break;
                    
                case 2:
                    [fenJi_Button2 setChecked:YES];
                    break;
                    
                case 3:
                    [fenJi_Button3 setChecked:YES];
                    break;
                    
                default:
                    break;
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(fenJi_Button0.frame)+8, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH*i, WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [fenJi_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        xuanXiang_Label.text=fenJi_Title_Array[i];
    }
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(fenJi_View.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.assessment intValue]==0 || [self.assessment intValue]==1 || [self.assessment intValue]==5 || [self.assessment intValue]==6) {
            //保存
            Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
            [self.view addSubview:Save_Button];
            [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
            Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
            [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
            
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(fenJi_View.frame)+20+Tabbar_HE);
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"（1）回忆词语：\n\n目的：考察申请人目前的记忆能力，主要包括短期记忆能力和情景记忆能力。\n\n方法：先按照表中的提示，说出三样东西（3个词语），并请申请人记住。在短暂打断（画钟测验）后，要求申请人重复刚才说的三样东西。对于语言表达障碍的申请人，如果能够以非语言的方式回答（例如用手指出正确的东西），也表示其能够成功回忆起相应的词语。\n\n（2）画钟测验：\n\n目的：采用简单、快速的方法，对申请人的认知功能进行评估。\n\n定义：徒手画钟表是一项复杂的行为活动，除了空间构造技巧外，尚需很多知识功能参与，涉及记忆、注意力、抽象思维、涉及、布局安排、运用、数字、计算、时间和空间定向概念、运作的顺序等多种认知功能。操作简单、省时，与其他认知测试题相比，更易被评估对象所接受。\n\n方法：使用一张白纸，提供易于书写的笔，请申请人在纸上画一个圆形的时钟，完成后再请对方在时钟上标出10点45分。\n\n（3）记录：画钟测验结果正确（即圆形完整、闭锁，指诊位置正确），同时能正确回忆出的词语个数。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：确定攻击行为发生的频率，这些行为可能对申请人本人或其他人造成伤害。识别并记录此类行为将为进一步评估、规划及持续、合理提供照护服务提供依据。\n\n定义：攻击行为包括身体攻击行为和语言攻击行为。\n\n方法：向申请人的家属或照护者询问申请人是否出现过特定的攻击行为。只需要关注行为本身是否发生，而不是行为背后的意图。例如有时候家属因为已经习惯了申请人的一些攻击行为，会刻意淡化，称申请人“仅仅是见了陌生人有点紧张，并无恶意、没打算伤害别人”。评估人员应该忠实记录攻击行为是否发生的事实。请注意观察申请人在其家属或他人向其提供照护服务时的反映。如果有观察到身体攻击行为或者语言攻击行为，可向照护者询问是否知道在过去7天内发生了什么。如果有可能，最好在申请人不在场时询问照护者，因为当着申请人的面询问结果可能还需要事后再验证。另外，如果有不止一位照护者在场，单个照护者的回答也可能不尽准确。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：记录过去7天内申请人出现的可能与抑郁有关的症状，无论导致该症状/行为的原因是什么。\n\n方法：精神上的受压感觉可能会通过言语表现出来，但也有可能通过非语言信号传达出来。评估人员与申请人谈话时应重视其之前的表述。有些申请人善于使用语言表达感受，会很愿意在感到压抑时告诉他人，或至少在被人问道其感受如何时说出来。遇到这样的评估对象，评估人员可以询问其这样的感受大概有了多长时间。\n\n另外一些人可能不太擅长表述自己的感受（有可能是找不到描述自己感受的词语，也可能是缺乏自省或认知能力）。对这类申请人需要评估人员细心观察申请人，既包括评估当天，也包括之前7天内可能与其接触的时间。\n\n应向熟悉申请人日常表现的家属或医生了解其可能出现的异常情况。在进行本项评估时，需要注意申请人的文化背景，做好预备功夫。最好先告知涉及情绪方面的问题，问对方是否愿意回答，并尊重申请人的意愿。\n\n记录：根据与申请人的交流和自己的观察，记录过去7天内申请人的相应情况。切记只需要关注这些情况有没有出现，无论是什么原因导致的。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：将精神状态1-3项的得分全部加总，得到的总数即为本项总分，使用评估系统应用程序（APP），本项将自动加总前述1-3项答案对应的得分，直接显示总分结果。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：根据精神状态1-3项得分加总得到的总分数，对应精神状态的分级结果。\n\n记录：根据第4题总分在本题各答案对应的区间，得到正确的分级结果。例如总分为3分，对应区间为2-3分，分级结果为“2，中度受损”。使用评估系统应用程序（APP），本项将自动显示分级结果。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    if ([groupId isEqualToString:@"renZhiGN"]) {
        my_renZhiGN=[NSString stringWithFormat:@"%ld",radio.tag-3000];
        [zongFen_dict setValue:my_renZhiGN forKey:@"renZhiGN"];
    }
    
    if ([groupId isEqualToString:@"gongJiXW"]) {
        my_gongJiXW=[NSString stringWithFormat:@"%ld",radio.tag-4000];
        [zongFen_dict setValue:my_gongJiXW forKey:@"gongJiXW"];
    }
    
    if ([groupId isEqualToString:@"yiYuZZ"]) {
        my_yiYuZZ=[NSString stringWithFormat:@"%ld",radio.tag-5000];
        [zongFen_dict setValue:my_yiYuZZ forKey:@"yiYuZZ"];
    }

    
    //更新总分
    [self update_zongFen];
    
    //更新分级
    [self update_fenJi];
    
}


#pragma mark - 更新总分
-(void)update_zongFen
{
    zongFen=0;
    NSArray * dict_keyArray=[zongFen_dict allKeys];
    for (NSString * key in dict_keyArray) {
        NSString * value=[zongFen_dict objectForKey:key];
        zongFen=zongFen+[value intValue];
    }
    
    jingShenZTZF_Field.text=[NSString stringWithFormat:@"%d",zongFen];
}



#pragma mark - 更新分级
-(void)update_fenJi
{
    if (zongFen==0) {
        [fenJi_Button0 setChecked:YES];
        my_jingShenZTFJ=@"0";
        
    } else if (zongFen==1) {
        [fenJi_Button1 setChecked:YES];
        my_jingShenZTFJ=@"1";
        
    } else if (zongFen>=2 && zongFen<=3) {
        [fenJi_Button2 setChecked:YES];
        my_jingShenZTFJ=@"2";
        
    } else if (zongFen>=4 && zongFen<=6) {
        [fenJi_Button3 setChecked:YES];
        my_jingShenZTFJ=@"3";
    }
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_renZhiGN]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“认知功能”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_gongJiXW]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“攻击行为”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_yiYuZZ]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“抑郁症状”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        
        //更新 精神状态
        [self update_JingShenZT];
    }
    
}



//更新 精神状态
-(void)update_JingShenZT
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"12" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    if (![PublicFunction isBlankString:my_renZhiGN]) {
        [parameter setObject:my_renZhiGN forKey:@"renZhiGN"];
    }
    
    if (![PublicFunction isBlankString:my_gongJiXW]) {
        [parameter setObject:my_gongJiXW forKey:@"gongJiXW"];
    }
    
    if (![PublicFunction isBlankString:my_yiYuZZ]) {
        [parameter setObject:my_yiYuZZ forKey:@"yiYuZZ"];
    }
    
    if (![PublicFunction isBlankString:my_jingShenZTFJ]) {
        [parameter setObject:my_jingShenZTFJ forKey:@"jingShenZTFJ"];
    }
    
    if (![PublicFunction isBlankString:jingShenZTZF_Field.text]) {
        [parameter setObject:jingShenZTZF_Field.text forKey:@"jingShenZTZF"];
    }
    
    
    [KVNProgress show];
    
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:insertResultHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
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

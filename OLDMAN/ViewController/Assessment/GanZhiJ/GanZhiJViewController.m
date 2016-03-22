//
//  GanZhiJViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/22.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "GanZhiJViewController.h"
#import "GanZhiJModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

@interface GanZhiJViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    NSString * my_yiShiSP;//意识水平
    
    NSString * my_shiLi;//视力
    
    NSString * my_tingLi;//听力
    
    NSString * my_gouTongJL;//沟通交流
    
    NSString * my_ganZhiJYGTFJ;//感知觉与沟通分级
    
    UITextField * ganZhiJYGTZF_Field;//感知觉与沟通总分
    
    NSArray * titleArray;//标题数组
    
    
    
    NSMutableDictionary * zongFen_dict;//感知觉与沟通总分
    
    int zongFen;//感知觉与沟通总分
    
    
    
    NSArray * fenJi_Title_Array;//感知觉与沟通分级 标题数组
    
    QRadioButton * fenJi_Button0;//感知觉与沟通分级 选项 0
    
    QRadioButton * fenJi_Button1;//感知觉与沟通分级 选项 1
    
    QRadioButton * fenJi_Button2;//感知觉与沟通分级 选项 2
    
    QRadioButton * fenJi_Button3;//感知觉与沟通分级 选项 3
    
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    
    GanZhiJModel * _ganZhiJModel;//请求 数据
}
@property(nonatomic,retain)NSMutableArray * dataSourse;//数据源
@end

@implementation GanZhiJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    //感知觉与沟通总分
    zongFen_dict=[[NSMutableDictionary alloc]init];

    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}
//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _ganZhiJModel=[[GanZhiJModel alloc]init];//请求 数据
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _ganZhiJModel=nil;
    
    [zongFen_dict removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}

#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    titleArray=@[@"1. 意识水平",@"2. 视力－若平日带老花镜或近视镜，应在配戴眼镜的情况下评估",@"3. 听力－若平时佩戴助听器，应在佩戴助听器的情况下评估",@"4. 沟通交流－包括非语言沟通"];
    
    _dataSourse=[[NSMutableArray alloc]initWithCapacity:titleArray.count];
    for (int i=0; i<titleArray.count; i++) {
        NSArray * titleArr;
        switch (i) {
            case 0:
                titleArr=@[@"神志清醒，对周围环境警觉",@"嗜睡，表现为睡眠状态过度延长。当呼唤或推动患者的肢体时可以唤醒，并能进行正确的交谈或执行指令，停止刺激后又继续入睡",@"昏睡，一般的外界刺激不能使其觉醒，给予较强烈的刺激时可有短时的意识清醒，醒后可简短回答提问，当刺激减弱后又很快进入睡眠状态",@"昏迷，处于浅昏迷时对疼痛刺激有回避和痛苦表情：处于深昏迷时对刺激无反应（若评定为昏迷，直接评定为重度失能，可不进行以下项目的评估）"];
                break;
            case 1:
                titleArr=@[@"能看清书报上的标准字体",@"能看清楚大字体，但看不清书报上的标准字体",@"视力有限，看不清报纸大标题，但能辨认物体",@"辨认物体有困难，但眼睛能跟随物体移动，只能看到光、颜色和形状",@"没有视力，眼睛不能跟随物体移动"];
                break;
            case 2:
                titleArr=@[@"可正常交谈，能听到电视、电话、门铃的声音",@"在轻声说话或说话的距离超过2米时听不清",@"正常交流有些困，需在安静的环境或大声说话才能听到",@"讲话者大声说话或说话很慢，才能部分听见",@"完全听不见"];
                break;
            case 3:
                titleArr=@[@"无困难，能与他人正常沟通和交",@"能够表达自己的需要及理解别人的话，但需要增加时间或给予帮助",@"表达需要或理解有困难，需频繁重复或简化口头表达",@"不能表达需要或理解他人的话",@"完全听不见"];
                break;
            default:
                break;
        }
        
        [_dataSourse addObject:titleArr];
    }
    
    //感知觉与沟通分级 标题数组
    fenJi_Title_Array=@[@"能力完好：意识清醒，且视力和听力评级为0或1，沟通评为0",@"轻度受损：意识清醒，但视力或听力中至少有一项评为2，或沟通评为1",@"中度受损：意识清醒，但视力或听力中至少有一项评为3，或沟通评为2；或嗜睡，视力或听力评定为3及以下，沟通评定为2及以下",@"重度受损：意识清醒或嗜睡，但视力或听力中至少有一项评为4，或沟通评为3；或昏睡／昏迷"];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"13"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_ganZhiJModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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




-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航背景图
    self.navigationController.navigationBar.barTintColor = Nav_Tabbar_backgroundColor;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"感知觉与沟通";
    
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
                    [xuanXiang_Button getGroupId:@"yiShiSP"];
                    xuanXiang_Button.tag=3000+i;
                    
                    if (![PublicFunction isBlankString:_ganZhiJModel.yiShiSP]) {
                        if ([_ganZhiJModel.yiShiSP intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"shiLi"];
                    xuanXiang_Button.tag=4000+i;
                    
                    if (![PublicFunction isBlankString:_ganZhiJModel.shiLi]) {
                        if ([_ganZhiJModel.shiLi intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"tingLi"];
                    xuanXiang_Button.tag=5000+i;
                    
                    if (![PublicFunction isBlankString:_ganZhiJModel.tingLi]) {
                        if ([_ganZhiJModel.tingLi intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"gouTongJL"];
                    xuanXiang_Button.tag=6000+i;
                    
                    if (![PublicFunction isBlankString:_ganZhiJModel.gouTongJL]) {
                        if ([_ganZhiJModel.gouTongJL intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
            //选项标题
            UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Button.frame)+8, CGRectGetMinY(xuanXiang_Button.frame), WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
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
    
    
    
    
    
    //感知觉与沟通总分 标题
    UILabel * ganZhiJYGTZF_Label=[ZCControl createLabelWithFrame:CGRectMake(15, RootScrollView_contentSize+10, 44+Title_text_font*8, Title_text_font) Font:Title_text_font Text:@"5. 感知觉与沟通总分"];
    [RootScrollView addSubview:ganZhiJYGTZF_Label];
    ganZhiJYGTZF_Label.textColor=Title_text_color;
    
    //感知觉与沟通总分 签字框
    ganZhiJYGTZF_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(ganZhiJYGTZF_Label.frame)+Title_Field_WH, CGRectGetMinY(ganZhiJYGTZF_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-ganZhiJYGTZF_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    ganZhiJYGTZF_Field.textColor=Field_text_color;
    [RootScrollView addSubview:ganZhiJYGTZF_Field];
    ganZhiJYGTZF_Field.delegate=self;
    ganZhiJYGTZF_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_ganZhiJModel.ganZhiJYGTZF]) {
        ganZhiJYGTZF_Field.text=_ganZhiJModel.ganZhiJYGTZF;
    }
    
    //介绍
    UIButton * ganZhiJYGTZF_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(ganZhiJYGTZF_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:ganZhiJYGTZF_Button];
    ganZhiJYGTZF_Button.tag=90004;
    
    
    
    
    
    
    //感知觉与沟通分级 标题数组
    UIView * fenJi_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(ganZhiJYGTZF_Field.frame)+20, WIDTH, 24*(fenJi_Title_Array.count+1))];
    [RootScrollView addSubview:fenJi_View];
    
    //感知觉与沟通分级 标题
    UILabel * fenJi_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"6. 感知觉与沟通分级"];
    [fenJi_View addSubview:fenJi_Label];
    fenJi_Label.textColor=Title_text_color;
    
    //感知觉与沟通分级 介绍
    UIButton * fenJi_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(fenJi_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [fenJi_View addSubview:fenJi_Button];
    fenJi_Button.tag=90005;
    
    
    
    //感知觉与沟通分级 选项 0
    
    fenJi_Button0=[[QRadioButton alloc]initWithDelegate:self groupId:@"fenJi"];
    [fenJi_View addSubview:fenJi_Button0];
    [fenJi_Button0 setChecked:NO];
    fenJi_Button0.userInteractionEnabled=NO;
    
    
    
    //感知觉与沟通分级 选项 1
    
    fenJi_Button1=[[QRadioButton alloc]initWithDelegate:self groupId:@"fenJi"];
    [fenJi_View addSubview:fenJi_Button1];
    [fenJi_Button1 setChecked:NO];
    fenJi_Button1.userInteractionEnabled=NO;

    
    
    //感知觉与沟通分级 选项 2
    
    fenJi_Button2=[[QRadioButton alloc]initWithDelegate:self groupId:@"fenJi"];
    [fenJi_View addSubview:fenJi_Button2];
    [fenJi_Button2 setChecked:NO];
    fenJi_Button2.userInteractionEnabled=NO;

    
    
    //感知觉与沟通分级 选项 3
    
    fenJi_Button3=[[QRadioButton alloc]initWithDelegate:self groupId:@"fenJi"];
    [fenJi_View addSubview:fenJi_Button3];
    [fenJi_Button3 setChecked:NO];
    fenJi_Button3.userInteractionEnabled=NO;

    
    
    
    //起始高度
    float xuanXiang_Label_frame_origin_y=CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE;
    
    //选项标题
    for (int i=0; i<fenJi_Title_Array.count; i++) {
        
            switch (i) {
                case 0:
                    fenJi_Button0.frame=CGRectMake(15, xuanXiang_Label_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
                    break;
                    
                case 1:
                    fenJi_Button1.frame=CGRectMake(15, xuanXiang_Label_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
                    break;
                    
                case 2:
                    fenJi_Button2.frame=CGRectMake(15, xuanXiang_Label_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
                    break;
                    
                case 3:
                    fenJi_Button3.frame=CGRectMake(15, xuanXiang_Label_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
                    break;
                    
                default:
                    break;
            }
        
        
        if (![PublicFunction isBlankString:_ganZhiJModel.ganZhiJYGTFJ]) {
            switch (i) {
                case 0:
                    [fenJi_Button0 setChecked:YES];
                    break;
                    
                case 1:
                    [fenJi_Button0 setChecked:YES];
                    break;
                    
                case 2:
                    [fenJi_Button0 setChecked:YES];
                    break;
                    
                case 3:
                    [fenJi_Button0 setChecked:YES];
                    break;
                    
                default:
                    break;
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(fenJi_Button0.frame)+8, xuanXiang_Label_frame_origin_y, WIDTH-60, Q_RADIO_ICON_WH) Font:Answer_text_font Text:nil];
        [fenJi_View addSubview:xuanXiang_Label];
        xuanXiang_Label.textColor=Answer_text_color;
        xuanXiang_Label.numberOfLines=0;
        
        NSString * labelText = fenJi_Title_Array[i];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        xuanXiang_Label.attributedText = attributedString;
        [xuanXiang_Label sizeToFit];
        xuanXiang_Label_frame_origin_y=CGRectGetMaxY(xuanXiang_Label.frame)+Q_ICON_HE;
    }
    
    fenJi_View.frame = CGRectMake(0, CGRectGetMaxY(ganZhiJYGTZF_Field.frame)+20, WIDTH, xuanXiang_Label_frame_origin_y);
    
    
    
    
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"若平日带老花镜或近视镜，应在配戴眼镜的情况下评估。\n\n目的：评估申请人在光线充足的情况下，佩戴日常使用的视力矫正工具（如老花镜或近视镜），能否看清近处物体。\n\n定义：光线充足指的是对视力正常的人来说足够舒适的光线水平。\n\n方法：向申请人、其家属或照护者询问申请人过去7天内有无视力方面的改变。例如申请人是否能如常读书看报？向申请人询问其视力，并通过请申请人在使用视力矫正工具的情况下看清楚书报上的字来对其回答进行验证。请申请人大声读出该书报上的文字，从大字号的标题开始，直到小字体的内容。\n\n需要注意，有些申请人可能不识字或者半文盲，如果能够读出部分文字、日期或页码等数字，或说出较小图片中的物品的名称，也算通过了验证。\n\n如果申请人无法进行沟通，或无法执行评估人员的视力测验要求，观察申请人的眼睛是否能够跟随动作和物体而移动。尽管这些只是对视力的粗略检测，却有可能帮助评估人员判断申请人是否有最起码的视物能力。\n\n记录：选择最能描述申请人视力情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"若平时佩戴助听器，应在佩戴助听器的情况下评估。\n\n目的：评估申请人过去7天内的听力水平（必要时佩戴助听器）。\n\n方法：如果申请人平时佩戴助听器，应确保评估时正确佩戴助听器，已经打开并且正常工作。在与申请人沟通过程中进行细致观察。可以向申请人的家属询问，并在整个评估过程中观察其语言互动情况，检验答案的准确性。最好采取多种方式进行测试，例如一对一交流、群体交流（观察申请人与家属或照护者之间的交流情况），排除环境噪音可能带来的影响。注意听力障碍的一些表现，例如与其沟通时需要减慢语速、发音更加清晰、提高音量或增加手势。听力受限的人还有可能需要在交谈中看到对方的脸。有些申请人可能需要到一个更加安静的地方接受评估。\n\n记录：选择最能描述申请人听力情况的答案，系统自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"包括非语言交流。\n\n目的：记录和描述申请人的沟通交流能力，即包括表达自己的需要、意见及参与交流的能力，也包括理解文字信息的能力，无论是使用口头交流、书面信息、手语还是盲文。\n\n方法：通过与申请人沟通互动观察、聆听后得到结论。必要时可以向申请人的家属或照护者提问。\n\n记录：选择最能描述申请人沟通交流的情况的答案，系统自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：将感知觉与沟通1-4项的得分全部加总，得到的总数即为本项总分，使用评估系统应用程序（APP），本项将自动加总前述1-4项答案对应的得分，直接显示总分结果。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：根据感知觉与沟通1-4项得分加总得到的总分数，对应感知觉与沟通的分级结果。\n\n 记录：根据第5题总分在本题各答案对应的区间，得到正确的分级结果。使用评估系统应用程序（APP），本项将自动显示分级结果。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}







#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    if ([groupId isEqualToString:@"yiShiSP"]) {
        my_yiShiSP=[NSString stringWithFormat:@"%ld",radio.tag-3000];
        [zongFen_dict setValue:my_yiShiSP forKey:@"yiShiSP"];
    }
    
    if ([groupId isEqualToString:@"shiLi"]) {
        my_shiLi=[NSString stringWithFormat:@"%ld",radio.tag-4000];
        [zongFen_dict setValue:my_shiLi forKey:@"shiLi"];
    }
    
    if ([groupId isEqualToString:@"tingLi"]) {
        my_tingLi=[NSString stringWithFormat:@"%ld",radio.tag-5000];
        [zongFen_dict setValue:my_tingLi forKey:@"tingLi"];
    }
    
    if ([groupId isEqualToString:@"gouTongJL"]) {
        my_gouTongJL=[NSString stringWithFormat:@"%ld",radio.tag-6000];
        [zongFen_dict setValue:my_gouTongJL forKey:@"gouTongJL"];
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
    
    ganZhiJYGTZF_Field.text=[NSString stringWithFormat:@"%d",zongFen];
}



#pragma mark - 更新分级
-(void)update_fenJi
{
    NSString * yiShiSP=[zongFen_dict objectForKey:@"yiShiSP"];
    
    NSString * shiLi=[zongFen_dict objectForKey:@"shiLi"];
    
    NSString * tingLi=[zongFen_dict objectForKey:@"tingLi"];
    
    NSString * gouTongJL=[zongFen_dict objectForKey:@"gouTongJL"];
    //获取分级
    my_ganZhiJYGTFJ=[PublicFunction getGanZhiJYGTFJ:yiShiSP shiLi:shiLi tingLi:tingLi gouTongJL:gouTongJL];
    
    
    if ([my_ganZhiJYGTFJ intValue]==0) {
        
        [fenJi_Button0 setChecked:YES];
    } else if ([my_ganZhiJYGTFJ intValue]==1) {
        
        [fenJi_Button1 setChecked:YES];
    } else if ([my_ganZhiJYGTFJ intValue]==2) {
        
        [fenJi_Button2 setChecked:YES];
    } else if ([my_ganZhiJYGTFJ intValue]==3) {
        
        [fenJi_Button3 setChecked:YES];
    }
}






#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_yiShiSP]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“意识水平”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_shiLi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“视力”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_tingLi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“听力”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_gouTongJL]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“沟通交流”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        //更新 感知觉与沟通
        [self update_GanZhiJ];
    }
    
}


//更新 感知觉与沟通
-(void)update_GanZhiJ
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"13" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    if (![PublicFunction isBlankString:my_yiShiSP]) {
        [parameter setObject:my_yiShiSP forKey:@"yiShiSP"];
    }
    
    if (![PublicFunction isBlankString:my_shiLi]) {
        [parameter setObject:my_shiLi forKey:@"shiLi"];
    }
    
    if (![PublicFunction isBlankString:my_tingLi]) {
        [parameter setObject:my_tingLi forKey:@"tingLi"];
    }
    
    if (![PublicFunction isBlankString:my_gouTongJL]) {
        [parameter setObject:my_gouTongJL forKey:@"gouTongJL"];
    }
    
    if (![PublicFunction isBlankString:my_ganZhiJYGTFJ]) {
        [parameter setObject:my_ganZhiJYGTFJ forKey:@"ganZhiJYGTFJ"];
    }
    
    if (![PublicFunction isBlankString:ganZhiJYGTZF_Field.text]) {
        [parameter setObject:ganZhiJYGTZF_Field.text forKey:@"ganZhiJYGTZF"];
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

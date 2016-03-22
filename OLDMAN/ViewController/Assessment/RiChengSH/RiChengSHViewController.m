//
//  RiChengSHViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/22.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "RiChengSHViewController.h"
#import "RiChengSHModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

@interface RiChengSHViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    NSString * my_jinShi;//进食
    
    NSString * my_xiZao;//洗澡
    
    NSString * my_xiuShi;//修饰
    
    NSString * my_chuanYi;//穿衣
    
    NSString * my_daBianKZ;//大便控制
    
    NSString * my_xiaoBianKZ;//小便控制
    
    NSString * my_ruCe;//如厕
    
    NSString * my_chuangYiZY;//床椅转移
    
    NSString * my_pingDiXZ;//平地移动
    
    NSString * my_shangXiaLT;//上下楼梯
    
    UITextField * riChangSSHDZF_Field;//日常生活总分
    
    NSString * my_riChangSSHDFJ;//日常生活活动分级
    
    NSArray * titleArray;//标题数组
    
    
    NSMutableDictionary * zongFen_dict;//日常生活总分
    
    int zongFen;//日常生活总分
    
    
    NSArray * fenJi_Title_Array;//日常生活活动分级 标题数组
    
    QRadioButton * fenJi_Button0;//日常生活活动分级 选项 0
    
    QRadioButton * fenJi_Button1;//日常生活活动分级 选项 1
    
    QRadioButton * fenJi_Button2;//日常生活活动分级 选项 2
    
    QRadioButton * fenJi_Button3;//日常生活活动分级 选项 3
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    RiChengSHModel * _riChengSHModel;//请求 数据
}

@property(nonatomic,retain)NSMutableArray * dataSourse;//数据源
@end

@implementation RiChengSHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //日常生活总分
    zongFen_dict=[[NSMutableDictionary alloc]init];
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _riChengSHModel=[[RiChengSHModel alloc]init];//请求 数据
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _riChengSHModel=nil;
    
    [zongFen_dict removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    titleArray=@[@"1. 进食－指用餐具将食物由容器送到口中、咀嚼、吞咽等过程",@"2. 洗澡",@"3. 修饰－指洗脸、刷牙、梳头、刮脸(剪指甲不作为评定)",@"4. 穿衣－指穿脱衣服、系扣、拉拉链、穿脱鞋袜、系鞋带等",@"5. 大便控制（一周内情况）",@"6. 小便控制（24小时~48小时内情况）",@"7. 如厕－包括去厕所、解开衣裤、擦净、整理衣裤、冲水",@"8. 床椅转移-换座位，110cm以上",@"9. 平地移动",@"10. 上下楼梯"];
    
    _dataSourse=[[NSMutableArray alloc]initWithCapacity:titleArray.count];
    for (int i=0; i<titleArray.count; i++) {
        NSArray * titleArr;
        switch (i) {
            case 0:
                titleArr=@[@"可自己独立进食（在合理的时间内独立进食准备好的食物）",@"需部分帮助（进食过程中需要一定帮助，如协助把持餐具）",@"需极大帮助或完全依赖他人，或有留置营养管"];
                break;
            case 1:
                titleArr=@[@"准备好洗澡水后，可自己独立完成洗澡过程",@"在洗澡过程中需他人帮助"];
                break;
            case 2:
                titleArr=@[@"可自己独立完成",@"需他人帮助"];
                break;
            case 3:
                titleArr=@[@"可自己独立完成",@"需部分帮助（自己能穿脱,但需他人帮助整理衣物、系扣/鞋带、拉拉链），能在20分钟内换完毕",@"需极大帮助或完全依赖他人"];
                break;
            case 4:
                titleArr=@[@"可自己控制大便",@"偶尔失控（每周 小于1次），或需要他人提示",@"完全失控"];
                break;
            case 5:
                titleArr=@[@"可自己控制小便",@"偶尔失控（每天小于1次，但每周大于1次），或需要他人提示",@"完全失控，或留置导尿管"];
                break;
            case 6:
                titleArr=@[@"可自己独立完成",@"需部分帮助（需他人搀扶去厕所，需他人帮忙冲水或整理衣裤等）",@"需极大帮助或完全依赖他人"];
                break;
            case 7:
                titleArr=@[@"可自己独立完成",@"需部分帮助（需他人搀扶或使用拐杖）",@"需极大帮助（较大程度上依赖他人搀扶和帮助）",@"完全依赖他人"];
                break;
            case 8:
                titleArr=@[@"可自己独立在平地上行走45米",@"需部分帮助（因肢体残疾、平衡能力差、过度衰弱、视力等问题，在一定程度上依赖他人搀扶或使用拐杖、助行器等辅助用具）",@"需极大帮助（因肢体残疾、平衡能力差、过度衰弱、视力等问题，在较大程度上依赖他人搀扶或坐在轮椅上自行移动）",@"完全依赖他人"];
                break;
            case 9:
                titleArr=@[@"可自己独立上下楼梯（连续上下10~15个台阶）",@"需部分帮助（需他人搀扶，或扶着楼梯、使用拐杖等）",@"需极大帮助或完全依赖他人"];
                break;
            default:
                break;
        }
        
        [_dataSourse addObject:titleArr];
    }
    
    
    
    
    //日常生活活动分级 标题数组
    fenJi_Title_Array=@[@"能力完好：总分100分",@"轻度受损：总分65~95分",@"中度受损：总分45~60分",@"重度受损：总分40分以下"];
}

#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"11"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_riChengSHModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"日常生活能力";
    
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
                
            default:
                break;
        }
        
        //起始高度
        float root_View_frame_origin_y=CGRectGetMaxY(title_Label.frame)+Q_ICON_HE;
        
        for (int i=0; i<Title_Array.count; i++) {
            //选框
            QRadioButton * xuanXiang_Button=[[QRadioButton alloc]initWithDelegate:self groupId:@""];
            [root_View addSubview:xuanXiang_Button];
            xuanXiang_Button.frame=CGRectMake(15, root_View_frame_origin_y, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
            [xuanXiang_Button setChecked:NO];
            
            
            switch (j) {
                case 0:
                {
                    [xuanXiang_Button getGroupId:@"jinShi"];
                    xuanXiang_Button.tag=3000+i;
            
                    if (![PublicFunction isBlankString:_riChengSHModel.jinShi]) {
                        if ([_riChengSHModel.jinShi intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"xiZao"];
                    xuanXiang_Button.tag=4000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.xiZao]) {
                        if ([_riChengSHModel.xiZao intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"xiuShi"];
                    xuanXiang_Button.tag=5000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.xiuShi]) {
                        if ([_riChengSHModel.xiuShi intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"chuanYi"];
                    xuanXiang_Button.tag=6000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.chuanYi]) {
                        if ([_riChengSHModel.chuanYi intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"daBianKZ"];
                    xuanXiang_Button.tag=7000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.daBianKZ]) {
                        if ([_riChengSHModel.daBianKZ intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 5:
                {
                    [xuanXiang_Button getGroupId:@"xiaoBianKZ"];
                    xuanXiang_Button.tag=8000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.xiaoBianKZ]) {
                        if ([_riChengSHModel.xiaoBianKZ intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 6:
                {
                    [xuanXiang_Button getGroupId:@"ruCe"];
                    xuanXiang_Button.tag=9000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.ruCe]) {
                        if ([_riChengSHModel.ruCe intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 7:
                {
                    [xuanXiang_Button getGroupId:@"chuangYiZY"];
                    xuanXiang_Button.tag=10000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.chuangYiZY]) {
                        if ([_riChengSHModel.chuangYiZY intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 8:
                {
                    [xuanXiang_Button getGroupId:@"pingDiXZ"];
                    xuanXiang_Button.tag=11000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.pingDiXZ]) {
                        if ([_riChengSHModel.pingDiXZ intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 9:
                {
                    [xuanXiang_Button getGroupId:@"shangXiaLT"];
                    xuanXiang_Button.tag=12000+i;
                    
                    if (![PublicFunction isBlankString:_riChengSHModel.shangXiaLT]) {
                        if ([_riChengSHModel.shangXiaLT intValue]==i) {
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
            [paragraphStyle setLineSpacing:Answer_HE];//调整行间距
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
            xuanXiang_Label.attributedText = attributedString;
            [xuanXiang_Label sizeToFit];
            root_View_frame_origin_y=CGRectGetMaxY(xuanXiang_Label.frame)+Q_ICON_HE;
        }
        
        root_View.frame = CGRectMake(0, RootScrollView_contentSize, WIDTH, root_View_frame_origin_y);
        
        
        RootScrollView_contentSize=RootScrollView_contentSize+root_View_frame_origin_y+10;
    }
    
    
    
    
    
    //日常生活总分 标题
    UILabel * riChangSSHDZF_Label=[ZCControl createLabelWithFrame:CGRectMake(15, RootScrollView_contentSize+10, 44+Title_text_font*6, Title_text_font) Font:Title_text_font Text:@"11. 日常生活总分"];
    [RootScrollView addSubview:riChangSSHDZF_Label];
    riChangSSHDZF_Label.textColor=Title_text_color;
    
    //日常生活总分 签字框
    riChangSSHDZF_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(riChangSSHDZF_Label.frame)+Title_Field_WH, CGRectGetMinY(riChangSSHDZF_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-riChangSSHDZF_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    riChangSSHDZF_Field.textColor=Field_text_color;
    [RootScrollView addSubview:riChangSSHDZF_Field];
    riChangSSHDZF_Field.delegate=self;
    riChangSSHDZF_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_riChengSHModel.riChangSSHDZF]) {
        riChangSSHDZF_Field.text=_riChengSHModel.riChangSSHDZF;
    }
    
    //日常生活总分 介绍
    UIButton * zongFen_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(riChangSSHDZF_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:zongFen_Button];
    zongFen_Button.tag=90010;
    
    

    
    
    
    //日常生活活动分级 标题数组
    UIView * fenJi_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(riChangSSHDZF_Field.frame)+20, WIDTH, Q_RADIO_WH*(fenJi_Title_Array.count+1))];
    [RootScrollView addSubview:fenJi_View];
    
    //日常生活活动分级 标题
    UILabel * fenJi_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"12. 日常生活活动分级"];
    [fenJi_View addSubview:fenJi_Label];
    fenJi_Label.textColor=Title_text_color;
    
    //日常生活活动分级 介绍
    UIButton * fenJi_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(fenJi_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [fenJi_View addSubview:fenJi_Button];
    fenJi_Button.tag=90011;
    
    
    //精神状态分级 选项 0
    
    fenJi_Button0=[[QRadioButton alloc]initWithDelegate:self groupId:@"riChangSSHDFJ"];
    [fenJi_View addSubview:fenJi_Button0];
    fenJi_Button0.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button0 setChecked:NO];
    fenJi_Button0.userInteractionEnabled=NO;
    
    
    
    //精神状态分级 选项 1
    
    fenJi_Button1=[[QRadioButton alloc]initWithDelegate:self groupId:@"riChangSSHDFJ"];
    [fenJi_View addSubview:fenJi_Button1];
    fenJi_Button1.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button1 setChecked:NO];
    fenJi_Button1.userInteractionEnabled=NO;
    
    
    
    //精神状态分级 选项 2
    
    fenJi_Button2=[[QRadioButton alloc]initWithDelegate:self groupId:@"riChangSSHDFJ"];
    [fenJi_View addSubview:fenJi_Button2];
    fenJi_Button2.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH*2, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button2 setChecked:NO];
    fenJi_Button2.userInteractionEnabled=NO;
    
    
    
    //精神状态分级 选项 3
    
    fenJi_Button3=[[QRadioButton alloc]initWithDelegate:self groupId:@"riChangSSHDFJ"];
    [fenJi_View addSubview:fenJi_Button3];
    fenJi_Button3.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH*3, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button3 setChecked:NO];
    fenJi_Button3.userInteractionEnabled=NO;
    
    
    
    //选项标题
    for (int i=0; i<fenJi_Title_Array.count; i++) {
        
        if (![PublicFunction isBlankString:_riChengSHModel.riChangSSHDFJ]) {
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"指用餐具将食物由容器送到口中、咀嚼、吞咽等过程。\n\n定义：将食物以通常习惯的方式放在桌上或托盘中后，被检查者是否可以成功的做到：1.使用合适的餐具将食物送入口中；2.咀嚼；3.吞咽。\n\n记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：包括洗和擦干的动作，包括洗头发，不包括更衣和移动。盆浴、淋浴均可。\n\n记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：包括1.刷牙（含挤牙膏）；2.洗脸（不含端脸盆的动作）；3.洗手；4.梳头；5.刮胡子或化妆（女性不化妆，男性留胡子时此项不计入其中）\n\n记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"指穿脱衣服、系扣、拉拉链、穿脱鞋袜、系鞋带等。\n\n定义：包括穿上身衣服和穿下身衣服。\n\n穿上身衣服包括：穿脱腰以上的各种内外衣，穿脱假肢或矫形器。动作要点包括取衣、穿、脱、系扣。\n\n穿下身衣服包括：穿脱裤、裙、鞋、亦包括穿脱假肢和矫形器。动作要点包括套裤腿，上提裤子，系带（扣），穿袜，穿鞋。\n\n记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：包括去厕所、解开衣裤、擦净、整理衣裤、冲水。\n\n记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90007:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：包括转移过程中的所有工作，如站起、转身移动、坐下。坐在轮椅中时则包括接近轮椅、合上车闸、提起足拖、持扶手、转移并返回等动作。\n\n记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录。"];
            
            [modal show];
        }
            break;
            
        case 90008:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90009:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：针对本项评估内容，选择最符合申请人情况的答案，系统会自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90010:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：将日常生活能力1-10项的得分全部加总，得到的总数即为本项总分，使用评估系统应用程序（APP），本项将自动加总前述1-10项答案对应的得分，直接显示总分结果。"];
            
            [modal show];
        }
            break;
            
        case 90011:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：根据日常生活能力1-10项得分加总得到的总分数，对应日常生活能力的分级结果。\n\n记录：根据第11题总分在本题各答案对应的区间，得到正确的分级结果。例如总分为88分，对应区间为65-95分，分级结果为“1，轻度受损”。使用评估系统应用程序（APP），本项将自动显示分级结果。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
    
}




#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    if ([groupId isEqualToString:@"jinShi"]) {
        my_jinShi=[NSString stringWithFormat:@"%ld",radio.tag-3000];
        [zongFen_dict setValue:my_jinShi forKey:@"jinShi"];
    }
    
    if ([groupId isEqualToString:@"xiZao"]) {
        my_xiZao=[NSString stringWithFormat:@"%ld",radio.tag-4000];
        [zongFen_dict setValue:my_xiZao forKey:@"xiZao"];
    }
    
    if ([groupId isEqualToString:@"xiuShi"]) {
        my_xiuShi=[NSString stringWithFormat:@"%ld",radio.tag-5000];
        [zongFen_dict setValue:my_xiuShi forKey:@"xiuShi"];
    }
    
    if ([groupId isEqualToString:@"chuanYi"]) {
        my_chuanYi=[NSString stringWithFormat:@"%ld",radio.tag-6000];
        [zongFen_dict setValue:my_chuanYi forKey:@"chuanYi"];
    }
    
    if ([groupId isEqualToString:@"daBianKZ"]) {
        my_daBianKZ=[NSString stringWithFormat:@"%ld",radio.tag-7000];
        [zongFen_dict setValue:my_daBianKZ forKey:@"daBianKZ"];
    }
    
    if ([groupId isEqualToString:@"xiaoBianKZ"]) {
        my_xiaoBianKZ=[NSString stringWithFormat:@"%ld",radio.tag-8000];
        [zongFen_dict setValue:my_xiaoBianKZ forKey:@"xiaoBianKZ"];
    }
    
    if ([groupId isEqualToString:@"ruCe"]) {
        my_ruCe=[NSString stringWithFormat:@"%ld",radio.tag-9000];
        [zongFen_dict setValue:my_ruCe forKey:@"ruCe"];
    }
    
    if ([groupId isEqualToString:@"chuangYiZY"]) {
        my_chuangYiZY=[NSString stringWithFormat:@"%ld",radio.tag-10000];
        [zongFen_dict setValue:my_chuangYiZY forKey:@"chuangYiZY"];
    }
    
    if ([groupId isEqualToString:@"pingDiXZ"]) {
        my_pingDiXZ=[NSString stringWithFormat:@"%ld",radio.tag-11000];
        [zongFen_dict setValue:my_pingDiXZ forKey:@"pingDiXZ"];
    }

    if ([groupId isEqualToString:@"shangXiaLT"]) {
        my_shangXiaLT=[NSString stringWithFormat:@"%ld",radio.tag-12000];
        [zongFen_dict setValue:my_shangXiaLT forKey:@"shangXiaLT"];
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
    
    NSString * jinShi=[zongFen_dict objectForKey:@"jinShi"];
    
    NSString * xiZao=[zongFen_dict objectForKey:@"xiZao"];
    
    NSString * xiuShi=[zongFen_dict objectForKey:@"xiuShi"];
    
    NSString * chuanYi=[zongFen_dict objectForKey:@"chuanYi"];
    
    NSString * daBianKZ=[zongFen_dict objectForKey:@"daBianKZ"];
    
    NSString * xiaoBianKZ=[zongFen_dict objectForKey:@"xiaoBianKZ"];
    
    NSString * ruCe=[zongFen_dict objectForKey:@"ruCe"];
    
    NSString * chuangYiZY=[zongFen_dict objectForKey:@"chuangYiZY"];
    
    NSString * pingDiXZ=[zongFen_dict objectForKey:@"pingDiXZ"];
    
    NSString * shangXiaLT=[zongFen_dict objectForKey:@"shangXiaLT"];
    
    switch ([jinShi intValue]) {
        case 0:
            zongFen=zongFen+10;
            break;
            
        case 1:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    
    switch ([xiZao intValue]) {
        case 0:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    switch ([xiuShi intValue]) {
        case 0:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    switch ([chuanYi intValue]) {
        case 0:
            zongFen=zongFen+10;
            break;
            
        case 1:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    switch ([daBianKZ intValue]) {
        case 0:
            zongFen=zongFen+10;
            break;
            
        case 1:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    switch ([xiaoBianKZ intValue]) {
        case 0:
            zongFen=zongFen+10;
            break;
            
        case 1:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    switch ([ruCe intValue]) {
        case 0:
            zongFen=zongFen+10;
            break;
            
        case 1:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    switch ([chuangYiZY intValue]) {
        case 0:
            zongFen=zongFen+15;
            break;
            
        case 1:
            zongFen=zongFen+10;
            break;
            
        case 2:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    switch ([pingDiXZ intValue]) {
        case 0:
            zongFen=zongFen+15;
            break;
            
        case 1:
            zongFen=zongFen+10;
            break;
            
        case 2:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    switch ([shangXiaLT intValue]) {
        case 0:
            zongFen=zongFen+10;
            break;
            
        case 1:
            zongFen=zongFen+5;
            break;
            
        default:
            break;
    }
    
    
    riChangSSHDZF_Field.text=[NSString stringWithFormat:@"%d",zongFen];
}



#pragma mark - 更新分级
-(void)update_fenJi
{
    if (zongFen==100) {
        [fenJi_Button0 setChecked:YES];
        my_riChangSSHDFJ=@"0";
        
    } else if (zongFen>=65 && zongFen<=95) {
        [fenJi_Button1 setChecked:YES];
        my_riChangSSHDFJ=@"1";
        
    } else if (zongFen>=45 && zongFen<=60) {
        [fenJi_Button2 setChecked:YES];
        my_riChangSSHDFJ=@"2";
        
    } else if (zongFen>=0 && zongFen<=40) {
        [fenJi_Button3 setChecked:YES];
        my_riChangSSHDFJ=@"3";
    }
}





#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_jinShi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“进食”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_xiZao]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“洗澡”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_xiuShi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“修饰”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_chuanYi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“穿衣”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_daBianKZ]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“大便控制”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_xiaoBianKZ]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“小便控制”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_ruCe]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“如厕”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_chuangYiZY]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“床椅转移”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_pingDiXZ]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“平地行走”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_shangXiaLT]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“上下楼梯”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        //更新 日常生活能力
        [self update_RiChengSH];
    }
    
}


//更新 日常生活能力
-(void)update_RiChengSH
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"11" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    if (![PublicFunction isBlankString:my_jinShi]) {
        [parameter setObject:my_jinShi forKey:@"jinShi"];
    }
    
    if (![PublicFunction isBlankString:my_xiZao]) {
        [parameter setObject:my_xiZao forKey:@"xiZao"];
    }
    
    if (![PublicFunction isBlankString:my_xiuShi]) {
        [parameter setObject:my_xiuShi forKey:@"xiuShi"];
    }
    
    if (![PublicFunction isBlankString:my_chuanYi]) {
        [parameter setObject:my_chuanYi forKey:@"chuanYi"];
    }
    
    if (![PublicFunction isBlankString:my_daBianKZ]) {
        [parameter setObject:my_daBianKZ forKey:@"daBianKZ"];
    }
    
    if (![PublicFunction isBlankString:my_xiaoBianKZ]) {
        [parameter setObject:my_xiaoBianKZ forKey:@"xiaoBianKZ"];
    }
    
    if (![PublicFunction isBlankString:my_ruCe]) {
        [parameter setObject:my_ruCe forKey:@"ruCe"];
    }
    
    if (![PublicFunction isBlankString:my_chuangYiZY]) {
        [parameter setObject:my_chuangYiZY forKey:@"chuangYiZY"];
    }
    
    if (![PublicFunction isBlankString:my_pingDiXZ]) {
        [parameter setObject:my_pingDiXZ forKey:@"pingDiXZ"];
    }
    
    if (![PublicFunction isBlankString:my_shangXiaLT]) {
        [parameter setObject:my_shangXiaLT forKey:@"shangXiaLT"];
    }
    
    if (![PublicFunction isBlankString:my_riChangSSHDFJ]) {
        [parameter setObject:my_riChangSSHDFJ forKey:@"riChangSSHDFJ"];
    }
    
    if (![PublicFunction isBlankString:riChangSSHDZF_Field.text]) {
        [parameter setObject:riChangSSHDZF_Field.text forKey:@"riChangSSHDZF"];
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

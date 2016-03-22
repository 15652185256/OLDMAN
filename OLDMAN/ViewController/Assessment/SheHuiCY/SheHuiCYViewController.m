//
//  SheHuiCYViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/22.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "SheHuiCYViewController.h"
#import "SheHuiCYModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

@interface SheHuiCYViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    NSString * my_shengHuoNL;//生活能力
    
    NSString * my_gongZuoNL;//工作能力
    
    NSString * my_shiJianKJ;//时间/空间定向
    
    NSString * my_renWuDX;//人物定向
    
    NSString * my_sheHuiJW;//社会交往能力
    
    NSString * my_sheHuiCYFJ;//社会参与分级
    
    UITextField * sheHuiCYZF_Field;//社会参与总分
    
    NSArray * titleArray;//标题数组
    
    
    
    NSMutableDictionary * zongFen_dict;//社会参与总分
    
    int zongFen;//社会参与总分
    
    
    NSArray * fenJi_Title_Array;//社会参与分级 标题数组
    
    QRadioButton * fenJi_Button0;//社会参与分级 选项 0
    
    QRadioButton * fenJi_Button1;//社会参与分级 选项 1
    
    QRadioButton * fenJi_Button2;//社会参与分级 选项 2
    
    QRadioButton * fenJi_Button3;//社会参与分级 选项 3
    
    
    
    
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    
    SheHuiCYModel * _sheHuiCYModel;//请求 数据
}
@property(nonatomic,retain)NSMutableArray * dataSourse;//数据源

@end

@implementation SheHuiCYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    //社会参与总分
    zongFen_dict=[[NSMutableDictionary alloc]init];
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _sheHuiCYModel=[[SheHuiCYModel alloc]init];//请求 数据
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _sheHuiCYModel=nil;
    
    [zongFen_dict removeAllObjects];
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}

#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    titleArray=@[@"1. 生活能力",@"2. 工作能力",@"3. 时间／空间定向",@"4. 人物定向",@"5. 社会交往能力"];
    
    _dataSourse=[[NSMutableArray alloc]initWithCapacity:titleArray.count];
    for (int i=0; i<titleArray.count; i++) {
        NSArray * titleArr;
        switch (i) {
            case 0:
                titleArr=@[@"除个人生活自理外（如饮食、洗漱、穿戴、二便），能料理家务（如做饭、洗衣）或当家管理事物",@"除个人生活自理外，能做家务，但欠好，家庭事务安排欠条理",@"个人生活能自理；只有在他人帮助下才能做些家务，但质量不好",@"个人基本生活事物能自理（如饮食、二便），在督促下可洗漱",@"个人基本生活事物（如饮食、二便）需要部分帮助或完全依赖他人帮助"];
                break;
            case 1:
                titleArr=@[@"原来熟练的脑力工作或体力技巧性工作可照常进行",@"原来熟练的脑力工作或体力技巧性工作能力有所下降",@"原来熟练的脑力工作或体力技巧性工作明显不如以往，部分遗忘",@"对熟练工作只有一些片段保留，技能全部遗忘",@"对以往的知识或技能全部磨灭"];
                break;
            case 2:
                titleArr=@[@"时间观念（年、月、日、时）清楚；可单独出远门，能很快掌握新环境的方位",@"时间观念有些下降，年、月、日清楚，但有时相差几天；可单独来往于近街，知道现在住地的名称和方位，但不知回家的路线",@"时间观念较差，年、月、日不清楚，可知上半年或下半年；只能单独在家附近行动，对现住地只知名称，不知道方位",@"时间观念很差，年、月、日不清楚，可知上午或下午；只能在左邻右舍间串门 ，对现住地不知名称和方位",@"无时间观念；不能单独外出"];
                break;
            case 3:
                titleArr=@[@"知道周围人们的关系，知道祖孙、叔伯、姑姨、侄子侄女等称谓的意义；可分辨陌生人的大致年龄和身份，可用适当称呼",@"只知家中亲密近亲的关系，不会分辨陌生人的大致年龄，不能称呼陌生人",@"只能称呼家中人，或只能照样称呼，不知其关系，不辨辈分",@"只认识常同住的亲人，可称呼子女或孙子女，可辨熟人和生人",@"只认识保护人，不辨熟人和生人"];
                break;
            case 4:
                titleArr=@[@"参与社会，在社会环境有一定的适应能力，待人接物恰当",@"能适应单纯环境，主动接触人，初见面时难让人发现智力问题，不能理解隐喻语",@"脱离社会，可被动接触，不会主动待人，谈话中很多不适词句，容易上当受骗",@"勉强可与人交往，谈吐内容不清楚，表情不恰当",@"难以与人接触"];
                break;
            default:
                break;
        }
        
        [_dataSourse addObject:titleArr];
    }
    
    //社会参与分级 标题数组
    fenJi_Title_Array=@[@"能力完好：总分0～2分",@"轻度受损：总分3～7分",@"中度受损：总分8～13分",@"重度受损：总分14～20分"];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"14"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_sheHuiCYModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"社会参与";
    
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
    
    
    
    
    
    
    
    
    
    
    //RootScrollView_contentSize 的移动距离
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
                    [xuanXiang_Button getGroupId:@"shengHuoNL"];
                    
                    xuanXiang_Button.tag=3000+i;
                    
                    if (![PublicFunction isBlankString:_sheHuiCYModel.shengHuoNL]) {
                        if ([_sheHuiCYModel.shengHuoNL intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"gongZuoNL"];
                    
                    xuanXiang_Button.tag=4000+i;
                    
                    if (![PublicFunction isBlankString:_sheHuiCYModel.gongZuoNL]) {
                        if ([_sheHuiCYModel.gongZuoNL intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"shiJianKJ"];
                    
                    xuanXiang_Button.tag=5000+i;
                    
                    if (![PublicFunction isBlankString:_sheHuiCYModel.shiJianKJ]) {
                        if ([_sheHuiCYModel.shiJianKJ intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"renWuDX"];
                    
                    xuanXiang_Button.tag=6000+i;
                    
                    if (![PublicFunction isBlankString:_sheHuiCYModel.renWuDX]) {
                        if ([_sheHuiCYModel.renWuDX intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"sheHuiJW"];
                    
                    xuanXiang_Button.tag=7000+i;
                    
                    if (![PublicFunction isBlankString:_sheHuiCYModel.sheHuiJW]) {
                        if ([_sheHuiCYModel.sheHuiJW intValue]==i) {
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
        
        //更新 root_View 坐标
        root_View.frame = CGRectMake(0, RootScrollView_contentSize, WIDTH, root_View_frame_origin_y);
        
        //重置 RootScrollView_contentSize 的移动距离
        RootScrollView_contentSize=RootScrollView_contentSize+root_View_frame_origin_y+10;
    }
    
    
    
    
    
    //社会参与总分 标题
    UILabel * sheHuiCYZF_Label=[ZCControl createLabelWithFrame:CGRectMake(15, RootScrollView_contentSize+10, 44+Title_text_font*6, Title_text_font) Font:Title_text_font Text:@"6. 社会参与总分"];
    [RootScrollView addSubview:sheHuiCYZF_Label];
    sheHuiCYZF_Label.textColor=Title_text_color;
    
    //社会参与总分 签字框
    sheHuiCYZF_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(sheHuiCYZF_Label.frame)+Title_Field_WH, CGRectGetMinY(sheHuiCYZF_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-sheHuiCYZF_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    sheHuiCYZF_Field.textColor=Field_text_color;
    [RootScrollView addSubview:sheHuiCYZF_Field];
    sheHuiCYZF_Field.delegate=self;
    sheHuiCYZF_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_sheHuiCYModel.sheHuiCYZF]) {
        sheHuiCYZF_Field.text=_sheHuiCYModel.sheHuiCYZF;
    }
    
    //介绍
    UIButton * sheHuiCYZF_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(sheHuiCYZF_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:sheHuiCYZF_Button];
    sheHuiCYZF_Button.tag=90005;
    
    
    
    
    
    //社会参与分级 标题数组
    UIView * fenJi_View=[ZCControl createView:CGRectMake(0, CGRectGetMaxY(sheHuiCYZF_Field.frame)+20, WIDTH, Q_RADIO_WH*(fenJi_Title_Array.count+1))];
    [RootScrollView addSubview:fenJi_View];
    
    //社会参与分级 标题
    UILabel * fenJi_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-60, Title_text_font) Font:Title_text_font Text:@"7. 社会参与分级"];
    [fenJi_View addSubview:fenJi_Label];
    fenJi_Label.textColor=Title_text_color;
    
    //社会参与分级 介绍
    UIButton * fenJi_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(fenJi_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [fenJi_View addSubview:fenJi_Button];
    fenJi_Button.tag=90006;
    
    
    
    //社会参与分级 选项 0
    
    fenJi_Button0=[[QRadioButton alloc]initWithDelegate:self groupId:@"sheHuiCYFJ"];
    [fenJi_View addSubview:fenJi_Button0];
    fenJi_Button0.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button0 setChecked:NO];
    fenJi_Button0.userInteractionEnabled=NO;


    
    
    //社会参与分级 选项 1
    
    fenJi_Button1=[[QRadioButton alloc]initWithDelegate:self groupId:@"sheHuiCYFJ"];
    [fenJi_View addSubview:fenJi_Button1];
    fenJi_Button1.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button1 setChecked:NO];
    fenJi_Button1.userInteractionEnabled=NO;

    
    
    
    
    
    //社会参与分级 选项 2
    
    fenJi_Button2=[[QRadioButton alloc]initWithDelegate:self groupId:@"sheHuiCYFJ"];
    [fenJi_View addSubview:fenJi_Button2];
    fenJi_Button2.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH*2, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button2 setChecked:NO];
    fenJi_Button2.userInteractionEnabled=NO;

    
    
    
    
    //社会参与分级 选项 3
    
    fenJi_Button3=[[QRadioButton alloc]initWithDelegate:self groupId:@"sheHuiCYFJ"];
    [fenJi_View addSubview:fenJi_Button3];
    fenJi_Button3.frame=CGRectMake(15, CGRectGetMaxY(fenJi_Label.frame)+Q_ICON_HE+Q_RADIO_WH*3, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
    [fenJi_Button3 setChecked:NO];
    fenJi_Button3.userInteractionEnabled=NO;
    
    
    
    //选项标题
    for (int i=0; i<fenJi_Title_Array.count; i++) {
        
        if (![PublicFunction isBlankString:_sheHuiCYModel.sheHuiCYFJ]) {
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：通过与申请人沟通互动、观察、聆听后得到结论。必要时可以向申请人的家属或照护者询问其最近7天之内的情况。\n\n记录：选择最能描述申请人生活能力的答案，系统自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：通过与申请人沟通互动、观察、聆听后得到结论。必要时可以向申请人的家属或照护者询问其最近7天之内的情况。\n\n记录：选择最能描述申请人工作能力的答案，系统自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：询问申请人是否知道评估当时的年、月、日和具体时间，询问其是否能准确说出评估所在地的地址。向申请人的家属或照护者询问其最近7天之内的外出和回家情况。\n\n记录：选择最能描述申请人时间/空间定向能力的答案，系统自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：问申请人是否知道周围人们的关系，并挑选几个称谓，询问其是否知道该称谓的意义。询问其能否准确说出评估人员的大致年龄和身份。向申请人的家属或照护者询问其最近7天之内的人物定向情况。\n\n记录：选择最能描述申请人人物定向能力的答案，系统自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：评估人员通过观察，必要时询问申请人的家属或照护者，判断其社会交往能力。\n\n记录：选择最能描述申请人社会交往能力的答案，系统自动记录分数。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：将社会参与1-5项的得分全部加总，得到的总数即为本项总分，使用评估系统应用程序（APP），本项将自动加总前述1-5项答案对应的得分，直接显示总分结果。"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：根据社会参与1-5项得分加总得到的总分数，对应社会参与的分级结果。\n\n记录：根据第6题总分在本题各答案对应的区间，得到正确的分级结果。使用评估系统应用程序（APP），本项将自动显示分级结果。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}







#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    if ([groupId isEqualToString:@"shengHuoNL"]) {
        my_shengHuoNL=[NSString stringWithFormat:@"%ld",radio.tag-3000];
        [zongFen_dict setValue:my_shengHuoNL forKey:@"shengHuoNL"];
    }
    
    if ([groupId isEqualToString:@"gongZuoNL"]) {
        my_gongZuoNL=[NSString stringWithFormat:@"%ld",radio.tag-4000];
        [zongFen_dict setValue:my_gongZuoNL forKey:@"gongZuoNL"];
    }
    
    if ([groupId isEqualToString:@"shiJianKJ"]) {
        my_shiJianKJ=[NSString stringWithFormat:@"%ld",radio.tag-5000];
        [zongFen_dict setValue:my_shiJianKJ forKey:@"shiJianKJ"];
    }
    
    if ([groupId isEqualToString:@"renWuDX"]) {
        my_renWuDX=[NSString stringWithFormat:@"%ld",radio.tag-6000];
        [zongFen_dict setValue:my_renWuDX forKey:@"renWuDX"];
    }
    
    if ([groupId isEqualToString:@"sheHuiJW"]) {
        my_sheHuiJW=[NSString stringWithFormat:@"%ld",radio.tag-7000];
        [zongFen_dict setValue:my_sheHuiJW forKey:@"sheHuiJW"];
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
    
    sheHuiCYZF_Field.text=[NSString stringWithFormat:@"%d",zongFen];
}



#pragma mark - 更新分级
-(void)update_fenJi
{
    if (zongFen>=0 && zongFen<=2) {
        [fenJi_Button0 setChecked:YES];
        my_sheHuiCYFJ=@"0";
        
    } else if (zongFen>=3 && zongFen<=7) {
        [fenJi_Button1 setChecked:YES];
        my_sheHuiCYFJ=@"1";
        
    } else if (zongFen>=8 && zongFen<=13) {
        [fenJi_Button2 setChecked:YES];
        my_sheHuiCYFJ=@"2";
        
    } else if (zongFen>=14 && zongFen<=20) {
        [fenJi_Button3 setChecked:YES];
        my_sheHuiCYFJ=@"3";
    }
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_shengHuoNL]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“生活能力”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_gongZuoNL]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“工作能力”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_shiJianKJ]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选“时间／空间定向”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_renWuDX]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“人物定向”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_sheHuiJW]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择“社会交往能力”情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        //更新 社会参与
        [self update_SheHuiCY];
    }
    
}


//更新 社会参与
-(void)update_SheHuiCY
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"14" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    if (![PublicFunction isBlankString:my_shengHuoNL]) {
        [parameter setObject:my_shengHuoNL forKey:@"shengHuoNL"];
    }
    
    if (![PublicFunction isBlankString:my_gongZuoNL]) {
        [parameter setObject:my_gongZuoNL forKey:@"gongZuoNL"];
    }
    
    if (![PublicFunction isBlankString:my_shiJianKJ]) {
        [parameter setObject:my_shiJianKJ forKey:@"shiJianKJ"];
    }
    
    if (![PublicFunction isBlankString:my_renWuDX]) {
        [parameter setObject:my_renWuDX forKey:@"renWuDX"];
    }
    
    if (![PublicFunction isBlankString:my_sheHuiJW]) {
        [parameter setObject:my_sheHuiJW forKey:@"sheHuiJW"];
    }
    
    if (![PublicFunction isBlankString:my_sheHuiCYFJ]) {
        [parameter setObject:my_sheHuiCYFJ forKey:@"sheHuiCYFJ"];
    }
    
    if (![PublicFunction isBlankString:sheHuiCYZF_Field.text]) {
        [parameter setObject:sheHuiCYZF_Field.text forKey:@"sheHuiCYZF"];
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

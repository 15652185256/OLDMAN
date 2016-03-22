//
//  BuChongPGViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/22.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "BuChongPGViewController.h"
#import "BuChongPGModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "QRadioButton.h"//单选

@interface BuChongPGViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    NSString * my_laoNianCZ;//老年痴呆
    
    NSString * my_jingShenJB;//精神疾病
    
    NSString * my_dieDao;//跌倒
    
    NSString * my_yeShi;//噎食
    
    NSString * my_zouShi;//走失
    
    NSString * my_ziSha;//自杀
    
    NSArray * titleArray;//标题数组
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    BuChongPGModel * _buChongPGModel;//请求 数据
}
@property(nonatomic,retain)NSMutableArray * dataSourse;//数据源
@end

@implementation BuChongPGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    
    //设置导航
    [self createNav];
    
    //实列化 标题数组
    [self loadTitleArray];
}


//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _buChongPGModel=[[BuChongPGModel alloc]init];//请求 数据
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _buChongPGModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}

#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    titleArray=@[@"1. 老年痴呆",@"2. 精神疾病",@"3. 跌倒（近30天内）",@"4. 噎食",@"5. 走失（近30天内）",@"6. 自杀（近30天内）"];
    
    _dataSourse=[[NSMutableArray alloc]initWithCapacity:titleArray.count];
    for (int i=0; i<titleArray.count; i++) {
        NSArray * titleArr;
        switch (i) {
            case 0:
                titleArr=@[@"无",@"轻度",@"中度",@"重度"];
                break;
            case 1:
                titleArr=@[@"无",@"精神分裂症",@"双相情感障碍",@"偏执性精神障碍",@"分裂情感性障碍",@"癫痫所致精神障碍",@"精神发育迟滞伴发精神障碍"];
                break;
            case 2:
                titleArr=@[@"无",@"发生过1次",@"发生过2次",@"发生过3次及以上"];
                break;
            case 3:
                titleArr=@[@"无",@"发生过1次",@"发生过2次",@"发生过3次及以上"];
                break;
            case 4:
                titleArr=@[@"无",@"发生过1次",@"发生过2次",@"发生过3次及以上"];
                break;
            case 5:
                titleArr=@[@"无",@"发生过1次",@"发生过2次",@"发生过3次及以上"];
                break;
            default:
                break;
        }
        
        [_dataSourse addObject:titleArr];
    }
}

#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"15"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_buChongPGModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"补充评估信息";
    
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
        UILabel * title_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-15-55, 16) Font:Title_text_font Text:nil];
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
        UIButton * JieShao_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-30, CGRectGetMinY(title_Label.frame), 22, 22) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
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
                    [xuanXiang_Button getGroupId:@"laoNianCZ"];
                    xuanXiang_Button.tag=3000+i;
                    
                    if (![PublicFunction isBlankString:_buChongPGModel.laoNianCZ]) {
                        if ([_buChongPGModel.laoNianCZ intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 1:
                {
                    [xuanXiang_Button getGroupId:@"jingShenJB"];
                    xuanXiang_Button.tag=4000+i;
                    
                    if (![PublicFunction isBlankString:_buChongPGModel.jingShenJB]) {
                        if ([_buChongPGModel.jingShenJB intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    [xuanXiang_Button getGroupId:@"dieDao"];
                    xuanXiang_Button.tag=5000+i;
                    
                    if (![PublicFunction isBlankString:_buChongPGModel.dieDao]) {
                        if ([_buChongPGModel.dieDao intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    [xuanXiang_Button getGroupId:@"yeShi"];
                    xuanXiang_Button.tag=6000+i;
                    
                    if (![PublicFunction isBlankString:_buChongPGModel.yeShi]) {
                        if ([_buChongPGModel.yeShi intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 4:
                {
                    [xuanXiang_Button getGroupId:@"zouShi"];
                    xuanXiang_Button.tag=7000+i;
                    
                    if (![PublicFunction isBlankString:_buChongPGModel.zouShi]) {
                        if ([_buChongPGModel.zouShi intValue]==i) {
                            [xuanXiang_Button setChecked:YES];
                        }
                    }
                }
                    break;
                    
                case 5:
                {
                    [xuanXiang_Button getGroupId:@"ziSha"];
                    xuanXiang_Button.tag=8000+i;
                    
                    if (![PublicFunction isBlankString:_buChongPGModel.ziSha]) {
                        if ([_buChongPGModel.ziSha intValue]==i) {
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
    
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, RootScrollView_contentSize);
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须依据申请人提供的索取医院证明、病历、处方等证明文件，结合询问或查看到的实际情况记录。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：须依据申请人提供的索取医院证明、病历、处方等证明文件，结合询问或查看到的实际情况记录。"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：跌倒指患者突发的、不自主的、非故意的体位改变，倒在地上活更低的平面上。\n\n方法：通过与申请人/代理人沟通，或查看就诊记录，获取尽可能准确的信息。"];
            
            [modal show];
        }
            break;
            
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：噎食是指老人在进食时食物卡在咽喉部或食管内造成器官的压迫。噎食时由于气管收到了压迫会出现通气障碍，甚至会导致老人窒息死亡。\n\n方法：通过与申请人/代理人沟通，或查看就诊记录，获取尽可能准确的信息。"];
            
            [modal show];
        }
            break;
            
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：通过与申请人/代理人沟通，或查看就诊记录，获取尽可能准确的信息。"];
            
            [modal show];
        }
            break;
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"方法：通过与申请人/代理人沟通，或查看就诊记录，获取尽可能准确的信息。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
}







#pragma mark - 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    if ([groupId isEqualToString:@"laoNianCZ"]) {
        my_laoNianCZ=[NSString stringWithFormat:@"%ld",radio.tag-3000];
    }
    
    if ([groupId isEqualToString:@"jingShenJB"]) {
        my_jingShenJB=[NSString stringWithFormat:@"%ld",radio.tag-4000];
    }
    
    if ([groupId isEqualToString:@"dieDao"]) {
        my_dieDao=[NSString stringWithFormat:@"%ld",radio.tag-5000];
    }
    
    if ([groupId isEqualToString:@"yeShi"]) {
        my_yeShi=[NSString stringWithFormat:@"%ld",radio.tag-6000];
    }
    
    if ([groupId isEqualToString:@"zouShi"]) {
        my_zouShi=[NSString stringWithFormat:@"%ld",radio.tag-7000];
    }
    
    if ([groupId isEqualToString:@"ziSha"]) {
        my_ziSha=[NSString stringWithFormat:@"%ld",radio.tag-8000];
    }
    
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_laoNianCZ]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择老年痴呆情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_jingShenJB]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择精神疾病情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_dieDao]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择跌倒情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_yeShi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择噎食情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_zouShi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择走失情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_ziSha]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请选择自杀情况" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        
        //跟新补充评估信息
        [self update_BuChongPG];
    }
        
    
}


//跟新补充评估信息
-(void)update_BuChongPG
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"15" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    if (![PublicFunction isBlankString:my_laoNianCZ]) {
        [parameter setObject:my_laoNianCZ forKey:@"laoNianCZ"];
    }
    
    if (![PublicFunction isBlankString:my_jingShenJB]) {
        [parameter setObject:my_jingShenJB forKey:@"jingShenJB"];
    }
    
    if (![PublicFunction isBlankString:my_dieDao]) {
        [parameter setObject:my_dieDao forKey:@"dieDao"];
    }
    
    if (![PublicFunction isBlankString:my_yeShi]) {
        [parameter setObject:my_yeShi forKey:@"yeShi"];
    }
    
    if (![PublicFunction isBlankString:my_zouShi]) {
        [parameter setObject:my_zouShi forKey:@"zouShi"];
    }
    
    if (![PublicFunction isBlankString:my_ziSha]) {
        [parameter setObject:my_ziSha forKey:@"ziSha"];
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

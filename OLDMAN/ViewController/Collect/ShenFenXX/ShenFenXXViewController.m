//
//  ShenFenXXViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/18.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "ShenFenXXViewController.h"
#import "ShenFenXXModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

@interface ShenFenXXViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    UITextField * xingMing_Field;//姓名
    
    //UITextField * cengYongM_Field;//曾用名
    
    UITextField * shenFenZH_Field;//身份证件号
    
    UITextField * sheHuiBZ_Field;//社会保障卡
    
    UITextField * canJiJR_Field;//残疾军人证
    
    UITextField * canJiZ_Field;//残疾证
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    ShenFenXXModel * _shenFenXXModel;//数据源
}
@end

@implementation ShenFenXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //设置导航
    [self createNav];
    
    
}

//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _shenFenXXModel=[[ShenFenXXModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _shenFenXXModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 请求数据
-(void)loadData
{
    NSDictionary * select_parameter = @{@"shenFenZJ":self.shenFenZJ};
    
    [KVNProgress show];
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getUserInfoHttp WithParameter:select_parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [_shenFenXXModel setValuesForKeysWithDictionary:returnValue[@"data"]];
            }
            
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误代码%@",returnValue[@"code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
        //设置页面
        [self createView];
        
    } WithErrorCodeBlock:^(id errorCode) {
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
    self.navigationItem.title = @"身份信息";
    
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
    
    
    //姓名  标题
    UILabel * xingMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 30, 44+Title_text_font, Title_text_font) Font:Title_text_font Text:@"1. 姓名"];
    [RootScrollView addSubview:xingMing_Label];
    xingMing_Label.textColor=Title_text_color;
    
    //姓名 签字框
    xingMing_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(xingMing_Label.frame)+Title_Field_WH, CGRectGetMinY(xingMing_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-xingMing_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    xingMing_Field.textColor=Field_text_color;
    [RootScrollView addSubview:xingMing_Field];
    xingMing_Field.delegate=self;
    xingMing_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_shenFenXXModel.xingMing]) {
        xingMing_Field.text=_shenFenXXModel.xingMing;
    }
    
    //姓名 介绍
    UIButton * xingMing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(xingMing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:xingMing_Button];
    xingMing_Button.tag=90000;
    
    
    
    //身份证件号
    UILabel * shenFenZH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(xingMing_Field.frame)+20, 44+Title_text_font*4, Title_text_font) Font:Title_text_font Text:@"2. 身份证件号"];
    [RootScrollView addSubview:shenFenZH_Label];
    shenFenZH_Label.textColor=Title_text_color;
    
    //身份证件号 签字框
    shenFenZH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(shenFenZH_Label.frame)+Title_Field_WH, CGRectGetMinY(shenFenZH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-shenFenZH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    shenFenZH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:shenFenZH_Field];
    shenFenZH_Field.delegate=self;
    shenFenZH_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_shenFenXXModel.shenFenZJ]) {
        shenFenZH_Field.text=_shenFenXXModel.shenFenZJ;
    }
    
    //身份证件号 介绍
    UIButton * shenFenZH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(shenFenZH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:shenFenZH_Button];
    shenFenZH_Button.tag=90001;
    
    
    
    
    
    //社会保障卡 标题
    UILabel * sheHuiBZ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(shenFenZH_Field.frame)+20, 44+Title_text_font*4, Title_text_font) Font:Title_text_font Text:@"3. 医保卡号"];
    [RootScrollView addSubview:sheHuiBZ_Label];
    sheHuiBZ_Label.textColor=Title_text_color;
    
    //社会保障卡 签字框
    sheHuiBZ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(sheHuiBZ_Label.frame)+Title_Field_WH, CGRectGetMinY(sheHuiBZ_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-sheHuiBZ_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    sheHuiBZ_Field.textColor=Field_text_color;
    [RootScrollView addSubview:sheHuiBZ_Field];
    sheHuiBZ_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_shenFenXXModel.yiBaoKH]) {
        sheHuiBZ_Field.text=_shenFenXXModel.yiBaoKH;
    }
    
    //社会保障卡 介绍
    UIButton * sheHuiBZ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(sheHuiBZ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:sheHuiBZ_Button];
    sheHuiBZ_Button.tag=90002;
    
    
    
    
    
    
    //残疾军人证 标题
    UILabel * canJiJR_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(sheHuiBZ_Field.frame)+20, 44+Title_text_font*4, Title_text_font) Font:Title_text_font Text:@"4. 残疾军人证"];
    [RootScrollView addSubview:canJiJR_Label];
    canJiJR_Label.textColor=Title_text_color;
    
    //残疾军人证 签字框
    canJiJR_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(canJiJR_Label.frame)+Title_Field_WH, CGRectGetMinY(canJiJR_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-canJiJR_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    canJiJR_Field.textColor=Field_text_color;
    [RootScrollView addSubview:canJiJR_Field];
    canJiJR_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_shenFenXXModel.canJiJR]) {
        canJiJR_Field.text=_shenFenXXModel.canJiJR;
    }
    
    //残疾军人证 介绍
    UIButton * canJiJR_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(canJiJR_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:canJiJR_Button];
    canJiJR_Button.tag=90003;
    
    
    
    
    
    
    //残疾证
    UILabel * canJiZ_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(canJiJR_Field.frame)+20, 44+Title_text_font*4, Title_text_font) Font:Title_text_font Text:@"5. 残疾人证"];
    [RootScrollView addSubview:canJiZ_Label];
    canJiZ_Label.textColor=Title_text_color;
    
    //残疾证 签字框
    canJiZ_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(canJiZ_Label.frame)+Title_Field_WH, CGRectGetMinY(canJiZ_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-canJiZ_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    canJiZ_Field.textColor=Field_text_color;
    [RootScrollView addSubview:canJiZ_Field];
    canJiZ_Field.delegate=self;
    
    if (![PublicFunction isBlankString:_shenFenXXModel.canJiRZ]) {
        canJiZ_Field.text=_shenFenXXModel.canJiRZ;
    }
    
    //残疾证 介绍
    UIButton * canJiZ_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(canJiZ_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:canJiZ_Button];
    canJiZ_Button.tag=90004;
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(canJiZ_Field.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;


    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.collection intValue]==0 || [self.collection intValue]==1 || [self.collection intValue]==5 || [self.collection intValue]==6) {
            //保存
            Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
            [self.view addSubview:Save_Button];
            [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
            Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
            [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
            
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(canJiZ_Field.frame)+20+Tabbar_HE);
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
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"定义：申请的合法姓名，以及曾经使用过的名字（如有）\n\n记录：姓名必须和被访者身份证上的姓名保持一致，须用汉字填写，不得简写，不得使用其他文字或用文字符合代替文字。"];
            
            [modal show];
        }
            break;
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：记录申请人的身份识别号码。\n\n方法：征得申请人和照护者允许，查看申请人本人的身份证件（或任何含有身份证号码的官方证明、文件）。如果无法获得本项信息，请及时与评估机构负责人联系，请求指示。\n\n记录：身份证号为必须和被访者身份证上的身份证号保持一致，填写时必须从左向右依次填写，每个数字或字母占一格。填写完毕后，须从左向右认真校对1遍，确保填写准确无误。"];
            
            [modal show];
        }
            break;
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：号码必须和原证件号码保持一致，填写时须从左向右依次填写，每个数字或字母占一格，填写完毕后，须从左向右认真校对1遍，确保填写准确无误。如果申请人没有医保卡，则此项无须操作。"];
            
            [modal show];
        }
            break;
        case 90003:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：号码必须和原证件号码保持一致，填写时须从左向右依次填写，每个数字或字母占一格，填写完毕后，须从左向右认真校对1遍，确保填写准确无误。如果申请人没有残疾军人证，则此项无须操作。"];
            
            [modal show];
        }
            break;
        case 90004:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"记录：号码必须和原证件号码保持一致，填写时须从左向右依次填写，每个数字或字母占一格，填写完毕后，须从左向右认真校对1遍，确保填写准确无误。如果申请人没有残疾人证，则此项无须操作。"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark - 保存
-(void)Save_Button_Click
{
    if (![PublicFunction isBlankString:sheHuiBZ_Field.text] && ![PublicFunction validateNumber:sheHuiBZ_Field.text]) {
#pragma mark - 医保卡号
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入12位“医保卡号”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:sheHuiBZ_Field.text] && sheHuiBZ_Field.text.length!=12) {
#pragma mark - 医保卡号
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入12位“医保卡号”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:canJiJR_Field.text] && ![PublicFunction validateNumber:canJiJR_Field.text]) {
#pragma mark - 残疾军人证
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确“残疾军人证”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if (![PublicFunction isBlankString:canJiZ_Field.text] &&![PublicFunction validateNumber:canJiZ_Field.text]) {
#pragma mark - 残疾人证
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确“残疾人证”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        //更新身份信息
        [self update_ShenFenXX];
    }
    
    
    
    
    
}


//更新身份信息
-(void)update_ShenFenXX
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:sheHuiBZ_Field.text forKey:@"yiBaoKH"];
    [parameter setObject:canJiJR_Field.text forKey:@"canJiJR"];
    [parameter setObject:canJiZ_Field.text forKey:@"canJiRZ"];
    
    
    
    [KVNProgress show];
    
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:updateUserInfoHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
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

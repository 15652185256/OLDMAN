//
//  AdviseTeShuFWViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/11.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "AdviseTeShuFWViewController.h"
#import "TeShuFWModel.h"
#import "CollectViewModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动
@interface AdviseTeShuFWViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存
    
    
    UITextField * TeShuFW_Field1;//特殊服务需求 1
    
    UITextField * TeShuFW_Field2;//特殊服务需求 2
    
    UITextField * TeShuFW_Field3;//特殊服务需求 3
    
    UITextField * TeShuFW_Field4;//特殊服务需求 4
    
    UITextField * TeShuFW_Field5;//特殊服务需求 5
    
    UITextField * TeShuFW_Field6;//特殊服务需求 6
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    TeShuFWModel * _teShuFWModel;//数据源
}
@end

@implementation AdviseTeShuFWViewController

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
    _teShuFWModel=[[TeShuFWModel alloc]init];//数据源
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _teShuFWModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    [Save_Button removeFromSuperview];
}


#pragma mark 请求数据
-(void)loadData
{
    CollectViewModel * _collectViewModel=[[CollectViewModel alloc]init];
    
    [_collectViewModel SelectAssessmentResult:self.shenFenZJ tableFlag:@"36"];
    
    [KVNProgress show];
    
    [_collectViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSDictionary class]]) {

                [_teShuFWModel setValuesForKeysWithDictionary:returnValue[@"data"]];
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
    self.navigationItem.title = @"特殊服务需求";
    
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



#pragma mark 设置页面
-(void)createView
{
    RootScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    [self.view addSubview:RootScrollView];
    RootScrollView.backgroundColor=View_Background_Color;
    RootScrollView.delegate=self;
    
    
    
    
    //特殊服务需求 1
    UILabel * TeShuFW_Label1=[ZCControl createLabelWithFrame:CGRectMake(15, 30, 44+Title_text_font*5, Title_text_font) Font:Title_text_font Text:@"特殊服务需求1"];
    [RootScrollView addSubview:TeShuFW_Label1];
    TeShuFW_Label1.textColor=Title_text_color;
    
    //特殊服务需求 签字框
    TeShuFW_Field1=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(TeShuFW_Label1.frame), CGRectGetMinY(TeShuFW_Label1.frame)-(Field_HE-Title_text_font)/2, WIDTH-TeShuFW_Label1.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    TeShuFW_Field1.textColor=Field_text_color;
    [RootScrollView addSubview:TeShuFW_Field1];
    TeShuFW_Field1.delegate=self;
    
    if (![PublicFunction isBlankString:_teShuFWModel.teShuFW1]) {
        TeShuFW_Field1.text=_teShuFWModel.teShuFW1;
    }
    
    //特殊服务需求 介绍
    UIButton * TeShuFW_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(TeShuFW_Label1.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:TeShuFW_Button];
    TeShuFW_Button.tag=90000;
    
    
    
    
    
    
    //特殊服务需求 2
    UILabel * TeShuFW_Label2=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(TeShuFW_Field1.frame)+20, 44+Title_text_font*5, Title_text_font) Font:Title_text_font Text:@"特殊服务需求2"];
    [RootScrollView addSubview:TeShuFW_Label2];
    TeShuFW_Label2.textColor=Title_text_color;
    
    //特殊服务需求 2 签字框
    TeShuFW_Field2=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(TeShuFW_Label2.frame), CGRectGetMinY(TeShuFW_Label2.frame)-(Field_HE-Title_text_font)/2, WIDTH-TeShuFW_Label2.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    TeShuFW_Field2.textColor=Field_text_color;
    [RootScrollView addSubview:TeShuFW_Field2];
    TeShuFW_Field2.delegate=self;
    
    if (![PublicFunction isBlankString:_teShuFWModel.teShuFW2]) {
        TeShuFW_Field2.text=_teShuFWModel.teShuFW2;
    }
    
    
    
    
    
    
    //特殊服务需求 3
    UILabel * TeShuFW_Label3=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(TeShuFW_Field2.frame)+20, 44+Title_text_font*5, Title_text_font) Font:Title_text_font Text:@"特殊服务需求3"];
    [RootScrollView addSubview:TeShuFW_Label3];
    TeShuFW_Label3.textColor=Title_text_color;
    
    //特殊服务需求 3 签字框
    TeShuFW_Field3=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(TeShuFW_Label3.frame), CGRectGetMinY(TeShuFW_Label3.frame)-(Field_HE-Title_text_font)/2, WIDTH-TeShuFW_Label3.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    TeShuFW_Field3.textColor=Field_text_color;
    [RootScrollView addSubview:TeShuFW_Field3];
    TeShuFW_Field3.delegate=self;
    
    if (![PublicFunction isBlankString:_teShuFWModel.teShuFW3]) {
        TeShuFW_Field3.text=_teShuFWModel.teShuFW3;
    }
    
    
    
    
    
    //特殊服务需求 4
    UILabel * TeShuFW_Label4=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(TeShuFW_Field3.frame)+20, 44+Title_text_font*5, Title_text_font) Font:Title_text_font Text:@"特殊服务需求4"];
    [RootScrollView addSubview:TeShuFW_Label4];
    TeShuFW_Label4.textColor=Title_text_color;
    
    //特殊服务需求 4 签字框
    TeShuFW_Field4=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(TeShuFW_Label4.frame), CGRectGetMinY(TeShuFW_Label4.frame)-(Field_HE-Title_text_font)/2, WIDTH-TeShuFW_Label4.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    TeShuFW_Field4.textColor=Field_text_color;
    [RootScrollView addSubview:TeShuFW_Field4];
    TeShuFW_Field4.delegate=self;
    
    if (![PublicFunction isBlankString:_teShuFWModel.teShuFW4]) {
        TeShuFW_Field4.text=_teShuFWModel.teShuFW4;
    }
    
    
    
    
    
    //特殊服务需求 5
    UILabel * TeShuFW_Label5=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(TeShuFW_Field4.frame)+20, 44+Title_text_font*5, Title_text_font) Font:Title_text_font Text:@"特殊服务需求5"];
    [RootScrollView addSubview:TeShuFW_Label5];
    TeShuFW_Label5.textColor=Title_text_color;
    
    //特殊服务需求 5 签字框
    TeShuFW_Field5=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(TeShuFW_Label5.frame), CGRectGetMinY(TeShuFW_Label5.frame)-(Field_HE-Title_text_font)/2, WIDTH-TeShuFW_Label5.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    TeShuFW_Field5.textColor=Field_text_color;
    [RootScrollView addSubview:TeShuFW_Field5];
    TeShuFW_Field5.delegate=self;
    
    if (![PublicFunction isBlankString:_teShuFWModel.teShuFW4]) {
        TeShuFW_Field5.text=_teShuFWModel.teShuFW4;
    }
    
    
    
    
    //特殊服务需求 6
    UILabel * TeShuFW_Label6=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(TeShuFW_Field5.frame)+20, 44+Title_text_font*5, Title_text_font) Font:Title_text_font Text:@"特殊服务需求6"];
    [RootScrollView addSubview:TeShuFW_Label6];
    TeShuFW_Label6.textColor=Title_text_color;
    
    //特殊服务需求 6 签字框
    TeShuFW_Field6=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(TeShuFW_Label6.frame), CGRectGetMinY(TeShuFW_Label6.frame)-(Field_HE-Title_text_font)/2, WIDTH-TeShuFW_Label6.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    TeShuFW_Field6.textColor=Field_text_color;
    [RootScrollView addSubview:TeShuFW_Field6];
    TeShuFW_Field6.delegate=self;
    
    if (![PublicFunction isBlankString:_teShuFWModel.teShuFW6]) {
        TeShuFW_Field6.text=_teShuFWModel.teShuFW6;
    }
    
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(TeShuFW_Field6.frame)+20);
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
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(TeShuFW_Field6.frame)+20+Tabbar_HE);
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
            
        default:
            break;
    }
}




#pragma mark - 保存
-(void)Save_Button_Click
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    [parameter setObject:@"36" forKey:@"tableFlag"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    
#pragma mark - 特殊服务需求
    
    if (![PublicFunction isBlankString:TeShuFW_Field1.text]) {
        [parameter setObject:TeShuFW_Field1.text forKey:@"teShuFW1"];
    }
    
    if (![PublicFunction isBlankString:TeShuFW_Field2.text]) {
        [parameter setObject:TeShuFW_Field2.text forKey:@"teShuFW2"];
    }
    
    if (![PublicFunction isBlankString:TeShuFW_Field3.text]) {
        [parameter setObject:TeShuFW_Field3.text forKey:@"teShuFW3"];
    }
    
    if (![PublicFunction isBlankString:TeShuFW_Field4.text]) {
        [parameter setObject:TeShuFW_Field4.text forKey:@"teShuFW4"];
    }
    
    if (![PublicFunction isBlankString:TeShuFW_Field5.text]) {
        [parameter setObject:TeShuFW_Field5.text forKey:@"teShuFW5"];
    }
    
    if (![PublicFunction isBlankString:TeShuFW_Field6.text]) {
        [parameter setObject:TeShuFW_Field6.text forKey:@"teShuFW6"];
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

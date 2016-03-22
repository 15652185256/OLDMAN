//
//  YongHuQZViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/5.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "YongHuQZViewController.h"
#import "ShenFenXXModel.h"

#import "PopSignUtil.h"//写字框

#import "CDPMonitorKeyboard.h"//键盘移动

#import "RNBlurModalView.h"//弹出框

#import "QCheckBox.h"//复选

@interface YongHuQZViewController ()<UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    UIButton * Save_Button;//保存

    NSArray * Title_Array;//声明
    
    
    float nav_height;//导航高度
    
    NSString * my_xinXi;//信息
    
    NSString * my_tongZhi;//通知
    
    NSString * my_tuPian;//图片
    
    NSString * qianMing;//签名
    
    
    
    UIButton * shenQingR_button;//申请人/代理人签字
    
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    ShenFenXXModel * _shenFenXXModel;//数据源

}
@end

@implementation YongHuQZViewController

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
    my_xinXi=@"";
    my_tongZhi=@"";
    my_tuPian=@"";
    
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


#pragma mark 实列化 标题数组
-(void)loadTitleArray
{
    //声明
    Title_Array=@[@"本人承诺所提供的信息真实、准确",@"本人同意使用本评估表中的名字、地址、电话等信息用于通知等事项",@"本人同意使用在评估及相关活动中所拍摄的图片和影像。"];
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
    nav_height=64;
    
    //背景
    UIView * navView=[ZCControl createView:CGRectMake(0, 0, WIDTH, nav_height)];
    [self.view addSubview:navView];
    navView.backgroundColor=Nav_Tabbar_backgroundColor;
    
    //返回按钮
    UIButton * returnButton=[ZCControl createButtonWithFrame:CGRectMake(15, 20+(44-18)/2, 100, 18) Text:nil ImageName:@"reg_return@2x.png" bgImageName:nil Target:self Method:@selector(returnButtonClick)];
    [navView addSubview:returnButton];
    returnButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 100/10*8);
    
    //标题
    UILabel * titleLabel=[ZCControl createLabelWithFrame:CGRectMake(15, 20, WIDTH-30, 44) Font:Title_text_font Text:@"服务协议"];
    titleLabel.font=[UIFont boldSystemFontOfSize:Title_text_font];
    [navView addSubview:titleLabel];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=CREATECOLOR(255, 255, 255, 1);
    
}

//返回
-(void)returnButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark 设置页面
-(void)createView
{
    RootScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, nav_height, WIDTH, HEIGHT-64)];
    [self.view addSubview:RootScrollView];
    RootScrollView.backgroundColor=View_Background_Color;
    RootScrollView.delegate=self;
    
    
    //声明 板块
    UIView * root_View=[ZCControl createView:CGRectMake(0, 20, WIDTH, 40)];
    [RootScrollView addSubview:root_View];
    
    //声明  标题
    UILabel * ShengMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-40, Title_text_font) Font:Title_text_font Text:@"声明"];
    [root_View addSubview:ShengMing_Label];
    ShengMing_Label.textColor=Title_text_color;
    
    
    //声明 介绍
    UIButton * xingMing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(ShengMing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [root_View addSubview:xingMing_Button];
    xingMing_Button.tag=90000;
    
    
    
    
    //起始高度
    float root_View_frame_origin_y=CGRectGetMaxY(ShengMing_Label.frame)+Q_ICON_HE;
    
    for (int i=0; i<Title_Array.count; i++) {
        //选框
        //选框
        QCheckBox * xuanXiang_Check = [[QCheckBox alloc] initWithDelegate:self];
        xuanXiang_Check.frame = CGRectMake(15, root_View_frame_origin_y, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
        [root_View addSubview:xuanXiang_Check];
        [xuanXiang_Check setChecked:NO];
        
        xuanXiang_Check.tag=3000+i;
        
        if (![PublicFunction isBlankString:_shenFenXXModel.agree1] && [_shenFenXXModel.agree1 intValue]==1) {
            if (i==0) {
                [xuanXiang_Check setChecked:YES];
            }
        }
        
        if (![PublicFunction isBlankString:_shenFenXXModel.agree2] && [_shenFenXXModel.agree2 intValue]==1) {
            if (i==1) {
                [xuanXiang_Check setChecked:YES];
            }
        }
        
        if (![PublicFunction isBlankString:_shenFenXXModel.agree3] && [_shenFenXXModel.agree3 intValue]==1) {
            if (i==2) {
                [xuanXiang_Check setChecked:YES];
            }
        }
        
        
        //选项标题
        UILabel * xuanXiang_Label=[ZCControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xuanXiang_Check.frame)+8, CGRectGetMinY(xuanXiang_Check.frame), WIDTH-60, Q_CHECK_ICON_WH) Font:Answer_text_font Text:nil];
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
    
    root_View.frame = CGRectMake(0, 20, WIDTH, root_View_frame_origin_y);
    
    
    
    
    
    //申请人/代理人签字
    UILabel * shenQingR_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(root_View.frame)+10, WIDTH-40, Title_text_font) Font:Title_text_font Text:@"申请人/代理人签字"];
    [RootScrollView addSubview:shenQingR_Label];
    shenQingR_Label.textColor=Title_text_color;
    
    
    //申请人/代理人签字 签字框
    shenQingR_button=[ZCControl createButtonWithFrame:CGRectMake(5, CGRectGetMaxY(shenQingR_Label.frame)+10, WIDTH-10, (WIDTH-10)/5*3) Text:nil ImageName:nil bgImageName:nil Target:self Method:@selector(shenQingR_button_click)];
    [RootScrollView addSubview:shenQingR_button];
    shenQingR_button.layer.masksToBounds=YES;
    //[shenQingR_button setBackgroundColor:CREATECOLOR(101, 129, 90, 1)];
    [shenQingR_button setBackgroundColor:[UIColor whiteColor]];
    shenQingR_button.layer.cornerRadius=5.0;
    shenQingR_button.layer.borderWidth=0.1;
    
    if (![PublicFunction isBlankString:_shenFenXXModel.qianMing]) {
        
        qianMing=_shenFenXXModel.qianMing;
        
        NSData * ImageData=[[NSData alloc]initWithBase64EncodedString:_shenFenXXModel.qianMing options:1];
        
        UIImage * Image = [UIImage imageWithData:ImageData];
        
        //[shenQingR_button setImage:Image forState:UIControlStateNormal];
        
        [shenQingR_button setBackgroundImage:Image forState:UIControlStateNormal];
        
        //NSLog(@"%ld",qianMing.length/1024);
    }
    
    //申请人/代理人签字 介绍
    UIButton * JieShao_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(shenQingR_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:JieShao_Button];
    JieShao_Button.tag=90001;
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(shenQingR_button.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:idenity] intValue]==1) {
        
        if ([self.collection intValue]==0 || [self.collection intValue]==1 || [self.collection intValue]==5 || [self.collection intValue]==6) {
            //保存
            Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
            [self.view addSubview:Save_Button];
            [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
            Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
            [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];
            
            //设置滚动范围
            RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(shenQingR_button.frame)+20+Tabbar_HE);
        }
    }
}

#pragma mark - 签字
-(void)shenQingR_button_click
{
    [PopSignUtil getSignWithVC:self withOk:^(UIImage * image) {
        
        NSData * data = UIImageJPEGRepresentation(image, 0.1);
        
        qianMing = [data base64EncodedStringWithOptions:1];
        
        //NSLog(@"WIDTH:%f,qianMing:%ld",WIDTH,qianMing.length);
        
        [shenQingR_button setImage:nil forState:UIControlStateNormal];
        
        [shenQingR_button setBackgroundImage:image forState:UIControlStateNormal];
        
        [PopSignUtil closePop];
    } withCancel:^{
        [PopSignUtil closePop];
    }];
}



#pragma mark - 介绍
-(void)JieShao_Button_Click:(UIButton*)button
{
    switch (button.tag) {
        case 90000:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"目的：确保评估中所获取的信息质量，并对评估中获取的个人信息、影像资料的使用进行授权。\n\n定义：代理人特指协助申请人（被访者）完成本次调查工作的、与申请人有亲属关系的在场人员。\n\n记录：申请人（被访者）或代理人确认（√）并签字。"];
            
            [modal show];
        }
            break;
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
        default:
            break;
    }
    
    
}



#pragma mark - 复选
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    
    switch (checkbox.tag-3000) {
        case 0:
            if (checked==1) {
                my_xinXi=@"1";
            } else{
                my_xinXi=@"";
            }
            break;
            
        case 1:
            if (checked==1) {
                my_tongZhi=@"1";
            } else{
                my_tongZhi=@"";
            }
            break;
            
        case 2:
            if (checked==1) {
                my_tuPian=@"1";
            } else{
                my_tuPian=@"";
            }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:my_xinXi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请承诺提供“真实信息”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else if ([PublicFunction isBlankString:my_tongZhi]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请同意使用“联系方式”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } else if ([PublicFunction isBlankString:qianMing]) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请填写“签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if (WIDTH==320  && qianMing.length<4500) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if (WIDTH==375  && qianMing.length<5000) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if (WIDTH==414  && qianMing.length<6200) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请正确填写“签名”" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else {
        //更新 服务协议
        [self update_YongHuQZ];
    }
}


//更新 服务协议
-(void)update_YongHuQZ
{
    NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
    
    [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
    
    if (![PublicFunction isBlankString:my_xinXi]) {
        [parameter setObject:my_xinXi forKey:@"agree1"];
    }
    
    if (![PublicFunction isBlankString:my_tongZhi]) {
        [parameter setObject:my_tongZhi forKey:@"agree2"];
    }
    
    if (![PublicFunction isBlankString:my_tuPian]) {
        [parameter setObject:my_tuPian forKey:@"agree3"];
    }
    
    if (![PublicFunction isBlankString:qianMing]) {
        [parameter setObject:qianMing forKey:@"qianMing"];
    }
    
    
    [KVNProgress show];
    
    
    //发送请求
    [NetRequestClass NetRequestLoginRegWithRequestURL:updateUserInfoHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        [KVNProgress dismiss];
        
        //NSLog(@"%@",returnValue);
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] intValue]==1) {
                
                [self dismissViewControllerAnimated:YES completion:^{}];
                
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

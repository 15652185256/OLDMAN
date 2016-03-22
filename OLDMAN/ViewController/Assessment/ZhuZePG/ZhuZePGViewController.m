//
//  ZhuZePGViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 15/12/22.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "ZhuZePGViewController.h"
#import "ZhuZePGModel.h"

#import "RNBlurModalView.h"//弹出框

#import "CDPMonitorKeyboard.h"//键盘移动

@interface ZhuZePGViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView * RootScrollView;//主页面
    
    
    UITextField * xingMing_Field;// 姓名
    
    UITextField * suoShuJG_Field;// 所属机构
    
    UITextField * juZhuSheng_Field;//居住 省
    
    UITextField * juZhuAddress_Field;//居住 地址
    
    UITextField * zhuZhaiDH_Field;//居住电话
    
    UITextField * yiDongDH_Field;//移动电话
    
    UITextField * youZhengBM_Field;//邮政编码
    
    UITextField * dianZiYX_Field;//电子邮箱
    
    
    
    float RootScrollView_contentOffset_y;//ScrollView 滑动距离
    
    ZhuZePGModel * _zhuZeModel;//初审 信息
}

@end

@implementation ZhuZePGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=View_Background_Color;
    
    //设置导航
    [self createNav];
    
    //请求数据
    [self loadData];
}


//刷新
-(void)viewWillAppear:(BOOL)animated
{
    _zhuZeModel=[[ZhuZePGModel alloc]init];//初审 信息
    //请求数据
    [self loadData];
}
//释放
-(void)viewDidDisappear:(BOOL)animated
{
    _zhuZeModel=nil;
    
    [RootScrollView removeFromSuperview];
    
    RootScrollView=nil;
}

#pragma mark 请求数据
-(void)loadData
{
    NSDictionary * parameter = @{@"shenFenZJ":self.shenFenZJ};
    
    [KVNProgress show];
    
    [NetRequestClass NetRequestLoginRegWithRequestURL:getServiceUserHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        //NSLog(@"%@",returnValue);
        
        [KVNProgress dismiss];
        
        if ([returnValue[@"success"] intValue]==1) {
            
            if ([returnValue[@"data"] isKindOfClass:[NSArray class]]) {
                
                for (int i=0; i<[returnValue[@"data"] count]; i++) {
                    
                    NSDictionary * Dict=returnValue[@"data"][i];
                    
                    NSString * IDENTITY=[Dict objectForKey:@"IDENTITY"];
                    
                    if([IDENTITY intValue]==2) {
                        
                        [_zhuZeModel setValuesForKeysWithDictionary:Dict];
                    }
                }
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
    self.navigationItem.title = @"主责评估员信息";
    
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
    
    
    
    
    //姓名 标题
    UILabel * xingMing_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 30, 44+Title_text_font, Title_text_font) Font:Title_text_font Text:@"1. 姓名"];
    [RootScrollView addSubview:xingMing_Label];
    xingMing_Label.textColor=Title_text_color;
    
    //姓名 签字框
    xingMing_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(xingMing_Label.frame)+Title_Field_WH, CGRectGetMinY(xingMing_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-xingMing_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    xingMing_Field.textColor=Field_text_color;
    [RootScrollView addSubview:xingMing_Field];
    xingMing_Field.delegate=self;
    xingMing_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.DOC_NAME]) {
        xingMing_Field.text=_zhuZeModel.DOC_NAME;
    }
    
    
    //姓名 介绍
    UIButton * xingMing_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(xingMing_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:xingMing_Button];
    xingMing_Button.tag=90000;
    
    
    
    
    //所属机构 标题
    UILabel * suoShuJG_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(xingMing_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"2. 所属机构"];
    [RootScrollView addSubview:suoShuJG_Label];
    suoShuJG_Label.textColor=Title_text_color;
    
    //所属机构 签字框
    suoShuJG_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(suoShuJG_Label.frame)+Title_Field_WH, CGRectGetMinY(suoShuJG_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-suoShuJG_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    suoShuJG_Field.textColor=Field_text_color;
    [RootScrollView addSubview:suoShuJG_Field];
    suoShuJG_Field.delegate=self;
    suoShuJG_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.ORG_NAME]) {
        suoShuJG_Field.text=_zhuZeModel.ORG_NAME;
    }
    
    
    //所属机构 介绍
    UIButton * suoShuJG_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(suoShuJG_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:suoShuJG_Button];
    suoShuJG_Button.tag=90001;
    
    
    
    //居住 详细
    UILabel * juZhuAddress_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(suoShuJG_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"3. 居住地址"];
    [RootScrollView addSubview:juZhuAddress_Label];
    juZhuAddress_Label.textColor=Title_text_color;
    
    //居住 详细 签字框
    juZhuAddress_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(juZhuAddress_Label.frame)+Title_Field_WH, CGRectGetMinY(juZhuAddress_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-juZhuAddress_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    juZhuAddress_Field.textColor=Field_text_color;
    [RootScrollView addSubview:juZhuAddress_Field];
    juZhuAddress_Field.delegate=self;
    juZhuAddress_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.ADDRESS]) {
        juZhuAddress_Field.text=_zhuZeModel.ADDRESS;
    }
    
    
    
    //居住 详细 介绍
    UIButton * juZhuAddress_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(juZhuAddress_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:juZhuAddress_Button];
    juZhuAddress_Button.tag=90002;
    
    
    
    //居住电话 标题
    UILabel * zhuZhaiDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(juZhuAddress_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"4. 住宅电话"];
    [RootScrollView addSubview:zhuZhaiDH_Label];
    zhuZhaiDH_Label.textColor=Title_text_color;
    
    //居住电话 签字框
    zhuZhaiDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(zhuZhaiDH_Label.frame)+Title_Field_WH, CGRectGetMinY(zhuZhaiDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-zhuZhaiDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    zhuZhaiDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:zhuZhaiDH_Field];
    zhuZhaiDH_Field.delegate=self;
    zhuZhaiDH_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.TEL]) {
        zhuZhaiDH_Field.text=_zhuZeModel.TEL;
    }
    
    //居住电话 介绍
    UIButton * zhuZhaiDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(zhuZhaiDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:zhuZhaiDH_Button];
    zhuZhaiDH_Button.tag=90003;
    
    
    
    
    //移动电话 标题
    UILabel * yiDongDH_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(zhuZhaiDH_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"5. 移动电话"];
    [RootScrollView addSubview:yiDongDH_Label];
    yiDongDH_Label.textColor=Title_text_color;
    
    //移动电话 签字框
    yiDongDH_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(yiDongDH_Label.frame)+Title_Field_WH, CGRectGetMinY(yiDongDH_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-yiDongDH_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    yiDongDH_Field.textColor=Field_text_color;
    [RootScrollView addSubview:yiDongDH_Field];
    yiDongDH_Field.delegate=self;
    yiDongDH_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.PHONE]) {
        yiDongDH_Field.text=_zhuZeModel.PHONE;
    }
    
    
    //移动电话 介绍
    UIButton * yiDongDH_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(yiDongDH_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:yiDongDH_Button];
    yiDongDH_Button.tag=90004;
    
    
    
    
    //邮政编码 标题
    UILabel * youZhengBM_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(yiDongDH_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"6. 邮政编码"];
    [RootScrollView addSubview:youZhengBM_Label];
    youZhengBM_Label.textColor=Title_text_color;
    
    //邮政编码 签字框
    youZhengBM_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(youZhengBM_Label.frame)+Title_Field_WH, CGRectGetMinY(youZhengBM_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-youZhengBM_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    youZhengBM_Field.textColor=Field_text_color;
    [RootScrollView addSubview:youZhengBM_Field];
    youZhengBM_Field.delegate=self;
    youZhengBM_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.ZIPCODE]) {
        youZhengBM_Field.text=_zhuZeModel.ZIPCODE;
    }
    
    
    //邮政编码 介绍
    UIButton * youZhengBM_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(youZhengBM_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:youZhengBM_Button];
    youZhengBM_Button.tag=90005;
    
    
    
    
    //电子邮箱 标题
    UILabel * dianZiYX_Label=[ZCControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(youZhengBM_Field.frame)+20, 44+Title_text_font*3, Title_text_font) Font:Title_text_font Text:@"7. 电子邮箱"];
    [RootScrollView addSubview:dianZiYX_Label];
    dianZiYX_Label.textColor=Title_text_color;
    
    //电子邮箱 签字框
    dianZiYX_Field=[ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(dianZiYX_Label.frame)+Title_Field_WH, CGRectGetMinY(dianZiYX_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-dianZiYX_Label.frame.size.width-55, Field_HE) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:Field_text_font backgRoundImageName:nil];
    dianZiYX_Field.textColor=Field_text_color;
    [RootScrollView addSubview:dianZiYX_Field];
    dianZiYX_Field.delegate=self;
    dianZiYX_Field.userInteractionEnabled=NO;
    
    if (![PublicFunction isBlankString:_zhuZeModel.EMAIL]) {
        dianZiYX_Field.text=_zhuZeModel.EMAIL;
    }

    
    //电子邮箱 介绍
    UIButton * dianZiYX_Button=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-33, CGRectGetMinY(dianZiYX_Label.frame)-5, 33, 33) Text:nil ImageName:@"icon_comment@3x" bgImageName:nil Target:self Method:@selector(JieShao_Button_Click:)];
    [RootScrollView addSubview:dianZiYX_Button];
    dianZiYX_Button.tag=90006;
    
    
    
    
    //设置滚动范围
    RootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(dianZiYX_Field.frame)+20);
    //禁用滚动条,防止缩放还原时崩溃
    RootScrollView.showsHorizontalScrollIndicator = NO;
    RootScrollView.showsVerticalScrollIndicator = YES;
    RootScrollView.bounces = NO;
    
    
    
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
            
        case 90001:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90002:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
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
            
        case 90005:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        case 90006:
        {
            RNBlurModalView * modal = [[RNBlurModalView alloc] initWithViewController:self title:nil message:@"暂无内容"];
            
            [modal show];
        }
            break;
            
        default:
            break;
    }
    
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

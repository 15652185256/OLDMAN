//
//  BoHuiViewController.m
//  OLDMAN
//
//  Created by 赵晓东 on 16/1/11.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "BoHuiViewController.h"

#import "RNBlurModalView.h"//弹出框

@interface BoHuiViewController ()
{
    UITextView * remark_TextView;//原因
}
@end

@implementation BoHuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=View_Background_Color;
    
    //设置导航
    [self createNav];
    
    //设置页面
    [self createView];
}

#pragma mark 设置导航
-(void)createNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent=NO;
    
    //设置导航的标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:CREATECOLOR(255, 255, 255, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:Title_text_font]}];
    self.navigationItem.title = @"驳回原因";
    
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
    //驳回原因
    UILabel * remark_Label=[ZCControl createLabelWithFrame:CGRectMake(15, 20, 44+Title_text_font*2, Title_text_font) Font:Title_text_font Text:@"驳回原因"];
    [self.view addSubview:remark_Label];
    remark_Label.textColor=CREATECOLOR(51, 51, 51, 1);
    
    
    //驳回原因 签字框
    float remark_TextView_height=HEIGHT-64-30-250;
    
    remark_TextView=[ZCControl createTextViewWithFrame:CGRectMake(CGRectGetMaxX(remark_Label.frame)+Title_Field_WH, CGRectGetMinY(remark_Label.frame)-(Field_HE-Title_text_font)/2, WIDTH-remark_Label.frame.size.width-55, remark_TextView_height) scrollEnabled:YES editable:YES Font:PAGESIZE(17)];
    [self.view addSubview:remark_TextView];
    remark_TextView.textColor=CREATECOLOR(153, 153, 153, 1);
    
    
    
    //保存
    UIButton * Save_Button=[ZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-Tabbar_HE-64, WIDTH, Tabbar_HE) Text:@"保存" ImageName:nil bgImageName:nil Target:self Method:@selector(Save_Button_Click)];
    [self.view addSubview:Save_Button];
    [Save_Button setTitleColor:CREATECOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    Save_Button.titleLabel.font=[UIFont systemFontOfSize:Title_text_font];
    [Save_Button setBackgroundColor:Nav_Tabbar_backgroundColor];

    
    //收起键盘
    UITapGestureRecognizer * tapRoot = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRootAction)];
    //设置点击次数
    tapRoot.numberOfTapsRequired = 1;
    //设置几根胡萝卜有效
    tapRoot.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRoot];
    
}



#pragma mark - 保存
-(void)Save_Button_Click
{
    if ([PublicFunction isBlankString:remark_TextView.text]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请填写驳回原因" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else {
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary * parameter=[[NSMutableDictionary alloc] init];
        
        [parameter setObject:[user objectForKey:doc_id] forKey:@"doc_id"];
        
        [parameter setObject:self.shenFenZJ forKey:@"shenFenZJ"];
        
        [parameter setObject:self.type forKey:@"type"];
        
        [parameter setObject:@"5" forKey:@"value"];
        
        //去除首尾空格和换行
        NSString * content = [remark_TextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [parameter setObject:content forKey:@"remark"];
        
        [KVNProgress show];
        
        
        //发送请求
        [NetRequestClass NetRequestLoginRegWithRequestURL:updateProcessStateHttp WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
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
}


//收起键盘
-(void)tapRootAction
{
    [self.view endEditing:YES];
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

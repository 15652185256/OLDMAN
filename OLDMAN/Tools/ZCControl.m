
#import "ZCControl.h"
#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
@implementation ZCControl

#pragma mark --创建View
+(UIView*)createView:(CGRect)frame
{
    UIView * view=[[UIView alloc]initWithFrame:frame];
    return view;
}

#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text
{
    UILabel * label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.font=[UIFont systemFontOfSize:font];
    return label;
}

#pragma mark --创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame Text:(NSString*)text ImageName:(NSString*)imageName bgImageName:(NSString*)bgImageName Target:(id)target Method:(SEL)Method
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    [button addTarget:target action:Method forControlEvents:UIControlEventTouchUpInside];
    if (text) {
        [button setTitle:text forState:UIControlStateNormal];
    }
    return button;
}

#pragma mark --创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:frame];
    NSString * filePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    imageView.image=[UIImage imageWithContentsOfFile:filePath];
    
//    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView;
}

#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder=placeholder;
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    textField.secureTextEntry=YESorNO;
    //边框
    textField.borderStyle=UITextBorderStyleRoundedRect;
    //键盘类型
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //左图片
    textField.leftView=imageView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右图片
    textField.rightView=rightImageView;
    //编辑状态下一直存在
    textField.rightViewMode=UITextFieldViewModeWhileEditing;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
    //textField.textColor=[UIColor blackColor];
    return textField ;
    
}


#pragma  mark 适配器方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName
{
    UITextField * text= [self createTextFieldWithFrame:frame placeholder:placeholder passWord:YESorNO leftImageView:imageView rightImageView:rightImageView Font:font];
    text.background=[UIImage imageNamed:imageName];
    return  text;
    
}



#pragma mark --创建UIView
+(UITextView*)createTextViewWithFrame:(CGRect)frame scrollEnabled:(BOOL)scrollEnabled editable:(BOOL)editable Font:(float)font
{
    UITextView * textView=[[UITextView alloc]initWithFrame:frame];
    //文字对齐方式
    textView.textAlignment = NSTextAlignmentLeft;
    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    textView.scrollEnabled=scrollEnabled;
    //是否允许编辑内容，默认为“YES”
    textView.editable=editable;
    //字体
    textView.font=[UIFont systemFontOfSize:font];
    //边框颜色
    textView.layer.borderColor = [[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]CGColor];
    //边框宽度
    textView.layer.borderWidth = 0.5;
    //边框圆角
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 5;
    
    return textView;
}


#pragma mark 创建UIScrollView
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = size;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    return scrollView ;
}

#pragma mark 创建UIPageControl
+(UIPageControl*)makePageControlWithFram:(CGRect)frame
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    return pageControl;
}

#pragma mark 创建UISlider
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image
{
    UISlider *slider = [[UISlider alloc]initWithFrame:rect];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider setThumbImage:[UIImage imageNamed:@"qiu"] forState:UIControlStateNormal];
    slider.maximumTrackTintColor = [UIColor grayColor];
    slider.minimumTrackTintColor = [UIColor yellowColor];
    slider.continuous = YES;
    slider.enabled = YES;
    return slider ;
}

#pragma mark 创建时间转换字符串
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma -mark 判断导航的高度
+(float)isIOS7{
    
    float height;
    if (IOS7) {
        height=64.0;
    }else{
        height=44;
    }
    
    return height;
}

#pragma mark 内涵图需要的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval
{
    NSTimeInterval seconds = [timeInterval integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [format stringFromDate:date];
}

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize
{
    NSDictionary * dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    // 根据第一个参数的文本内容，使用280*float最大值的大小，使用系统14号字，返回一个真实的frame size : (280*xxx)!!
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height + 5;
}

// 返回一个整数字符串加1后的新字符串
+ (NSString *)addOneByIntegerString:(NSString *)integerString
{
    NSInteger integer = [integerString integerValue];
    return [NSString stringWithFormat:@"%ld",integer+1];
}


//获取行高 宽
//+(CGSize)setSize:(NSString*)string fontOfSize:(float)size
//{
//    CGSize oldSize = CGSizeMake(WIDTH, HEIGHT);
//    CGSize newSize;
//    if (IOS7) {
//        newSize = [string sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:oldSize lineBreakMode:NSLineBreakByCharWrapping];
//    }
//    else
//    {
//        newSize = [string boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
//    }
//    return newSize;
//}

@end

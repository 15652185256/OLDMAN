//
//  DrawSignView.m
//  YRF
//
//
/**
 本界面
 
 */

#import "DrawSignView.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define SYSTEMFONT(x) [UIFont systemFontOfSize:(x)]

////页面尺寸
//#define WIDTH [UIScreen mainScreen].bounds.size.width    //屏幕宽度
//#define HEIGHT [UIScreen mainScreen].bounds.size.height  //屏幕高度

@interface DrawSignView ()
//@property (strong,nonatomic)  MyView *drawView;
@property (assign,nonatomic)  BOOL buttonHidden;
@property (assign,nonatomic)  BOOL widthHidden;
@end


//保存线条颜色
static NSMutableArray * colors;


@implementation DrawSignView{
    UIButton *redoBtn;//撤销
    UIButton *undoBtn;//恢复
    UIButton *clearBtn;//清空
    UIButton *colorBtn;//颜色
    UIButton *screenBtn;//截屏
    UIButton *widthBtn;//高度
    UIButton *okBtn;//确定并截图返回
    UIButton *cancelBtn;//取消

    UISlider *penBoldSlider;
    

    MyView *drawView;//画图的界面，宽高3:1

}

@synthesize signCallBackBlock,cancelBlock;


- (void)dealloc {
    [signCallBackBlock release];
    [cancelBlock release];
    [redoBtn release];
    [undoBtn release];
    [clearBtn release];
    [colorBtn release];
    [screenBtn release];
    [widthBtn release];
    [drawView release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)createView
{
    CGFloat btn_x = 10;
    CGFloat btn_y = 40;
    CGFloat btn_w = 60;
    CGFloat btn_h = 30;
    CGFloat btn_mid = 5;



    //self
    self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.backgroundColor = [UIColor colorWithRed:59./255. green:73./255. blue:82./255. alpha:1];



    //btns
    redoBtn = [[UIButton alloc]init];
    [self renderBtn:redoBtn];
    [redoBtn setTitle:@"撤销" forState:UIControlStateNormal];
    redoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:redoBtn];
    [redoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    redoBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    
    //undoBtn
    undoBtn = [[UIButton alloc]init];
    [self renderBtn:undoBtn];
    [undoBtn setTitle:@"恢复" forState:UIControlStateNormal];
    undoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:undoBtn];
    [undoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    undoBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    
    //clearBtn
    clearBtn = [[UIButton alloc]init];
    [self renderBtn:clearBtn];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    clearBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    
    //okBtn
    okBtn = [[UIButton alloc]init];
    [self renderBtn:okBtn];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:okBtn];
    [okBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    
    //cancelBtn
    cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self renderBtn:cancelBtn];
    cancelBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:15];


    NSMutableArray * btnLArr = [[NSMutableArray alloc]init];
    //统一设坐标
    [btnLArr addObject:redoBtn];
    [btnLArr addObject:undoBtn];
    [btnLArr addObject:clearBtn];
    [btnLArr addObject:okBtn];
    [btnLArr addObject:cancelBtn];


    int i = 0;
    for (UIButton * btn in btnLArr) {
        btn.frame = CGRectMake((WIDTH-btn_w*5-btn_mid*4)/2+i*(btn_w+btn_mid), btn_y, btn_w, btn_h);
        i++;
    }

    [btnLArr release];


    //
    colors=[[NSMutableArray alloc]initWithObjects:[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor blackColor],[UIColor whiteColor], nil];
    self.buttonHidden=YES;
    self.widthHidden=YES;
    drawView=[[MyView alloc]initWithFrame:CGRectMake(0, 100, WIDTH, (WIDTH)/5*3)];
    //[self.drawView setBackgroundColor:RGBCOLOR(101, 129, 90)];
    [drawView setBackgroundColor:[UIColor whiteColor]];
    
    drawView.layer.cornerRadius=5.0;
    drawView.layer.borderWidth=0.1;
    
    [self addSubview:drawView];
    [self sendSubviewToBack:drawView];

	// Do any additional setup after loading the view, typically from a nib.
}


-(void)changeColors:(id)sender{
    if (self.buttonHidden==YES) {
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=NO;
            self.buttonHidden=NO;
        }
    }else{
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=YES;
            self.buttonHidden=YES;
        }
    }
}

-(void)changeWidth:(id)sender{
    if (self.widthHidden==YES) {
        for (int i=11; i<15; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=NO;
            self.widthHidden=NO;
        }
    }else{
        for (int i=11; i<15; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=YES;
            self.widthHidden=YES;
        }

    }

}
- (void)widthSet:(id)sender {
    UIButton *button=(UIButton *)sender;
    [drawView setlineWidth:button.tag-10];
}

- (UIImage *)saveScreen{

    UIView *screenView = drawView;

    for (int i=1; i<16;i++) {
        UIView *view=[self viewWithTag:i];
        if ((i>=1&&i<=5)||(i>=10&&i<=15)) {
            if (view.hidden==YES) {
                continue;
            }
        }
        view.hidden=YES;
        if(i>=1&&i<=5){
            self.buttonHidden=YES;
        }
        if(i>=10&&i<=15){
            self.widthHidden=YES;
        }
    }
    UIGraphicsBeginImageContext(screenView.bounds.size);
    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //NSLog(@"截屏成功");
    image = [DrawSignView imageToTransparent:image];
    return [[image retain]autorelease];
}

- (void)colorSet:(id)sender {
    UIButton *button=(UIButton *)sender;
    [drawView setLineColor:button.tag-1];
    colorBtn.backgroundColor=[colors objectAtIndex:button.tag-1];
}

/** 封装的按钮事件 */
-(void)btnAction:(id)sender{
    if (sender == cancelBtn) {
        cancelBlock();
    }else if (sender == okBtn){
        //笔画数组
        //NSLog(@"%ld",self.drawView.MyLineArray.count);
        
        if (drawView.MyLineArray.count!=0) {
            signCallBackBlock([self saveScreen]);
        }
        
    }else if (sender == redoBtn){
       [drawView revocation];
    }else if(sender == undoBtn){
        [drawView refrom];
    }else if(sender == clearBtn){
        [drawView clear];
    }
}



/** 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

//颜色替换
+ (UIImage*) imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);

    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);

    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {



        //把绿色变成黑色，把背景色变成透明
        if ((*pCurPtr & 0x65815A00) == 0x65815a00)    // 将背景变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else if ((*pCurPtr & 0x00FF0000) == 0x00ff0000)    // 将绿色变成黑色
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
        else if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        //去掉边框
//        else
//        {
//            // 改成下面的代码，会将图片转成想要的颜色
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[3] = 0; //0~255
//            ptr[2] = 0;
//            ptr[1] = 0;
//        }

    }

    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);

    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];

    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}


-(void)renderBtn:(UIButton *)btn{
    [btn setBackgroundImage:[self imageFromColor:RGBCOLOR(59,73,82)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageFromColor:RGBCOLOR(169,183,192)]
                   forState:UIControlStateHighlighted];
     double dRadius = 2.0f;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //CornerRadius/Border
    [btn.layer setCornerRadius:dRadius];
    [btn.layer setBorderWidth:1.0f];
    [btn.layer setBorderColor:RGBCOLOR(255, 255, 255).CGColor];
    [btn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];

}

- (UIImage *) imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end

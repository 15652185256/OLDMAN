
#import <Foundation/Foundation.h>

@interface PublicFunction : NSObject

#pragma mark --获取状态
+(NSString*)selectState:(int)type;


#pragma mark --获取状态 字体颜色
+(UIColor*)selectState_textColor:(int)type;


#pragma mark --是否为空
+(BOOL)isBlankString:(NSString *)string;


#pragma mark --是否 包含
+(BOOL)isRangeOfString:(NSDictionary *)dict num:(NSInteger)num;


//验证手机号
+(BOOL)validateMobile:(NSString *)mobile;

//验证密码
+(BOOL)validatePassword:(NSString *)password;

//验证真实姓名
+(BOOL)validateNickName:(NSString *)nickname;

//验证身份证号
+(BOOL)validateIdentityCard: (NSString *)identityCard;

//验证 邮政编码
+(BOOL)validateZipCode:(NSString *)zipCode;

//验证 电子邮箱
+(BOOL)validateEmail:(NSString *)email;

//过滤纯数字
+(BOOL)validateNumber:(NSString *)textString;



//感知觉与沟通 分级
+(NSString*)getGanZhiJYGTFJ:(NSString*)yiShiSP shiLi:(NSString*)shiLi tingLi:(NSString*)tingLi gouTongJL:(NSString*)gouTongJL;


//能力等级初评
+(NSString*)getNengLiDJ:(NSString*)riChengSH jingShenZT:(NSString*)jingShenZT ganZhiJ:(NSString*)ganZhiJ sheHuiCY:(NSString*)sheHuiCY;

@end

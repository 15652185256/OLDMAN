
#import "PublicFunction.h"

@implementation PublicFunction

#pragma mark --获取状态
+(NSString*)selectState:(int)type
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    NSString * state;
    
    switch (type) {
        case -1:
            state=@"无需采集";
            break;
        case 0:
            state=@"采集未开始";
            break;
        case 1:
            state=@"采集进行中";
            break;
        case 2:
            if ([[user objectForKey:idenity] intValue]==1) {
                state=@"采集已完成";
            } else if ([[user objectForKey:idenity] intValue]==2) {
                state=@"待审核";
            }
            break;
        case 3:
            if ([[user objectForKey:idenity] intValue]==1) {
                state=@"初审已完成";
            } else if ([[user objectForKey:idenity] intValue]==2) {
                state=@"已审核";
            }
            break;
        case 4:
            state=@"主审已完成";
            break;
        case 5:
            state=@"初审未通过";
            break;
        case 6:
            state=@"主审未通过";
            break;
        default:
            break;
    }
    
    return state;
}



#pragma mark --获取状态 字体颜色
+(UIColor*)selectState_textColor:(int)type
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    UIColor * color;
    
    switch (type) {
        case -1:
            color=CREATECOLOR(202, 52, 48, 1);
            break;
        case 0:
            color=CREATECOLOR(205, 155, 53, 1);
            break;
        case 1:
            color=CREATECOLOR(86, 174, 215, 1);
            break;
        case 2:
            if ([[user objectForKey:idenity] intValue]==1) {
                color=CREATECOLOR(49, 153, 49, 1);
            } else if ([[user objectForKey:idenity] intValue]==2) {
                color=CREATECOLOR(202, 52, 48, 1);
            }
            break;
        case 3:
            color=CREATECOLOR(49, 153, 49, 1);
            break;
        case 4:
            color=CREATECOLOR(49, 153, 49, 1);
            break;
        case 5:
            color=CREATECOLOR(202, 52, 48, 1);
            break;
        case 6:
            color=CREATECOLOR(202, 52, 48, 1);
            break;
        default:
            break;
    }
    
    
    return color;
}




#pragma mark --是否为空
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string length] == 0) {
        return YES;
    }
    return NO;
    
    
//    NSData * resData = [[NSData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
}



#pragma mark --是否 包含
+(BOOL)isRangeOfString:(NSDictionary *)dict num:(NSInteger)num
{
    NSArray * arr=[dict allKeys];
    
    for (NSString * str in arr) {
        if ([str integerValue]==num) {
            return YES;
        }
    }
    
    return NO;
}


//验证手机号
+(BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString * phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//验证密码
+(BOOL)validatePassword:(NSString *)password
{
    //6~10位数字和字母混合
    NSString * passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10}$";
    NSPredicate * passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordTest evaluateWithObject:password];
}

//验证真实姓名
+(BOOL)validateNickName:(NSString *)nickname
{
    NSString * nicknameRegex = @"^[\u4e00-\u9fa5·]{2,}$";
    NSPredicate * passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//验证身份证号
+(BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


//验证 邮政编码
+(BOOL)validateZipCode:(NSString *)zipCode
{
    NSString *regex2 = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:zipCode];
}

//验证 电子邮箱
+(BOOL)validateEmail:(NSString *)email
{
    NSString *regex2 = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:email];
}

//过滤纯数字
+(BOOL)validateNumber:(NSString *)textString
{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}






//感知觉与沟通 分级
+(NSString*)getGanZhiJYGTFJ:(NSString*)yiShiSP shiLi:(NSString*)shiLi tingLi:(NSString*)tingLi gouTongJL:(NSString*)gouTongJL
{
    NSString * GanZhiJYGTFJ=@"-1";
    
    
    //NSString * str = @"2200";
    
    NSString * str = [NSString stringWithFormat:@"%@%@%@%@",yiShiSP,shiLi,tingLi,gouTongJL];
    
    //意识为0，视力听力为0或1，沟通为0
    NSString * levelZero = @"0(0|1)(0|1)0";
    NSPredicate * levelZero_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",levelZero];
    if ([levelZero_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"0";
    }
    
    
    
    
    //意识为0，至少视力为2
    NSString * pattern10 = @"02(0|1|2)(0|1)";
    NSPredicate * pattern10_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern10];
    if ([pattern10_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"1";
    }
    //意识为0，至少听力为2
    NSString * pattern11 = @"0(0|1|2)2(0|1)";
    NSPredicate * pattern11_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern11];
    if ([pattern11_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"1";
    }
    //意识为0，沟通为1
    NSString * pattern12 = @"0(0|1|2)(0|1|2)1";
    NSPredicate * pattern12_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern12];
    if ([pattern12_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"1";
    }
    
    

    
    //意识为0，至少视力为3
    NSString * pattern20 = @"03(0|1|2|3)(0|1|2)";
    NSPredicate * pattern20_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern20];
    if ([pattern20_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"2";
    }
    //意识为0，至少听力为3
    NSString * pattern21 = @"0(0|1|2|3)3(0|1|2)";
    NSPredicate * pattern21_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern21];
    if ([pattern21_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"2";
    }
    //意识为0，沟通为2
    NSString * pattern22 = @"0(0|1|2|3)(0|1|2|3)2";
    NSPredicate * pattern22_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern22];
    if ([pattern22_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"2";
    }
    //嗜睡，视力听力在3及以下，沟通为2及以下
    NSString * pattern23 = @"1(0|1|2|3)(0|1|2|3)(0|1|2)";
    NSPredicate * pattern23_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern23];
    if ([pattern23_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"2";
    }
    

    
    //意识为0，至少视力为4
    NSString * pattern30 = @"(0|1)4(0|1|2|3|4)(0|1|2|3)";
    NSPredicate * pattern30_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern30];
    if ([pattern30_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"3";
    }
    //意识为0，至少听力为4
    NSString * pattern31 = @"(0|1)(0|1|2|3|4)4(0|1|2|3)";
    NSPredicate * pattern31_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern31];
    if ([pattern31_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"3";
    }
    //意识为0，沟通为3
    NSString * pattern32 = @"(0|1)(0|1|2|3|4)(0|1|2|3|4)3";
    NSPredicate * pattern32_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern32];
    if ([pattern32_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"3";
    }
    //意识为昏睡2或昏迷3
    NSString * pattern33 = @"(2|3)(0|1|2|3|4)(0|1|2|3|4)(0|1|2|3)";
    NSPredicate * pattern33_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern33];
    if ([pattern33_validate evaluateWithObject:str]) {
        GanZhiJYGTFJ=@"3";
    }
    
    
    
    return GanZhiJYGTFJ;
}





//能力等级初评
+(NSString*)getNengLiDJ:(NSString*)riChengSH jingShenZT:(NSString*)jingShenZT ganZhiJ:(NSString*)ganZhiJ sheHuiCY:(NSString*)sheHuiCY
{
    NSString * NengLiDJ=@"-1";
    
    NSString * str = [NSString stringWithFormat:@"%@%@%@%@",riChengSH,jingShenZT,ganZhiJ,sheHuiCY];
    
    //NSString * str=@"3000";
    
    
    //日常生活为0，精神状况为0，感知觉与沟通为0，社会参与为0或1
    NSString * levelZero = @"000(0|1)";
    NSPredicate * levelZero_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",levelZero];
    if ([levelZero_validate evaluateWithObject:str]) {
        NengLiDJ=@"0";
    }
    
    
    
    //日常生活为0，精神状况为1,2,3,感知觉与沟通为1,2,3,社会参与为2,3
    NSString * pattern10 = @"0(1|2|3)(1|2|3)(2|3)";
    NSPredicate * pattern10_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern10];
    if ([pattern10_validate evaluateWithObject:str]) {
        NengLiDJ=@"1";
    }
    //日常生活为1，精神状况为0,1感知觉与沟通为0,1社会参与为0,1
    NSString * pattern11 = @"1(0|1)(0|1)(0|1)";
    NSPredicate * pattern11_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern11];
    if ([pattern11_validate evaluateWithObject:str]) {
        NengLiDJ=@"1";
    }
    
    
    
    //日常生活为1，精神状况为2,3,感知觉与沟通为2,3,社会参与为2,3
    NSString * pattern21 = @"1(2|3)(2|3)(2|3)";
    NSPredicate * pattern21_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern21];
    if ([pattern21_validate evaluateWithObject:str]) {
        NengLiDJ=@"2";
    }
    //日常生活为2，精神状况为0,1感知觉与沟通为0,1社会参与为0,1
    NSString * pattern22 = @"2(0|1)(0|1)(0|1)";
    NSPredicate * pattern22_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern22];
    if ([pattern22_validate evaluateWithObject:str]) {
        NengLiDJ=@"2";
    }
    
    
    
    //日常生活为2，精神状况为2,3,感知觉与沟通为2,3,社会参与为2,3
    NSString * pattern32 = @"2(2|3)(2|3)(2|3)";
    NSPredicate * pattern32_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern32];
    if ([pattern32_validate evaluateWithObject:str]) {
        NengLiDJ=@"3";
    }
    //日常生活为3，精神状况为0,1,2,3,感知觉与沟通为0,1,2,3,社会参与为0,1,2,3
    NSString * pattern33 = @"3(0|1|2|3)(0|1|2|3)(0|1|2|3)";
    NSPredicate * pattern33_validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern33];
    if ([pattern33_validate evaluateWithObject:str]) {
        NengLiDJ=@"3";
    }
    
    
    return NengLiDJ;
}

@end

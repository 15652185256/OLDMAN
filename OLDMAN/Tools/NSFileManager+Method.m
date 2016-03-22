
#import "NSFileManager+Method.h"

@implementation NSFileManager (Method)
//判断文件是否超时
-(BOOL)timeOutFileName:(NSString*)name time:(NSTimeInterval)time
{
    //Documents模拟器对大小写不敏感,但真机区分大小写
    NSString * path=[NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),name];
    //读取文件信息
    NSDictionary * info=[[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
    //读取文件创建时间
    NSDate * createData=[info objectForKey:NSFileCreationDate];
    //获取现在时间
    NSDate * date=[NSDate date];
    //二个时间算差值
    NSTimeInterval time1=[date timeIntervalSinceDate:createData];
    
    if (time>time1) {
        return YES;
    }
    else{
        return NO;
    }
}
//清空缓存
-(void)clearFile{
    //获取文件管理的单列
    NSFileManager * manager=[NSFileManager defaultManager];
    //获取文件,仅仅只获得了文件名称
    NSArray * fileArray=[manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] error:nil];
    //遍历文件名称,删除
    [fileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),obj] error:nil];
    }];
}

@end

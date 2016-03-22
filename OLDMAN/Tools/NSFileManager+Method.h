
#import <Foundation/Foundation.h>

@interface NSFileManager (Method)

//用于判断文件是否超时
-(BOOL)timeOutFileName:(NSString*)name time:(NSTimeInterval)time;

@end

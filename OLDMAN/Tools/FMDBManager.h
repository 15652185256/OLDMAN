
#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface FMDBManager : NSObject
{
    FMDatabase * fm;
}
//设置单例方法
+(id)shareManager;

//添加方法 通知
-(BOOL)addNewsData:(NSDictionary*)dic;

//读取方法 通知
-(NSArray*)selectNewsData;

//查询 推送 是否有 新消息
-(NSArray*)IsSelectNewsData;

//修改 推送 查看状态
-(void)updateNewsDataByNewsID:(NSString*)NewsID Time:(NSString*)Time;

//删除方法 通知
-(void)deleteNewsDataByNewsID:(NSString*)NewsID Time:(NSString*)Time;

//添加 回复
-(BOOL)addReplyData:(NSDictionary*)dic;

//查询 回复
-(NSArray *)selectReplyData:(NSString*)NewsID;


@end

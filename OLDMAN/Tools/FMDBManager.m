
#import "FMDBManager.h"

#import "JpushNewsModel.h"//通知 数据模型

#import "JpushReplyModel.h"//回复 数据模型

static FMDBManager * manager=nil;
@implementation FMDBManager
+(id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //GCD方式创建单例，保证此方法只调用一次
        manager=[[FMDBManager alloc]init];
    });
    return manager;
}


//查询表是否存在
- (BOOL)isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [fm executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (count == 0){
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

////查询 表 是否 存在 字段
//- (BOOL)columnExists:(NSString*)columnName inTableWithName:(NSString*)tableName
//{
//    NSString * sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", columnName, tableName];
//    FMResultSet * rs = [fm executeQuery:sql];
//    if (rs) {
//        return YES;
//    }
//    [rs close];
//    return NO;
//}

-(id)init
{
    if (self=[super init]) {
        //设置一个缓存路径
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * docDir = [paths objectAtIndex:0];
        
        //创建数据库
        fm=[[FMDatabase alloc]initWithPath:[NSString stringWithFormat:@"%@/data.db",docDir]];
        
        //打开数据
        if ([fm open]) {
            
            
            if (![self isTableOK:@"JpushNews"]) {
                //创建表格 推送
                [fm executeUpdate:@"create table JpushNews (time,content,NewsID,DocID,state)"];
            }
//            else {
//                //查询 JpushNews 表 中 是否 存在 state 字段
//                if (![self columnExists:@"state" inTableWithName:@"JpushNews"]) {
//                    //NSLog(@"如果不存在  添加 字段");
//                    //如果不存在  添加 字段
//                     [fm executeUpdate:@"alter table JpushNews add column state"];
//                }
//            }
            
            if (![self isTableOK:@"JpushReply"]) {
                //创建表格 回复
                [fm executeUpdate:@"create table JpushReply (time,content,NewsID)"];
            }
        }
    }
    return self;
}




//添加 推送
-(BOOL)addNewsData:(NSDictionary*)dic
{
    return [fm executeUpdate:@"insert into JpushNews values(?,?,?,?,?)",dic[@"time"],dic[@"content"],dic[@"NewsID"],dic[@"DocID"],dic[@"state"]];
}

//查询 推送 是否有 新消息
-(NSArray*)IsSelectNewsData
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    FMResultSet * result=[fm executeQuery:@"select * from JpushNews WHERE DocID = ?",[user objectForKey:doc_id]];
    NSMutableArray * array=[NSMutableArray arrayWithCapacity:0];
    while ([result next]) {
        JpushNewsModel * model=[[JpushNewsModel alloc]init];
        
        if (![PublicFunction isBlankString:[result stringForColumn:@"content"]]) {

            if ([[result stringForColumn:@"state"] intValue]==0) {
                [array addObject:model];
            }
        }
    }
    return array;
}

//查询 推送
-(NSArray *)selectNewsData
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    FMResultSet * result=[fm executeQuery:@"select * from JpushNews WHERE DocID = ?",[user objectForKey:doc_id]];
    NSMutableArray * array=[NSMutableArray arrayWithCapacity:0];
    while ([result next]) {
        JpushNewsModel * model=[[JpushNewsModel alloc]init];
        
        if (![PublicFunction isBlankString:[result stringForColumn:@"content"]]) {
            model.time=[result stringForColumn:@"time"];
            model.content=[result stringForColumn:@"content"];
            model.NewsID=[result stringForColumn:@"NewsID"];
            model.state=[result stringForColumn:@"state"];
            [array addObject:model];
        }
    }
    return array;
}

//修改 推送 查看状态
-(void)updateNewsDataByNewsID:(NSString*)NewsID Time:(NSString*)Time
{
    if ([self isTableOK:@"JpushNews"]) {
        
        [fm executeUpdate:@"update JpushNews SET state = ? where NewsID = ? and time = ?",@"1", NewsID,Time];
    }
}

//删除 推送
-(void)deleteNewsDataByNewsID:(NSString*)NewsID Time:(NSString*)Time
{
    if ([self isTableOK:@"JpushNews"]) {
        
        [fm executeUpdate:@"delete from JpushNews where NewsID = ? and time = ?", NewsID,Time];
        
        if ([self isTableOK:@"JpushReply"]) {
            
            [fm executeUpdate:@"delete from JpushReply where NewsID = ?", NewsID];
        }
    }
}






//添加 回复
-(BOOL)addReplyData:(NSDictionary*)dic
{
    return [fm executeUpdate:@"insert into JpushReply values(?,?,?)",dic[@"time"],dic[@"content"],dic[@"NewsID"]];
}


//查询 回复
-(NSArray *)selectReplyData:(NSString*)NewsID
{
    FMResultSet * result=[fm executeQuery:@"select * from JpushReply where NewsID = ?", NewsID];
    NSMutableArray * array=[NSMutableArray arrayWithCapacity:0];
    while ([result next]) {
        JpushReplyModel * model=[[JpushReplyModel alloc]init];
        
        if (![PublicFunction isBlankString:[result stringForColumn:@"content"]]) {
            model.time=[result stringForColumn:@"time"];
            model.content=[result stringForColumn:@"content"];
            model.NewsID=[result stringForColumn:@"NewsID"];
            [array addObject:model];
        }
    }
    
    return array;
}



@end

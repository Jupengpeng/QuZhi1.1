//
//  DBmanager.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-9.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "DBmanager.h"
#import "FMDatabase.h"
@implementation DBmanager
{
    FMDatabase * _dataBase;
    
}
+ (instancetype)sharedManager{
    static DBmanager * manager = nil;
    @synchronized(self){
        if (manager == nil) {
            manager = [[DBmanager alloc]init];
        }
    }
    return manager;
}

- (id)init{
    if (self = [super init]) {
        NSString *filePath = [self getFileFullPathWithFileName:@"jpApp.db"];
        _dataBase = [[FMDatabase alloc] initWithPath:filePath];

        if ([_dataBase open]) {
//            NSLog(@"数据库打开成功");
        }else {
//            NSLog(@"database open failed:%@",_dataBase.lastErrorMessage);
        }
    }
    return self;
    
}


- (void)creatArticleTable {

    NSString *sql = @"create table if not exists articleInfo(share_url Varchar(1024),title Varchar(1024),id integer)";
    //创建表 如果不存在则创建新的表
    BOOL isSuccees = [_dataBase executeUpdate:sql];
    if (!isSuccees) {
//        NSLog(@"creatTable error:%@",_dataBase.lastErrorMessage);
    }
}
- (NSString *)getFileFullPathWithFileName:(NSString *)fileName {
    NSString *docPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {
        //文件的全路径
//        NSLog(@"%@",NSHomeDirectory());
        return [docPath stringByAppendingFormat:@"/%@",fileName];
    }else {
        //如果不存在可以创建一个新的
        return nil;
    }
}


- (void)insertModel:(id)model  {
    [self creatArticleTable];

    DetailModel *myModel = (DetailModel *)model;
    
    if ([self isExistArticleForTitle:myModel.title]) {
        return;
    }
    NSString *sql = @"insert into articleInfo values (?,?,?)";
    BOOL isSuccess = [_dataBase executeUpdate:sql,myModel.share_url,myModel.title,[NSNumber numberWithInt:myModel.id]];
    if (!isSuccess) {
//        NSLog(@"insert error:%@",_dataBase.lastErrorMessage);
    }
}
- (BOOL)isExistArticleForTitle:(NSString *)title {
    NSString *sql = @"select * from articleInfo where title = ? ";
    FMResultSet *rs = [_dataBase executeQuery:sql,title];
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}



- (void)deleteModelForTitle:(NSString *)title{
    NSString *sql = @"delete from articleInfo where title = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,title];
    if (!isSuccess) {
//        NSLog(@"delete error:%@",_dataBase.lastErrorMessage);
    }
}

- (void)deleteModelForStoryId:(NSInteger)StoryId{
    NSString * sql = @"delete from articleInfo where id = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,[NSNumber numberWithInt:(int)StoryId ]];

    if (!isSuccess) {
//        NSLog(@"delete error:%@",_dataBase.lastErrorMessage);
    }
    
}

- (NSArray *)readArticleModels{
    
    NSString *sql = @"select * from articleInfo ";
    FMResultSet * rs = [_dataBase executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([rs next]) {
        //把查询之后结果 放在model
        DetailModel *myModel = [[DetailModel alloc] init];
        myModel.title = [rs stringForColumn:@"title"];
        myModel.id = [rs intForColumn:@"id"];
        myModel.share_url = [rs stringForColumn:@"share_url"];
        //放入数组
        [arr addObject:myModel];
    }
    return arr;
}

- (NSArray *)readArticleModelsWithTitle:(NSString *)title{
    NSString *sql = @"select * from articleInfo where title = ?";
    FMResultSet * rs = [_dataBase executeQuery:sql,title];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([rs next]) {
        //把查询之后结果 放在model
        DetailModel *myModel = [[DetailModel alloc] init];
        myModel.title = [rs stringForColumn:@"title"];
        myModel.id = [rs intForColumn:@"id"];
        myModel.share_url = [rs stringForColumn:@"share_url"];
        //放入数组
        [arr addObject:myModel];
    }
    return arr;
    
    
}

- (NSInteger)getCountsFromAppWithTitle:(NSString *)title {
    NSString *sql = @"select count(*) from articleInfo where title = ?";
    FMResultSet *rs = [_dataBase executeQuery:sql,title];
    NSInteger count = 0;
    while ([rs next]) {
        //查找 指定类型的记录条数
        count = [[rs stringForColumnIndex:0] integerValue];
    }
    return count;
}


- (void)createPicTable
{
    NSString * sql = @"create table if not exists picInfo(url Varchar(1024),title Varchar(1024),content Varchar(1024),author Varchar(1024),id Varchar(1024))";
    BOOL isSuccess = [_dataBase executeUpdate:sql];
    if (!isSuccess) {
//        NSLog(@"createTable error"); 
    }
}
- (void)insertPicModel:(PicDetailModel *)model{
    [self createPicTable];
    if ([self isExistPicForPicId:model.id]) {
        return;
    }
    NSString * sql  = @"insert into picInfo values (?,?,?,?,?)";
    BOOL isSuccess = [_dataBase executeUpdate:sql,model.url,model.title,model.content,model.author,model.id];
    if (!isSuccess) {
//        NSLog(@"insert error:%@",_dataBase.lastError);
    }
}

- (BOOL)isExistPicForPicId:(NSString *)picId{
    NSString *sql = @"select * from picInfo where id = ? ";
    FMResultSet *rs = [_dataBase executeQuery:sql,picId];
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
- (void)deleteModelForPicId:(NSString *)picId{
    NSString *sql = @"delete from picInfo where id = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,picId];
    if (!isSuccess) {
//        NSLog(@"delete error:%@",_dataBase.lastErrorMessage);
    }
    
}

- (NSArray *)readPicModels{
    NSString *sql = @"select * from picInfo ";
    FMResultSet * rs = [_dataBase executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([rs next]) {
        //把查询之后结果 放在model
        PicDetailModel *myModel = [[PicDetailModel alloc] init];
        myModel.title = [rs stringForColumn:@"title"];
        myModel.id = [rs stringForColumn:@"id"];
        myModel.url = [rs stringForColumn:@"url"];
        myModel.content = [rs stringForColumn:@"content"];
        myModel.author = [rs stringForColumn:@"author"];
        //放入数组
        [arr addObject:myModel];
    }
    return arr;
}



@end

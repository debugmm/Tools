//
//  MTFMDBManager.m
//
//  Created by worktree on 09/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "MTFMDBManager.h"

//fmdb
#import <FMDB.h>

//helpers class
#import "NSString+CateString.h"

//model class


//define
static MTFMDBManager *sharedManager=nil;
#define DBName (@"mt.db")
#define DBFolderName (@"db")

#define CreateTbSQLPrefix (@"create table if not exists")
#define UserTbPrimaryKey (@"integer primary key")

#define UserTbName (@"t_user")
#define UserTb_Id (@"id")//integer primary key

#define UserTb_uid (@"uid")//user id,varchar
#define UserTb_userName (@"username")//user name,varchar
#define UserTb_loginToken (@"token")//login token,varchar

//build sql string
#define CreateTbSQLDefaultPrefix(tableName) ([NSString stringWithFormat:@"%@ %@ (%@ %@,",CreateTbSQLPrefix,tableName,UserTb_Id,UserTbPrimaryKey])

#define RightParenthesis (@")")

//user defaults key
#define DictionaryKey (@"key")//key:value<dictionary>
#define UidKey (@"uid")//key:value<string>,the value is user id

#pragma mark -
@interface MTFMDBManager(){
    
    FMDatabaseQueue *dbQueue;//fmdb queue
}

@end

@implementation MTFMDBManager

+(instancetype)sharedManager{
    
   static dispatch_once_t one;
    
    dispatch_once(&one, ^{
        
        sharedManager=[[MTFMDBManager alloc] init];
    });
    
    return sharedManager;
}

-(void)initConfigDBWithUId:(nonnull NSString *)uid{
    
    [self createDBQueueWithUId:uid];
}

#pragma mark - about DB
-(void)createDBQueueWithUId:(nonnull NSString *)uid{
    
    //init db queue
    NSString *rootPath=[self dbPathWithUId:uid];
    
    NSString *fullPath=[NSString stringWithFormat:@"%@/%@",rootPath,DBName];
    
    dbQueue=[FMDatabaseQueue databaseQueueWithPath:fullPath];
    
    NSAssert(dbQueue!=nil, @"create db queue failed,occur error...");
    
    //create User Table
    [self createUserTb];
}

-(void)closeDBQueue{
    
    [dbQueue close];
}

#pragma mark -
-(NSString *)dbPathWithUId:(nonnull NSString *)uid{
    //root path
    NSString *rootPath=[self dbRootPath];
    
    NSFileManager *fm=[NSFileManager defaultManager];
    
    BOOL result=[fm fileExistsAtPath:rootPath];
    if(!result){
        result=[fm createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSAssert(result, @"create db path,occur error...");
    
    return rootPath;
}

-(NSString *)dbRootPath{
    
    NSArray *rootPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath=[rootPaths firstObject];
    
    rootPath=[NSString stringWithFormat:@"%@/%@",rootPath,DBFolderName];
    
    return rootPath;
}

#pragma mark - about user default
-(NSString *)getAutoLoginUserUId{
    //for auto login
    NSUserDefaults *u=[NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict=[u objectForKey:DictionaryKey];
    NSString *uid=@"";
    
    if(dict){
        
        uid=[motouDict objectForKey:UidKey];
    }
    
    return uid;
}

-(void)saveUIdToPlist:(nonnull NSString *)uid{
    //for auto login
    NSUserDefaults *u=[NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict=@{UidKey:uid};
    
    [u setObject:dict forKey:DictionaryKey];
    
    [u synchronize];
}

#pragma mark - about User table
-(void)createUserTb{
    
    NSDictionary *dict=@{UserTb_uid:@"varchar",
                         UserTb_userName:@"varchar",
                         UserTb_loginToken:@"varchar"
                         };
    
    NSString *sql=[self buildSQLStringTableName:UserTbName withFieldNameAndTypeDicationary:dict];
    
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        BOOL result=[db executeUpdate:sql];
        NSLog(@"create user table result:%d",result);
    }];
}

#pragma mark -
-(NSString *)buildSQLStringTableName:(nonnull NSString *)tableName
     withFieldNameAndTypeDicationary:(nonnull NSDictionary *)fieldDict{
    /**
     * FieldKeyValueDicationary format:
     *      field-name:field-type
     *      uid:varchar
     */
    if(!fieldDict ||
       fieldDict.count<=0 ||
       [NSString isEmptyString:tableName]){
        
        return [[NSString alloc] init];
    }
    
    __block NSString *sql=CreateTbSQLDefaultPrefix(tableName);
    
    [fieldDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *keyvalue=[NSString stringWithFormat:@"%@ %@,",key,obj];
        
        sql=[sql stringByAppendingString:keyvalue];
    }];
    
    //remove last char:,
    sql=[sql substringWithRange:NSMakeRange(0, sql.length-1)];
    
    //append char:)
    sql=[sql stringByAppendingString:RightParenthesis];
    
    return sql;
}

#pragma mark - about user table CRUD

#pragma mark -
-(NSString *)buildUpdateUserTbSQLWithModel:(nonnull id)userModel{
    
    sql=[NSString stringWithFormat:@"update %@ set %@ = '%@', %@ = '%@' where %@ = '%@'",UserTbName,UserTb_userName,uname,UserTb_loginToken,token,UserTb_uid,uid];
    
    NSLog(@"update sql:%@",sql);
    
    return sql;
}

-(NSString *)buildInsertUserTbSQLWithModel:(nonnull MTUserEntity *)userModel{
    
    sql=[NSString stringWithFormat:@"insert into %@(%@,%@,%@) values('%@','%@','%@')",UserTbName,UserTb_uid,UserTb_userName,UserTb_loginToken,uid,uname,token];
    
    NSLog(@"insert sql:%@",sql);
    
    return sql;
}

#pragma mark -

@end

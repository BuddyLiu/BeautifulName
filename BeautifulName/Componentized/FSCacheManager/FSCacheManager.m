//
//  FSCacheManager.m
//  ComponentizedFramework
//
//  Created by Paul on 2018/11/30.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "FSCacheManager.h"

#define NameKey @"7Dhyysj7as2DsDDL"

@interface FSCacheManager()

@property (nonatomic, assign) FSCacheType fsCacheType;

@end

@implementation FSCacheManager

+(FSCacheManager *)sharedManager
{
    static FSCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FSCacheManager alloc] init];
    });
    return manager;
}

-(void)saveData:(NSData *)data name:(NSString *)name cacheType:(FSCacheType)cacheType successBlock:(FSCacheManagerDidSuccessSaveCache)successBlock failBlock:(FSCacheManagerDidFailSaveCache)failBlock
{
    self.fsCacheType = cacheType;
    NSString *fullPath = [FSCachePath pathWithType:_fsCacheType fileName:name];
    NSLog(@"%@", fullPath);
    BOOL isSuccess = [data writeToFile:fullPath atomically:YES];
    if(!isSuccess)
    {
        failBlock(@"文件写入失败");
    }
    else
    {
        successBlock(@"文件写入成功！", data, fullPath);
    }
}

-(void)searchDataWithName:(NSString *)name cacheType:(FSCacheType)cacheType successBlock:(FSCacheManagerDidSuccessSaveCache)successBlock failBlock:(FSCacheManagerDidFailSaveCache)failBlock
{
    self.fsCacheType = cacheType;
    NSString *fullPath = [FSCachePath pathWithType:_fsCacheType fileName:name];
    NSLog(@"%@", fullPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:fullPath])
    {
        failBlock(@"文件读取失败，文件不存在");
    }
    else
    {
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        if(data)
        {
            successBlock(@"读取成功", data, fullPath);
        }
        else
        {
            failBlock(@"文件读取失败，内容为空");
        }
    }
}

-(void)clearAllCache
{
    NSString *cachePath = [FSCachePath CachePath];
    [self deleteFileWithPath:cachePath];
}

-(void)clearCacheWithCacheType:(FSCacheType)cactheType
{
    self.fsCacheType = cactheType;
    [self deleteFileWithPath:[FSCachePath pathWithType:_fsCacheType]];
}

-(void)clearCacheWithName:(NSString *)name cacheType:(FSCacheType)cactheType
{
    self.fsCacheType = cactheType;
    [self deleteFileWithPath:[NSString stringWithFormat:@"%@/%@", [FSCachePath pathWithType:_fsCacheType], name]];
}

-(void)deleteFileWithPath:(NSString *)path
{
    if([self isDirectory:path])
    {
        NSArray *foldersPathArr = [[NSFileManager defaultManager ] subpathsAtPath:path];
        for (int i = 0; i < foldersPathArr.count; i++)
        {
            [self deleteFileWithPath:[NSString stringWithFormat:@"%@/%@", path, foldersPathArr[i]]];
        }
    }
    else
    {
        NSError *error = nil;
        //获取文件全路径
        if ([[NSFileManager defaultManager ] isDeletableFileAtPath:path])
        {
            [[NSFileManager defaultManager ] removeItemAtPath:path error:&error];
            NSLog(@"%@", error.localizedDescription);
        }
    }
}

- (BOOL)isDirectory:(NSString *)filePath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

@end

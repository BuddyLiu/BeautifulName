//
//  FSCachePath.m
//  ComponentizedFramework
//
//  Created by Paul on 2018/11/30.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "FSCachePath.h"

#define PathNames (@[@"FS_General", @"FS_UserInfo", @"FS_Setting", @"FS_RequestData", @"FS_Customize", @"FS_Image", @"FS_Audio", @"FS_Video", @"FS_State"])

@implementation FSCachePath

+(NSString *)HomePath
{
    return NSHomeDirectory();
}

+(NSString *)TmpPath
{
    return NSTemporaryDirectory();
}

+(NSString *)DocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [paths objectAtIndex:0];
}

+(NSString *)CachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+(NSString *)pathWithType:(FSCacheType)type
{
    return [FSCachePath checkIsExistPath:[[FSCachePath CachePath] stringByAppendingPathComponent:PathNames[(NSInteger)type]]];
}

+(NSString *)pathWithType:(FSCacheType)type fileName:(NSString *)name
{
    return [NSString stringWithFormat:@"%@/%@", [FSCachePath checkIsExistPath:[[FSCachePath CachePath] stringByAppendingPathComponent:PathNames[(NSInteger)type]]], name];
}

+(NSString *)checkIsExistPath:(NSString *)path
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end

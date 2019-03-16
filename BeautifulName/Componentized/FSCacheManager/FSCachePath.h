//
//  FSCachePath.h
//  ComponentizedFramework
//
//  Created by Paul on 2018/11/30.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FSCacheTypeGeneral, //通用缓存数据
    FSCacheTypeUserInfo, //用户缓存数据
    FSCacheTypeSetting, //用户设置缓存数据
    FSCacheTypeRequestData, //请求数据缓存数据
    FSCacheTypeCustomize, //自定义模型缓存数据
    FSCacheTypeImage, //图片缓存数据
    FSCacheTypeAudio, //音频缓存数据
    FSCacheTypeVideo, //视频缓存数据
    FSCacheTypeState, //App状态缓存数据
} FSCacheType;

NS_ASSUME_NONNULL_BEGIN

@interface FSCachePath : NSObject

//根路径
+(NSString *)HomePath;

//临时缓存路径
+(NSString *)TmpPath;

//Document路径
+(NSString *)DocumentPath;

//缓存路径
+(NSString *)CachePath;

//根据类型返回路径
+(NSString *)pathWithType:(FSCacheType)type;

//根据类型返回路径,追加文件名
+(NSString *)pathWithType:(FSCacheType)type fileName:(NSString *)name;

//检查是否存在路径，不存在时自动创建
+(NSString *)checkIsExistPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

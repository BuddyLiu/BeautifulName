//
//  FSCacheManager.h
//  ComponentizedFramework
//
//  Created by Paul on 2018/11/30.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCachePath.h"

typedef void(^FSCacheManagerDidSuccessSaveCache)(NSString *message, NSData *data, NSString *path);
typedef void(^FSCacheManagerDidFailSaveCache)(NSString *message);

NS_ASSUME_NONNULL_BEGIN

@interface FSCacheManager : NSObject

+(FSCacheManager *)sharedManager;

-(void)saveData:(NSData *)data name:(NSString *)name cacheType:(FSCacheType)cacheType successBlock:(FSCacheManagerDidSuccessSaveCache)successBlock failBlock:(FSCacheManagerDidFailSaveCache)failBlock;
-(void)searchDataWithName:(NSString *)name cacheType:(FSCacheType)cacheType successBlock:(FSCacheManagerDidSuccessSaveCache)successBlock failBlock:(FSCacheManagerDidFailSaveCache)failBlock;

-(void)clearAllCache;
-(void)clearCacheWithCacheType:(FSCacheType)cactheType;
-(void)clearCacheWithName:(NSString *)name cacheType:(FSCacheType)cactheType;

@end

NS_ASSUME_NONNULL_END

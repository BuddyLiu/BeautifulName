//
//  NameRequestTool.m
//  BeautifulName
//
//  Created by Paul on 2019/3/13.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "NameRequestTool.h"
#import "FSCacheManager.h"

static NSString *namesUrl = @"http://18.216.203.212/Doc";
static NSString *allNames = @"all_names.txt";
static NSString *allNamesDetail = @"all_names_detail.txt";
static NSString *cnBoyNameWord = @"cn_boy_name_word.txt";
static NSString *cnGirlNameWord = @"cn_girl_name_word.txt";
static NSString *cnAllFirstName = @"cn_all_first_name.txt";

@implementation NameRequestTool

DEF_SINGLETON(NameRequestTool)

-(void)preRequestData {
    //提前请求所有数据，并缓存下来
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakSelf requestAllNamesDetailNamesArrBlock:^(NSArray * _Nonnull arr) {
            
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakSelf requestAllNamesNamesArrBlock:^(NSArray * _Nonnull arr) {
            
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakSelf requestWithGender:YES namesArrBlock:^(NSArray * _Nonnull arr) {
            
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakSelf requestWithGender:NO namesArrBlock:^(NSArray * _Nonnull arr) {
            
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakSelf requestCNAllFirstNameNamesArrBlock:^(NSArray * _Nonnull arr) {
            
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
    });
}

-(void)requestWithFileName:(NSString *)fileName NamesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock {
    [[FSCacheManager sharedManager] searchDataWithName:fileName cacheType:(FSCacheTypeGeneral) successBlock:^(NSString *message, NSData *data, NSString *path) {
        NSArray *arr;
        if(data) {
            arr = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            if(arr.count > 0) {
                block(arr);
            } else {
                arr = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", namesUrl, fileName]]];
                block(arr);
                [[FSCacheManager sharedManager] saveData: [NSKeyedArchiver archivedDataWithRootObject:arr] name:fileName cacheType:(FSCacheTypeGeneral) successBlock:^(NSString *message, NSData *data, NSString *path) {
                    
                } failBlock:^(NSString *message) {
                    errorBlock(message);
                }];
            }
        } else {
            arr = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", namesUrl, fileName]]];
            block(arr);
            [[FSCacheManager sharedManager] saveData: [NSKeyedArchiver archivedDataWithRootObject:arr] name:fileName cacheType:(FSCacheTypeGeneral) successBlock:^(NSString *message, NSData *data, NSString *path) {
                
            } failBlock:^(NSString *message) {
                errorBlock(message);
            }];
        }
    } failBlock:^(NSString *message) {
        NSArray *arr = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", namesUrl, fileName]]];
        block(arr);
        [[FSCacheManager sharedManager] saveData: [NSKeyedArchiver archivedDataWithRootObject:arr] name:fileName cacheType:(FSCacheTypeGeneral) successBlock:^(NSString *message, NSData *data, NSString *path) {
            
        } failBlock:^(NSString *message) {
            errorBlock(message);
        }];
    }];
}

-(void)requestAllNamesNamesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock {
    [self requestWithFileName:allNames NamesArrBlock:block errorBlock:errorBlock];
}

-(void)requestAllNamesDetailNamesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock {
    [self requestWithFileName:allNamesDetail NamesArrBlock:block errorBlock:errorBlock];
}

-(void)requestNamesDetailWithWord:(NSString *)word namesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock {
    [self requestWithFileName:[NSString stringWithFormat:@"%@_names_detail.txt", word] NamesArrBlock:block errorBlock:errorBlock];
}

-(void)requestWithGender:(BOOL)isBoy namesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock {
    if(isBoy) {
        [self requestWithFileName:cnBoyNameWord NamesArrBlock:block errorBlock:errorBlock];
    } else {
        [self requestWithFileName:cnGirlNameWord NamesArrBlock:block errorBlock:errorBlock];
    }
}

-(void)requestCNAllFirstNameNamesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock {
    [self requestWithFileName:cnAllFirstName NamesArrBlock:block errorBlock:errorBlock];
}

@end

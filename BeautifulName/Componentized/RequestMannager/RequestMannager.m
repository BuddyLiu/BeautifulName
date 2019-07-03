//
//  RequestMannager.m
//  ComponentizedFramework
//
//  Created by Paul on 2018/8/24.
//  Copyright © 2018年 Paul. All rights reserved.
//

#import "RequestMannager.h"
#import "RequestHelper.h"

@interface RequestMannager()

@end

@implementation RequestMannager

DEF_SINGLETON(RequestMannager);

-(AFHTTPSessionManager *)requestWithRequestKey:(NSString *)requestKey param:(NSDictionary *)param CompletionBlock:(RMQueryCompletionBlock)completionBlock failBlock:(RMQueryFailBlock)failBlock
{
    RequestHelper *requestHelper = [[RequestHelper alloc] init];
    AFHTTPSessionManager *manager = [[GeneralTool sharedInstance] sharedAFManager];
    NSLog(@"__requestHeader:\n%@", manager.requestSerializer.HTTPRequestHeaders);
    [requestHelper requestWithManager:manager key:requestKey parameter:param completion:^(id responseObject) {
        if(responseObject) {
            if(completionBlock) {
                completionBlock(responseObject);
            }
        } else {
            NSError *error = [[NSError alloc] init];
            [error.userInfo setValue:[NSString stringWithFormat:@"get请求失败(key:%@,param:%@)，返回数据：%@", requestKey, param, responseObject] forKey:NSLocalizedDescriptionKey];
            if(failBlock) {
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock) {
            failBlock(error);
        }
    }];
    return manager;
}

-(AFHTTPSessionManager *)postWithRequestKey:(NSString *)requestKey param:(NSDictionary *)param CompletionBlock:(RMQueryCompletionBlock)completionBlock failBlock:(RMQueryFailBlock)failBlock
{
    RequestHelper *requestHelper = [[RequestHelper alloc] init];
    AFHTTPSessionManager *manager = [[GeneralTool sharedInstance] sharedAFManager];
    [requestHelper postWithManager:manager key:requestKey parameter:param completion:^(id responseObject) {
        if(responseObject) {
            if(completionBlock) {
                completionBlock(responseObject);
            }
        } else {
            NSError *error = [[NSError alloc] init];
            [error.userInfo setValue:[NSString stringWithFormat:@"post请求失败(key:%@,param:%@)，返回数据：%@", requestKey, param, responseObject] forKey:NSLocalizedDescriptionKey];
            if(failBlock) {
                failBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if(failBlock) {
            failBlock(error);
        }
    }];
    return manager;
}

@end

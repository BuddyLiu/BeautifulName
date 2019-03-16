//
//  RecordTool.m
//  QHWallet
//
//  Created by Paul on 2018/8/29.
//  Copyright © 2018年 QingHu. All rights reserved.
//

#import "RecordTool.h"

#define HttpRequestKeyRecordClickAction @"/1.0/tracker/RecordClickAction" //追踪统计接口
#define HttpRequestKeyRecordBrowse @"/1.0/contents/RecordBrowse" //记录产品浏览记录

@interface RecordTool()

@end

@implementation RecordTool

static RecordTool *recordTool = nil;

+(RecordTool *)sharedRecordTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recordTool = [[RecordTool alloc] init];
    });
    return recordTool;
}

//点击列表产品
-(void)clickProductRecordWithPid:(NSString *)pid
{
    pid = pid?pid:@"clickProductRecordWithPid";
    [self clickRecordWithParam:[self dealDicWithType:@"1" otherParam:@{@"Extend1":pid}]];
}

//点击Banner
-(void)clickBannerRecordWithPid:(NSString *)pid
{
    pid = pid?pid:@"clickBannerRecordWithPid";
    [self clickRecordWithParam:[self dealDicWithType:@"2" otherParam:@{@"Extend1":pid}]];
}

//搜索产品
-(void)searchProductRecordWithMoney:(NSString *)money date:(NSString *)date
{
    money = money?money:@"";
    date = date?date:@"";
    [self clickRecordWithParam:[self dealDicWithType:@"3" otherParam:@{@"Extend1":money?money:@"", @"Extend2":date?date:@""}]];
}

//进入详情页
-(void)openDetailViewRecordWithPid:(NSString *)pid
{
    pid = pid?pid:@"openDetailViewRecordWithPid";
    [self clickRecordWithRequestKey:HttpRequestKeyRecordBrowse param:@{@"pid":pid?pid:@"", @"SessionId":DefaultSessionId, @"resource":Resource_Type}];
}

//进入登录页面
-(void)openLoginView
{
    [self clickRecordWithParam:[self dealDicWithType:@"5" otherParam:@{}]];
}

//进入注册页面
-(void)openRegistView
{
    [self clickRecordWithParam:[self dealDicWithType:@"6" otherParam:@{}]];
}

//点击通告栏
-(void)clickNotiRecordWithPid:(NSString *)pid
{
    pid = pid?pid:@"clickNotiRecordWithPid";
    [self clickRecordWithParam:[self dealDicWithType:@"7" otherParam:@{@"Extend1":pid}]];
}

//点击新口子入口
-(void)clickNewRecord
{
    [self clickRecordWithParam:[self dealDicWithType:@"8" otherParam:@{}]];
}

//点击高通过率入口
-(void)clickHighRecord
{
    [self clickRecordWithParam:[self dealDicWithType:@"9" otherParam:@{}]];
}

//第三方页面停留
-(void)accountTimeRecordWithPid:(NSString *)pid duration:(NSString *)duration startTime:(NSString *)startTime endTime:(NSString *)endTime
{
    pid = pid?pid:@"accountTimeRecordWithPid";
    duration = duration?duration:@"";
    startTime = startTime?startTime:@"";
    endTime = endTime?endTime:@"";
    [self clickRecordWithParam:[self dealDicWithType:@"10" otherParam:@{@"Extend1":pid, @"Extend2":duration, @"Extend3":startTime, @"Extend4":endTime}]];
}

//点击首页弹出推荐
-(void)clickOpenshowRecordWithPid:(NSString *)pid
{
    pid = pid?pid:@"clickOpenshowRecordWithPid";
    [self clickRecordWithParam:[self dealDicWithType:@"11" otherParam:@{@"Extend1":pid}]];
}

//点击今日推荐入口
-(void)clickTodayRecomendRecordWithPid:(NSString *)pid
{
    pid = pid?pid:@"clickTodayRecomendRecordWithPid";
    [self clickRecordWithParam:[self dealDicWithType:@"12" otherParam:@{@"Extend1":pid}]];
}

//点击今日推荐入口
-(void)clickCardRecordWithPid:(NSString *)pid
{
    pid = pid?pid:@"clickCardRecordWithPid";
    [self clickRecordWithParam:[self dealDicWithType:@"13" otherParam:@{@"Extend1":pid}]];
}


-(NSDictionary *)dealDicWithType:(NSString *)type otherParam:(NSDictionary *)otherParam
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"Sessionid":DefaultSessionId, @"ActionClickType":type, @"resource":Resource_Type}];
    for (int i = 0; i < [otherParam allKeys].count; i++)
    {
        [dic setObject:[otherParam allValues][i] forKey:[otherParam allKeys][i]];
    }
    return [dic copy];
}

-(void)clickRecordWithParam:(NSDictionary *)param
{
    if(![DefaultSessionId isEqual:@""])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postWithManager:[AFHTTPSessionManager new] url:[NSString stringWithFormat:@"%@%@", BaseUrl, HttpRequestKeyRecordClickAction] parameter:param];
        });
    }
}

-(void)clickRecordWithRequestKey:(NSString *)requestKey param:(NSDictionary *)param
{
    if(![DefaultSessionId isEqual:@""])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postWithManager:[AFHTTPSessionManager new] url:[NSString stringWithFormat:@"%@%@", BaseUrl, requestKey] parameter:param];
        });
    }
}

- (AFHTTPSessionManager *)postWithManager:(AFHTTPSessionManager *)manager
                                      url:(NSString *)url
                                parameter:(NSDictionary *)parameter
{
    ASNetworkActivityTaskDidStart();
    
    NSLog(@"__url:%@\n__parameter:%@\n", url, parameter);
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"AppTerminalType"];
    [manager.requestSerializer setValue:AppVersion forHTTPHeaderField:@"AppVersion"];
    [manager.requestSerializer setValue:@"appstore" forHTTPHeaderField:@"AppChannel"];
    [manager.requestSerializer setValue:AppBundleIdentifier forHTTPHeaderField:@"AppPackageName"];
    [manager.requestSerializer setValue:AppNameEncoding forHTTPHeaderField:@"AppName"];
    [manager.requestSerializer setValue:[UUID getUUID] forHTTPHeaderField:@"UniqueId"];
    [manager.requestSerializer setValue:DefaultSessionId forHTTPHeaderField:@"SessionId"];
    [manager.requestSerializer setValue:[USERDEFAULTS objectForKey:@"User-Agent"] forHTTPHeaderField:@"User-Agent"];
    
    [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"__POST进度:%.2f%@", ((uploadProgress.completedUnitCount*1.0)/(uploadProgress.totalUnitCount*1.0))*100, @"%");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ASNetworkActivityTaskDidFinish();
        NSLog(@"__responseObject:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ASNetworkActivityTaskDidFinish();
        NSLog(@"__error:%@", error);
    }];
    return manager;
}

@end

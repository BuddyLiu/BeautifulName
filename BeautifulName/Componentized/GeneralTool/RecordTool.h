//
//  RecordTool.h
//  QHWallet
//
//  Created by Paul on 2018/8/29.
//  Copyright © 2018年 QingHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordTool : NSObject

//单例
+(RecordTool *)sharedRecordTool;

//点击列表产品
-(void)clickProductRecordWithPid:(NSString *)pid;

//点击Banner
-(void)clickBannerRecordWithPid:(NSString *)pid;

//搜索产品
-(void)searchProductRecordWithMoney:(NSString *)money date:(NSString *)date;

//进入详情页
-(void)openDetailViewRecordWithPid:(NSString *)pid;

//进入登录页面
-(void)openLoginView;

//进入注册页面
-(void)openRegistView;

//点击通告栏
-(void)clickNotiRecordWithPid:(NSString *)pid;

//点击新口子入口
-(void)clickNewRecord;

//点击高通过率入口
-(void)clickHighRecord;

//第三方页面停留
-(void)accountTimeRecordWithPid:(NSString *)pid duration:(NSString *)duration startTime:(NSString *)startTime endTime:(NSString *)endTime;

//点击首页弹出推荐
-(void)clickOpenshowRecordWithPid:(NSString *)pid;

//点击今日推荐入口
-(void)clickTodayRecomendRecordWithPid:(NSString *)pid;

//点击今日推荐入口
-(void)clickCardRecordWithPid:(NSString *)pid;

@end

//
//  RequestMannager.h
//  ComponentizedFramework
//
//  Created by Paul on 2018/8/24.
//  Copyright © 2018年 Paul. All rights reserved.
//

/**
 * 具体的请求管理器，如有新的接口需要对接，请在此类添加新的方法
 **/

#import <Foundation/Foundation.h>

#define RequestKey_checkUpdate @"/1.0/contents/CheckAppUpdate" //检查更新
#define RequestKey_checkLogin @"/1.0/account/CheckLogin" //检查登录状态

#define RequestKey_Verifyimgcode @"/1.0/account/VerifyImgCode" //获取图形验证码
#define RequestKey_Sendloginvcode @"/1.0/account/SendLoginVICode" //获取短信验证码
#define RequestKey_LoginByVCode @"/1.0/account/LoginByVCode" //使用验证码登录
#define RequestKey_SendLoginByVCode @"/1.0/account/SendLoginCode" //发送免密登陆验证码(验签)

#define RequestKey_Products @"/1.0/contents/Products" //获取产品列表
#define RequestKey_HomePageInfo @"/1.0/contents/HomePageInfo" //获取首页基础数据,包括轮播图和下面的新闻
#define RequestKey_GlobalConfigInfo @"/1.0/Contents/GlobalConfigInfo" // 获取全局配置信息
#define RequestKey_ProductDetail @"/1.0/contents/Product" //获取产品详情信息
#define RequestKey_CheckUnionLogin @"/1.0/contents/CheckUnionLogin" //获取联合登陆信息

#define RequestKey_LoginOut @"/1.0/account/LoginOut" //退出登录
#define RequestKey_FeedBack @"/1.0/account/FeedBack" //提交反馈意见
#define RequestKey_ModifyAccount @"/1.0/account/ModifyAccount" //修改昵称
#define RequestKey_FindPwd @"/1.0/account/FindPwd" //找回密码
#define RequestKey_SendFindVCode @"/1.0/account/SendFindVCode" //发送找回密码验证码
#define RequestKey_UploadAvatar @"/1.0/account/UploadAvatar" //上传头像
#define RequestKey_RecordBrowses @"/1.0/contents/RecordBrowses" //获取历史访问记录

typedef void (^RMQueryProcessBlock)(NSProgress *process);
typedef void (^RMQueryCompletionBlock)(id responseObject);
typedef void (^RMQueryFailBlock)(NSError *error);

@interface RequestMannager : NSObject

GD_SINGLETON(RequestMannager);

/**
 检查版本更新

 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)checkVersionUpdateCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                                 failBlock:(RMQueryFailBlock)failBlock;

/**
 请求避审信息

 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)requestFuturesDataCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                                 failBlock:(RMQueryFailBlock)failBlock;

/**
 检查登录状态
 
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)checkLoginStateCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock;

/**
 获取产品

 @param param 参数字典（此处使用字典是为了适应产品请求的参数不确定，不在细分）
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)requestProductsWithParam:(NSDictionary *)param
                                  completionBlock:(RMQueryCompletionBlock)completionBlock
                                        failBlock:(RMQueryFailBlock)failBlock;

/**
 获取首页基础数据

 @param param 参数字典（此处使用字典是为了适应产品请求的参数不确定，不在细分）
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)requestHomePageInfoParam:(NSDictionary *)param
                                  completionBlock:(RMQueryCompletionBlock)completionBlock
                                        failBlock:(RMQueryFailBlock)failBlock;

/**
 获取全局配置信息

 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)requestGlobalInfoCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                                failBlock:(RMQueryFailBlock)failBlock;

/**
 获取产品详情

 @param pid 产品id
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)requestProductDetailWithPid:(NSString *)pid
                                     completionBlock:(RMQueryCompletionBlock)completionBlock
                                           failBlock:(RMQueryFailBlock)failBlock;

/**
 获取联合登录数据
 
 @param pid 产品id
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)requestCheckUnionLoginWithPid:(NSString *)pid
                                       completionBlock:(RMQueryCompletionBlock)completionBlock
                                             failBlock:(RMQueryFailBlock)failBlock;
/**
 登录
 手机号，密码必须填写，图形验证码选填（没有图形验证码传空字符串）
 @param phoneNum 手机号
 @param password 密码
 @param picCode 图形验证码，选填
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)loginRequestWithPhoneNum:(NSString *)phoneNum
                                         password:(NSString *)password
                                          picCode:(NSString *)picCode
                                  completionBlock:(RMQueryCompletionBlock)completionBlock
                                        failBlock:(RMQueryFailBlock)failBlock;

/**
 获取图形验证码

 @param mobile 手机号
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)requestVerifyImgCodeWithMobile:(NSString *)mobile
                                     completionBlock:(RMQueryCompletionBlock)completionBlock
                                           failBlock:(RMQueryFailBlock)failBlock;

/**
 获取短信验证码

 @param mobile 手机号
 @param imgCode 图形验证码
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)postSendLoginVCodeWithMobile:(NSString *)mobile
                                              imgCode:(NSString *)imgCode
                                      completionBlock:(RMQueryCompletionBlock)completionBlock
                                            failBlock:(RMQueryFailBlock)failBlock;

/**
 使用短信验证码登录

 @param mobile 手机号
 @param vcode 短信验证码
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)postLoginByVCodeWithMobile:(NSString *)mobile
                                              vcode:(NSString *)vcode
                                    completionBlock:(RMQueryCompletionBlock)completionBlock
                                          failBlock:(RMQueryFailBlock)failBlock;


/**
 退出登录

 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)logOutCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                     failBlock:(RMQueryFailBlock)failBlock;
/**
 反馈
 
 @param content 反馈的内容
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)feedBackWithContent:(NSString *)content
                             completionBlock:(RMQueryCompletionBlock)completionBlock
                                   failBlock:(RMQueryFailBlock)failBlock;

/**
 修改昵称

 @param nickName 新昵称
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */

-(AFHTTPSessionManager *)modifyAccountWithNickName:(NSString *)nickName
                                   completionBlock:(RMQueryCompletionBlock)completionBlock
                                         failBlock:(RMQueryFailBlock)failBlock;

/**
 找回密码

 @param mobile 手机号
 @param pwd 新密码
 @param confirmPwd 确认密码
 @param VCode 短信验证码
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)findPwdWithMobile:(NSString *)mobile
                                       pwd:(NSString *)pwd
                                confirmPwd:(NSString *)confirmPwd
                                     VCode:(NSString *)VCode
                           completionBlock:(RMQueryCompletionBlock)completionBlock
                                 failBlock:(RMQueryFailBlock)failBlock;

/**
 获取找回密码验证码

 @param mobile 手机号
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)sendFindVCodeWithMobile:(NSString *)mobile
                                 completionBlock:(RMQueryCompletionBlock)completionBlock
                                       failBlock:(RMQueryFailBlock)failBlock;

/**
 上传头像

 @param imageBase64Str 图片转base64字符串
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)uploadAvatarWithImageBase64Str:(NSString *)imageBase64Str
                                        completionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock;

/**
 获取访问记录

 @param pageIndex 当前页
 @param pageNo 每页返回条数
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)requestRecordBrowsesWithPageIndex:(NSInteger)pageIndex
                                                    pageNo:(NSInteger)pageNo
                                           completionBlock:(RMQueryCompletionBlock)completionBlock
                                                 failBlock:(RMQueryFailBlock)failBlock;

/**
 获取短信验证码
 
 @param mobile 手机号
 @param completionBlock 完成回调
 @param failBlock 失败回调
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)postSendLoginByVCodeWithMobile:(NSString *)mobile
                                        completionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock;

-(AFHTTPSessionManager *)requestNameWithCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock;
@end

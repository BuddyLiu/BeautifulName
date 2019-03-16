//
//  RequestMannager.m
//  ComponentizedFramework
//
//  Created by Paul on 2018/8/24.
//  Copyright © 2018年 Paul. All rights reserved.
//

#import "RequestMannager.h"
#import "RequestHelper.h"
#import "ShowMessageView.h"

@interface RequestMannager()

@property (nonatomic, strong) ShowMessageView *showMessageView;

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

//检版本查更新
-(AFHTTPSessionManager *)checkVersionUpdateCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                                 failBlock:(RMQueryFailBlock)failBlock
{
    return [self requestWithRequestKey:RequestKey_checkUpdate
                                 param:@{@"t":@"iOS", @"P":AppBundleIdentifier, @"V":AppVersion}
                       CompletionBlock:^(id responseObject) {
                           if(completionBlock) {
                               completionBlock(responseObject);
                           }
                       } failBlock:^(NSError *error) {
                           if(failBlock) {
                               failBlock(error);
                           }
                       }];
}

// 请求避审接口
-(AFHTTPSessionManager *)requestFuturesDataCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                                 failBlock:(RMQueryFailBlock)failBlock
{
    RequestHelper *requestHelper = [[RequestHelper alloc] init];
    AFHTTPSessionManager *manager = [[GeneralTool sharedInstance] sharedAFManager];
    [requestHelper requestWithManager:manager
                                  url:FuturesURL
                            parameter:@{}
                              process:nil
                           completion:^(id responseObject) {
                               if(completionBlock) {
                                   completionBlock(responseObject);
                               }
                           } failure:^(NSError *error) {
                               if(failBlock) {
                                   failBlock(error);
                               }
                           }];
    
    return manager;
}

// 检查登录状态
-(AFHTTPSessionManager *)checkLoginStateCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_checkLogin
                              param:@{@"SessionId":DefaultSessionId}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

// 请求产品
-(AFHTTPSessionManager *)requestProductsWithParam:(NSDictionary *)param
                                  completionBlock:(RMQueryCompletionBlock)completionBlock
                                        failBlock:(RMQueryFailBlock)failBlock {
    return [self requestWithRequestKey:RequestKey_Products
                                 param:param
                       CompletionBlock:^(id responseObject) {
                           if(completionBlock) {
                               completionBlock(responseObject);
                           }
                       } failBlock:^(NSError *error) {
                           if(failBlock) {
                               failBlock(error);
                           }
                       }];
}

// 获取首页主要信息
-(AFHTTPSessionManager *)requestHomePageInfoParam:(NSDictionary *)param
                                  completionBlock:(RMQueryCompletionBlock)completionBlock
                                        failBlock:(RMQueryFailBlock)failBlock {
    return [self requestWithRequestKey:RequestKey_HomePageInfo
                                 param:param
                       CompletionBlock:^(id responseObject) {
                           if(completionBlock) {
                               completionBlock(responseObject);
                           }
                       } failBlock:^(NSError *error) {
                           if(failBlock) {
                               failBlock(error);
                           }
                       }];
}

// 获取全局配置信息
-(AFHTTPSessionManager *)requestGlobalInfoCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                                failBlock:(RMQueryFailBlock)failBlock {
    return [self requestWithRequestKey:RequestKey_GlobalConfigInfo
                                 param:@{@"SessionId":DefaultSessionId, @"AppTerminalType":@"ios", @"AppVersion":[NSString stringWithFormat:@"%@", AppVersion], @"AppChannel":@"appstore", @"AppPackageName":AppName}
                       CompletionBlock:^(id responseObject) {
                           if(completionBlock) {
                               completionBlock(responseObject);
                           }
                       } failBlock:^(NSError *error) {
                           if(failBlock) {
                               failBlock(error);
                           }
                       }];
}

// 获取产品详情
-(AFHTTPSessionManager *)requestProductDetailWithPid:(NSString *)pid
                                     completionBlock:(RMQueryCompletionBlock)completionBlock
                                           failBlock:(RMQueryFailBlock)failBlock {
    return [self requestWithRequestKey:RequestKey_ProductDetail
                                 param:@{@"Pid":MakeSureNotNil(pid)}
                       CompletionBlock:^(id responseObject) {
                           if(completionBlock) {
                               completionBlock(responseObject);
                           }
                       } failBlock:^(NSError *error) {
                           if(failBlock) {
                               failBlock(error);
                           }
                       }];
}

// 获取联合登录数据
-(AFHTTPSessionManager *)requestCheckUnionLoginWithPid:(NSString *)pid
                                       completionBlock:(RMQueryCompletionBlock)completionBlock
                                             failBlock:(RMQueryFailBlock)failBlock {
    return [self requestWithRequestKey:RequestKey_CheckUnionLogin
                                 param:@{@"Pid":MakeSureNotNil(pid), @"sessionId":DefaultSessionId}
                       CompletionBlock:^(id responseObject) {
                           if(completionBlock) {
                               completionBlock(responseObject);
                           }
                       } failBlock:^(NSError *error) {
                           if(failBlock) {
                               failBlock(error);
                           }
                       }];
}

//获取图形验证码
-(AFHTTPSessionManager *)requestVerifyImgCodeWithMobile:(NSString *)mobile
                                        completionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock {
    return [self requestWithRequestKey:RequestKey_Verifyimgcode
                                 param:@{@"Mobile":MakeSureNotNil(mobile)}
                       CompletionBlock:^(id responseObject) {
                           if(completionBlock) {
                               completionBlock(responseObject);
                           }
                       } failBlock:^(NSError *error) {
                           if(failBlock) {
                               failBlock(error);
                           }
                       }];
}

//获取短信验证码
-(AFHTTPSessionManager *)postSendLoginVCodeWithMobile:(NSString *)mobile
                                              imgCode:(NSString *)imgCode
                                      completionBlock:(RMQueryCompletionBlock)completionBlock
                                            failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_Sendloginvcode
                              param:@{@"Mobile":MakeSureNotNil(mobile), @"VImgCode":imgCode}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

//使用图形验证码登录
-(AFHTTPSessionManager *)postLoginByVCodeWithMobile:(NSString *)mobile
                                              vcode:(NSString *)vcode
                                    completionBlock:(RMQueryCompletionBlock)completionBlock
                                          failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_LoginByVCode
                              param:@{@"mobile":MakeSureNotNil(mobile), @"vcode":vcode, @"App":AppName}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

//退出登录
-(AFHTTPSessionManager *)logOutCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                     failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_LoginOut
                              param:@{@"sessionId":DefaultSessionId}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

//反馈
-(AFHTTPSessionManager *)feedBackWithContent:(NSString *)content
                             completionBlock:(RMQueryCompletionBlock)completionBlock
                                   failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_FeedBack
                              param:@{@"sessionId":DefaultSessionId, @"Content":MakeSureNotNil(content)}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

//修改昵称
-(AFHTTPSessionManager *)modifyAccountWithNickName:(NSString *)nickName
                                   completionBlock:(RMQueryCompletionBlock)completionBlock
                                         failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_ModifyAccount
                              param:@{@"sessionId":DefaultSessionId, @"NickName":MakeSureNotNil(nickName)}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

//找回密码
-(AFHTTPSessionManager *)findPwdWithMobile:(NSString *)mobile
                                       pwd:(NSString *)pwd
                                confirmPwd:(NSString *)confirmPwd
                                     VCode:(NSString *)VCode
                           completionBlock:(RMQueryCompletionBlock)completionBlock
                                 failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_FindPwd
                              param:@{@"Mobile":mobile, @"Pwd":MakeSureNotNil(pwd), @"ConfirmPwd":MakeSureNotNil(confirmPwd), @"VCode":MakeSureNotNil(VCode)}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

//获取找回密码验证码
-(AFHTTPSessionManager *)sendFindVCodeWithMobile:(NSString *)mobile
                                 completionBlock:(RMQueryCompletionBlock)completionBlock
                                       failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_SendFindVCode
                              param:@{@"Mobile":MakeSureNotNil(mobile)}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

//上传头像
-(AFHTTPSessionManager *)uploadAvatarWithImageBase64Str:(NSString *)imageBase64Str
                                        completionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_UploadAvatar
                              param:@{@"sessionId":DefaultSessionId, @"Img":MakeSureNotNil(imageBase64Str)}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

//获取访问记录
-(AFHTTPSessionManager *)requestRecordBrowsesWithPageIndex:(NSInteger)pageIndex
                                                    pageNo:(NSInteger)pageNo
                                           completionBlock:(RMQueryCompletionBlock)completionBlock
                                                 failBlock:(RMQueryFailBlock)failBlock {
    return [self requestWithRequestKey:RequestKey_RecordBrowses
                                 param:@{@"sessionId":DefaultSessionId, @"PageIndex":[NSString stringWithFormat:@"%ld", pageIndex], @"PageNo":[NSString stringWithFormat:@"%ld", pageNo]}
                       CompletionBlock:^(id responseObject) {
                           if(completionBlock) {
                               completionBlock(responseObject);
                           }
                       } failBlock:^(NSError *error) {
                           if(failBlock) {
                               failBlock(error);
                           }
                       }];
}

-(AFHTTPSessionManager *)postSendLoginByVCodeWithMobile:(NSString *)mobile
                                        completionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock {
    return [self postWithRequestKey:RequestKey_SendLoginByVCode
                              param:@{@"Mobile":mobile}
                    CompletionBlock:^(id responseObject) {
                        if(completionBlock) {
                            completionBlock(responseObject);
                        }
                    } failBlock:^(NSError *error) {
                        if(failBlock) {
                            failBlock(error);
                        }
                    }];
}

-(AFHTTPSessionManager *)requestNameWithCompletionBlock:(RMQueryCompletionBlock)completionBlock
                                              failBlock:(RMQueryFailBlock)failBlock {
    RequestHelper *requestHelper = [[RequestHelper alloc] init];
    AFHTTPSessionManager *manager = [[GeneralTool sharedInstance] sharedAFManager];
    NSLog(@"__requestHeader:\n%@", manager.requestSerializer.HTTPRequestHeaders);
    [requestHelper requestWithManager:manager url:@"https://www.yingwenming.com/ying-wen-ming-ku/a?field_gender_value=All" parameter:@{} process:nil completion:^(id responseObject) {
        if(responseObject) {
            if(completionBlock) {
                completionBlock(responseObject);
            }
        } else {
            NSError *error = [[NSError alloc] init];
            [error.userInfo setValue:[NSString stringWithFormat:@"get请求失败, 返回数据：%@", responseObject] forKey:NSLocalizedDescriptionKey];
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

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


typedef void (^RMQueryProcessBlock)(NSProgress *process);
typedef void (^RMQueryCompletionBlock)(id responseObject);
typedef void (^RMQueryFailBlock)(NSError *error);

@interface RequestMannager : NSObject

GD_SINGLETON(RequestMannager);

@end

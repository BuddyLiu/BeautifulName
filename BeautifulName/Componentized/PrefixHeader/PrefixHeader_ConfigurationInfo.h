//
//  PrefixHeader_ConfigurationInfo.h
//  ComponentizedFramework
//
//  Created by Paul on 2018/8/23.
//  Copyright © 2018年 Paul. All rights reserved.
//

/**
 * 全局配置信息宏定义
 **/

#ifndef PrefixHeader_ConfigurationInfo_h
#define PrefixHeader_ConfigurationInfo_h

#define DefaultSessionId        ([[NSUserDefaults standardUserDefaults] objectForKey:@"SessionId"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"SessionId"]:@"")
#define MainColor               ItemColorFromRGB(0xb5b5b5)
#define MainSelectedColor       ItemColorFromRGB(0xfd5048)

#endif /* PrefixHeader_ConfigurationInfo_h */

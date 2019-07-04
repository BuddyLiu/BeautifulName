//
//  AppDelegate.h
//  BeautifulName
//
//  Created by Paul on 2019/2/27.
//  Copyright © 2019 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
//友盟
#import <UMCommon/UMCommon.h>

//极光
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

//启动选项
@property (nonatomic, strong) NSDictionary *launchOptions;

@end


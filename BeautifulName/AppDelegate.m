//
//  AppDelegate.m
//  BeautifulName
//
//  Created by Paul on 2019/2/27.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "NameRequestTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [SVProgressHUD setBorderColor:[UIColor lightGrayColor]];
    [SVProgressHUD setBorderWidth:2];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"success"]];
    [SVProgressHUD setShouldTintImages:NO];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0];
    
    //为极光推送保存launchOptions，在regeisterJPush方法使用
    self.launchOptions = launchOptions;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HomeViewController *homeViewController = NibController(HomeViewController);
    self.window.rootViewController = homeViewController;
    WEAKSELF
    [[GeneralTool sharedInstance] AFNReachabilitynetworkBlock:^(AFNetworkReachabilityStatus status) {
        [[NameRequestTool sharedInstance] preRequestData];
    } noNetworkBlock:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前无网络，请检查网络！" preferredStyle:(UIAlertControllerStyleAlert)];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSURL *appSettingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:appSettingURL]) {
                [[UIApplication sharedApplication] openURL:appSettingURL options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[NameRequestTool sharedInstance] preRequestData];
        }]];
        [weakSelf.window.rootViewController presentViewController:alertController animated:YES completion:^{
            
        }];
    }];
    
    [UMConfigure initWithAppkey:UMengKey channel:@"App Store"];
    
    // 初始化极光配置 start
    [[GeneralTool sharedInstance] regeisterJPush:self.launchOptions delegate:self];
    // 初始化极光配置 end
    
    return YES;
}

    
//极光回调方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}
    
-(void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error:%@", [NSString stringWithFormat: @"%@", error]);
}
    
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSString *content = userInfo[@"aps"][@"alert"];
    [[NSUserDefaults standardUserDefaults] setObject:content?content:@"" forKey:@"pushMessage"];
    NSString *contentStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pushMessage"] copy];
    if(contentStr && contentStr.length > 0) {
        [self showMessage:contentStr title:@"通知"];
    }
    completionHandler();  // 系统要求执行这个方法
}
    
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSString *content = userInfo[@"aps"][@"alert"];
    [[NSUserDefaults standardUserDefaults] setObject:content?content:@"" forKey:@"pushMessage"];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self showMessage:content title:@"通知"];
    }

    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

-(void)showMessage:(NSString *)message title:(NSString *)titleStr {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"pushMessage"];
    }]];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

@end

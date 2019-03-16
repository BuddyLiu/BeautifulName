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
    return YES;
}

@end

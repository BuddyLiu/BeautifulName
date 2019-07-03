//
//  SettingViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/3/12.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (strong, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end

static NSString *phoneNumber = @"13621905107";
static NSString *emailNumber = @"13621905107@163.com";

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.copyrightLabel.alpha = 0;
    self.versionLabel.alpha = 0;
    self.versionLabel.text = [NSString stringWithFormat:@"版本号：%@", AppVersion];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [[ExpandView shareInstance] dismissToController:self type:(ExpandViewAnimationTypeZoom) showEnd:^{
        
    }];
}

- (IBAction)recommendBtnAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kAppID]] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

- (IBAction)aboutBtnAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.copyrightLabel.alpha = 1;
        weakSelf.versionLabel.alpha = 1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
        STRONGSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __weak typeof(strongSelf) weakStrongSelf = strongSelf;
            [UIView animateWithDuration:0.5 animations:^{
                weakStrongSelf.copyrightLabel.alpha = 0;
                weakStrongSelf.versionLabel.alpha = 0;
            }];
        });
    });
    
}

- (IBAction)connectBtnAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"联系方式" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    WEAKSELF
    [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拨打电话（%@）", phoneNumber] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWebView *webView = [[UIWebView alloc] init];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]]];
            [strongSelf.view addSubview:webView];
        });
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拷贝电话号码" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[GeneralTool sharedInstance] copyStringToPast:phoneNumber];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"发送反馈邮件（%@）", emailNumber] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf sendEmailWithEmailNum:emailNumber title:[NSString stringWithFormat:@"反馈\"%@\"", AppName] content:@"反馈内容：\n"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拷贝邮箱" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[GeneralTool sharedInstance] copyStringToPast:emailNumber];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"不要点这个" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kAppID]] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (IBAction)moreBtnAction:(UIButton *)sender {
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", kAppID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

-(void)sendEmailWithEmailNum:(NSString *)emailNum title:(NSString *)title content:(NSString *)content {
    //创建可变的地址字符串对象
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    [mailUrl appendFormat:@"mailto:%@?", emailNum];
    //添加邮件主题
    [mailUrl appendFormat:@"&subject=%@", title];
    //添加邮件内容
    [mailUrl appendString:[NSString stringWithFormat:@"&body=%@", content]];
    //跳转到系统邮件App发送邮件
    NSString *emailPath = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:emailPath] options:@{} completionHandler:nil];
}

@end

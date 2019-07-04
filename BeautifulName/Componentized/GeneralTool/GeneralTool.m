//
//  GeneralTool.m
//  IntegralWall
//
//  Created by QingHu on 2018/6/25.
//  Copyright © 2018 QingHu. All rights reserved.
//

#import "GeneralTool.h"
#import <AdSupport/AdSupport.h>
#import <objc/runtime.h>

#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#import <sys/utsname.h>

#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AFNetworkActivityIndicatorManager.h"

@implementation GeneralTool

DEF_SINGLETON(GeneralTool)

-(UINavigationController *)createRootTabBarItemWithController:(UIViewController *)viewController
                                                        title:(NSString *)title
                                                    imageName:(NSString *)imageName
                                            selectedImageName:(NSString *)selectedImageName
                                              normalTitlColor:(UIColor *)normalTitlColor
                                           selectedTitleColor:(UIColor *)selectedTitleColor
                                                    titleFont:(NSUInteger)fontSize
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *imageSelected = [UIImage imageNamed:selectedImageName];
    imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title
                                                       image:image
                                               selectedImage:imageSelected];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalTitlColor, NSForegroundColorAttributeName, [UIFont systemFontOfSize:fontSize], NSFontAttributeName, nil]
                        forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:selectedTitleColor, NSForegroundColorAttributeName, [UIFont systemFontOfSize:fontSize], NSFontAttributeName, nil]
                        forState:UIControlStateSelected];
    
    nav.tabBarItem = item;
    return nav;
}

- (BOOL)isPhoneNum:(NSString *)phoneNum
{
    NSString *MOBILE = @"^1[3|4|5|6|7|8|9][0-9]\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNum];
}

-(UIImage *)imageWithColor:(UIColor *)aColor
{
    CGRect aFrame = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// 读取本地JSON文件
- (NSDictionary *)readLocalFileWithName:(NSString *)name
{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)resignFirstResponder
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)to:nil from:nil forEvent:nil];
}

static AFHTTPSessionManager *manager;
-(AFHTTPSessionManager *)sharedAFManager
{
    return [self createManagerHeader:[AFHTTPSessionManager manager]];
}

/**
 * 统一设置请求头
 */
-(AFHTTPSessionManager *)createManagerHeader:(AFHTTPSessionManager *)manager
{
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];

    return manager;
}


-(NSString *)transportNumberToUnit:(NSInteger)num
{
    if(num/10000 > 0)
    {
        return [NSString stringWithFormat:@"%ld万", num/10000];
    }
    else if(num/1000 > 0)
    {
        return [NSString stringWithFormat:@"%ld千", num/1000];
    }
    else if(num/100 > 0)
    {
        return [NSString stringWithFormat:@"%ld百", num/100];
    }
    else if(num/10 > 0)
    {
        return [NSString stringWithFormat:@"%ld十", num/10];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld", num];
    }
}

#pragma mark ---- 检测更新版本
- (void)updateApp
{
    // kAPP_URL : @"http://itunes.apple.com/lookup?id=";
    //  kAppID : 在iTunes connect上申请的APP ID;
    NSString *urlStr = [NSString stringWithFormat:@"%@", kAPP_URL(kAppID)];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //网络请求
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err;
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        if(data)
        {
            NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            NSArray *resultArray = [appInfoDict objectForKey:@"results"];
            if (![resultArray count]) {
                NSLog(@"error : resultArray == nil");
                return;
            }
            NSDictionary *infoDict = [resultArray objectAtIndex:0];
            //获取服务器上应用的最新版本号
            NSString *updateVersion = infoDict[@"version"];
            //updateVersionUrl: 更新的时候用到的地址
            self.updateVersionUrl = infoDict[@"trackViewUrl"];
            //获取当前设备中应用的版本号
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            //判断两个版本是否相同
            if ([currentVersion doubleValue] < [updateVersion doubleValue]) {
                NSString *messageStr = [NSString stringWithFormat:@"发现新版本（%@）,是否更新", updateVersion];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }];
    [task resume];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //点击”升级“按钮，就从打开app store上应用的详情页面
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateVersionUrl]];
    }
}

/**
 对字典(Key-Value)排序 区分大小写
 
 @param dict 要排序的字典
 */
- (NSArray *)sortedDictionary:(NSDictionary *)dict
{
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        /**
         In the compare: methods, the range argument specifies the
         subrange, rather than the whole, of the receiver to use in the
         comparison. The range is not applied to the search string.  For
         example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
         compares "A" to "ABC", not "A" to "A", and will return
         NSOrderedAscending. It is an error to specify a range that is
         outside of the receiver's bounds, and an exception may be raised.
         
         - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
//    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray)
    {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:[NSString stringWithFormat:@"%@=%@", sortsing, valueString]];
    }
    return [valueArray copy];
}

-(AppDelegate *)appdelegate
{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appdelegate;
}


- (UIColor *)colorWithHex:(int)hexNumber alpha:(CGFloat)alpha
{
    if (hexNumber > 0xFFFFFF)
    {
        return nil;
    }
    CGFloat red   = ((hexNumber >> 16) & 0xFF) / 255.0;
    CGFloat green = ((hexNumber >> 8) & 0xFF) / 255.0;
    CGFloat blue  = (hexNumber & 0xFF) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}

-(UIImage *)imageWithColor:(UIColor *)aColor size:(CGSize)size
{
    CGRect aFrame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage *)getLaunchImage
{
    NSString *viewOrientation = @"Portrait";//横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, CGSizeMake(ScreenWidth, ScreenHeight)) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return  [UIImage imageNamed:launchImage];
}

-(UINavigationController *)generateNavViewController:(UIViewController *)viewController
{
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:viewController];
    return nav;
}

- (BOOL)getProxyStatus
{
    NSDictionary *proxySettings = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    NSArray *proxies = (__bridge NSArray *)CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"http://www.google.com"], (__bridge CFDictionaryRef)proxySettings);
    NSDictionary *settings = [proxies objectAtIndex:0];
    
    NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        //没有设置代理
        return NO;
    }
    else
    {
        //设置代理了
        return YES;
    }
}

- (CGFloat)getHeightWithString:(NSString *)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    if (!string.length)
    {
        return CGSizeZero.height;
    }
    
    CGSize size;
    size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    size.width += 20;
    
    return size.height;
}

- (CGFloat)getWidthWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    if (!string.length)
    {
        return CGSizeZero.height;
    }
    
    CGSize size;
    size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    size.width += 10;
    
    return size.width;
}

- (NSString *)getMacAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

- (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
}

- (NSString *)getNetconnType
{
    
    NSString *netconnType = @"";
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:// 没有网络
        {
            netconnType = @"no network";
        }
            break;
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"])
            {
                netconnType = @"GPRS";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"])
            {
                netconnType = @"2.75G EDGE";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"])
            {
                netconnType = @"3G";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"])
            {
                netconnType = @"3.5G HSDPA";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"])
            {
                netconnType = @"3.5G HSUPA";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"])
            {
                netconnType = @"2G";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"])
            {
                netconnType = @"3G";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"])
            {
                netconnType = @"3G";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"])
            {
                netconnType = @"3G";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"])
            {
                netconnType = @"HRPD";
            }
            else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"])
            {
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

//使用AFN框架来检测网络状态的改变
-(void)AFNReachabilitynetworkBlock:(NetworkReachabilityNetworkBlock)networkBlock noNetworkBlock:(NetworkReachabilityNoNetworkBlock)noNetworkBlock
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                if(noNetworkBlock)
                {
                    noNetworkBlock();
                }
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有网络");
                if(noNetworkBlock)
                {
                    noNetworkBlock();
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"3G, wifi");
                if(networkBlock)
                {
                    networkBlock(status);
                }
            }
                break;
            default:
                break;
        }
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    }];
    
    //3.开始监听
    [manager startMonitoring];
}


#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

- (BOOL)isJailBreak
{
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]])
        {
            NSLog(@"The device is jail broken!");
            return YES;
        }
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

-(UIImage *)getImageByBase64String:(NSString *)base64String
{
    // 将base64字符串转为NSData
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:[base64String stringByReplacingOccurrencesOfString:@"data:image/jpeg;base64," withString:@""] options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    // 将NSData转为UIImage
    UIImage *decodedImage = [UIImage imageWithData:decodeData];
    if(decodedImage)
    {
        return decodedImage;
    }
    else
    {
        return nil;
    }
}

-(NSString *)getCurrentTimeWithFormatStr:(NSString *)formatStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    return [formatter stringFromDate:date];
}

- (NSString *)getweekDayStringWithDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    // 1 是周日，2是周一 3.以此类推
    NSNumber * weekNumber = @([comps weekday]);
    NSInteger weekInt = [weekNumber integerValue];
    NSString *weekDayString = @"周一";
    switch (weekInt)
    {
        case 1:
        {
            weekDayString = @"周日";
        }
            break;
        case 2:
        {
            weekDayString = @"周一";
        }
            break;
        case 3:
        {
            weekDayString = @"周二";
        }
            break;
        case 4:
        {
            weekDayString = @"周三";
        }
            break;
        case 5:
        {
            weekDayString = @"周四";
        }
            break;
        case 6:
        {
            weekDayString = @"周五";
        }
            break;
        case 7:
        {
            weekDayString = @"周六";
        }
            break;
        default:
            break;
    }
    return weekDayString;
}

- (NSInteger)getweekDayIntegerWithDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    // 1 是周日，2是周一 3.以此类推
    NSNumber * weekNumber = @([comps weekday]);
    return [weekNumber integerValue];
}

-(void)copyStringToPast:(NSString *)copyStr
{
    if(copyStr && copyStr.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = copyStr;
        [SVProgressHUD showSuccessWithStatus:@"拷贝成功！"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"拷贝失败！"];
    }
}

-(void)callTelPhoneNumber:(NSString *)phoneNum
{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

//字典转字符串
-(NSString *)dicToStringWithDict:(id)dict
{
    NSString *dataStr;
    if (dict == nil) {
        dataStr = @"";
        return dataStr;
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    if (!parseError) {
        dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return MakeSureNotNil(dataStr);
}

// 判断是否是第一次登录
- (BOOL)isFirstLoad {
    NSString *key = [NSString stringWithFormat:@"%@-%@", AppBundleIdentifier, AppName];
    NSString *lastRunVersion = [USERDEFAULTS objectForKey:key];
    if (!lastRunVersion) {
        [USERDEFAULTS setObject:AppVersion forKey:key];
        return YES;
    } else if (![lastRunVersion isEqualToString:AppVersion]) {
        [USERDEFAULTS setObject:AppVersion forKey:key];
        return YES;
    }
    return NO;
}

-(void)saveUserAgent
{
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [USERDEFAULTS setObject:userAgent forKey:@"User-Agent"];
}

-(void)addBlankViewToView:(UIView *)view title:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image
{
    [view removeAllSubviews];
    UIView *backView = [view viewWithTag:1235679];
    [backView removeFromSuperview];
    UILabel *titleLabel = [view viewWithTag:12356790];
    [titleLabel removeFromSuperview];
    UILabel *subTitleLabel = [view viewWithTag:12356791];
    [subTitleLabel removeFromSuperview];
    UIImageView *messageImageView = [view viewWithTag:12356790];
    [messageImageView removeFromSuperview];
    
    UIView *blankBackView = [[UIView alloc] initWithFrame:view.bounds];
    blankBackView.tag = 1235679;
    blankBackView.backgroundColor = [UIColor whiteColor];
    [view addSubview:blankBackView];
    
    UILabel *blankTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height/3.0, view.frame.size.width, 20)];
    blankTitleLabel.tag = 12356790;
    blankTitleLabel.backgroundColor = [UIColor whiteColor];
    blankTitleLabel.textAlignment = NSTextAlignmentCenter;
    blankTitleLabel.textColor = [UIColor blackColor];
    blankTitleLabel.font = kSysFontSize(15);
    blankTitleLabel.text = title;
    [blankBackView addSubview:blankTitleLabel];
    
    UILabel *blankSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(blankTitleLabel.frame) + 10, view.frame.size.width, 20)];
    blankSubTitleLabel.tag = 12356791;
    blankSubTitleLabel.backgroundColor = [UIColor whiteColor];
    blankSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    blankSubTitleLabel.textColor = ItemColorFromRGB(0x666666);
    blankSubTitleLabel.font = kSysFontSize(13);
    blankSubTitleLabel.text = subTitle;
    blankSubTitleLabel.numberOfLines = 0;
    [blankBackView addSubview:blankSubTitleLabel];
    
    UIImageView *blankImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width-80)/2.0, CGRectGetMinY(blankTitleLabel.frame) - 85, 80, 80)];
    blankImageView.image = image;
    [blankBackView addSubview:blankImageView];
    
    [view bringSubviewToFront:blankBackView];
    [blankBackView bringSubviewToFront:blankTitleLabel];
    [blankBackView bringSubviewToFront:blankSubTitleLabel];
    [blankBackView bringSubviewToFront:blankImageView];
}

-(void)removeBlankViewFromView:(UIView *)view
{
    UIView *backView = [view viewWithTag:1235679];
    [backView removeFromSuperview];
    UILabel *titleLabel = [view viewWithTag:12356790];
    [titleLabel removeFromSuperview];
    UILabel *subTitleLabel = [view viewWithTag:12356791];
    [subTitleLabel removeFromSuperview];
    UIImageView *messageImageView = [view viewWithTag:12356790];
    [messageImageView removeFromSuperview];
}

-(NSDictionary*)returnDictionaryWithData:(NSData*)data
{
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
}

-(NSString *)returnStringWithData:(NSData*)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSData *)returnDataWithDictionary:(NSDictionary*)dict
{
    return  [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];;
}

- (NSString *)transformChinese:(NSString *)chinese hasMarks:(BOOL)hasMarks
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, hasMarks);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, YES);
    return pinyin;
}

//注册极光推送 start
-(void)regeisterJPush:(NSDictionary *)launchOptions delegate:(id)delegate
    {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            NSSet<UNNotificationCategory *> *categories;
            entity.categories = categories;
        }
        else {
            NSSet<UIUserNotificationCategory *> *categories;
            entity.categories = categories;
        }
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:delegate];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushKey
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
        NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else
        {
        NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    [JPUSHService setBadge:0];
    }
    //注册极光推送 end

@end

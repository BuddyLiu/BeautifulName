//
//  HomeViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/2/27.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "HomeViewController.h"
#import "FindNameViewController.h"
#import "GDataXMLNode.h"
#import "NamesViewController.h"
#import "CreateCNNameViewController.h"
#import "SettingViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "FSCacheManager.h"

@interface HomeViewController ()<NSURLSessionDataDelegate>

@property (strong, nonatomic) IBOutlet UIStackView *backStack;
@property (strong, nonatomic) IBOutlet UIButton *CNToENBtn;
@property (strong, nonatomic) IBOutlet UIButton *namesBtn;
@property (strong, nonatomic) IBOutlet UIButton *createCNNameBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CNToENBtn.layer.borderColor = ItemColorFromRGB(0xf2f2f2).CGColor;
    self.namesBtn.layer.borderColor = ItemColorFromRGB(0xf2f2f2).CGColor;
    self.createCNNameBtn.layer.borderColor = ItemColorFromRGB(0xf2f2f2).CGColor;
    
    BOOL IsPortrait = ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown);
    if(IsPortrait) {
        self.backStack.axis = UILayoutConstraintAxisVertical;
    } else {
        self.backStack.axis = UILayoutConstraintAxisVertical;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"横竖屏进行了切换size:%@",NSStringFromCGSize(size));
    // 延时一下 获得的高度才正确，要不然是转屏前的宽高
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STRONGSELF
        if(size.width < size.height) {
            //竖屏
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.backStack.axis = UILayoutConstraintAxisVertical;
                [strongSelf.backStack layoutIfNeeded];
            });
        } else {
            //横屏
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.backStack.axis = UILayoutConstraintAxisVertical;
                [strongSelf.backStack layoutIfNeeded];
            });
        }
    });
}

- (IBAction)CNToENBtnAction:(UIButton *)sender {
    //中文转英文
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [MobClick event:@"Click-ZhongWenZhuanYingWen" label:@"点击中文转英文"];
        FindNameViewController *findNameViewController = NibController(FindNameViewController);
        [[ExpandView shareInstance] presentToController:findNameViewController rootController:weakSelf expandView:sender type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{
            
        }];
    });
}

- (IBAction)namesBtnAction:(UIButton *)sender {
    //名字库
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [MobClick event:@"Click-MingZiKu" label:@"点击名字库"];
        NamesViewController *names = NibController(NamesViewController);
        [[ExpandView shareInstance] presentToController:names rootController:weakSelf expandView:sender type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{
            
        }];
    });
}

- (IBAction)createCNNameBtnAction:(UIButton *)sender {
    //取中文名
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [MobClick event:@"Click-QuZhongWenMing" label:@"点击取中文名"];
        CreateCNNameViewController *cnName = NibController(CreateCNNameViewController);
        [[ExpandView shareInstance] presentToController:cnName rootController:weakSelf expandView:sender type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{
            
        }];
    });
}

- (IBAction)requestMessageBtnAction:(UIButton *)sender {
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [MobClick event:@"Click-SheZhi" label:@"点击设置"];
        SettingViewController *setting = NibController(SettingViewController);
        [[ExpandView shareInstance] presentToController:setting rootController:weakSelf expandView:sender type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{

        }];
    });
//    [self getNameDetail];
//    [self getFirstNameSource];
//    [self getFirstNameSourceDetail];
//    NSString *niujinStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"niujin" ofType:@"txt"] encoding:(NSUTF8StringEncoding) error:nil];
//    NSArray *niujinArr = [niujinStr componentsSeparatedByString:@".\n"];
//    NSMutableArray *mArr = [NSMutableArray new];
//    for (int i = 0; i < niujinArr.count; i++) {
//        NSMutableDictionary *mDic = [NSMutableDictionary new];
//        NSString *wordStr = [NSString stringWithFormat:@"%@", niujinArr[i]];
//        NSArray *wordArr = [wordStr componentsSeparatedByString:@":"];
//        if(wordArr && wordArr.count > 1) {
//            [mDic setObject:wordArr.firstObject forKey:@"key_word"];
//            NSString *means = wordArr.lastObject;
//            NSMutableArray *meansArr = [NSMutableArray arrayWithArray:[means componentsSeparatedByString:@","]];
//            if(meansArr && meansArr.count > 0) {
//                if([meansArr.firstObject rangeOfString:@"/"].length > 0) {
//                    [mDic setObject:meansArr.firstObject forKey:@"key_read"];
//                    [meansArr removeObjectAtIndex:0];
//                    [mDic setObject:[meansArr copy] forKey:@"key_means"];
//                } else {
//                    [mDic setObject:[meansArr copy] forKey:@"key_means"];
//                }
//            }
//        }
//        [mArr addObject:mDic];
//    }
//    NSLog(@"%@", mArr);
}

//-(void)getAllNames {
//    NSMutableArray *mArr = [NSMutableArray new];
//    NSArray *word = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"];
//    for (int i = 0; i < word.count; i++) {
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.yingwenming.com/ying-wen-ming-ku/%@?field_gender_value=All", word[i]]];
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:10];
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithHTMLString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] error:NULL];
//            NSArray *arr = [doc nodesForXPath:@"//table//tbody//tr//a" error:NULL];
//            NSMutableArray *nodes = [NSMutableArray new];
//            for (int j = 0; j < arr.count; j++) {
//                GDataXMLNode *node = arr[j];
//                [nodes addObject:[[[[node.XMLString componentsSeparatedByString:@"\">"] lastObject] componentsSeparatedByString:@"</"] firstObject]];
//            }
//            [mArr addObject:nodes];
//        }];
//        [dataTask resume];
//        sleep(2+i*0.1);
//        NSLog(@"mArr.count:%ld", mArr.count);
//    }
//    NSLog(@"%@", mArr);
//}
//
//-(void)getNameDetail {
//    NSMutableArray *mArr = [NSMutableArray new];
//    
//    NSArray *names = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"all_names" ofType:@"txt"]];
//    for (int i = 0; i < names.count; i++) {
//        NSMutableDictionary *mDic = [NSMutableDictionary new];
//        for (int j = 0; j < ((NSArray *)names[i]).count; j++) {
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.yingwenming.com/name/%@", names[i][j]]];
//            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:10];
//            NSURLSession *session = [NSURLSession sharedSession];
//            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithHTMLString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] error:NULL];
//                NSArray *arr = [doc nodesForXPath:@"//article//div//div//div//div//p" error:NULL];
//                NSMutableDictionary *nodes = [NSMutableDictionary new];
//                NSArray *genderArr = [doc nodesForXPath:@"//article//div//h2//span" error:NULL];
//                if(genderArr.count > 0) {
//                    if([((GDataXMLNode *)genderArr.firstObject).XMLString rangeOfString:@"男性"].length > 0) {
//                        [nodes setObject:@"1" forKey:@"key_gender"];
//                    } else {
//                        [nodes setObject:@"0" forKey:@"key_gender"];
//                    }
//                }
//                if(arr.count > 0){
//                    NSString *keyWords = [NSString stringWithFormat:@"%@", ((GDataXMLNode *)arr[0]).XMLString];
//                    keyWords = [NSString stringWithFormat:@"%@", [keyWords stringByReplacingOccurrencesOfString:@"<p>" withString:@""]];
//                    while ([keyWords rangeOfString:@" "].length > 0) {
//                        keyWords = [NSString stringWithFormat:@"%@", [keyWords stringByReplacingOccurrencesOfString:@" " withString:@""]];
//                    }
//                    keyWords = [NSString stringWithFormat:@"%@", [keyWords stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
//                    keyWords = [NSString stringWithFormat:@"%@", [keyWords stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
//                    [nodes setValue:keyWords forKey:@"key_words"];
//                    if(arr.count > 1) {
//                        NSString *detail = [NSString stringWithFormat:@"%@", ((GDataXMLNode *)arr[1]).XMLString];
//                        detail = [NSString stringWithFormat:@"%@", [detail stringByReplacingOccurrencesOfString:@"<p>" withString:@""]];
//                        while ([detail rangeOfString:@" "].length > 0) {
//                            detail = [NSString stringWithFormat:@"%@", [detail stringByReplacingOccurrencesOfString:@" " withString:@""]];
//                        }
//                        detail = [NSString stringWithFormat:@"%@", [detail stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
//                        detail = [NSString stringWithFormat:@"%@", [detail stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
//                        [nodes setValue:detail forKey:@"key_detail"];
//                        if(arr.count > 2) {
//                            NSString *about = [NSString stringWithFormat:@"%@", ((GDataXMLNode *)arr[2]).XMLString];
//                            about = [NSString stringWithFormat:@"%@", [about stringByReplacingOccurrencesOfString:@"<p>" withString:@""]];
//                            while ([about rangeOfString:@" "].length > 0) {
//                                about = [NSString stringWithFormat:@"%@", [about stringByReplacingOccurrencesOfString:@" " withString:@""]];
//                            }
//                            about = [NSString stringWithFormat:@"%@", [about stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
//                            about = [NSString stringWithFormat:@"%@", [about stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
//                            [nodes setValue:about forKey:@"key_about"];
//                            if(arr.count > 5) {
//                                NSString *recommend = [NSString stringWithFormat:@"%@", ((GDataXMLNode *)arr[5]).XMLString];
//                                recommend = [NSString stringWithFormat:@"%@", [recommend stringByReplacingOccurrencesOfString:@"<p>" withString:@""]];
//                                while ([recommend rangeOfString:@" "].length > 0) {
//                                    recommend = [NSString stringWithFormat:@"%@", [recommend stringByReplacingOccurrencesOfString:@" " withString:@""]];
//                                }
//                                recommend = [NSString stringWithFormat:@"%@", [recommend stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
//                                recommend = [NSString stringWithFormat:@"%@", [recommend stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
//                                [nodes setValue:recommend forKey:@"key_recommend"];
//                            }
//                        }
//                    }
//                }
//                
//                [mDic setValue:nodes forKey:names[i][j]];
//            }];
//            [dataTask resume];
//            sleep(1);
//        }
//        sleep(1);
//        NSLog(@"mArr.count:%ld", mArr.count);
//        [mArr addObject:mDic];
//    }
//    NSLog(@"%@", mArr);
//}
//
//-(void)getFirstNameSource {
//    NSMutableArray *mArr = [NSMutableArray new];
//    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"first_name_link" ofType:@"txt"] encoding:(NSUTF8StringEncoding) error:nil] error:NULL];
//    NSArray *arr = [doc nodesForXPath:@"//table//tbody//tr//td//a" error:NULL];
//    NSMutableArray *nodes = [NSMutableArray new];
//    for (int j = 0; j < arr.count; j++) {
//        GDataXMLNode *node = arr[j];
//        [nodes addObject:@{@"link":[NSString stringWithFormat:@"%@%@", @"http://xh.5156edu.com", [[[[node.XMLString componentsSeparatedByString:@"=\""] lastObject] componentsSeparatedByString:@"\">"] firstObject]],
//                           @"word":[[[[node.XMLString componentsSeparatedByString:@"\">"] lastObject] componentsSeparatedByString:@"</"] firstObject]}];
//    }
//    [mArr addObjectsFromArray:nodes];
//    NSLog(@"%@", mArr);
//}
//
//-(void)getFirstNameSourceDetail {
//    NSMutableArray *firstNameLinks = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"first_name_link" ofType:@"txt"]];
//    for (int j = 0; j < firstNameLinks.count; j++) {
//        NSMutableDictionary *firstNameDic = firstNameLinks[j];
//        NSURL *url = [NSURL URLWithString:firstNameDic[@"link"]];
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:10];
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLString:[[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] error:NULL];
//            NSArray *arr = [doc nodesForXPath:@"//body//table//table//table" error:NULL];
//            for (int i = 0; i < arr.count; i++) {
//                GDataXMLNode *node = arr[i];
//                if([node.XMLString rangeOfString:@"起源、来源、由来"].length > 0) {
//                    NSString *xml = node.XMLString;
//                    while ([xml rangeOfString:@"\n"].length > 0) {
//                        xml = [xml stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                    }
//                    while ([xml rangeOfString:@"<br/>"].length > 0) {
//                        xml = [xml stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
//                    }
//                    
//                    [firstNameDic setObject:node.XMLString forKey:@"xml"];
//                    [firstNameLinks replaceObjectAtIndex:j withObject:firstNameDic];
//                    break;
//                }
//            }
//        }];
//        NSLog(@"%ld", (long)j);
//        [dataTask resume];
//        sleep(1+j*0.00001);
//    }
//    NSLog(@"firstNameLinks:%@", firstNameLinks);
//}

@end

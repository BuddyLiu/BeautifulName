//
//  FindNameViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/3/1.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "FindNameViewController.h"
#import "FindName_AgeViewController.h"
#import "NameListViewController.h"

@interface FindNameViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *manBtn;
@property (strong, nonatomic) IBOutlet UIButton *womanBtn;
@property (assign, nonatomic) BOOL isMan;
@property (strong, nonatomic) IBOutlet UIButton *requestNameBtn;

@end

@implementation FindNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manBtn setBackgroundColor:[MainSelectedColor colorWithAlphaComponent:0.5]];
    [self.womanBtn setBackgroundColor:[UIColor whiteColor]];
    self.isMan = YES;
    [USERDEFAULTS setBool:YES forKey:@"gender"];
    self.requestNameBtn.layer.borderColor = [MainSelectedColor colorWithAlphaComponent:0.5].CGColor;
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [USERDEFAULTS setBool:YES forKey:@"gender"];
    [[ExpandView shareInstance] dismissToController:self type:(ExpandViewAnimationTypeZoom) showEnd:^{
        
    }];
}

- (IBAction)requestNameBtnAction:(UIButton *)sender {
    if(self.nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入中文名"];
        return;
    } else if(self.nameTextField.text.length > 4) {
        [SVProgressHUD showErrorWithStatus:@"名字太长了"];
        return;
    }
    [USERDEFAULTS setObject:[[[[GeneralTool sharedInstance] transformChinese:[self.nameTextField.text substringToIndex:1] hasMarks:NO] lowercaseString] capitalizedString] forKey:@"FirstName"];
    NameListViewController *nameList = NibController(NameListViewController);
    [[ExpandView shareInstance] presentToController:nameList rootController:self expandView:sender type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{
        
    }];
}

- (IBAction)manBtnAction:(UIButton *)sender {
//    [self directToAgeViewIsWoman:NO view:sender];
    if(!self.isMan) {
        [sender setBackgroundColor:[MainSelectedColor colorWithAlphaComponent:0.5]];
        [self.womanBtn setBackgroundColor:[UIColor whiteColor]];
        self.isMan = YES;
        [USERDEFAULTS setBool:YES forKey:@"gender"];
    }
}

- (IBAction)womenBtnAction:(UIButton *)sender {
//    [self directToAgeViewIsWoman:YES view:sender];
    if(self.isMan) {
        [sender setBackgroundColor:[MainSelectedColor colorWithAlphaComponent:0.5]];
        [self.manBtn setBackgroundColor:[UIColor whiteColor]];
        self.isMan = NO;
        [USERDEFAULTS setBool:NO forKey:@"gender"];
    }
}

-(void)directToAgeViewIsWoman:(BOOL)isWomen view:(UIView *)view {
    [MobClick event:@"Click-SheZhi" label:@"点击设置"];
    [USERDEFAULTS setBool:isWomen forKey:@"gender"];
    FindName_AgeViewController *age = NibController(FindName_AgeViewController);
    [[ExpandView shareInstance] presentToController:age rootController:self expandView:view type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{
        
    }];
}

@end

//
//  FindName_JobViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/3/2.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "FindName_JobViewController.h"
#import "NameListViewController.h"

@interface FindName_JobViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *jobPicker;
@property (strong, nonatomic) NSArray *jobs;

@end

@implementation FindName_JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobPicker.delegate = self;
    self.jobPicker.dataSource = self;
    self.jobs = @[@"白领", @"学生", @"老板", @"艺人", @"无业"];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [[ExpandView shareInstance] dismissToController:self type:(ExpandViewAnimationTypeZoom) showEnd:^{
        
    }];
}

- (IBAction)nextBtnAction:(UIButton *)sender {
    NameListViewController *nameList = NibController(NameListViewController);
    [[ExpandView shareInstance] presentToController:nameList rootController:self expandView:sender type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{
        
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.jobs.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 80;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.text = [NSString stringWithFormat:@"%@", self.jobs[row]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = kSysBoldFontSize(25);
    return label;
}

@end

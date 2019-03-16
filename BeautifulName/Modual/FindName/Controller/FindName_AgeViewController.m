//
//  FindName_AgeViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/3/2.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "FindName_AgeViewController.h"
#import "FindName_JobViewController.h"

@interface FindName_AgeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *agePicker;
@property (strong, nonatomic) NSArray *ages;

@end

@implementation FindName_AgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agePicker.delegate = self;
    self.agePicker.dataSource = self;
    self.ages = @[@"10后", @"00后", @"90后", @"80后", @"70后", @"60后"];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [[ExpandView shareInstance] dismissToController:self type:(ExpandViewAnimationTypeZoom) showEnd:^{
        
    }];
}

- (IBAction)nextBtnAction:(UIButton *)sender {
    FindName_JobViewController *job = NibController(FindName_JobViewController);
    [[ExpandView shareInstance] presentToController:job rootController:self expandView:sender type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{
        
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.ages.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 80;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.text = [NSString stringWithFormat:@"%@", self.ages[row]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = kSysBoldFontSize(25);
    return label;
}
@end

//
//  CreateCNNameDetailViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/3/7.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "CreateCNNameDetailViewController.h"
#import "NameRequestTool.h"

@interface CreateCNNameDetailViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *nameNumSeg;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSeg;
@property (strong, nonatomic) IBOutlet UIPickerView *namesPick;
@property (strong, nonatomic) IBOutlet UIButton *loadAnotherGroupBtn;

@property (strong, nonatomic) NSMutableArray *lastNames;
@property (strong, nonatomic) NSMutableArray *namesArr;
@property (strong, nonatomic) NSMutableArray *namesRecordArr;
@property (copy, nonatomic) NSString *firstName;

@end

static NSInteger groupNameNum = 5;

@implementation CreateCNNameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadAnotherGroupBtn.layer.borderColor = ItemColorFromRGB(0xf2f2f2).CGColor;
    self.loadAnotherGroupBtn.layer.borderWidth = 1.5;
    self.namesPick.delegate = self;
    self.namesPick.dataSource = self;
    self.firstNameLabel.text = self.firstName;
}

- (IBAction)loadAnotherGroupBtnAction:(UIButton *)sender {
    if(self.nameNumSeg.selectedSegmentIndex == 2) {
        [self refreshDoubleNamesWithGender:(self.genderSeg.selectedSegmentIndex == 0)?YES:NO];
    } else {
        [self refreshNamesWithLastNameNum:self.nameNumSeg.selectedSegmentIndex+1 gender:(self.genderSeg.selectedSegmentIndex == 0)?YES:NO];
    }
}

-(void)refreshNamesWithFirstName:(NSString *)firstName {
    self.firstName = firstName;
    [self refreshNamesWithLastNameNum:1 gender:YES];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [[ExpandView shareInstance] dismissToController:self type:(ExpandViewAnimationTypeZoom) showEnd:^{
        
    }];
}

- (IBAction)nameNumSegChanged:(UISegmentedControl *)sender {
    [self.namesRecordArr removeAllObjects];
    if(sender.selectedSegmentIndex == 2) {
        [self refreshDoubleNamesWithGender:(self.genderSeg.selectedSegmentIndex == 0)?YES:NO];
    } else {
        [self refreshNamesWithLastNameNum:sender.selectedSegmentIndex+1 gender:(self.genderSeg.selectedSegmentIndex == 0)?YES:NO];
    }
}

- (IBAction)genderSegChanged:(UISegmentedControl *)sender {
    [self.namesRecordArr removeAllObjects];
    if(self.nameNumSeg.selectedSegmentIndex == 2) {
        [self refreshDoubleNamesWithGender:(self.genderSeg.selectedSegmentIndex == 0)?YES:NO];
    } else {
        [self refreshNamesWithLastNameNum:self.nameNumSeg.selectedSegmentIndex+1 gender:(self.genderSeg.selectedSegmentIndex == 0)?YES:NO];
    }
}

-(void)refreshNamesWithLastNameNum:(NSInteger)num gender:(BOOL)isBoy {
    WEAKSELF
    [[NameRequestTool sharedInstance] requestWithGender:isBoy namesArrBlock:^(NSArray * _Nonnull arr) {
        weakSelf.lastNames = [NSMutableArray arrayWithArray:arr];
        NSMutableArray *namesArr = [NSMutableArray new];
        for (int i = 0; i < groupNameNum; i++) {
            NSString *lastName = @"";
            for (int j = 0; lastName.length < num; j++) {
                NSString *newWord = [NSString stringWithFormat:@"%@", [self randomLastNameWordInArray:weakSelf.lastNames]];
                if(newWord.length > 0) {
                    if([lastName rangeOfString:newWord].length > 0) {
                        j--;
                        continue;
                    } else {
                        lastName = [NSString stringWithFormat:@"%@%@", lastName, newWord];
                    }
                }
            }
            if(weakSelf.namesRecordArr.count == 0) {
                [namesArr addObject:lastName];
            } else {
                BOOL isExist = NO;
                for (int k = 0; k < weakSelf.namesRecordArr.count; k++) {
                    if([weakSelf.namesRecordArr[i] isEqual:lastName]){
                        isExist = YES;
                    }
                }
                if(!isExist) {
                    [namesArr addObject:lastName];
                } else {
                    i--;
                    continue;
                }
            }
        }
        [weakSelf.namesRecordArr addObjectsFromArray:namesArr];
        weakSelf.namesArr = [NSMutableArray arrayWithArray:namesArr];
        [weakSelf.namesPick reloadComponent:0];
        [weakSelf.namesPick selectRow:2 inComponent:0 animated:YES];

    } errorBlock:^(NSString * _Nonnull msg) {
        
    }];
}

-(void)refreshDoubleNamesWithGender:(BOOL)isBoy {
    self.lastNames = [NSMutableArray new];
    WEAKSELF
    [[NameRequestTool sharedInstance] requestWithGender:isBoy namesArrBlock:^(NSArray * _Nonnull arr) {
        weakSelf.lastNames = [NSMutableArray arrayWithArray:arr];
        NSMutableArray *namesArr = [NSMutableArray new];
        for (int i = 0; i < 10; i++) {
            NSString *lastName = @"";
            NSString *newWord = [NSString stringWithFormat:@"%@", [weakSelf randomLastNameWordInArray:weakSelf.lastNames]];
            if(newWord.length > 0) {
                lastName = [NSString stringWithFormat:@"%@%@", newWord, newWord];
            }
            if(weakSelf.namesRecordArr.count == 0) {
                [namesArr addObject:lastName];
            } else {
                BOOL isExist = NO;
                for (int k = 0; k < weakSelf.namesRecordArr.count; k++) {
                    if([weakSelf.namesRecordArr[i] isEqual:lastName]){
                        isExist = YES;
                    }
                }
                if(!isExist) {
                    [namesArr addObject:lastName];
                } else {
                    i--;
                    continue;
                }
            }
        }
        [weakSelf.namesRecordArr addObjectsFromArray:namesArr];
        weakSelf.namesArr = [NSMutableArray arrayWithArray:namesArr];
        [weakSelf.namesPick reloadComponent:0];
        [weakSelf.namesPick selectRow:2 inComponent:0 animated:YES];
    } errorBlock:^(NSString * _Nonnull msg) {
        
    }];
}

-(NSString *)randomLastNameWordInArray:(NSArray *)lastNames {
    NSInteger index = (NSInteger)((arc4random() % (lastNames.count)));
    if(index < lastNames.count) {
        return lastNames[index];
    } else {
        return lastNames[0];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.namesArr.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 48;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.width, 48)];
    name.text = [NSString stringWithFormat:@"%@%@", self.firstName, self.namesArr[row]];
    name.font = kSysBoldFontSize(25);
    name.textColor = [UIColor darkGrayColor];
    name.textAlignment = NSTextAlignmentCenter;
    return name;
}

-(NSMutableArray *)namesRecordArr {
    if(!_namesRecordArr) {
        _namesRecordArr = [NSMutableArray new];
    }
    return _namesRecordArr;
}

@end

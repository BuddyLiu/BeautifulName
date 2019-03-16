//
//  NameListViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/3/3.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "NameListViewController.h"
#import "FSCardView.h"
#import "NameListDetailView.h"
#import "NameRequestTool.h"

@interface NameListViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) FSCardView *cardView;
@property (strong, nonatomic) NSMutableArray *names;

@end

@implementation NameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer displayIfNeeded];
    self.contentView.userInteractionEnabled = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshCardsView];
}

-(void)refreshCardsView {
    [self.names removeAllObjects];
    [[NameRequestTool sharedInstance] requestAllNamesDetailNamesArrBlock:^(NSArray * _Nonnull arr) {
        NSArray *allNamesArray = arr;
        for (int i = 0; i < 5; i++) {
            NSInteger index = (NSInteger)(arc4random() % 25);
            NSArray *namesKeyArray = [[allNamesArray objectAtIndex:index] allKeys];
            NSArray *namesValueArray = [[allNamesArray objectAtIndex:index] allValues];
            NSString *genderStr = [USERDEFAULTS boolForKey:@"gender"]?@"1":@"0";
            NSInteger j = (NSInteger)(arc4random() % (namesKeyArray.count-1));
            if([[[allNamesArray objectAtIndex:index] allValues][j][@"key_gender"] isEqual:genderStr]) {
                NSMutableDictionary *mDic = [NSMutableDictionary new];
                [mDic setDictionary:namesValueArray[j]];
                [mDic setObject:namesKeyArray[j] forKey:@"name"];
                [self.names addObject:mDic];
            } else {
                i--;
                continue;
            }
        }
        
        [self.cardView removeAllSubviews];
        [self.contentView removeAllSubviews];
        self.cardView = [[FSCardView alloc] initWithCardFrame:self.contentView.bounds];
        NSMutableArray *mArr = [NSMutableArray new];
        for (int i = 0; i < self.names.count; i++) {
            NameListDetailView *nameListDetailView = [[NameListDetailView alloc] initWithNameListDetailFrame:self.cardView.bounds];
            nameListDetailView.clipsToBounds = YES;
            nameListDetailView.layer.cornerRadius = 10;
            nameListDetailView.layer.borderColor = ItemColorFromRGB(0xf2f2f2).CGColor;
            nameListDetailView.layer.borderWidth = 2;
            nameListDetailView.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.names[i][@"name"], [USERDEFAULTS objectForKey:@"FirstName"]];
            nameListDetailView.genderImageView.image = [UIImage imageNamed:[USERDEFAULTS boolForKey:@"gender"]?@"boy":@"girl"];
            nameListDetailView.deatailLabel.text = [NSString stringWithFormat:@"%@", self.names[i][@"key_detail"]];
            nameListDetailView.indexLabel.text = [NSString stringWithFormat:@"%ld", self.names.count - i];
            [mArr addObject:nameListDetailView];
        }
        [self.cardView refreshViewArray:[mArr copy]];
        [self.contentView addSubview:self.cardView];
    } errorBlock:^(NSString * _Nonnull msg) {
        
    }];
}

- (IBAction)upDateGroupNames:(UIButton *)sender {
    [self refreshCardsView];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [[ExpandView shareInstance] dismissToController:self type:(ExpandViewAnimationTypeZoom) showEnd:^{
        
    }];
}

-(NSMutableArray *)names {
    if(!_names) {
        _names = [NSMutableArray new];
    }
    return _names;
}

@end

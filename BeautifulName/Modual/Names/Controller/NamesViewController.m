//
//  NamesViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/3/5.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "NamesViewController.h"
#import "SearchNamesView.h"
#import "NameRequestTool.h"

@interface NamesViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *groupTable;
@property (strong, nonatomic) IBOutlet UITableView *namesTable;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameKeyLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *nearNameTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nearNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *recommendTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *recommendlabel;

@property (strong, nonatomic) NSArray *allNamesData;
@property (strong, nonatomic) NSArray *allNamesDetailData;
@property (strong, nonatomic) NSArray *groupData;
@property (strong, nonatomic) NSMutableArray *namesData;
@property (assign, nonatomic) NSUInteger selectedGroupIndex;
@property (strong, nonatomic) NSDictionary *groupNameDetailDic;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) SearchNamesView *showSearchView;
@property (strong, nonatomic) NSMutableArray *showSearchData;

@end

static NSString *SearchNameRecordList = @"SearchNameRecordList";

@implementation NamesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.showSearchData = [NSMutableArray new];
    self.contentScrollView.contentSize = ({
        CGSize size = self.contentScrollView.contentSize;
        size.width = self.contentScrollView.width;
        size;
    });
    self.selectedGroupIndex = 0;
    self.groupNameDetailDic = [NSDictionary new];
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        STRONGSELF
        [SVProgressHUD show];
        [[NameRequestTool sharedInstance] requestAllNamesNamesArrBlock:^(NSArray * _Nonnull arr) {
            strongSelf.allNamesData = [NSMutableArray arrayWithArray:arr];
            
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
        
        [[NameRequestTool sharedInstance] requestAllNamesDetailNamesArrBlock:^(NSArray * _Nonnull arr) {
            weakSelf.allNamesDetailData = [NSMutableArray arrayWithArray:arr];
            [SVProgressHUD dismiss];
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf refreshNamesWithGroup:self.selectedGroupIndex];
            [weakSelf.namesTable reloadData];
            [weakSelf.groupTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [weakSelf.namesTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        });
    });
    
    self.groupTable.clipsToBounds = YES;
    self.groupTable.layer.cornerRadius = 10;
    self.groupTable.layer.borderColor = ItemColorFromRGB(0xf2f2f2).CGColor;
    self.groupTable.layer.borderWidth = 2;
    self.groupTable.delegate = self;
    self.groupTable.dataSource = self;
    self.groupTable.separatorColor = [UIColor clearColor];
    self.groupData = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"];
    
    self.namesData = [NSMutableArray new];
    self.namesTable.clipsToBounds = YES;
    self.namesTable.layer.cornerRadius = 10;
    self.namesTable.layer.borderColor = ItemColorFromRGB(0xf2f2f2).CGColor;
    self.namesTable.layer.borderWidth = 1;
    self.namesTable.delegate = self;
    self.namesTable.dataSource = self;
    self.namesTable.separatorColor = [UIColor clearColor];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.showSearchView = [[SearchNamesView alloc] initWithSNFrame:self.contentScrollView.frame];
    self.showSearchView.clipsToBounds = YES;
    self.showSearchView.layer.borderColor = ItemColorFromRGB(0xf2f2f2).CGColor;
    self.showSearchView.layer.borderWidth = 1.0;
    self.showSearchView.layer.cornerRadius = 10;
    self.showSearchView.alpha = 0;
    self.showSearchView.searchNameTableView.delegate = self;
    self.showSearchView.searchNameTableView.dataSource = self;
    self.showSearchView.searchNameTableView.separatorColor = [UIColor whiteColor];
    [self.showSearchView.searchNameClearBtn addTarget:self action:@selector(searchNameClearBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.showSearchView.cancelBtn addTarget:self action:@selector(cancelShowSearchViewBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self hideShowSearchView];
    [self.view addSubview:self.showSearchView];
}

-(void)searchNameClearBtnAction:(UIButton *)sender {
    [self hideShowSearchView];
    [self clearSearchRecord];
    [self.showSearchData removeAllObjects];
    [self.showSearchView.searchNameTableView reloadData];
}

-(void)cancelShowSearchViewBtnAction:(UIButton *)sender {
    [self.searchBar resignFirstResponder];
    [self hideShowSearchView];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSMutableArray *list = [NSMutableArray arrayWithArray:[USERDEFAULTS objectForKey:SearchNameRecordList]];
    if(list) {
        self.showSearchData = [NSMutableArray arrayWithArray:list];
    }
    [self showShowSearchView];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self hideShowSearchView];
}

-(void)showShowSearchView {
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.showSearchView.searchNameTableView reloadData];
        weakSelf.showSearchView.alpha = 1;
        weakSelf.showSearchView.frame = ({
            CGRect frame = weakSelf.showSearchView.frame;
            frame.size.height = weakSelf.contentScrollView.height/3.0;
            frame;
        });
    }];
}

-(void)hideShowSearchView {
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.showSearchView.alpha = 0;
        weakSelf.showSearchView.frame = ({
            CGRect frame = weakSelf.showSearchView.frame;
            frame.size.height = 0;
            frame;
        });
    }];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [[ExpandView shareInstance] dismissToController:self type:(ExpandViewAnimationTypeZoom) showEnd:^{
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 101) {
        return self.groupData.count;
    } else if(tableView.tag == 102) {
        return self.namesData.count;
    } else {
        return self.showSearchData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 101) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"GroupCell"];
        }
        cell.textLabel.text = self.groupData[indexPath.row];
        cell.textLabel.font = kSysBoldFontSize(18);
        if((indexPath.row+2)%2 == 0) {
            cell.backgroundColor = ItemColorFromRGB(0xf2f2f2);
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    } else if(tableView.tag == 102) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NamesCell"];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"NamesCell"];
        }
        cell.textLabel.text = self.namesData[indexPath.row];
        if((indexPath.row+2)%2 == 0) {
            cell.backgroundColor = ItemColorFromRGB(0xf2f2f2);
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NamesCell"];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"NamesCell"];
        }
        cell.textLabel.text = self.showSearchData[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 101) {
        self.selectedGroupIndex = indexPath.row;
        [self refreshNamesWithGroup:self.selectedGroupIndex];
        [self.namesTable reloadData];
        [self.groupTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self.namesTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    } else if(tableView.tag == 102) {
        if(indexPath.row < self.namesData.count) {
            self.searchBar.text = self.namesData[indexPath.row];
            [self refreshDetailViewWithName:self.namesData[indexPath.row]];
            [self.namesTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    } else {
        self.searchBar.text = self.showSearchData[indexPath.row];
        [self searchBarSearchButtonClicked:self.searchBar];
        [self hideShowSearchView];
    }
}

-(void)refreshNamesWithGroup:(NSInteger)index {
    [self.namesData removeAllObjects];
    [self.namesData addObjectsFromArray:self.allNamesData[index]];
    if(self.namesData.count > 0) {
        [self refreshDetailViewWithName:self.namesData[0]];
    }
}

-(void)refreshDetailViewWithName:(NSString *)name {
    if(name.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入名字！"];
        return;
    }
    WEAKSELF
    [[NameRequestTool sharedInstance] requestNamesDetailWithWord:[[name substringToIndex:1] lowercaseString] namesArrBlock:^(NSArray * _Nonnull arr) {
        NSDictionary *dic = [NSDictionary new];
        for (int i = 0; i < arr.count; i++) {
            dic = arr[i];
            if([dic[@"key_name"] isEqual:name]) {
                break;
            }
        }
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            if(dic) {
                strongSelf.nameLabel.text = dic[@"key_name"];
                strongSelf.nameKeyLabel.text = dic[@"key_words"]?dic[@"key_words"]:@"";
                strongSelf.detailTitleLabel.text = ((NSString *)dic[@"key_detail"]).length>0?@"***起源***":@"";
                strongSelf.detailLabel.text = dic[@"key_detail"]?dic[@"key_detail"]:@"";
                NSString *nearName = [NSString stringWithFormat:@"%@", dic[@"key_about"]];
                if(nearName.length > 0 && [nearName rangeOfString:@"https"].length == 0 && [[nearName substringToIndex:1] isEqualToString:[dic[@"key_name"] substringToIndex:1]]) {
                    strongSelf.nearNameTitleLabel.text = @"***相近名字***";
                    strongSelf.nearNameLabel.text = nearName;
                } else {
                    strongSelf.nearNameTitleLabel.text = @"";
                    strongSelf.nearNameLabel.text = @"";
                }
                NSString *recommend = [NSString stringWithFormat:@"%@", dic[@"key_recommend"]];
                if([[recommend substringToIndex:1] isEqualToString:[dic[@"key_name"] substringToIndex:1]]) {
                    strongSelf.nearNameTitleLabel.text = @"***相近名字***";
                    strongSelf.nearNameLabel.text = recommend;
                    strongSelf.recommendTitleLabel.text = @"";
                    strongSelf.recommendlabel.text = @"";
                } else {
                    strongSelf.recommendTitleLabel.text = ((NSString *)dic[@"key_recommend"]).length>0?@"***评价***":@"";
                    strongSelf.recommendlabel.text = dic[@"key_recommend"]?dic[@"key_recommend"]:@"";
                }
            } else {
                [strongSelf clearDetailWithMsg:@"无搜索结果"];
            }
        });
    } errorBlock:^(NSString * _Nonnull msg) {
        [weakSelf clearDetailWithMsg:@"无搜索结果"];
    }];
}

-(void)clearDetailWithMsg:(NSString *)msg {
    [SVProgressHUD showErrorWithStatus:msg];
    self.nameLabel.text = msg;
    self.nameKeyLabel.text = @"";
    self.detailTitleLabel.text = @"";
    self.detailLabel.text = @"";
    self.nearNameTitleLabel.text = @"";
    self.nearNameLabel.text = @"";
    self.recommendTitleLabel.text = @"";
    self.recommendlabel.text = @"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    NSMutableArray *list = [NSMutableArray arrayWithArray:[USERDEFAULTS objectForKey:SearchNameRecordList]];
    if(list) {
        self.showSearchData = [NSMutableArray arrayWithArray:list];
        [self showShowSearchView];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.namesData removeAllObjects];
    for (int i = 0; i < self.allNamesDetailData.count; i++) {
        NSDictionary *nameDic = self.allNamesDetailData[i];
        NSArray *valueArr = [NSArray arrayWithArray:[nameDic allValues]];
        NSArray *keyArr = [NSArray arrayWithArray:[nameDic allKeys]];
        for (int j = 0; j < valueArr.count; j++) {
            NSDictionary *dic = valueArr[j];
            NSString *searchText = [searchBar.text lowercaseString];
            if([[dic[@"key_about"] lowercaseString] rangeOfString:searchText].length > 0 ||
               [[dic[@"key_detail"] lowercaseString] rangeOfString:searchText].length > 0 ||
               [[dic[@"key_words"] lowercaseString] rangeOfString:searchText].length > 0 ||
               [[dic[@"key_recommend"] lowercaseString] rangeOfString:searchText].length > 0) {
                NSString *name = keyArr[j];
                BOOL isExist = NO;
                for (int k = 0; k < self.namesData.count; k++) {
                    if([name isEqual:self.namesData[k]]) {
                        isExist = YES;
                    }
                }
                if(!isExist) {
                    [self.namesData addObject:keyArr[j]];
                }
            }
        }
    }
    [self.namesTable reloadData];
    if(self.namesData.count > 0) {
        [self refreshDetailViewWithName:self.namesData[0]];
    } else {
        [self refreshDetailViewWithName:searchBar.text];
    }
    [self addSearchRecord:searchBar.text];
}

-(void)addSearchRecord:(NSString *)name {
    if(name && name.length > 0) {
        NSMutableArray *list = [NSMutableArray arrayWithArray:[USERDEFAULTS objectForKey:SearchNameRecordList]];
        if(list) {
            for (int i = 0; i < list.count; i++) {
                if([list[i] isEqual:name]) {
                    [list removeObjectAtIndex:i];
                }
            }
            [list insertObject:name atIndex:0];
        }
        [USERDEFAULTS setObject:list forKey:SearchNameRecordList];
        self.showSearchData = [NSMutableArray arrayWithArray:[list copy]];
    }
}

-(void)removeSearchRecord:(NSString *)name {
    if(name && name.length > 0) {
        NSMutableArray *list = [NSMutableArray arrayWithArray:[USERDEFAULTS objectForKey:SearchNameRecordList]];
        if(list && list.count > 0) {
            [list removeObject:name];
        }
        [USERDEFAULTS setObject:list forKey:SearchNameRecordList];
        self.showSearchData = [NSMutableArray arrayWithArray:[list copy]];
    }
}

-(void)clearSearchRecord {
    [USERDEFAULTS setObject:@[] forKey:SearchNameRecordList];
    self.showSearchData = [NSMutableArray arrayWithArray:@[]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideShowSearchView];
    [self.searchBar resignFirstResponder];
}

-(NSArray *)allNamesData {
    if(!_allNamesData) {
        _allNamesData = [NSMutableArray new];
    }
    return _allNamesData;
}

-(NSArray *)allNamesDetailData {
    if(!_allNamesDetailData) {
        _allNamesDetailData = [NSMutableArray new];
    }
    return _allNamesDetailData;
}

@end

//
//  CreateCNNameViewController.m
//  BeautifulName
//
//  Created by Paul on 2019/3/7.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "CreateCNNameViewController.h"
#import "CreateCNNameDetailViewController.h"
#import "NameRequestTool.h"

@interface CreateCNNameViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation CreateCNNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    WEAKSELF
    [[NameRequestTool sharedInstance] requestCNAllFirstNameNamesArrBlock:^(NSArray * _Nonnull arr) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:arr];
    } errorBlock:^(NSString * _Nonnull msg) {
        
    }];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [[ExpandView shareInstance] dismissToController:self type:(ExpandViewAnimationTypeZoom) showEnd:^{
        
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *searchStr = searchBar.text;
    while ([searchBar.text rangeOfString:@" "].length > 0) {
        searchStr = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    WEAKSELF
    if(searchStr.length == 0) {
        [[NameRequestTool sharedInstance] requestCNAllFirstNameNamesArrBlock:^(NSArray * _Nonnull arr) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray:arr];
            [weakSelf.tableView reloadData];
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
    } else {
        [[NameRequestTool sharedInstance] requestCNAllFirstNameNamesArrBlock:^(NSArray * _Nonnull arr) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray:arr];
            NSMutableArray *mArr = [NSMutableArray new];
            for (int i = 0; i < weakSelf.dataArray.count; i++) {
                if([weakSelf.dataArray[i] isEqual:searchStr] ||
                   [weakSelf.dataArray[i] rangeOfString:searchStr].length > 0) {
                    [mArr addObject:weakSelf.dataArray[i]];
                }
            }
            if(mArr.count > 0) {
                weakSelf.dataArray = [NSMutableArray arrayWithArray:[mArr copy]];
                [weakSelf.tableView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"没有搜索到姓氏\"%@\"", searchBar.text]];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.tableView reloadData];
            }
            for (int i = 0; i < weakSelf.dataArray.count; i++) {
                if([weakSelf.dataArray[i] rangeOfString:searchBar.text].length > 0) {
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
                }
            }
        } errorBlock:^(NSString * _Nonnull msg) {
            
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstName"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"FirstName"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.row < self.dataArray.count) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.dataArray[indexPath.row], [[[GeneralTool sharedInstance] transformChinese:self.dataArray[indexPath.row] hasMarks:YES] lowercaseString]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self directToDetailViewControllerWithFirstName:self.dataArray[indexPath.row] fromView:[tableView cellForRowAtIndexPath:indexPath]];
}

-(void)directToDetailViewControllerWithFirstName:(NSString *)firstName fromView:(UIView *)view {
    CreateCNNameDetailViewController *detail = NibController(CreateCNNameDetailViewController);
    [detail refreshNamesWithFirstName:firstName];
    [[ExpandView shareInstance] presentToController:detail rootController:self expandView:view type:(ExpandViewAnimationTypeSingleColorCirle) showEnd:^{
    }];
}

@end

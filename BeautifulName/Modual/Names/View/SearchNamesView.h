//
//  SearchNamesView.h
//  BeautifulName
//
//  Created by Paul on 2019/3/6.
//  Copyright © 2019 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchNamesView : UIView

@property (strong, nonatomic) IBOutlet UITableView *searchNameTableView;
@property (strong, nonatomic) IBOutlet UIButton *searchNameClearBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

- (instancetype)initWithSNFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

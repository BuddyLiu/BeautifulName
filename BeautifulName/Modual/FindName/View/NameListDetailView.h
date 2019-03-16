//
//  NameListDetailView.h
//  BeautifulName
//
//  Created by Paul on 2019/3/12.
//  Copyright © 2019 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NameListDetailView : UIView

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *genderImageView;
@property (strong, nonatomic) IBOutlet UILabel *deatailLabel;
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;

-(instancetype)initWithNameListDetailFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

//
//  SearchNamesView.m
//  BeautifulName
//
//  Created by Paul on 2019/3/6.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "SearchNamesView.h"

@implementation SearchNamesView

- (instancetype)initWithSNFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"SearchNamesView" owner:self options:nil][0];
        self.frame = frame;
    }
    return self;
}

@end

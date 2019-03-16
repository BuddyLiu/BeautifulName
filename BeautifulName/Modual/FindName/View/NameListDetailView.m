//
//  NameListDetailView.m
//  BeautifulName
//
//  Created by Paul on 2019/3/12.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "NameListDetailView.h"

@implementation NameListDetailView

-(instancetype)initWithNameListDetailFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"NameListDetailView" owner:self options:nil][0];
        self.frame = frame;
    }
    return self;
}

@end

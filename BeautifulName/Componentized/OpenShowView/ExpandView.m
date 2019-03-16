//
//  ExpandView.m
//  QHWallet
//
//  Created by Paul on 2019/1/4.
//  Copyright © 2019 QingHu. All rights reserved.
//

#import "ExpandView.h"

@interface ExpandView()
<
    UIGestureRecognizerDelegate,
    UIWebViewDelegate,
    UITextFieldDelegate
>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *mainView;

@end

static BOOL isVisible = NO;

static CGFloat circleSideWidth = 60;

static CGFloat moveAnimationDuration = 0.3;
static CGFloat expandAnimationDuration = 0.3;
static CGFloat springAnimationDuration = 0.5;
static CGFloat hideAnimationDuration = 0.1;

@implementation ExpandView

static ExpandView *expandView = nil;

+(ExpandView *)shareInstance {
    if(!expandView) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            expandView = [[ExpandView alloc] initExpandView];
        });
    }
    return expandView;
}

- (instancetype)initExpandView {
    self = [super init];
    if (self) {
        self.window = [UIApplication sharedApplication].delegate.window;
        self.window.windowLevel = UIWindowLevelNormal;
    }
    return self;
}

-(void)pushToController:(UIViewController *)controller navController:(UINavigationController *)navController hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed expandView:(UIView *)view type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd {
    [self showExpandView:view type:type showEnd:^{
        controller.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed;
        [navController pushViewController:controller animated:NO];
    }];
}

-(void)popWithNavController:(UINavigationController *)navController type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd {
    [self showZoomWithType:type showEnd:^{
        [navController popViewControllerAnimated:NO];
    }];
}

-(void)presentToController:(UIViewController *)controller rootController:(UIViewController *)rootController expandView:(UIView *)view type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd {
    [self showExpandView:view type:type showEnd:^{
        [rootController presentViewController:controller animated:NO completion:nil];
    }];
}
-(void)dismissToController:(UIViewController *)controller type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd {
    [self showZoomWithType:type showEnd:^{
        [controller dismissViewControllerAnimated:NO completion:nil];
    }];
}

-(void)showExpandView:(UIView *)view type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd {
    if(!isVisible) {
        [self createBackiViewWithExpandView:(UIView *)view type:type showEnd:showEnd];
    }
}

-(void)showZoomWithType:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd {
    if(!isVisible) {
        [self createBackiViewWithExpandView:[UIView new] type:type showEnd:showEnd];
    }
}

-(void)zoomExpandViewWithType:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd {
    if(!isVisible) {
        [self createBackiViewWithExpandView:[UIView new] type:type showEnd:showEnd];
    }
}

-(void)createBackiViewWithExpandView:(UIView *)view type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd {
    [self removeAllSubviews];
    isVisible = YES;
    
    self.blackView = [[UIView alloc] initWithFrame:self.window.bounds];
    self.blackView.userInteractionEnabled = YES;
    self.blackView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    [self.window addSubview:self.blackView];
    
    switch (type) {
        case ExpandViewAnimationTypeImageExpand: {
            [self addExpandImageAnimateToView:view showEnd:showEnd];
        } break;
        case ExpandViewAnimationTypeSingleColorCirle: {
            [self addExpandCircleAnimateToView:view showEnd:showEnd];
        } break;
        case ExpandViewAnimationTypeViewSpring: {
            [self addExpandSpringAnimateToView:view showEnd:showEnd];
        } break;
        case ExpandViewAnimationTypeZoom: {
            [self addExpandZoomAnimateShowEnd:showEnd];
        } break;
            
        default:
            break;
    }
}

-(void)addExpandImageAnimateToView:(UIView *)view showEnd:(ShowEndBlock)showEnd {
    UIImage *image = [[ViewTool sharedInstance] snapshotImageWithView:view];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = [view screenFrame];
    self.mainView = imageView;
    self.mainView.clipsToBounds = YES;
    self.mainView.layer.cornerRadius = 16;
    [self.window addSubview:self.mainView];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:moveAnimationDuration delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        weakSelf.mainView.center = CGPointMake(weakSelf.window.center.x, weakSelf.window.center.y);
    } completion:^(BOOL finished) {
        showEnd();
        __weak typeof(weakSelf) strongSelf = weakSelf;
        [UIView animateWithDuration:expandAnimationDuration animations:^{
            CGRect rect = strongSelf.mainView.frame;
            strongSelf.mainView.frame = ({
                CGRect frame = strongSelf.mainView.frame;
                frame.size.height = ScreenHeight;
                frame.size.width = ScreenHeight*rect.size.width/rect.size.height;
                frame;
            });
            strongSelf.mainView.center = CGPointMake(strongSelf.window.center.x, strongSelf.window.center.y);
        } completion:^(BOOL finished) {
            [strongSelf hide];
        }];
    }];
}

-(void)addExpandCircleAnimateToView:(UIView *)view showEnd:(ShowEndBlock)showEnd {
    self.mainView.frame = CGRectZero;
    CGRect viewRect = [view screenFrame];
    self.mainView.center = CGPointMake(viewRect.origin.x + viewRect.size.width/2.0, viewRect.origin.y + viewRect.size.height/2.0);
    self.mainView.clipsToBounds = YES;
    self.mainView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mainView.layer.borderWidth = 2.0;
    self.mainView.backgroundColor = [MainSelectedColor colorWithAlphaComponent:0.5];
    
    __block UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_logo"]];
    iconImageView.frame = CGRectZero;
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = circleSideWidth/2.0;
    [self.mainView addSubview:iconImageView];
    
    [self.window addSubview:self.mainView];
    [self.blackView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1]];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:springAnimationDuration/3.0 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        weakSelf.mainView.frame = ({
            CGRect frame = strongSelf.mainView.frame;
            frame.size.width = circleSideWidth;
            frame.size.height = circleSideWidth;
            frame;
        });
        weakSelf.mainView.layer.cornerRadius = circleSideWidth/2.0;
        CGRect viewRect = [view screenFrame];
        weakSelf.mainView.center = CGPointMake(viewRect.origin.x + viewRect.size.width/2.0, viewRect.origin.y + viewRect.size.height/2.0);
        
        iconImageView.frame = ({
            CGRect frame = iconImageView.frame;
            frame.size.width = strongSelf.mainView.width;
            frame.size.height = strongSelf.mainView.height;
            frame;
        });
        iconImageView.center = CGPointMake(weakSelf.mainView.centerX - weakSelf.mainView.left, weakSelf.mainView.centerY - weakSelf.mainView.top);
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [UIView animateWithDuration:expandAnimationDuration animations:^{
            CGFloat sideXMax = weakSelf.mainView.centerX > (ScreenWidth - weakSelf.mainView.centerX) ? weakSelf.mainView.centerX : (ScreenWidth - weakSelf.mainView.centerX);
            CGFloat sideYMax = weakSelf.mainView.centerY > (ScreenHeight - weakSelf.mainView.centerY) ? weakSelf.mainView.centerY : (ScreenHeight - weakSelf.mainView.centerY);
            CGFloat sideMax = 2.0*sqrt(pow(sideYMax, 2) + pow(sideXMax, 2));
            
            weakSelf.mainView.frame = ({
                CGRect frame = strongSelf.mainView.frame;
                frame.size.width = sideMax;
                frame.size.height = sideMax;
                frame;
            });
            weakSelf.mainView.layer.cornerRadius = sideMax/2.0;
            CGRect viewRect = [view screenFrame];
            weakSelf.mainView.center = CGPointMake(viewRect.origin.x + viewRect.size.width/2.0, viewRect.origin.y + viewRect.size.height/2.0);
            [weakSelf.blackView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
            
            iconImageView.frame = ({
                CGRect frame = iconImageView.frame;
                frame.size.width = circleSideWidth;
                frame.size.height = circleSideWidth;
                frame;
            });
            iconImageView.center = CGPointMake(weakSelf.mainView.centerX - weakSelf.mainView.left, weakSelf.mainView.centerY - weakSelf.mainView.top);
            
        } completion:^(BOOL finished) {
            showEnd();
            [weakSelf hide];
        }];
    }];
}

-(void)addExpandSpringAnimateToView:(UIView *)view showEnd:(ShowEndBlock)showEnd {
    UIImage *image = [[ViewTool sharedInstance] snapshotImageWithView:view];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = [view screenFrame];
    self.mainView = imageView;
    self.mainView.clipsToBounds = YES;
    self.mainView.layer.cornerRadius = 16;
    [self.window addSubview:self.mainView];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:springAnimationDuration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        weakSelf.mainView.center = CGPointMake(weakSelf.window.center.x, weakSelf.window.center.y - 50);
    } completion:^(BOOL finished) {
        showEnd();
        __weak typeof(weakSelf) strongSelf = weakSelf;
        [UIView animateWithDuration:springAnimationDuration/2.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            strongSelf.mainView.frame = ({
                CGRect frame = strongSelf.mainView.frame;
                frame.origin.y = ScreenHeight+20;
                frame;
            });
        } completion:^(BOOL finished) {
            [strongSelf hide];
        }];
    }];
}

-(void)addExpandZoomAnimateShowEnd:(ShowEndBlock)showEnd {
    CGFloat side = ScreenHeight;
    if(ScreenHeight < ScreenWidth) {
        side = ScreenWidth;
    }
    [self.mainView setFrame:CGRectMake(-(fabs(side - ScreenWidth)/2.0), 0, side, side)];
    [self.mainView setBackgroundColor:[MainSelectedColor colorWithAlphaComponent:0.0]];
    [self.window addSubview:self.mainView];
    
    WEAKSELF
    [UIView animateWithDuration:moveAnimationDuration/2.0 animations:^{
        [weakSelf.mainView setBackgroundColor:[MainSelectedColor colorWithAlphaComponent:0.5]];
    } completion:^(BOOL finished) {
        showEnd();
        weakSelf.mainView.clipsToBounds = YES;
        weakSelf.mainView.layer.cornerRadius = side/2.0;
        weakSelf.blackView.backgroundColor = [UIColor clearColor];
        
        STRONGSELF
        [UIView animateWithDuration:springAnimationDuration delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            strongSelf.mainView.frame = ({
                CGRect frame = strongSelf.mainView.frame;
                frame.size.width = circleSideWidth;
                frame.size.height = circleSideWidth;
                frame;
            });
            strongSelf.mainView.center = self.window.center;
            strongSelf.mainView.layer.cornerRadius = circleSideWidth/2.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:hideAnimationDuration animations:^{
                strongSelf.mainView.frame = ({
                    CGRect frame = strongSelf.mainView.frame;
                    frame.size.width = 0;
                    frame.size.height = 0;
                    frame;
                });
                strongSelf.mainView.center = self.window.center;
                strongSelf.mainView.layer.cornerRadius = 0;
            }];
            [strongSelf hide];
        }];
    }];
}

-(void)hide {
    isVisible = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:hideAnimationDuration animations:^{
        weakSelf.blackView.alpha = 0;
        weakSelf.mainView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.blackView removeFromSuperview];
        weakSelf.blackView = nil;
        [weakSelf.mainView removeFromSuperview];
        weakSelf.mainView = nil;
    }];
}

-(UIView *)mainView {
    if(!_mainView) {
        _mainView = [UIView new];
    }
    return _mainView;
}

@end

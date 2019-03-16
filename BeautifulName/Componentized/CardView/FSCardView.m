//
//  FSCardView.m
//  FSCardView
//
//  Created by Paul on 2018/12/28.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "FSCardView.h"

@interface FSCardView()

//缓存视图
@property (strong, nonatomic) NSMutableArray *viewArray;
@property (assign, nonatomic) BOOL isFromLeft;
@property (assign, nonatomic) CGPoint beganPoint;
@property (nonatomic, strong) UIView *operateView;
@property (nonatomic, assign) CGFloat cardSpace;

@end

@implementation FSCardView

- (instancetype)initWithCardFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[FSCardView alloc] initWithFrame:frame];
        self.isPanning = NO;
    }
    return self;
}

-(void)refreshViewArray:(NSArray *)viewArray {
    self.isPanning = NO;
    self.alpha = 0;
    [self removeAllSubviews];
    self.viewArray = [NSMutableArray arrayWithArray:viewArray];
    NSInteger showSpaceCount = self.viewArray.count > SHOWSPACECOUNT?SHOWSPACECOUNT:self.viewArray.count;
    self.cardSpace = CARDBORDERSHOWHEIGHT/showSpaceCount;
    CGFloat viewHeight = self.frame.size.height - TOPSPACE - self.cardSpace*showSpaceCount;
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < self.viewArray.count; i++) {
        UIView *view = self.viewArray[i];
        NSInteger count = 0;
        if((weakSelf.viewArray.count - i) <= showSpaceCount) {
            count = showSpaceCount - (weakSelf.viewArray.count - i);
            view.alpha = 1;
            view.frame = CGRectMake(weakSelf.cardSpace*(showSpaceCount - count)+LEFTSPACE, (showSpaceCount - count)*weakSelf.cardSpace+TOPSPACE, weakSelf.frame.size.width - LEFTSPACE*2 - weakSelf.cardSpace*(showSpaceCount - count)*2, viewHeight);
        } else {
            view.alpha = 0;
            view.frame = CGRectMake(weakSelf.cardSpace*showSpaceCount+LEFTSPACE, weakSelf.cardSpace+TOPSPACE, weakSelf.frame.size.width - LEFTSPACE*2 - weakSelf.cardSpace*showSpaceCount*2, viewHeight);
        }
        view.backgroundColor = [self randomColorAlpha:0.5];
        [self addSubview:view];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanHandle:)];
        [view addGestureRecognizer:panGesture];
    }
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1;
    }];
}

- (NSMutableArray *)viewArray {
    if (_viewArray == nil) {
        _viewArray = [NSMutableArray new];
    }
    return _viewArray;
}

/**
 *  视图手势处理
 */
- (void)viewPanHandle:(UIPanGestureRecognizer *)panGesture{
    CGPoint point = [panGesture translationInView:self];
    [panGesture setTranslation:CGPointZero inView:self];
    UIView *view = (UIView *)[self.viewArray lastObject];
    
    view.center = CGPointMake(view.center.x + point.x, view.center.y + point.y);
    __block float angle = (view.center.x - self.center.x)/self.center.x;
    float scale = 1 - fabsf(angle)/2;
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        // 开始滑动
        self.beganPoint = CGPointMake(view.centerX, view.centerY);
        self.isPanning = YES;
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        // 滑动过程中
        [self zoomView:view scale:scale];
        self.isPanning = YES;
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        self.isPanning = NO;
        // 滑动结束
        float positionX;
        if (view.center.x >self.center.x) {
            positionX = self.bounds.size.width + view.bounds.size.width/2;
            angle = M_PI*1/3;
        }else{
            positionX = -view.bounds.size.width/2;;
            angle = -M_PI*1/3;
        }
        [self operateSingeView:view];
    }
}

/**
 *  滑动一个视图的后续操作
 */
- (void)operateSingeView:(UIView *)view {
    __weak typeof(self) weakSelf = self;
    [self moveOutWindowView:view completion:^(BOOL finished) {
        [weakSelf.viewArray removeObject:view];
        [weakSelf insertSubview:view belowSubview:(UIView*)[weakSelf.viewArray firstObject]];
        [weakSelf.viewArray insertObject:view atIndex:0];
        NSInteger showSpaceCount = self.viewArray.count > SHOWSPACECOUNT?SHOWSPACECOUNT:self.viewArray.count;
        CGFloat viewHeight = weakSelf.frame.size.height - TOPSPACE - weakSelf.cardSpace*showSpaceCount;
        view.frame = CGRectMake(weakSelf.cardSpace*showSpaceCount+LEFTSPACE, weakSelf.cardSpace+TOPSPACE, weakSelf.frame.size.width - LEFTSPACE*2 - weakSelf.cardSpace*showSpaceCount*2, viewHeight);
        [weakSelf changeViewFrame];
    }];
}

/**
 *  改变所有视图位置和大小
 */
- (void)changeViewFrame {
    [UIView animateWithDuration:ADDTIME delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        for (int i = 0; i< self.viewArray.count; i++) {
            UIView *view = self.viewArray[i];
            [view.layer removeAllAnimations];
            NSInteger showSpaceCount = self.viewArray.count > SHOWSPACECOUNT?SHOWSPACECOUNT:self.viewArray.count;
            self.cardSpace = CARDBORDERSHOWHEIGHT/showSpaceCount;
            CGFloat viewHeight = self.frame.size.height - TOPSPACE - self.cardSpace*showSpaceCount;
            NSInteger index = 0;
            if((self.viewArray.count - i) <= showSpaceCount) {
                index = showSpaceCount - (self.viewArray.count - i);
                view.alpha = 1;
                view.frame = CGRectMake(self.cardSpace*(showSpaceCount - index)+LEFTSPACE, (showSpaceCount - index)*self.cardSpace+TOPSPACE, self.frame.size.width - LEFTSPACE*2 - self.cardSpace*(showSpaceCount - index)*2, viewHeight);
            } else {
                view.alpha = 0;
                view.frame = CGRectMake(self.cardSpace*showSpaceCount+LEFTSPACE, self.cardSpace+TOPSPACE, self.frame.size.width - LEFTSPACE*2 - self.cardSpace*showSpaceCount*2, viewHeight);
            }
        }
    } completion:nil];
}

/**
 *  随机颜色
 */
- (UIColor *)randomColorAlpha:(CGFloat)alpha
{
    return [UIColor clearColor];
//    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
//    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

-(void)zoomView:(UIView *)view scale:(CGFloat)scale {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1];
    animation.toValue = [NSNumber numberWithFloat:scale];
    animation.duration = ROTATETIME;
    animation.autoreverses = NO;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"zoom"];
}

-(void)moveOutWindowView:(UIView *)view completion:(void (^ __nullable)(BOOL finished))completion {
    CGFloat directionX = (view.centerX - self.beganPoint.x)>0?1:-1;
    CGFloat directionY = (view.centerY - self.beganPoint.y)>0?1:-1;
    [UIView animateWithDuration:REMOVETIME animations:^{
        view.frame = ({
            CGRect frame = view.frame;
            frame.origin.x += ScreenWidth*directionX;
            frame.origin.y += ScreenWidth*directionY;
            frame;
        });
    } completion:completion];
}

@end

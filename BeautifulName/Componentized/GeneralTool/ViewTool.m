//
//  ViewTool.m
//  IntegralWall
//
//  Created by QingHu on 2018/6/25.
//  Copyright © 2018 QingHu. All rights reserved.
//

#import "ViewTool.h"

@interface ViewTool()

@property (nonatomic, strong) ViewToolBlankViewRefreshBlock refreshBlock;
@property (nonatomic, strong) UIView *mainView;

@end

@implementation ViewTool

DEF_SINGLETON(ViewTool)

- (void)drawSectorWithDatas:(NSArray <NSNumber *>*)datas
                     colors:(NSArray <UIColor *>*)colors
                     inView:(UIView *)view
            sectorLineWidth:(NSUInteger)sectorLineWidth
{
    if(!self.needsToRefreshSubLayers)
    {
        self.needsToRefreshSubLayers = [NSMutableArray new];
    }
    NSArray *newDatas = [self getPersentArraysWithDataArray:datas];
    CGFloat start = 0.f;
    CGFloat end = 0.f;
    UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:view.center radius:100 startAngle: - M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    
    for (int i = 0; i < newDatas.count; i ++)
    {
        NSNumber *number = newDatas[i];
        end = start + number.floatValue;
        CAShapeLayer *pieLayer = [CAShapeLayer layer];
        pieLayer.strokeStart = start;
        pieLayer.strokeEnd = end;
        pieLayer.lineWidth = sectorLineWidth;
        pieLayer.strokeColor = [colors.count > i?colors[i]:[UIColor clearColor] CGColor];
        pieLayer.fillColor = [UIColor clearColor].CGColor;
        pieLayer.path = piePath.CGPath;
        
        [self addAnimateToLayer:pieLayer];
        
        [self.needsToRefreshSubLayers addObject:pieLayer];
        
        [view.layer addSublayer:pieLayer];
        start = end;
    }
}

- (void)redrawSectorWithDatas:(NSArray <NSNumber *>*)datas
                       colors:(NSArray <UIColor *>*)colors
                       inView:(UIView *)view
              sectorLineWidth:(NSUInteger)sectorLineWidth
{
    for (int i = 0; i < self.needsToRefreshSubLayers.count; i++)
    {
        CALayer *layer = self.needsToRefreshSubLayers[i];
        [layer removeFromSuperlayer];
    }
    [self.needsToRefreshSubLayers removeAllObjects];
    
    [self drawSectorWithDatas:datas colors:colors inView:view sectorLineWidth:sectorLineWidth];
}

-(void)addAnimateToLayer:(CAShapeLayer *)layer
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.f;
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:1.f];
    //禁止还原
    animation.autoreverses = NO;
    //禁止完成即移除
    animation.removedOnCompletion = NO;
    //让动画保持在最后状态
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:@"strokeEnd"];
}

/**
 将数据按降序排列，再计算出所占比例返回
 
 @param datas 原始数据
 @return 数据占比数组
 */
- (NSArray *)getPersentArraysWithDataArray:(NSArray *)datas
{
    NSArray *newDatas = [datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 floatValue] < [obj2 floatValue])
        {
            return NSOrderedDescending;
        }
        else if ([obj1 floatValue] > [obj2 floatValue])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray *persentArray = [NSMutableArray array];
    NSNumber *sum = [newDatas valueForKeyPath:@"@sum.floatValue"];
    for (NSNumber *number in newDatas)
    {
        [persentArray addObject:@(number.floatValue/sum.floatValue)];
    }
    
    return persentArray;
}


-(void)addBlankViewToView:(UIView *)view title:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image refreshBlock:(ViewToolBlankViewRefreshBlock)refreshBlock
{
    self.refreshBlock = refreshBlock;
    self.mainView = view;
    UIView *backView = [view viewWithTag:1235679];
    [backView removeFromSuperview];
    UILabel *titleLabel = [view viewWithTag:12356790];
    [titleLabel removeFromSuperview];
    UILabel *subTitleLabel = [view viewWithTag:12356791];
    [subTitleLabel removeFromSuperview];
    UIImageView *messageImageView = [view viewWithTag:12356790];
    [messageImageView removeFromSuperview];
    
    UIView *blankBackView = [[UIView alloc] initWithFrame:view.bounds];
    blankBackView.tag = 1235679;
    blankBackView.backgroundColor = [UIColor whiteColor];
    [view addSubview:blankBackView];
    
    UILabel *blankTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height/3.0, view.frame.size.width, 20)];
    blankTitleLabel.tag = 12356790;
    blankTitleLabel.backgroundColor = [UIColor whiteColor];
    blankTitleLabel.textAlignment = NSTextAlignmentCenter;
    blankTitleLabel.textColor = [UIColor blackColor];
    blankTitleLabel.font = kSysFontSize(15);
    blankTitleLabel.text = title;
    [blankBackView addSubview:blankTitleLabel];
    
    UILabel *blankSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(blankTitleLabel.frame) + 10, view.frame.size.width, 40)];
    blankSubTitleLabel.tag = 12356791;
    blankSubTitleLabel.backgroundColor = [UIColor whiteColor];
    blankSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    blankSubTitleLabel.textColor = ItemColorFromRGB(0x666666);
    blankSubTitleLabel.font = kSysFontSize(13);
    blankSubTitleLabel.text = subTitle;
    blankSubTitleLabel.numberOfLines = 0;
    [blankBackView addSubview:blankSubTitleLabel];
    
    UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake((blankBackView.width - 100)/2.0, blankSubTitleLabel.bottom + 20, 100, 40)];
    refreshBtn.tag = 12356792;
    refreshBtn.clipsToBounds = YES;
    refreshBtn.layer.cornerRadius = 10;
    refreshBtn.layer.borderWidth = 1.5;
    refreshBtn.layer.borderColor = ItemColorFromRGB(0x666666).CGColor;
    [refreshBtn setTitle:@"刷新" forState:(UIControlStateNormal)];
    [refreshBtn setTitleColor:ItemColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    refreshBtn.titleLabel.font = kSysFontSize(15);
    [refreshBtn addTarget:self action:@selector(refreshBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [blankBackView addSubview:refreshBtn];
    
    UIImageView *blankImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width-80)/2.0, CGRectGetMinY(blankTitleLabel.frame) - 85, 80, 80*image.size.height/image.size.width)];
    blankImageView.image = image;
    [blankBackView addSubview:blankImageView];
    
    [view bringSubviewToFront:blankBackView];
    [blankBackView bringSubviewToFront:blankTitleLabel];
    [blankBackView bringSubviewToFront:blankSubTitleLabel];
    [blankBackView bringSubviewToFront:blankImageView];
}

-(void)refreshBtnAction:(UIButton *)sender
{
    if(self.refreshBlock)
    {
        if(self.mainView)
        {
            [self removeBlankViewFromView:self.mainView];
        }
        self.refreshBlock();
    }
}

-(void)removeBlankViewFromView:(UIView *)view
{
    UIView *backView = [view viewWithTag:1235679];
    [backView removeFromSuperview];
    UILabel *titleLabel = [view viewWithTag:12356790];
    [titleLabel removeFromSuperview];
    UILabel *subTitleLabel = [view viewWithTag:12356791];
    [subTitleLabel removeFromSuperview];
    UIButton *refreshBtn = [view viewWithTag:12356792];
    [refreshBtn removeFromSuperview];
    UIImageView *messageImageView = [view viewWithTag:12356790];
    [messageImageView removeFromSuperview];
}

-(void)addTransitionAnimationToViews:(NSArray *)viewsArray
{
    [self addTransitionAnimationToViews:viewsArray animationTime:1.0];
}

-(void)addTransitionAnimationToViews:(NSArray *)viewsArray animationTime:(CGFloat)animationTime
{
    for(int i = 0; i < viewsArray.count; i++)
    {
        UIView *view = (UIView *)viewsArray[i];
        view.alpha = 0;
        [UIView animateWithDuration:animationTime animations:^{
            view.alpha = 1.0;
        }];
    }
}

- (UIImage *)snapshotImageWithView:(UIView *)view {
//    UIGraphicsBeginImageContextWithOptions(view.size, YES, [UIScreen mainScreen].scale);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return snapshotImage;
//    UIGraphicsBeginImageContext(view.size);
//    UIGraphicsGetCurrentContext();
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();        //image就是截取的图片
//    UIGraphicsEndImageContext();
//    return image;
    // 高清截屏
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 保存为图片
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (UIImage *)snapLongImageWithWebView:(UIWebView *)webView {
    // 1.获取WebView的宽高
    CGSize boundsSize = webView.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    // 2.获取contentSize
    CGSize contentSize = webView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    // 3.保存原始偏移量，便于截图后复位
    CGPoint offset = webView.scrollView.contentOffset;
    // 4.设置最初的偏移量为(0,0);
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        // 5.获取CGContext 5.获取CGContext
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 6.渲染要截取的区域
        [webView.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 7.截取的图片保存起来
        [images addObject:image];
        
        CGFloat offsetY = webView.scrollView.contentOffset.y;
        [webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    // 8 webView 恢复到之前的显示区域
    [webView.scrollView setContentOffset:offset];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    // 9.根据设备的分辨率重新绘制、拼接成完整清晰图片
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,scale * boundsHeight * idx,scale * boundsWidth,scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return fullImage;
}

-(void)addRotationToView:(UIView *)view isNorDir:(BOOL)isNorSir time:(CGFloat)time repeatCount:(NSInteger)repeatCount {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    if(isNorSir) {
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    } else {
        animation.fromValue = [NSNumber numberWithFloat: M_PI *2];
        animation.toValue = [NSNumber numberWithFloat:0.f];
    }
    animation.duration = time;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [view.layer addAnimation:animation forKey:nil];
}

@end

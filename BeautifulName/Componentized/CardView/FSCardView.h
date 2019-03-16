//
//  FSCardView.h
//  FSCardView
//
//  Created by Paul on 2018/12/28.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat ADDTIME = 0.3f; //卡片出现的动画时长
static CGFloat REMOVETIME = 0.3f; //动画移除的动画时长
static CGFloat ROTATETIME = 0.0001; //旋转动画时长
static CGFloat LEFTSPACE = 5.f; //子视图距左侧的最小距离
static CGFloat TOPSPACE = 5.f; //子视图距顶部的距离
static CGFloat CARDBORDERSHOWHEIGHT = 20.f; //卡片层叠部分的固定高度
static CGFloat SHOWSPACECOUNT = 3; //显示卡片的个数

NS_ASSUME_NONNULL_BEGIN

@interface FSCardView : UIView

@property (nonatomic, assign) BOOL isPanning;

/**
 初始化层叠卡片视图

 @param frame 外边框
 @return 实例本身
 */
- (instancetype)initWithCardFrame:(CGRect)frame;

/**
 刷新视图数组

 @param viewArray 数组中必须为UIView
 */
-(void)refreshViewArray:(NSArray *)viewArray;

@end

NS_ASSUME_NONNULL_END

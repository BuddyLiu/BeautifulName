//
//  ViewTool.h
//  IntegralWall
//
//  Created by QingHu on 2018/6/25.
//  Copyright © 2018 QingHu. All rights reserved.
//

/**
 * 视图控制器工具
 **/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^ViewToolBlankViewRefreshBlock)(void);

@interface ViewTool : NSObject

@property (nonatomic, strong) NSMutableArray *needsToRefreshSubLayers;

GD_SINGLETON(ViewTool)

/**
 画扇形图
 
 @param datas 数据源
 @param colors 对应颜色
 @param view 目标视图
 @param sectorLineWidth 分割线宽度
 */
- (void)drawSectorWithDatas:(NSArray <NSNumber *>*)datas
                     colors:(NSArray <UIColor *>*)colors
                     inView:(UIView *)view
            sectorLineWidth:(NSUInteger)sectorLineWidth;

/**
 页面数据为空时，加载空界面
 
 @param view 目标视图
 @param title 标题
 @param subTitle 子标题
 @param image 图片
 */
-(void)addBlankViewToView:(UIView *)view
                    title:(NSString *)title
                 subTitle:(NSString *)subTitle
                    image:(UIImage *)image
             refreshBlock:(ViewToolBlankViewRefreshBlock)refreshBlock;

/**
 移除空界面
 
 @param view 目标视图
 */
-(void)removeBlankViewFromView:(UIView *)view;

/**
 给一组视图添加过渡动画
 
 @param viewsArray 视图组
 */
-(void)addTransitionAnimationToViews:(NSArray *)viewsArray;
//animationTime 动画时长
-(void)addTransitionAnimationToViews:(NSArray *)viewsArray animationTime:(CGFloat)animationTime;

/**
 截取视图中的某一部分，生成图片

 @param view 要截取的视图
 @return 截取图片
 */
- (UIImage *)snapshotImageWithView:(UIView *)view;

/**
 截取网页长图

 @param webView 网页
 @return 截取长图
 */
- (UIImage *)snapLongImageWithWebView:(UIWebView *)webView;

/**
 给视图添加旋转动画

 @param view 要旋转的视图
 @param isNorSir 默认是顺时针效果，若将isNorSir == NO，则为逆时针效果
 @param time 动画时长
 @param repeatCount 重复次数
 */
-(void)addRotationToView:(UIView *)view isNorDir:(BOOL)isNorSir time:(CGFloat)time repeatCount:(NSInteger)repeatCount;

@end

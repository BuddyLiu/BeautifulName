//
//  ExpandView.h
//  QHWallet
//
//  Created by Paul on 2019/1/4.
//  Copyright © 2019 QingHu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ExpandViewAnimationType) {
    ExpandViewAnimationTypeImageExpand = 0,
    ExpandViewAnimationTypeSingleColorCirle,
    ExpandViewAnimationTypeViewSpring,
    ExpandViewAnimationTypeZoom,
};
typedef void(^ShowEndBlock)(void);

@interface ExpandView : UIView

+(ExpandView *)shareInstance;

-(void)showExpandView:(UIView *)view type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd;
-(void)zoomExpandViewWithType:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd;

-(void)pushToController:(UIViewController *)controller navController:(UINavigationController *)navController hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed expandView:(UIView *)view type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd;
-(void)popWithNavController:(UINavigationController *)navController type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd;

-(void)presentToController:(UIViewController *)controller rootController:(UIViewController *)rootController expandView:(UIView *)view type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd;
-(void)dismissToController:(UIViewController *)controller type:(ExpandViewAnimationType)type showEnd:(ShowEndBlock)showEnd;

@end

NS_ASSUME_NONNULL_END

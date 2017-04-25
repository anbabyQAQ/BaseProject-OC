//
//  BaseViewController.h
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BaseViewControllerDataSource<NSObject>

@optional
-(NSMutableAttributedString*)setTitle;
-(UIButton*)set_leftButton;
-(UIButton*)set_rightButton;
-(UIColor*)set_colorBackground;
-(CGFloat)set_navigationHeight;
-(UIView*)set_bottomView;
-(UIImage*)navBackgroundImage;
-(BOOL)hideNavigationBottomLine;
-(UIImage*)set_leftBarButtonItemWithImage;
-(UIImage*)set_rightBarButtonItemWithImage;
@end


@protocol BaseViewControllerDelegate <NSObject>

@optional
-(void)left_button_event:(UIButton*)sender;
-(void)right_button_event:(UIButton*)sender;
-(void)title_click_event:(UIView*)sender;
@end



@interface BaseViewController : UIViewController<BaseViewControllerDataSource , BaseViewControllerDelegate>

-(void)changeNavigationBarTranslationY:(CGFloat)translationY;
-(void)set_Title:(NSMutableAttributedString *)title;

@property (nonatomic, strong) UIColor *vcBgColor;

#pragma mark - ***** 显示自定义加载框


/*!
 *  三个球 自定义加载动画
 *
 *  @param isShow yes:显示，no:隐藏
 */
- (void)ba_showBallLoadingView:(BOOL)isShow;

#pragma mark - ***** 网络类型判断
/*!
 *  网络判断
 *
 *  @param viewController viewController
 */
- (void)ba_networkChangeWith:(UIViewController *)viewController;

/*!
 *  使用4G网络时的方法调用此方法
 */
- (void)ba_netUse4Gnet;

#pragma mark - ***** VC的基本设置
/*!
 *  设置VC的背景颜色
 *
 *  @param vcBgColor vcBgColor
 */
//- (void)setVCBgColor:(UIColor *)vcBgColor;

/*!
 *  创建UI
 */
- (void)ba_setupUI;

#pragma mark - ***** VC的navi设置
/*!
 *  设置navi
 */
- (void)ba_setupNavi;
/*!
 *  是否隐藏naviBar
 *
 *  @param hidden YES：隐藏，NO：显示
 */
- (void)ba_setNavbarBackgroundHidden:(BOOL)hidden;

@end

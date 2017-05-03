//
//  AppDelegate+TabVC.m
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "AppDelegate+TabVC.h"
/*! 用RDVTabBarController，使用此头文件 */
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#import "BAHomeViewController.h"
#import "BAMessageViewController.h"
#import "BAProfileViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate (TabVC)

- (void)initWithTabVC{
    
    BOOL isLogin = [BA_UserDefault objectForKey:FirstLogin];
    if (!isLogin) {
        //第一次登录处理
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        self.navController = [[BANavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = self.navController;
        [self.window makeKeyAndVisible];
    }else{
        [self setupViewControllers];
        [self.window setRootViewController:self.viewController];
        [self.window makeKeyAndVisible];
    }

    [self customizeInterface];
    
}

#pragma mark - ***** 使用RDVTabBarController 设置
#pragma mark 初始化各个ViewController
- (void)setupViewControllers
{
    UIViewController *firstViewController = [[BAHomeViewController alloc] init];
    UIViewController *firstNavigationController = [[BANavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[BAMessageViewController alloc] init];
    UIViewController *secondNavigationController = [[BANavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *fourViewController = [[BAProfileViewController alloc] init];
    UIViewController *fourNavigationController = [[BANavigationController alloc]
                                                  initWithRootViewController:fourViewController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController, fourNavigationController]];
    self.viewController = tabBarController;
    tabBarController.selectedIndex = 0;
    
    
    [self customizeTabBarForController:tabBarController];
}
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    NSArray *tabBarItemImages = @[@"tabbar_home", @"tabbar_message_center",  @"tabbar_profile"];
    NSArray *titlesArray = @[@"首页", @"消息", @"我的",];
    
    NSInteger index = 0;
    NSDictionary *textAttributes = nil;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title = [titlesArray objectAtIndex:index];
        textAttributes = @{
                           NSFontAttributeName: [UIFont systemFontOfSize:12],
                           NSForegroundColorAttributeName: [UIColor orangeColor],
                           };
        [item setSelectedTitleAttributes:textAttributes];
        index++;
    }
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

@end

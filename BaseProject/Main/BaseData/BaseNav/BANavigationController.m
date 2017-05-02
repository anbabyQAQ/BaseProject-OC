//
//  BANavigationController.m
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BANavigationController.h"
#import "BANavigationBar.h"
#import "BACustomBarItem.h"

@interface BANavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;


@end

@implementation BANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    // 实现滑动返回功能
    // 清空滑动返回手势代理
    self.interactivePopGestureRecognizer.delegate = nil;
    self.delegate = self;
    
    //    BANavigationBar *bar = self.navigationBar;
    //    [bar setBackgroundImage:[UIImage imageNamed:@"005.jpg"] forBarMetrics:UIBarMetricsCompactPrompt];
    //    [bar setBarTintColor:BA_White_Color];
    
    BANavigationBar *bar = [[BANavigationBar alloc]initWithFrame:CGRectMake(0, 20, BA_SCREEN_WIDTH, 44)];
    [self setValue:bar forKey:@"navigationBar"];
    //    [bar setBarTintColor:BA_White_Color];
    //    [bar setTranslucent:NO]; // 半透明
    
    bar.barTintColor = BA_Gray_Color;
    
    // 去掉导航分割线
    [bar setShadowImage:[UIImage new]];
    
    // 设置导航条按钮的文字颜色
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = BA_White_Color;
    titleAttr[NSFontAttributeName] = BA_FontSize(18);
    
    [bar setTitleTextAttributes:titleAttr];
}

/*! 当用户刷时,导航控制器的navigationBar会隐藏或显示 */
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    if (navigationBarHidden)
    {
        self.hidesBarsOnSwipe = YES;
    }
    else
    {
        self.hidesBarsOnSwipe = NO;
    }
    
}

// 导航控制器跳转完成的时候调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    BALog(@"%@", self.viewControllers[0]);
    if (viewController == self.viewControllers[0])
    {
        // 显示根控制器
        // 返回滑动返回手势代理
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    }
    else
    {
        // 实现滑动返回功能
        // 清空滑动返回手势代理
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 设置非根控制器导航条内容
    if (self.viewControllers.count)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置导航条的内容
        // 设置导航条左边 右边
        // 左边
        //        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_back"] highImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] target:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        
        //        UIBarButtonItem *left;
        //        /*! 从这里统一设置四个tabbarVC推出的子VC的navi的返回按钮图片 */
        //        if ([self.viewControllers.firstObject isKindOfClass:[BAHomeViewController class]])
        //        {
        //            left = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"profileVC.bundle/返回白色"] highImage:nil target:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        //        }
        //        else if ([self.viewControllers.firstObject isKindOfClass:[BAMessageViewController class]])
        //        {
        //            left = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"otherImages.bundle/返回黄色"] highImage:nil target:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        //        }
        //        else if ([self.viewControllers.firstObject isKindOfClass:[BADiscoverViewController class]])
        //        {
        //            left = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"otherImages.bundle/返回绿色"] highImage:nil target:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        //        }
        //        else if ([self.viewControllers.firstObject isKindOfClass:[BAProfileViewController class]])
        //        {
        //            left = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"profileVC.bundle/返回蓝色"] highImage:nil target:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        //        }
        
        // 设置导航条的按钮
        viewController.navigationItem.leftBarButtonItem = left;
        
        
        //        // 右边
        //        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_more"] highImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] target:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backToPre
{
    [self popViewControllerAnimated:YES];
}

- (void)backToRoot
{
    [self popToRootViewControllerAnimated:YES];
}

/**
 *  导航控制器 统一管理状态栏颜色
 *  @return 状态栏颜色
 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

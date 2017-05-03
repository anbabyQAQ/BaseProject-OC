//
//  AppDelegate.m
//  BaseProject
//
//  Created by tyl on 2017/4/21.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+TabVC.h"
#import "LoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //初始化根控制器
    [self initWithTabVC];

    /*! 键盘处理 */
    [self BA_KeyboardSetting];
    
    
    //网络监听
    [self netWorkMonitoring];
    
    return YES;
}

- (void)netWorkMonitoring{
    [BaseNetManager ba_startNetWorkMonitoringWithBlock:^(BANetworkStatus status) {
        switch (status)
        {
            case BANetworkStatusUnknown:
                NSLog(@"未知网络");
                
                break;
            case BANetworkStatusNotReachable:
                NSLog(@"没有网络");
                
                break;
            case BANetworkStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                
                break;
            case BANetworkStatusReachableViaWiFi:
                NSLog(@"wifi 网络");
                
                break;
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifi:) name:AFNetworkingReachabilityDidChangeNotification object:nil];  
}
- (void)notifi:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    
    BAWeak;
    //获取网络状态
    NSInteger status = [[dic objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    
    if(status == AFNetworkReachabilityStatusNotReachable) {
        //无网络连接
        [weakSelf BA_showAlertWithTitle:@"无网络连接"];
    }else if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
        //蜂窝网络或者Wi-Fi连接
//        [weakSelf BA_showAlertWithTitle:@"无网络连接"];
    }
}

#pragma mark - ***** 键盘处理
- (void)BA_KeyboardSetting
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
    /*! 如果某个VC不想用IQkeyboard，就在这里用这两行代码把那个VC加进去就行，那个VC就可以用自己写的键盘代理 */
    //    [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[DemoVC6 class]];
    //    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[DemoVC6 class]];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

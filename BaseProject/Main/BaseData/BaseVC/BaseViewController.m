//
//  BaseViewController.m
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BaseViewController.h"
#import "BALoadingHubView.h"
#import "RDVTabBarController.h"
#import "BANavigationBar.h"
#import "UIViewController+BAAlertView.h"
#import "BASystermSetting.h"

@interface BaseViewController ()
{
    CGFloat navigationY;
    CGFloat navBarY;
    CGFloat verticalY;
}

/*! 雪花动画 */
@property (strong, nonatomic) CADisplayLink    *displayLink;
/*! 自定义naviView */
@property (strong, nonatomic) UIView           *naviView;

@property (nonatomic, strong) BALoadingHubView *loadingHubView;

@end

@implementation BaseViewController

-(id)init
{
    if (self= [super init]) {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController setNavigationBarHidden:YES];
        navBarY = 0;
        navigationY = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    if ([self respondsToSelector:@selector(set_colorBackground)]) {
        UIColor *backgroundColor =  [self set_colorBackground];
        UIImage *bgimage = [self imageWithColor:backgroundColor];
        
        [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    }
    
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //默认显示黑线
    blackLineImageView.hidden = NO;
    if ([self respondsToSelector:@selector(hideNavigationBottomLine)]) {
        if ([self hideNavigationBottomLine]) {
            //隐藏黑线
            blackLineImageView.hidden = YES;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*! 1、基本设置 */
    [self setupBase];
    
    /*! 2、navi设置 */
    [self ba_setupNavi];
    
    /*! 3、创建UI */
    [self ba_setupUI];
    
    self.extendedLayoutIncludesOpaqueBars=YES;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    
    if ([self respondsToSelector:@selector(backgroundImage)]) {
        UIImage *bgimage = [self navBackgroundImage];
        [self setNavigationBack:bgimage];
    }
    if ([self respondsToSelector:@selector(setTitle)]) {
        NSMutableAttributedString *titleAttri = [self setTitle];
        [self set_Title:titleAttri];
    }
    if (![self leftButton]) {
        [self configLeftBaritemWithImage];
    }
    
    if (![self rightButton]) {
        [self configRightBaritemWithImage];
    }
}

/**
 *  @brief  根据颜色生成纯色图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(void)setNavigationBack:(UIImage*)image
{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image ];
    [self.navigationController.navigationBar setShadowImage:image];
}

-(void)set_Title:(NSMutableAttributedString *)title
{
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines=0;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    self.navigationItem.titleView = navTitleLabel;
}
-(void)titleClick:(UIGestureRecognizer*)Tap
{
    UIView *view = Tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}
#pragma mark -- left_item
-(void)configLeftBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)]) {
        UIImage *image = [self set_leftBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleBordered target:self  action:@selector(left_click:)];
        self.navigationItem.backBarButtonItem = item;
    }
}

-(void)configRightBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
        UIImage *image = [self set_rightBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleBordered target:self  action:@selector(right_click:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}


#pragma mark -- left_button
-(BOOL)leftButton
{
    BOOL isleft =  [self respondsToSelector:@selector(set_leftButton)];
    if (isleft) {
        UIButton *leftbutton = [self set_leftButton];
        [leftbutton addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
        self.navigationItem.leftBarButtonItem = item;
    }
    return isleft;
}

#pragma mark -- right_button
-(BOOL)rightButton
{
    BOOL isright = [self respondsToSelector:@selector(set_rightButton)];
    if (isright) {
        UIButton *right_button = [self set_rightButton];
        [right_button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
        self.navigationItem.rightBarButtonItem = item;
    }
    return isright;
}


-(void)left_click:(id)sender
{
    if ([self respondsToSelector:@selector(left_button_event:)]) {
        [self left_button_event:sender];
    }
}

-(void)right_click:(id)sender
{
    if ([self respondsToSelector:@selector(right_button_event:)]) {
        [self right_button_event:sender];
    }
}

-(void)changeNavigationBarHeight:(CGFloat)offset
{
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationController.navigationBar.frame  = CGRectMake(
                                                                    self.navigationController.navigationBar.frame.origin.x,
                                                                    navigationY,
                                                                    self.navigationController.navigationBar.frame.size.width,
                                                                    offset
                                                                    );
    }];
    
}

-(void)changeNavigationBarTranslationY:(CGFloat)translationY
{
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}

//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - ***** 基本设置
#pragma mark 创建UI
- (void)ba_setupUI
{
    
}


- (void)setupBase
{
    self.view.backgroundColor = BA_White_Color;
    
    
}

/*!
 *  设置VC的背景颜色
 *
 *  @param vcBgColor vcBgColor
 */
- (void)setVcBgColor:(UIColor *)vcBgColor
{
    _vcBgColor = vcBgColor;
    self.view.backgroundColor = vcBgColor;
}

#pragma mark - ***** navi设置
- (void)ba_setupNavi
{
    
}

#pragma mark - ***** 网络类型判断
/*!
 *  网络判断
 *
 *  @param viewController viewController
 */
- (void)ba_networkChangeWith:(UIViewController *)viewController
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    BA_WEAKSELF;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
                
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            {
                BALog(@"当前网络未知！");
                [weakSelf BA_showAlertWithTitle:@"当前网络未知！"];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                BALog(@"当前无网络！");
                [self BAAlertWithTitle:@"温馨提示：" message:@"亲！当前无网络！去设置网络" andOthers:@[@"取消", @"确认"] animated:YES action:^(NSInteger index) {
                    
                    if (index == 0)
                    {
                    }
                    if (index == 1)
                    {
                        [[BASystermSetting ba_systermSettingManage] ba_gotoSystermSettings];
                    }
                }];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                [self BAAlertWithTitle:@"温馨提示：" message:@"亲！正在使用手机3G/4G网络" andOthers:@[@"取消", @"确认"] animated:YES action:^(NSInteger index) {
                    
                    if (index == 0)
                    {
                    }
                    if (index == 1)
                    {
                        [weakSelf ba_netUse4Gnet];
                    }
                }];
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                BALog(@"当前是WiFi环境！");
                [weakSelf BA_showAlertWithTitle:@"当前是WiFi环境！"];
                break;
            }
        }
    }];
    
    // 3.开始监控
    [manager startMonitoring];
}

/*!
 *  使用4G网络时的方法回调
 */
- (void)ba_netUse4Gnet
{
    BALog(@"使用3G/4G网络情况处理方法调用！");
}


#pragma mark - ***** 其他设置
/*!
 *  是否隐藏naviBar
 *
 *  @param hidden YES：隐藏，NO：显示
 */
- (void)ba_setNavbarBackgroundHidden:(BOOL)hidden
{
    BANavigationBar *navBar =(BANavigationBar *)self.navigationController.navigationBar;
    if (hidden) {
        [navBar BA_hiddenNaviBar];
    }else{
        [navBar BA_showNaviBar];
    }
}

#pragma mark - ***** 各种动画开关

/*! 三个球 自定义加载动画 */
- (void)ba_showBallLoadingView:(BOOL)isShow
{
    if (isShow)
    {
        _loadingHubView = [[BALoadingHubView alloc] initWithFrame:CGRectMake(85, 80, 150, 150)];
        _loadingHubView.center = self.view.center;
        //        _loadingHubView = [[BALoadingHubView alloc] initWithFrame:CGRectMake(85, 80, 150, 150)];
        [self.view addSubview:_loadingHubView];
        [_loadingHubView showHub];
    }
    else
    {
        [_loadingHubView dismissHub];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

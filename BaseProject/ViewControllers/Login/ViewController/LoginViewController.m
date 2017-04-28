//
//  LoginViewController.m
//  BaseProject
//
//  Created by tyl on 2017/4/27.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "LoginViewController.h"
#import "PostLoginThread.h"

@interface LoginViewController ()


/** scrollView*/
@property (strong, nonatomic) UIScrollView *myScrollView;

/** 头像*/
@property (strong, nonatomic) UIImageView *iconImageView;
/** 账号标题*/
@property (strong, nonatomic) UILabel *accountTitle;
/** 密码标题*/
@property (strong, nonatomic) UILabel *PswTitle;
/** 第一条分割线*/
@property (strong, nonatomic) UIView *firstSegLine;
/** 第二条分割线*/
@property (strong, nonatomic) UIView *secondSegLine;

/** 用户名输入框*/
@property (nonatomic, strong) BATextField *tfName;
/** 登录按钮*/
@property (strong, nonatomic) UIButton *btLogin;
/** 忘记密码按钮*/
@property (strong, nonatomic) UIButton *btPsw;
/** 密码输入框*/
@property (nonatomic, strong) BATextField *tfPsw;
/** 密码输入框右侧的眼睛*/
@property (nonatomic, strong) UIButton *isVisiableBtn;
/** 判断是否离线模式*/
@property (nonatomic, assign) BOOL isOffLine;


@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
   
    [self setUpUI];
//    self.tfName.phoneRestrict = YES;
//    self.tfName.textfieldStyle = BATextfieldStylePhone;

  
    RACSignal *usernameSignal = [self.tfName.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    RACSignal *passwordSignal = [self.tfPsw.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
    RACSignal *loginEnableSignal = [RACSignal combineLatest:@[usernameSignal,passwordSignal] reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
        BOOL islogin = [usernameValid boolValue] && [passwordValid boolValue];
        [self setLoginBackColor:islogin];
         return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    RAC(self.btLogin, enabled) = loginEnableSignal;


    @weakify(self);
    [[[[self.btLogin rac_signalForControlEvents:(UIControlEventTouchUpInside)]
     doNext:^(id x) {
         @strongify(self);
         [self.view endEditing:YES];
         self.btLogin.enabled = NO;
     }]
     flattenMap:^RACStream *(id value) {
         @strongify(self);
         return [self loginSignal];
     }]
    subscribeNext:^(NSNumber *result) {
        @strongify(self);
        BOOL success = [result boolValue];
        self.btLogin.enabled = YES;
        if (success) {
            [self goToLoginSuccessVC];
        }
    }];
    
    
    [[self.btPsw rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         NSLog(@"button clicked");
     }];
    
    
    [[self.isVisiableBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)]
     subscribeNext:^(UIButton *btn) {
         [self isVisiableAction:btn];
     }];
    
}

- (RACSignal *)loginSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self loginWithUsername:self.tfName.text password:self.tfPsw.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (void)ForgetPsw{
  //忘记密码
    
}

- (void)goToLoginSuccessVC {

}

- (void)setUpUI{
    // 布局
    self.view.backgroundColor = [UIColor whiteColor];
    self.myScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.backgroundColor = KRGBA(220, 220, 220, 1);
    [self.view addSubview:self.myScrollView];
    
    [self setSubviewsLayout];
    
    _tfName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tfPsw.clearButtonMode  = UITextFieldViewModeWhileEditing;
    [_btLogin.layer setCornerRadius:6];
}

#pragma mark - Event Response

- (void)isVisiableAction:(UIButton *)btn {
    
    if (self.tfPsw.isSecureTextEntry) {
        self.tfPsw.secureTextEntry = NO;
    }else {
        self.tfPsw.secureTextEntry = YES;
    }
}

// 模拟触发一个API: 用户名和密码分别为username和password才登录成功
// 调用API属于逻辑范畴，和UI无关
- (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(void (^)(BOOL))loginResult {
    BAWeak;

    if ([BARegularExpression ba_isPhoneNumber:username]) {
        if ([BARegularExpression ba_isPasswordQualified:password]) {
            
            [PostLoginThread postLoginDataWithParameters:@{@"mdn":username,@"password":password}
                                                    prev:^{
                                                        [weakSelf BA_showAlert:@"正在加载数据"];

                                                    } success:^(id model) {
                                                        [weakSelf BA_hideProgress];
                                                        loginResult(YES);
                                                    } unavaliableNetwork:^{
                                                        [weakSelf BA_hideProgress];
                                                        loginResult(NO);

                                                        [weakSelf BA_showAlertWithTitle:@"无网络状态！"];
                                                    } timeout:^{
                                                        [weakSelf BA_hideProgress];
                                                        loginResult(NO);

                                                        [weakSelf BA_showAlertWithTitle:@"网络超时！"];
                                                    } exception:^(NSError *error) {
                                                        [weakSelf BA_hideProgress];
                                                        loginResult(NO);

                                                        [weakSelf BA_showAlertWithTitle:[NSString stringWithFormat:@"%@",error]];

                                                    }];        
        }else{
             [BAAlertView showTitle:@"提 示" message:@"查看输入密码是否以字母开头，长度在6-18之间，只能包含字符、数字和下划线！"];
        }}else{
            [BAAlertView showTitle:@"提 示" message:@"查看输入电话号码格式是否正确！"];

        }
}

#pragma mark - Private Methods
/**
 *  布局子控件
 */
- (void)setSubviewsLayout {
    
    // 头像布局
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = KRGBA(128, 128, 128, 1);
    self.iconImageView.image = [UIImage imageNamed:@"Icon_loginHead"];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.layer.cornerRadius = 6.f;
    self.iconImageView.frame = CGRectMake((BA_SCREEN_WIDTH - 100) / 2, 70, 100, 100);
    [self.myScrollView addSubview:self.iconImageView];
    
    // 账号标题
    self.accountTitle = [[UILabel alloc] init];
    self.accountTitle.text = @"账号";
    self.accountTitle.textColor = [UIColor darkGrayColor];
    self.accountTitle.frame = CGRectMake(20, self.iconImageView.bottom + 50, 80, 30);
    [self.myScrollView addSubview:self.accountTitle];
    
    // 账号
    self.tfName = [[BATextField alloc] init];
    self.tfName.textColor = [UIColor darkGrayColor];
    self.tfName.placeholder = @"请输入手机号";
    self.tfName.keyboardType = UIKeyboardTypeNumberPad;
//    self.tfName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfName.frame = CGRectMake(100, self.accountTitle.frame.origin.y, BA_SCREEN_WIDTH - 140, 30);
    [self.myScrollView addSubview:self.tfName];
    
    // 第一条分割线
    self.firstSegLine = [[UIView alloc] init];
    self.firstSegLine.backgroundColor = KRGBA(128, 128, 128, 1);
    self.firstSegLine.frame = CGRectMake(0, self.accountTitle.frame.origin.y + 40, BA_SCREEN_WIDTH, 0.5);
    [self.myScrollView addSubview:self.firstSegLine];
    
    // 密码标题
    self.PswTitle = [[UILabel alloc] init];
    self.PswTitle.text = @"密码";
    self.PswTitle.textColor = [UIColor darkGrayColor];
    self.PswTitle.frame = CGRectMake(20, self.firstSegLine.frame.origin.y + 11, 80, 30);
    [self.myScrollView addSubview:self.PswTitle];
    
    // 密码
    self.tfPsw = [[BATextField alloc] init];
    self.tfPsw.textColor = [UIColor darkGrayColor];
    self.tfPsw.placeholder = @"请输入密码";
    self.tfPsw.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfPsw.secureTextEntry = YES;
    self.tfPsw.frame = CGRectMake(100, self.PswTitle.frame.origin.y, BA_SCREEN_WIDTH - 140, 30);
    [self.myScrollView addSubview:self.tfPsw];
    
    // 密码右侧的眼睛
    self.isVisiableBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.isVisiableBtn.frame = CGRectMake(BA_SCREEN_WIDTH - 44 - 8, self.tfPsw.frame.origin.y, 44, 30);
    [self.isVisiableBtn setImage:[UIImage imageNamed:@"yanjing.jpg"] forState:(UIControlStateNormal)];
//    [self.isVisiableBtn addTarget:self action:@selector(isVisiableAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.myScrollView addSubview:self.isVisiableBtn];
    
    // 第二条分割线
    self.secondSegLine = [[UIView alloc] init];
    self.secondSegLine.backgroundColor = KRGBA(128, 128, 128, 1);
    self.secondSegLine.frame = CGRectMake(0, self.PswTitle.frame.origin.y + 40, BA_SCREEN_WIDTH, 0.5);
    [self.myScrollView addSubview:self.secondSegLine];
    
    
    // 忘记密码按钮
    self.btPsw = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btPsw.backgroundColor = [UIColor clearColor];
    [self.btPsw setTitle:@"忘记密码？" forState:(UIControlStateNormal)];
    self.btPsw.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btPsw setTitleColor:[UIColor colorWithHexString:@"e97300"] forState:(UIControlStateNormal)];
    self.btPsw.frame = CGRectMake(BA_SCREEN_WIDTH-15-74, self.secondSegLine.bottom+21, 74, 31);
    [self.myScrollView addSubview:self.btPsw];
    
    // 登录按钮
    self.btLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btLogin.backgroundColor = KRGBA(128, 128, 128, 1);
    [self.btLogin setTitle:@"登录" forState:(UIControlStateNormal)];
    [self.btLogin setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.btLogin.layer.cornerRadius = 6.f;
    self.btLogin.frame = CGRectMake(20, self.btPsw.bottom + 21, BA_SCREEN_WIDTH - 40, 44);
    [self.myScrollView addSubview:self.btLogin];

    self.myScrollView.contentSize = CGSizeMake(BA_SCREEN_WIDTH, BA_SCREEN_HEIGHT);
}

// 这两个判断都属于逻辑范畴，和UI无关
- (BOOL)isValidUsername:(NSString *)username {

    return username.length == 11;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 0;
}

- (void)setLoginBackColor:(BOOL)islogin {
    if (islogin) {
        self.btLogin.backgroundColor = [UIColor blueColor];
    }else{
        self.btLogin.backgroundColor = KRGBA(128, 128, 128, 1);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
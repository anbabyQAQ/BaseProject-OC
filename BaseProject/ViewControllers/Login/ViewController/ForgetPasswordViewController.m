//
//  ForgetPasswordViewController.m
//  BaseProject
//
//  Created by tyl on 2017/4/28.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

/** scrollView*/
@property (strong, nonatomic) UIScrollView *myScrollView;


/** 第一条分割线*/
@property (strong, nonatomic) UIView *firstSegLine;
/** 第二条分割线*/
@property (strong, nonatomic) UIView *secondSegLine;

/** 用户名输入框*/
@property (nonatomic, strong) BATextField *tfName;
/** 发送按钮*/
@property (strong, nonatomic) UIButton *btSender;
/** 获取验证码按钮*/
@property (strong, nonatomic) UIButton *btGetCode;
/** 验证码输入框*/
@property (nonatomic, strong) BATextField *tfPsw;


@property (nonatomic, assign) NSInteger remainSeconds;

@property (nonatomic, assign) NSInteger startCheckTimer;

@end

@implementation ForgetPasswordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    [self setUpUI];
    [self configBackItem];
    
    self.tfName.phoneRestrict = YES;
    self.tfName.textfieldStyle = BATextfieldStylePhone;
    
    
    RACSignal *tfNameSignal = [self.tfName.rac_textSignal map:^id(NSString * text) {
        return @([self isValidUsername:text]);
    }];
    
    RACSignal *tfPswSignal  = [self.tfPsw.rac_textSignal map:^id(NSString * text) {
        return @([self isValidPassword:text]);
    }];
    
    RACSignal *SenderEndleSignl = [RACSignal combineLatest:@[tfNameSignal,tfPswSignal] reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
        BOOL islogin = [usernameValid boolValue] && [passwordValid boolValue];
        [self setLoginBackColor:islogin];
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    RAC(self.btSender ,enabled) = SenderEndleSignl;
    
    @weakify(self);
    [[[[self.btSender rac_signalForControlEvents:UIControlEventTouchUpInside]
     doNext:^(id x) {
         @strongify(self);
         self.btSender.enabled = NO;
     }]
    
     flattenMap:^RACStream *(id value) {
         @strongify(self);
         return [self sendSignal];
     }]
     subscribeNext:^(NSNumber *result) {
         @strongify(self);
         BOOL success = [result boolValue];
         self.btSender.enabled = YES;
         if (success) {
             [self sendSuccess];
         }
     }];

    
    [[[[self.btGetCode rac_signalForControlEvents:(UIControlEventTouchUpInside)]
     
       doNext:^(id x) {
           @strongify(self);
           self.remainSeconds = 60;
           self.startCheckTimer = 1;
           self.btGetCode.enabled = NO;
           [self.btGetCode.layer setBorderColor:KRGBA(128, 128, 128, 1).CGColor];
           [self.btGetCode setTitleColor:KRGBA(128, 128, 128, 1) forState:UIControlStateNormal];
       }]
      flattenMap:^RACStream *(id value) {
          @strongify(self);
          return  [self setTime];
      }]
     subscribeNext:^(NSNumber *x) {
         @strongify(self);
         self.btGetCode.enabled = YES;
         [self.btGetCode.layer setBorderColor:[UIColor colorWithHexString:@"e97300"].CGColor];
         [self.btGetCode setTitleColor:[UIColor colorWithHexString:@"e97300"] forState:UIControlStateNormal];

     }];
    
}

- (RACSignal *)setTime{

    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
        RACSignal *signal = [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]]
                              take:self.remainSeconds+1]
                             map:^id(NSDate* value) {
                                 NSString *text;
                                 if(self.remainSeconds > 0 && self.startCheckTimer){
                                     self.remainSeconds = self.remainSeconds - 1;
                                     if(self.remainSeconds == 0){
                                         self.startCheckTimer = 0;
                                     }
                                     text = [NSString stringWithFormat:@"%lds重新获取",self.remainSeconds];
                                 }else{
                                     text  = [NSString stringWithFormat:@"获取验证码"];
                                     [subscriber sendNext:@(YES)];
                                     [subscriber sendCompleted];
                                 }
                                 return text;
                             }];
        [signal subscribeNext:^(NSString* x) {
            @strongify(self);
            [self.btGetCode setTitle:x forState:(UIControlStateNormal)];
        }];
        
        return nil;
        
    }];

}

- (void)sendSuccess{
    [BAAlertView showTitle:@"提 示" message:@"发送成功！"];

}


- (RACSignal *)sendSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self sendWithUsername:self.tfName.text password:self.tfPsw.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (void)sendWithUsername:(NSString *)username password:(NSString *)password complete:(void (^)(BOOL))loginResult {
    BAWeak;
    
    if (![weakSelf isValidPhoneNumber:username]) {
        [BAAlertView showTitle:@"提 示" message:@"查看输入电话号码格式是否正确！"];
        loginResult(NO);
        return;
    }
    if (![weakSelf isValidPassword:password]) {
        [BAAlertView showTitle:@"提 示" message:@"查看输入验证码，长度是6位数字组合！"];
        loginResult(NO);
        return;
    }
   
    
    loginResult(YES);

    
//    [PostLoginThread postLoginDataWithParameters:@{@"mdn":username,@"password":password}
//                                            prev:^{
//                                                [weakSelf BA_showAlert:@"正在加载数据"];
//                                                
//                                            } success:^(id model) {
//                                                [weakSelf BA_hideProgress];
//                                                loginResult(YES);
//                                                
//                                                [weakSelf BA_showAlertWithTitle:@"请求成功！"];
//                                            } unavaliableNetwork:^{
//                                                [weakSelf BA_hideProgress];
//                                                loginResult(NO);
//                                                
//                                                [weakSelf BA_showAlertWithTitle:@"无网络状态！"];
//                                            } timeout:^{
//                                                [weakSelf BA_hideProgress];
//                                                loginResult(NO);
//                                                
//                                                [weakSelf BA_showAlertWithTitle:@"网络超时！"];
//                                            } exception:^(NSError *error) {
//                                                [weakSelf BA_hideProgress];
//                                                loginResult(NO);
//                                                
//                                                [weakSelf BA_showAlertWithTitle:[NSString stringWithFormat:@"%@",error]];
//                                                
//                                            }];
}


#pragma mark - isValid Methods
- (BOOL) isValidPhoneNumber:(NSString *)phoneNumber{
    //保留纯数字 ： [phoneNumber ba_removeStringSaveNumber]
    
    return  [BARegularExpression ba_isPhoneNumber:[phoneNumber ba_removeStringSaveNumber]];
}

- (void)setLoginBackColor:(BOOL)islogin {
    if (islogin) {
        self.btSender.backgroundColor = [UIColor blueColor];
    }else{
        self.btSender.backgroundColor = KRGBA(128, 128, 128, 1);
    }
}

// 这两个判断都属于逻辑范畴，和UI无关
- (BOOL)isValidUsername:(NSString *)username {
    
    return username.length == 13;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length == 6;
}

- (void)setUpUI{
    // 布局
    self.view.backgroundColor = [UIColor whiteColor];
    self.myScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myScrollView];
    
    
    [self setSubviewsLayout];
    
    
    _tfName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tfPsw.clearButtonMode  = UITextFieldViewModeWhileEditing;
    [_btSender.layer setCornerRadius:6];
}

#pragma mark - Private Methods
/**
 *  布局子控件
 */
- (void)setSubviewsLayout {

    // 账号
    self.tfName = [[BATextField alloc] init];
    self.tfName.textColor = [UIColor darkGrayColor];
    self.tfName.placeholder = @"请输入手机号码";
    self.tfName.keyboardType = UIKeyboardTypeNumberPad;
    self.tfName.font = BA_FontSize(14);
    [self.myScrollView addSubview:self.tfName];

    // 第一条分割线
    self.firstSegLine = [[UIView alloc] init];
    self.firstSegLine.backgroundColor = KRGBA(128, 128, 128, 1);
    [self.myScrollView addSubview:self.firstSegLine];
    
    
    // 验证码
    self.tfPsw = [[BATextField alloc] init];
    self.tfPsw.textColor = [UIColor darkGrayColor];
    self.tfPsw.placeholder = @"请输入验证码";
    self.tfPsw.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfPsw.keyboardType = UIKeyboardTypeNumberPad;
    self.tfPsw.font = BA_FontSize(14);
    [self.myScrollView addSubview:self.tfPsw];
    
    // 第二条分割线
    self.secondSegLine = [[UIView alloc] init];
    self.secondSegLine.backgroundColor = KRGBA(128, 128, 128, 1);
    [self.myScrollView addSubview:self.secondSegLine];

    
    // 获取验证码按钮
    self.btGetCode = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btGetCode.backgroundColor = [UIColor clearColor];
    [self.btGetCode setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    self.btGetCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btGetCode setTitleColor:[UIColor colorWithHexString:@"e97300"] forState:(UIControlStateNormal)];
    self.btGetCode.layer.cornerRadius = 6.f;
    [self.btGetCode.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [self.btGetCode.layer setCornerRadius:6];
    [self.btGetCode.layer setBorderWidth:1];//设置边界的宽度
    [self.btGetCode.layer setBorderColor:[UIColor colorWithHexString:@"e97300"].CGColor];
    self.btGetCode.lineBreakMode = NSLineBreakByWordWrapping;
    [self.myScrollView addSubview:self.btGetCode];
    
    // 发送按钮
    self.btSender = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btSender.backgroundColor = KRGBA(128, 128, 128, 1);
    [self.btSender setTitle:@"发送" forState:(UIControlStateNormal)];
    [self.btSender setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.btSender.layer.cornerRadius = 6.f;
    [self.myScrollView addSubview:self.btSender];
    
    
    [self.tfName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(30);
        make.width.mas_equalTo(BA_SCREEN_WIDTH - 140);
        make.height.mas_equalTo(30);
    }];
    
    [self.firstSegLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tfName.mas_bottom);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(BA_SCREEN_WIDTH-20);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tfPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstSegLine.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.tfName.mas_left);
        make.width.mas_equalTo(BA_SCREEN_WIDTH - 140);
        make.height.mas_equalTo(30);
    }];
    
    [self.secondSegLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tfPsw.mas_bottom);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(BA_SCREEN_WIDTH-20);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.btGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tfPsw.mas_top);
        make.right.mas_equalTo(BA_SCREEN_WIDTH-15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
    }];
    
    [self.btSender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btGetCode.mas_bottom).offset(21);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(BA_SCREEN_WIDTH - 40);
        make.height.mas_equalTo(44);
    }];
    
    self.myScrollView.contentSize = CGSizeMake(BA_SCREEN_WIDTH, BA_SCREEN_HEIGHT-BA_NAVIGATION_HEIGHT);

    
}

- (void)configBackItem
{
    UIImage *backImage = [UIImage imageNamed:@"navigationbar_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTintColor:BA_Black_Color];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = colseItem;
}

- (void)backBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

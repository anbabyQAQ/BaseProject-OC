//
//  BAHomeViewController.m
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BAHomeViewController.h"
#import "BAMessageViewController.h"
#import "DemoWebviewController.h"

@interface BAHomeViewController ()

@end

@implementation BAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"首页";
    
    //    vc.urlString = @"http://192.168.14.68:8080/HumanAnalysis/index.html";
//    vc.urlString = @"http://192.168.18.248:8081/mts/testapp/index.html";
    
    
    //    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    //    NSURL* url = [NSURL fileURLWithPath:path];
    //    vc.urlString = url.absoluteString;
    self.urlString = @"http://192.168.18.248:8081/mts/testapp/index.html";
    [self loadRequest:self.urlString];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

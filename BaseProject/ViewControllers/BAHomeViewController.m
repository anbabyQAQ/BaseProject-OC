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
    
    self.title = @"shouye";
    
    self.tableView.backgroundColor = [UIColor cyanColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.frame = CGRectMake(0, 0, BA_SCREEN_WIDTH, BA_SCREEN_HEIGHT);
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
}

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    UIButton *right_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 22)];
    [right_button setTitle:@"出错效果" forState:UIControlStateNormal];
    right_button.titleLabel.font=BA_FontSize(14);
    [right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return right_button;
}

//设置右边事件
-(void)right_button_event:(UIButton*)sender
{
    DemoWebviewController *vc = [[DemoWebviewController alloc]init];
//    vc.urlString = @"http://m.jd.com/";
   
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
//    NSURLRequest *reUrl = [NSURLRequest requestWithURL:url];
    

//    vc.urlString = @"http://192.168.14.68:8080/HumanAnalysis/index.html";
    vc.urlString = @"http://192.168.14.68:8080/HumanAnalysis/view/map.html";

    
    [self.navigationController pushViewController:vc animated:YES];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [BaseNetManager ba_requestWithType:BAHttpRequestTypeGet urlString:@"http://192.9.100.76:60001/mts-ci/v250/tag/feed/13311097869" parameters:nil successBlock:^(id response) {
        
//        completionHandle([BAVideoModel BAMJParse:response], nil);
        
    } failureBlock:^(NSError *error) {
        
        BALog(@"error：%@", error);
//        completionHandle(nil, error);
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
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

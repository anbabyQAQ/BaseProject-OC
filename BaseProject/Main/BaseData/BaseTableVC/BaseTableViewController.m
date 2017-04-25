//
//  BaseTableViewController.m
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

@synthesize tableView = _tableView;
@synthesize dataArray = _dataArray;


// 加载视图
- (void)loadView
{
    [super loadView];
    // 自定制视图
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加tableView
    [self.view addSubview:self.tableView];
    
}

// 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    
}
// 视图已经出现
- (void)viewDidAppear:(BOOL)animated
{
}
// 视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    
}
// 视图已经消失
- (void)viewDidDisappear:(BOOL)animated
{
}
// 收到系统内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.view.top,self.view.width ,self.view.height - self.view.bottom - self.view.top) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        // 去掉下面没有数据呈现的cell
        self.tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate - 子类重写
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据-%02ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray ) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - ***** 注册是否开启头部刷新and脚部刷新
- (void)setIsOpenHeaderRefresh:(BOOL)isOpenHeaderRefresh
{
    _isOpenHeaderRefresh = isOpenHeaderRefresh;
    if (isOpenHeaderRefresh)
    {
        BA_WEAKSELF;

        weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        [weakSelf.tableView.mj_header beginRefreshing];
    }
    else
    {
        BALog(@"不开启头部刷新");
    }
}

- (void)setIsOpenFooterRefresh:(BOOL)isOpenFooterRefresh
{
    _isOpenFooterRefresh = isOpenFooterRefresh;
    if (isOpenFooterRefresh)
    {
        BA_WEAKSELF;
        // 上拉刷新
        weakSelf.tableView.mj_footer.hidden = NO;
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        
        
    }
    else
    {
        NSLog(@"不开启头脚部刷新");
    }
}

#pragma mark - ***** 头部刷新and脚部刷新
- (void)headerRefresh
{
    BA_WEAKSELF;
    [weakSelf.tableView.mj_header endRefreshing];

}
- (void)footerRefresh
{
    BA_WEAKSELF;
    [weakSelf.tableView.mj_footer endRefreshing];
}


@end

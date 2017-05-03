//
//  BAProfileViewController.m
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BAProfileViewController.h"
#import "BAProfileHeadCell.h"


#define BAProfile_Title   @"title"
#define BAProfile_Image   @"image"

#define BAProfile_CellID  @"BAProfileHeadCell"
#define BAProfile_CellID2 @"BAProfileCell"
@interface BAProfileViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BAProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];

}

#pragma mark - 私有方法
- (void)setupUI
{
    self.title                     = @"我 的";
    self.view.backgroundColor      = BA_White_Color;
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, BA_SCREEN_WIDTH, BA_SCREEN_HEIGHT-BA_NAVIGATION_HEIGHT)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor=BA_White_Color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:_tableView];

    [self addNoti];
}
#pragma mark - 通知
- (void)addNoti
{
    [BA_NotiCenter addObserver:self selector:@selector(loginFinishAction:) name:BANotioKey_LoginFinish object:nil];
}

#pragma mark - event response
- (void)loginFinishAction:(NSNotification *)noti
{
    NSDictionary *dict = noti.userInfo;
    if ([dict[@"isLogin"] isEqualToString:@"1"])
    {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableView Delegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (1 == section) ? 4:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (0 == indexPath.section) ? 82:42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (0 == section) ? 15:20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (!BAUSERSHARE.isLogin)
//    {
//        [BAJumpManager ba_gotoLoginVCWithViewController:self];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        static NSString *CellIdentifier = @"BAProfileHeadCell";
        BAProfileHeadCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell=[[BAProfileHeadCell alloc]initWithreuseIdentifier:CellIdentifier];;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BAProfile_CellID2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: BAProfile_CellID2];
        }

        if (1 == indexPath.section)
        {
            NSDictionary *dict = self.dataArray[indexPath.row];
            cell.textLabel.text  = dict[BAProfile_Title];
            cell.imageView.image = BA_ImageName(dict[BAProfile_Image]);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
        else if (2 == indexPath.section)
        {
            cell.textLabel.text = @"退出登录";
            cell.imageView.image = BA_ImageName(@"MoreExpressionShops");
            cell.accessoryType = UITableViewCellAccessoryNone;

        }
        
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - getters and setters
- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[
                       @{
                           BAProfile_Title : @"设置",
                           BAProfile_Image : @"MoreSetting"
                           },
                       @{
                           BAProfile_Title : @"公告",
                           BAProfile_Image : @"MoreMyFavorites"
                           },
                       @{
                           BAProfile_Title : @"意见反馈",
                           BAProfile_Image : @"MoreMyBankCard"
                           },
                       @{
                           BAProfile_Title : @"帮助支持",
                           BAProfile_Image : @"MyCardPackageIcon"
                           }
                       ];
        
    }
    return _dataArray;
}


#pragma mark - dealloc
- (void)dealloc
{
    //    [BA_NotiCenter removeObserver:self];
    [BA_NotiCenter removeObserver:self name:BANotioKey_LoginFinish object:nil];
    
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

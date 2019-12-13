//
//  RCMyOrganizationVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyOrganizationVC.h"
#import "RCMyOrganizationCell.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const MyOrganizationCell = @"MyOrganizationCell";

@interface RCMyOrganizationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 我的组织 */
@property(nonatomic,strong) NSArray *myOrganizations;
@end

@implementation RCMyOrganizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的组织"];
    [self setUpTableView];
    [self getOrganizationListRequest];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyOrganizationCell class]) bundle:nil] forCellReuseIdentifier:MyOrganizationCell];
    
    UIImageView *headerImg = [[UIImageView alloc] init];
    headerImg.hxn_x = 0;
    headerImg.hxn_y = 0;
    headerImg.hxn_width = HX_SCREEN_WIDTH;
    headerImg.hxn_height = 100.f;
    headerImg.contentMode = UIViewContentModeCenter;
    headerImg.image = HXGetImage(@"logo");
    
    self.tableView.tableHeaderView = headerImg;
}
#pragma mark -- 组织列表
-(void)getOrganizationListRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    page[@"current"] = @(1);//第几页
    page[@"size"] = @"10";
    parameters[@"data"] = @{};
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showRoomBeeOrg/getBeePemPageList" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            hx_strongify(weakSelf);
            strongSelf.myOrganizations = [NSArray yy_modelArrayWithClass:[MSUserRoles class] json:responseObject[@"data"][@"records"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myOrganizations.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrganizationCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MSUserRoles *role = self.myOrganizations[indexPath.row];
    cell.role = role;
    hx_weakify(self);
    cell.phoneCall = ^{
        hx_strongify(weakSelf);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:role.xqzyPhone constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",role.xqzyPhone]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        strongSelf.zh_popupController = [[zhPopupController alloc] init];
        [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end

//
//  RCChangeRoleVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCChangeRoleVC.h"
#import "RCChangeRoleCell.h"
#import "RCChangeRoleHeader.h"
#import "HXTabBarController.h"

static NSString *const ChangeRoleCell = @"ChangeRoleCell";

@interface RCChangeRoleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 组织角色 */
@property(nonatomic,strong) NSArray *roles;
/* 选择的组织 */
@property(nonatomic,strong) MSUserRoles *selectRole;
@end

@implementation RCChangeRoleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"切换角色"];
    [self setUpTableView];
    [self getUserRolesRequest];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCChangeRoleCell class]) bundle:nil] forCellReuseIdentifier:ChangeRoleCell];
    
    UIImageView *headerImg = [[UIImageView alloc] init];
    headerImg.hxn_x = 0;
    headerImg.hxn_y = 0;
    headerImg.hxn_width = HX_SCREEN_WIDTH;
    headerImg.hxn_height = 100.f;
    headerImg.contentMode = UIViewContentModeCenter;
    headerImg.image = HXGetImage(@"logo");
    
    self.tableView.tableHeaderView = headerImg;
    
    self.tableView.hidden = YES;
}
#pragma mark -- 点击事件
- (IBAction)sureRoleClicked:(UIButton *)sender {
    
    if (self.userInfo) {
        MSUserInfo *userInfo = [MSUserInfo yy_modelWithDictionary:self.userInfo];
        userInfo.selectRole = self.selectRole;
        // 切换角色之后要更改用户accRole
        userInfo.showroomLoginInside.accRole = userInfo.selectRole.roleType;
        
        [MSUserManager sharedInstance].curUserInfo = userInfo;
        [[MSUserManager sharedInstance] saveUserInfo];
    }else{
        [MSUserManager sharedInstance].curUserInfo.selectRole = self.selectRole;
        // 切换角色之后要更改用户accRole
        [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.accRole = [MSUserManager sharedInstance].curUserInfo.selectRole.roleType;
        [[MSUserManager sharedInstance] saveUserInfo];
    }
    HXTabBarController *tab = [[HXTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
    //推出主界面出来
    CATransition *ca = [CATransition animation];
    ca.type = @"movein";
    ca.duration = 0.5;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
}
#pragma mark -- 接口请求
-(void)getUserRolesRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:@"http://192.168.200.35:9000/open/api/" action:@"showroom/showroom/system/checkRole" parameters:self.userInfo?[NSString stringWithFormat:@"{\"domain\":\"org-app-ios\",\"loginId\":\"%@\"}",self.userInfo[@"userAccessInfo"][@"loginId"]]:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.roles = [NSArray yy_modelArrayWithClass:[MSUserRoles class] json:responseObject[@"data"]];
            if (!strongSelf.userInfo) {// 登录进来的切换需要先遍历出上一次的选中
                for (MSUserRoles *role in strongSelf.roles) {
                    if ([[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid isEqualToString:role.showRoomUuid] && [[MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid isEqualToString:role.groupUuid] && [[MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid isEqualToString:role.teamUuid]) {
                        role.isSelected = YES;
                        role.roleType = [MSUserManager sharedInstance].curUserInfo.selectRole.roleType;
                        
                        strongSelf.selectRole = role;
                        break;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.roles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MSUserRoles *role = self.roles[section];
    if (role.isManager == 1 && role.isZy == 1) {
        return 2;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCChangeRoleCell *cell = [tableView dequeueReusableCellWithIdentifier:ChangeRoleCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MSUserRoles *role = self.roles[indexPath.section];
    if (role.isSelected) {
        self.selectRole = role;
    }
    if (role.isManager == 1 && role.isZy == 1) {
        if (indexPath.row) {
            if (role.isSelected && role.roleType == 2){
                [cell.selectBtn setImage:HXGetImage(@"icon_choose_yellow") forState:UIControlStateNormal];
            }else{
                [cell.selectBtn setImage:HXGetImage(@"icon_choose_gray") forState:UIControlStateNormal];
            }
            cell.name.text = @"展厅专员";
            cell.work.text = @"展厅管理角色:报表统计/创建任务/转移客户等";
        }else{
            if (role.isSelected && role.roleType == 1){
                [cell.selectBtn setImage:HXGetImage(@"icon_choose_yellow") forState:UIControlStateNormal];
            }else{
                [cell.selectBtn setImage:HXGetImage(@"icon_choose_gray") forState:UIControlStateNormal];
            }
            cell.name.text = @"展厅经理";
            cell.work.text = @"展厅功能角色:参加任务/报备客户/跟进客户等";
        }
    }else{
        if (role.isManager == 1) {
            if (role.isSelected && role.roleType == 1){
                [cell.selectBtn setImage:HXGetImage(@"icon_choose_yellow") forState:UIControlStateNormal];
            }else{
                [cell.selectBtn setImage:HXGetImage(@"icon_choose_gray") forState:UIControlStateNormal];
            }
            cell.name.text = @"展厅经理";
            cell.work.text = @"展厅功能角色:参加任务/报备客户/跟进客户等";
        }else{
            if (role.isSelected && role.roleType == 2){
                [cell.selectBtn setImage:HXGetImage(@"icon_choose_yellow") forState:UIControlStateNormal];
            }else{
                [cell.selectBtn setImage:HXGetImage(@"icon_choose_gray") forState:UIControlStateNormal];
            }
            cell.name.text = @"展厅专员";
            cell.work.text = @"展厅管理角色:报表统计/创建任务/转移客户等";
        }
    }
    cell.selectCall = ^{
        // 先重置上一次的选中
        self.selectRole.isSelected = NO;
        self.selectRole.roleType = 0;
        
        role.isSelected = YES;
        if (role.isManager == 1 && role.isZy == 1) {
            if (indexPath.row) {
                role.roleType = 2;
            }else{
                role.roleType = 1;
            }
        }else{
            if (role.isManager == 1) {
                role.roleType = 1;
            }else{
                role.roleType = 2;
            }
        }
        [tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCChangeRoleHeader *header = [RCChangeRoleHeader loadXibView];
    MSUserRoles *role = self.roles[section];
    header.roleDesc.text = [NSString stringWithFormat:@"%@-%@-%@",role.showRoomName,role.teamName,role.groupName];
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

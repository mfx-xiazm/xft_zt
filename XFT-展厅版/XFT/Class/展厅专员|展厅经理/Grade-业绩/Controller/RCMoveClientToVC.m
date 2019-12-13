//
//  RCMoveClientToVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMoveClientToVC.h"
#import "RCChooseMemberHeader.h"
#import "RCChooseMemberCell.h"
#import "HXSearchBar.h"
#import "RCTaskMember.h"
#import "RCMoveClientFromVC.h"

static NSString *const ChooseMemberCell = @"ChooseMemberCell";

@interface RCMoveClientToVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeight;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *search;
/* 专员数组 */
@property(nonatomic,strong) NSArray *members;
/* 选择的要转移的专员 */
@property(nonatomic,strong) RCTaskAgentMember *moveAgent;
/* 选择的要转移的专员的所属的团队 */
@property(nonatomic,strong) RCTaskMember *moveAgentTeam;
@end

@implementation RCMoveClientToVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择要转出的专员"];
    
    if (!self.isHiddenSearch) {
        HXSearchBar *search = [HXSearchBar searchBar];
        search.backgroundColor = [UIColor whiteColor];
        search.hxn_width = HX_SCREEN_WIDTH - 30.f;
        search.hxn_height = 40;
        search.hxn_x = 5;
        search.hxn_centerY = self.searchView.hxn_height/2.0;
        search.layer.cornerRadius = 40/2.f;
        search.layer.masksToBounds = YES;
        search.delegate = self;
        self.search = search;
        [self.searchView addSubview:search];
    }else{
        self.searchViewHeight.constant = 0.f;
        self.searchView.hidden = YES;
    }
    
    [self setUpTableView];
    [self getAgentDataRequest];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.search) {
        self.search.hxn_width = HX_SCREEN_WIDTH - 30.f;
        self.search.hxn_height = 40;
        self.search.hxn_x = 15;
        self.search.hxn_centerY = self.searchView.hxn_height/2.0;
    }
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
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCChooseMemberCell class]) bundle:nil] forCellReuseIdentifier:ChooseMemberCell];
}
#pragma mark -- 点击事件
- (IBAction)moveClientClicked:(UIButton *)sender {
    if (!self.moveAgent) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"选择要转出的专员"];
        return;
    }
    RCMoveClientFromVC *tvc = [RCMoveClientFromVC new];
    tvc.selectMoveAgent = self.moveAgent;
    tvc.selectMoveAgentTeam = self.moveAgentTeam;
    [self.navigationController pushViewController:tvc animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getAgentDataRequest];
    return YES;
}
#pragma mark -- 数据请求
-(void)getAgentDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"name"] = [self.search hasText]?self.search.text:@"";
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;
    data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;
    data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomManager/commissionerList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.members = [NSArray yy_modelArrayWithClass:[RCTaskMember class] json:responseObject[@"data"]];
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
    return self.members.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RCTaskMember *member = self.members[section];
    return member.isExpand?member.list.count:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCChooseMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseMemberCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCTaskMember *member = self.members[indexPath.section];
    RCTaskAgentMember *agentMember = member.list[indexPath.row];
    cell.agentMember = agentMember;
    hx_weakify(self);
    cell.selectedCall = ^{
        hx_strongify(weakSelf);
        if (!agentMember.isSelected) {
            strongSelf.moveAgent.isSelected = NO;
            agentMember.isSelected = YES;
            strongSelf.moveAgent = agentMember;
            strongSelf.moveAgentTeam = member;
        }else{
            // 如果该经纪人已经选中，就不处理，点击其他经纪人来取消当前的选中
        }
        [tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCChooseMemberHeader *header = [RCChooseMemberHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 66.f);
    header.selectAllBtn.hidden = YES;
    RCTaskMember *member = self.members[section];
    header.member = member;
    header.expandCall = ^{
        member.isExpand = !member.isExpand;
        [tableView reloadData];
    };
    
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCTaskMember *member = self.members[indexPath.section];
    RCTaskAgentMember *agentMember = member.list[indexPath.row];
    if (!agentMember.isSelected) {
        self.moveAgent.isSelected = NO;
        agentMember.isSelected = YES;
        self.moveAgent = agentMember;
        self.moveAgentTeam = member;
    }else{
        // 如果该经纪人已经选中，就不处理，点击其他经纪人来取消当前的选中
    }
    [tableView reloadData];
}

@end

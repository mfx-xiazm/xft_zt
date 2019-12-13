//
//  RCChooseMemberVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCChooseMemberVC.h"
#import "RCChooseMemberHeader.h"
#import "RCChooseMemberCell.h"
#import "RCTaskMember.h"

static NSString *const ChooseMemberCell = @"ChooseMemberCell";

@interface RCChooseMemberVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCChooseMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    if (!self.members) {
        [self getAgentDataRequest];
    }else{
        [self.tableView reloadData];
    }
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"分配到专员"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectAllClicked) title:@"全选" font:[UIFont systemFontOfSize:16] titleColor:UIColorFromRGB(0x333333) highlightedColor:UIColorFromRGB(0x333333) titleEdgeInsets:UIEdgeInsetsZero];
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
    self.tableView.backgroundColor = HXGlobalBg;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCChooseMemberCell class]) bundle:nil] forCellReuseIdentifier:ChooseMemberCell];
}
#pragma mark -- 点击事件
-(void)selectAllClicked
{
    if (self.members && self.members.count) {
        for (RCTaskMember *member in self.members) {
            member.isCheckAll = YES;
            for (RCTaskAgentMember *agentMember in member.list) {
                agentMember.isSelected = YES;
            }
        }
    }
    [self.tableView reloadData];
}
- (IBAction)sureClicked:(UIButton *)sender {
    BOOL isCheck = NO;
    for (RCTaskMember *member in self.members) {
        for (RCTaskAgentMember *agentMember in member.list) {
            if (agentMember.isSelected) {
                isCheck = YES;
                break;
            }
        }
        if (isCheck) {
            break;
        }
    }
    
    if (isCheck) {
        NSMutableArray *selectArr = [NSMutableArray array];
        for (RCTaskMember *member in self.members) {
            for (RCTaskAgentMember *agentMember in member.list) {
                if (agentMember.isSelected) {
                    [selectArr addObject:agentMember];
                }
            }
        }
        if (self.chooseMemberCall) {
            self.chooseMemberCall(selectArr,self.members);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择专员"];
    }
}

#pragma mark -- 数据请求
-(void)getAgentDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"name"] = @"";
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
    cell.selectedCall = ^{
        agentMember.isSelected = !agentMember.isSelected;
        // 判断全选
        BOOL isCheckAll = YES;
        for (RCTaskAgentMember *agentMember1 in member.list) {
            if (!agentMember1.isSelected) {
                isCheckAll = NO;
                break;
            }
        }
        member.isCheckAll = isCheckAll;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCChooseMemberHeader *header = [RCChooseMemberHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 66.f);
    RCTaskMember *member = self.members[section];
    header.member = member;
    header.expandCall = ^{
        member.isExpand = !member.isExpand;
        [tableView reloadData];
    };
    header.checkAllCall = ^{
        member.isCheckAll = !member.isCheckAll;
        for (RCTaskAgentMember *agentMember in member.list) {
            agentMember.isSelected = member.isCheckAll;
        }
        [tableView reloadData];
    };
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

//
//  RCMyAgentVC.m
//  XFT
//
//  Created by 夏增明 on 2019/12/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyAgentVC.h"
#import "RCMyStoreCell.h"
#import "RCSearchClientVC.h"
#import "RCMyStoreVC.h"
#import "RCMyAgent.h"

static NSString *const MyStoreCell = @"MyStoreCell";
@interface RCMyAgentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 中介列表 */
@property(nonatomic,strong) NSMutableArray *agents;
@end

@implementation RCMyAgentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self getAgentListDataRequest:YES];
}
-(NSMutableArray *)agents
{
    if (_agents == nil) {
        _agents = [NSMutableArray array];
    }
    return _agents;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"合作中介"];
    
    SPButton *searchItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    searchItem.hxn_size = CGSizeMake(44, 44);
    [searchItem setImage:HXGetImage(@"icon_search") forState:UIControlStateNormal];
    [searchItem addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchItem];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyStoreCell class]) bundle:nil] forCellReuseIdentifier:MyStoreCell];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getAgentListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getAgentListDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
/** 公告列表请求 */
-(void)getAgentListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
//    data[@"agentStore"] = @"";//中介门店uuid,客户列表必传
//    data[@"agentUuid"] = @"";//中介uuid,门店列表必传
//    data[@"searchName"] = @"";//搜索名称
    data[@"showRoomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid,必传
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/coopagent/getCoopAgentList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.agents removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyAgent class] json:responseObject[@"data"][@"records"]];
                [strongSelf.agents addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyAgent class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.agents addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.agents.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                }else{
                    [strongSelf.tableView ly_showEmptyView];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)searchClicked
{
    RCSearchClientVC *cvc = [RCSearchClientVC  new];
    cvc.dataType = 2;
    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.agents.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCMyAgent *agent = self.agents[indexPath.row];
    cell.agent = agent;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMyStoreVC *cvc = [RCMyStoreVC new];
    RCMyAgent *agent = self.agents[indexPath.row];
    cvc.agentUuid = agent.agentUuid;
    cvc.navTitle = [NSString stringWithFormat:@"%@门店",agent.agentName];
    [self.navigationController pushViewController:cvc animated:YES];
}

@end

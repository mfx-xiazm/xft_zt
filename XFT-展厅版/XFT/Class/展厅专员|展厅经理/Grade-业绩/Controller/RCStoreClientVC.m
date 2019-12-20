//
//  RCStoreClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCStoreClientVC.h"
#import "RCStoreClientCell.h"
#import "RCMyClientStateCell.h"
#import "RCClientFilterView.h"
#import <zhPopupController.h>
#import "RCSearchClientVC.h"
#import "RCClientFilter.h"
#import "RCStoreClient.h"

static NSString *const StoreClientCell = @"StoreClientCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";
@interface RCStoreClientVC ()<UITableViewDelegate,UITableViewDataSource,RCClientFilterViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
/* 筛选条件 */
@property(nonatomic,strong) RCClientFilter *filterData;
/* 筛选视图 */
@property(nonatomic,strong) RCClientFilterView *filterView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 左侧的客户数量 */
@property(nonatomic,strong) NSMutableDictionary *clietNumInfo;
/* 左边分组选中的索引 */
@property(nonatomic,assign) NSInteger selectIndex;
@end

@implementation RCStoreClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    self.selectIndex = 0;
    [self getFilterDataRequest];
    [self getClientDataRequest:YES];
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
-(RCClientFilterView *)filterView
{
    if (_filterView == nil) {
        _filterView = [RCClientFilterView loadXibView];
        _filterView.delegate = self;
        _filterView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 365);
    }
    return _filterView;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:self.navTitle];
    
    SPButton *filterItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    filterItem.hxn_size = CGSizeMake(44, 44);
    [filterItem setImage:HXGetImage(@"icon_shaixuan") forState:UIControlStateNormal];
    [filterItem addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:filterItem];
    
//    SPButton *searchItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
//    searchItem.hxn_size = CGSizeMake(44, 44);
//    [searchItem setImage:HXGetImage(@"icon_search") forState:UIControlStateNormal];
//    [searchItem addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:searchItem];
    
    self.navigationItem.rightBarButtonItem = item1;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.rightTableView.estimatedRowHeight = 100;//预估高度
    self.rightTableView.rowHeight = UITableViewAutomaticDimension;
    self.rightTableView.estimatedSectionHeaderHeight = 0;
    self.rightTableView.estimatedSectionFooterHeight = 0;
    
    self.rightTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCStoreClientCell class]) bundle:nil] forCellReuseIdentifier:StoreClientCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.leftTableView.estimatedRowHeight = 100;//预估高度
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.leftTableView.estimatedSectionHeaderHeight = 0;
    self.leftTableView.estimatedSectionFooterHeight = 0;
    
    self.leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    
    self.leftTableView.showsVerticalScrollIndicator = NO;
    
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientStateCell class]) bundle:nil] forCellReuseIdentifier:MyClientStateCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.rightTableView.mj_header.automaticallyChangeAlpha = YES;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView.mj_footer resetNoMoreData];
        [strongSelf getClientDataRequest:YES];
    }];
    //追加尾部刷新
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientDataRequest:NO];
    }];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无客户"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.rightTableView.ly_emptyView = emptyView;
}
#pragma mark -- 接口请求
/** 客户列表请求 */
-(void)getClientDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"agentUuid"] = (self.filterData.selectAgent && self.filterData.selectAgent.uuid.length)?self.filterData.selectAgent.uuid:@"all";//经纪人id,全部:all
    data[@"proUuid"] = (self.filterData.selectPro && self.filterData.selectPro.proUuid.length)?self.filterData.selectPro.proUuid:@"all";//项目id,全部: all
    data[@"searchName"] = @"";//搜索名称
    data[@"showRoomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
    data[@"storeUuid"] = self.storeUuid;//门店id
    switch (self.selectIndex) {
        case 0:{
            data[@"type"] = @"all";//全部客户:all,已报备:0,已到访:2,已认筹:4,已认购:5,已签约:6,已退房:7,已失效:100
        }
            break;
        case 1:{
            data[@"type"] = @"0";//全部客户:all,已报备:0,已到访:2,已认筹:4,已认购:5,已签约:6,已退房:7,已失效:100
        }
            break;
        case 2:{
            data[@"type"] = @"2";//全部客户:all,已报备:0,已到访:2,已认筹:4,已认购:5,已签约:6,已退房:7,已失效:100
        }
            break;
        case 3:{
            data[@"type"] = @"4";//全部客户:all,已报备:0,已到访:2,已认筹:4,已认购:5,已签约:6,已退房:7,已失效:100
        }
            break;
        case 4:{
            data[@"type"] = @"5";//全部客户:all,已报备:0,已到访:2,已认筹:4,已认购:5,已签约:6,已退房:7,已失效:100
        }
            break;
        case 5:{
            data[@"type"] = @"6";//全部客户:all,已报备:0,已到访:2,已认筹:4,已认购:5,已签约:6,已退房:7,已失效:100
        }
            break;
        case 6:{
            data[@"type"] = @"7";//全部客户:all,已报备:0,已到访:2,已认筹:4,已认购:5,已签约:6,已退房:7,已失效:100
        }
            break;
        case 7:{
            data[@"type"] = @"100";//全部客户:all,已报备:0,已到访:2,已认筹:4,已认购:5,已签约:6,已退房:7,已失效:100
        }
            break;
            
        default:
            break;
    }
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
        [self.rightTableView.mj_footer resetNoMoreData];
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"anchang/anchang/baobei/queryClientList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.rightTableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCStoreClient class] json:responseObject[@"data"][@"page"][@"records"]];
                [strongSelf.clients addObjectsFromArray:arrt];
               
                strongSelf.clietNumInfo = [NSMutableDictionary dictionary];
                strongSelf.clietNumInfo[@"totalNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allCusNum"]];
                strongSelf.clietNumInfo[@"cusBaoBeiReportNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"reportNum"]];
                strongSelf.clietNumInfo[@"cusBaoBeiVisitNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"visitNum"]];
                strongSelf.clietNumInfo[@"cusBaoBeiRecognitionNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"recruitNum"]];
                strongSelf.clietNumInfo[@"cusBaoBeiSubscribeNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"subNum"]];
                strongSelf.clietNumInfo[@"cusBaoBeiSignNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"signNum"]];
                strongSelf.clietNumInfo[@"cusBaoBeiAbolishNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"checkOutNum"]];
                strongSelf.clietNumInfo[@"cusBaoBeiInvalidNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"invNum"]];

            }else{
                [strongSelf.rightTableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"page"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"page"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCStoreClient class] json:responseObject[@"data"][@"page"][@"records"]];
                    [strongSelf.clients addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.rightTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.leftTableView reloadData];
                [strongSelf.rightTableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                });
                if (strongSelf.clients.count || strongSelf.clients.count) {
                    [strongSelf.rightTableView ly_hideEmptyView];
                }else{
                    [strongSelf.rightTableView ly_showEmptyView];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getFilterDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"orgUuid"] = self.agentUuid;//中介机构uuid
    data[@"storeUuid"] = self.storeUuid;//门店uuid
    data[@"showRoomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid,必传
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/coopagent/getClientListFilter" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            RCClientFilter *filterData = [RCClientFilter yy_modelWithDictionary:responseObject[@"data"]];
            
            NSMutableArray *proList = [NSMutableArray arrayWithArray:filterData.proList];
            RCFilterPro *pro = [[RCFilterPro alloc] init];
            pro.proName = @"全部";
            pro.proUuid = @"";
            pro.isSelected = YES;
            [proList insertObject:pro atIndex:0];
            filterData.selectPro = pro;
            filterData.proList = proList;
            
            NSMutableArray *agentList = [NSMutableArray arrayWithArray:filterData.agentList];
            RCFilterAgent *agent = [[RCFilterAgent alloc] init];
            agent.name = @"全部";
            agent.uuid = @"";
            agent.isSelected = YES;
            [agentList insertObject:agent atIndex:0];
            filterData.selectAgent = agent;
            filterData.agentList = agentList;
            
            strongSelf.filterData = filterData;
           
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
    cvc.dataType = 4;
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void)filterClicked:(SPButton *)btn
{
    if (!self.filterData) {
        return;
    }
    if ([self.zh_popupController isPresenting]) {
        [self.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        return;
    }
    self.filterView.filterData = self.filterData;
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeTop;
    self.zh_popupController.maskAlpha = 0.15;
    [self.zh_popupController presentContentView:self.filterView duration:0.25 springAnimated:NO inView:self.contentView];
}
#pragma mark -- RCClientFilterViewDelegate
-(void)filterDidConfirm:(RCClientFilterView *)filter selectProId:(NSString *)proId selectAgentId:(NSString *)agentId reportBeginTime:(NSInteger)reportBegin reportEndTime:(NSInteger)reportEnd
{
    // 刷新数据接口
    [self getClientDataRequest:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.clietNumInfo?8:0;
    }else{
        return self.clients.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:{
                cell.clientState.text = @"全部客户";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"totalNum"]];
            }
                break;
            case 1:{
                cell.clientState.text = @"已报备";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiReportNum"]];
            }
                break;
            case 2:{
                cell.clientState.text = @"已到访";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiVisitNum"]];
            }
                break;
            case 3:{
                cell.clientState.text = @"已认筹";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiRecognitionNum"]];
            }
                break;
            case 4:{
                cell.clientState.text = @"已认购";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiSubscribeNum"]];
            }
                break;
            case 5:{
                cell.clientState.text = @"已签约";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiSignNum"]];
            }
                break;
            case 6:{
                cell.clientState.text = @"已退房";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiAbolishNum"]];
            }
                break;
            case 7:{
                cell.clientState.text = @"已失效";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiInvalidNum"]];
            }
                break;

            default:
                break;
        }
        return cell;
    }else{
        RCStoreClientCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.state.hidden = YES;
        RCStoreClient *client = self.clients[indexPath.row];
        cell.client = client;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.leftTableView) {
        return 75.f;
    }else{
        RCStoreClient *client = self.clients[indexPath.row];
        // 0:报备,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效
        if ([client.cusState isEqualToString:@"0"] || [client.cusState isEqualToString:@"100"]) {
            return 145.f;
        }else{
            return 170.f;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        self.selectIndex = indexPath.row;
        [self getClientDataRequest:YES];
    }
}

@end

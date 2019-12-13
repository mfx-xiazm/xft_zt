//
//  RCSearchClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchClientVC.h"
#import "RCMyClientCell.h"
#import "HXSearchBar.h"
#import "RCStoreClientCell.h"
#import "RCMyStoreCell.h"
#import "RCChangePwdVC.h"
#import "RCMyClient.h"
#import "RCClientDetailVC.h"
#import "zhAlertView.h"
#import "zhPopupController.h"
#import "RCGoHouseVC.h"
#import "RCMyAgent.h"
#import "RCMyStoreVC.h"
#import "RCStoreClientVC.h"

static NSString *const MyClientCell = @"MyClientCell";
static NSString *const StoreClientCell = @"StoreClientCell";
static NSString *const MyStoreCell = @"MyStoreCell";

@interface RCSearchClientVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 搜索结果列表 */
@property(nonatomic,strong) NSMutableArray *results;
/* 关键字 */
@property(nonatomic,copy) NSString *keyword;
/* 搜索出来的数量 */
@property(nonatomic,copy) NSString *total;
@end

@implementation RCSearchClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
}
-(NSMutableArray *)results
{
    if (_results == nil) {
        _results = [NSMutableArray array];
    }
    return _results;
}
-(void)setUpNavBar
{
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_width = HX_SCREEN_WIDTH - 100;
    search.hxn_height = 32;
    search.layer.cornerRadius = 32/2.f;
    search.layer.masksToBounds = YES;
    search.delegate = self;
    
    self.navigationItem.titleView = search;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClickd) title:@"取消" font:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0xFF9F08) highlightedColor:UIColorFromRGB(0xFF9F08) titleEdgeInsets:UIEdgeInsetsZero];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientCell class]) bundle:nil] forCellReuseIdentifier:MyClientCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCStoreClientCell class]) bundle:nil] forCellReuseIdentifier:StoreClientCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyStoreCell class]) bundle:nil] forCellReuseIdentifier:MyStoreCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getSearchDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getSearchDataRequest:NO];
    }];
}
#pragma mark -- 点击事件
-(void)cancelClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        self.keyword = textField.text;
        [self getSearchDataRequest:YES];
        return YES;
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入搜索内容"];
        return NO;
    }
}
#pragma mark -- 接口请求
-(void)getSearchDataRequest:(BOOL)isRefresh
{
    if (self.dataType == 1) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"nameOrPhoneLike"] = (self.keyword && self.keyword.length)?self.keyword:@"";
        data[@"showroomUuid"] = (self.showroomUuid && self.showroomUuid.length)?self.showroomUuid:@"";;
        data[@"teamUuid"] = (self.teamUuid && self.teamUuid.length)?self.teamUuid:@"";;
        data[@"groupUuid"] = (self.groupUuid && self.groupUuid.length)?self.groupUuid:@"";;
        data[@"accUuid"] = (self.accUuid && self.accUuid.length)?self.accUuid:@"";;
        data[@"isManager"] = ([MSUserManager sharedInstance].curUserInfo.ulevel==1)?@(1):@(0);
        data[@"isZy"] = ([MSUserManager sharedInstance].curUserInfo.ulevel==2)?@(1):@(0);
        
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
        [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroom/showroomSearchCusByPhoneOrName" parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            if ([responseObject[@"code"] integerValue] == 0) {
                if (isRefresh) {
                    [strongSelf.tableView.mj_header endRefreshing];
                    strongSelf.pagenum = 1;
                    [strongSelf.results removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"]];
                    [strongSelf.results addObjectsFromArray:arrt];
                }else{
                    [strongSelf.tableView.mj_footer endRefreshing];
                    strongSelf.pagenum ++;
                    if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"]];
                        [strongSelf.results addObjectsFromArray:arrt];
                    }else{// 提示没有更多数据
                        [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
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
    }else if (self.dataType == 2) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        //    data[@"agentStore"] = @"";//中介门店uuid,客户列表必传
        //    data[@"agentUuid"] = @"";//中介uuid,门店列表必传
        data[@"searchName"] = (self.keyword && self.keyword.length)?self.keyword:@"";//搜索名称
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
                    [strongSelf.results removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyAgent class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.results addObjectsFromArray:arrt];
                }else{
                    [strongSelf.tableView.mj_footer endRefreshing];
                    strongSelf.pagenum ++;
                    if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyAgent class] json:responseObject[@"data"][@"records"]];
                        [strongSelf.results addObjectsFromArray:arrt];
                    }else{// 提示没有更多数据
                        [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.tableView reloadData];
                });
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    }else if (self.dataType == 3) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        //    data[@"agentStore"] = @"";//中介门店uuid,客户列表必传
        data[@"agentUuid"] = self.agentUuid;//中介uuid,门店列表必传
        data[@"searchName"] = (self.keyword && self.keyword.length)?self.keyword:@"";//搜索名称
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
        [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/coopagent/getCoopAgentStoreList" parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            if ([responseObject[@"code"] integerValue] == 0) {
                if (isRefresh) {
                    [strongSelf.tableView.mj_header endRefreshing];
                    strongSelf.pagenum = 1;
                    [strongSelf.results removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyAgent class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.results addObjectsFromArray:arrt];
                }else{
                    [strongSelf.tableView.mj_footer endRefreshing];
                    strongSelf.pagenum ++;
                    if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyAgent class] json:responseObject[@"data"][@"records"]];
                        [strongSelf.results addObjectsFromArray:arrt];
                    }else{// 提示没有更多数据
                        [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
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
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == 1) {
        RCMyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyClient *client = self.results[indexPath.row];
        cell.cusType = client.cusType;
        cell.client = client;
        if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {//经理
            cell.handleToolView.hidden = YES;
            cell.handleToolViewHeight.constant = 0.f;
        }else{
            cell.handleToolView.hidden = NO;
            cell.handleToolViewHeight.constant = 40.f;
        }
        hx_weakify(self);
        cell.clientHandleCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                HXLog(@"关注");
            }else if (index == 2) {
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:client.phone constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",client.phone]]];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }else if (index == 3) {
                NSString *phoneStr = [NSString stringWithFormat:@"%@",client.phone];//发短信的号码
                NSString *urlStr = [NSString stringWithFormat:@"sms://%@", phoneStr];
                NSURL *url = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication] openURL:url];
            }else if (index == 4) {
                RCGoHouseVC *hvc = [RCGoHouseVC new];
                hvc.cusUuid = client.uuid;
                [strongSelf.navigationController pushViewController:hvc animated:YES];
            }else{
                RCClientDetailVC *dvc = [RCClientDetailVC new];
                dvc.cusType = client.cusType;
                if (client.cusType == 0) {// 如果是报备客户传报备uuid
                    dvc.cusUuid = client.uuid;
                }else{// 如果不是报备客户
                    if (client.cusType == 6) {// 失效客户传报备uuid
                        dvc.cusUuid = client.uuid;
                    }else{//其他状态 传cusUuid
                        dvc.cusUuid = client.cusUuid;
                    }
                }
                dvc.updateReamrkCall = ^(NSString * _Nonnull remarkTime, NSString * _Nonnull remark) {
                    client.remarkTime = remarkTime;
                    client.remark = remark;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            }
        };
        return cell;
    }else if (self.dataType == 2){
        RCMyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyAgent *agent = self.results[indexPath.row];
        cell.agent = agent;
        return cell;
    }else if (self.dataType == 3){
        RCMyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyAgent *store = self.results[indexPath.row];
        cell.agent = store;
        return cell;
    }else{
        RCStoreClientCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataType == 1) {
        if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {//经理
            return 200.f;
        }else{
            return 240.f;
        }
    }else if (self.dataType == 2){
        return 110.f;
    }else if (self.dataType == 3){
        return 110.f;
    }else{
        return 170.f;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44.f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] init];
//    label.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44);
//    label.backgroundColor = HXGlobalBg;
//    label.textColor = [UIColor lightGrayColor];
//    label.font = [UIFont systemFontOfSize:13];
//    if (self.dataType == 1) {
//        label.text = [NSString stringWithFormat:@"   您搜索到%@个客户",self.total];
//    }else if (self.dataType == 2){
//        label.text = [NSString stringWithFormat:@"   您搜索到%@个门店",self.total];
//    }else{
//        label.text = [NSString stringWithFormat:@"   您搜索到%@个门店客户",self.total];
//    }
//    return label;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataType == 1) {
        RCClientDetailVC *dvc = [RCClientDetailVC new];
        RCMyClient *client = self.results[indexPath.row];
        if (client.cusType == 0) {// 如果是报备客户传报备uuid
            dvc.cusUuid = client.uuid;
        }else{// 如果不是报备客户
            if (client.cusType == 6) {// 失效客户传报备uuid
                dvc.cusUuid = client.uuid;
            }else{//其他状态 传cusUuid
                dvc.cusUuid = client.cusUuid;
            }
        }
        dvc.cusType = client.cusType;
        dvc.updateReamrkCall = ^(NSString * _Nonnull remarkTime, NSString * _Nonnull remark) {
            client.remarkTime = remarkTime;
            client.remark = remark;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (self.dataType == 2){
        RCMyStoreVC *cvc = [RCMyStoreVC new];
        RCMyAgent *agent = self.results[indexPath.row];
        cvc.agentUuid = agent.agentUuid;
        cvc.navTitle = [NSString stringWithFormat:@"%@门店",agent.agentName];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (self.dataType == 3) {
        RCStoreClientVC *cvc = [RCStoreClientVC new];
        RCMyAgent *agent = self.results[indexPath.row];
        cvc.agentUuid = self.agentUuid;
        cvc.storeUuid = agent.agentUuid;
        cvc.navTitle = [NSString stringWithFormat:@"%@客户",agent.agentName];
        [self.navigationController pushViewController:cvc animated:YES];
    }
}


@end

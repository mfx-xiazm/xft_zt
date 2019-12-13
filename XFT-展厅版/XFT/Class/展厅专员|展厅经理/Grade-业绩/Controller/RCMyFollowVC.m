//
//  RCMyFollowVC.m
//  XFT
//
//  Created by 夏增明 on 2019/12/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyFollowVC.h"
#import "RCClientDetailVC.h"
#import "RCMyFollow.h"
#import "RCMyFollowClientCell.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCGoHouseVC.h"

static NSString *const MyFollowClientCell = @"MyFollowClientCell";
@interface RCMyFollowVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 客户列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 关注总数 */
@property(nonatomic,copy) NSString *total;
@end

@implementation RCMyFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关注客户"];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getClientDataRequest:YES];
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
#pragma mark -- 视图UI
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
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyFollowClientCell class]) bundle:nil] forCellReuseIdentifier:MyFollowClientCell];
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
        [strongSelf getClientDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
-(void)getClientDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"type"] = @"4";//用户身份 1：经纪人 2：顾问 3.自渠专员 4.展厅专员
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
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusInfo/getCusAttentionInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                strongSelf.total = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"total"]];
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyFollow class] json:responseObject[@"data"][@"records"]];
                [strongSelf.clients addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyFollow class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.clients addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                strongSelf.totalNum.text = [NSString stringWithFormat:@"已关注%@人",strongSelf.total];
                if (strongSelf.clients.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                }else{
                    [strongSelf.tableView ly_showEmptyView];
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
-(void)setFollowRequest:(NSString *)focusUuid completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accType"] = @"4";//当前账号的类型 1：经纪人 2：顾问 3:自渠专员 4.展厅专员
    data[@"focusUuid"] = focusUuid;//被关注人uuid
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/records/focusRecords" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (completedCall) {
                completedCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clients.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyFollowClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyFollowClientCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCMyFollow *follow = self.clients[indexPath.row];
    cell.follow = follow;
    hx_weakify(self);
    cell.fillowHandleCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            [strongSelf setFollowRequest:follow.uuid completedCall:^{
                if ([follow.isLove isEqualToString:@"1"]) {
                    follow.isLove = @"0";
                    weakSelf.total = [NSString stringWithFormat:@"%zd",[weakSelf.total integerValue]-1];
                    weakSelf.totalNum.text = [NSString stringWithFormat:@"已关注%@人",weakSelf.total];
                }else{
                    follow.isLove = @"1";
                    weakSelf.total = [NSString stringWithFormat:@"%zd",[weakSelf.total integerValue]+1];
                    weakSelf.totalNum.text = [NSString stringWithFormat:@"已关注%@人",weakSelf.total];
                }
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }else if (index == 2) {
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:follow.phone constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",follow.phone]]];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else if (index == 3) {
            NSString *phoneStr = [NSString stringWithFormat:@"%@",follow.phone];//发短信的号码
            NSString *urlStr = [NSString stringWithFormat:@"sms://%@", phoneStr];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }else if (index == 4) {
            RCGoHouseVC *hvc = [RCGoHouseVC new];
            hvc.cusUuid = follow.uuid;
            [strongSelf.navigationController pushViewController:hvc animated:YES];
        }else{
            RCClientDetailVC *nvc = [RCClientDetailVC new];
            if (follow.cusState == 0) {// 如果是报备客户传报备uuid
                nvc.cusUuid = follow.uuid;
            }else{// 如果不是报备客户
                if (follow.cusState == 8) {//失效客户
                    nvc.cusUuid = follow.uuid;
                }else{//其他状态客户
                    nvc.cusUuid = follow.cusUuid;
                }
            }
            switch (follow.cusState) {
                case 0:{
                    nvc.cusType = 0;
                }
                    break;
                case 2:{
                    nvc.cusType = 1;
                }
                    break;
                case 4:{
                    nvc.cusType = 2;
                }
                    break;
                case 5:{
                    nvc.cusType = 3;
                }
                    break;
                case 6:{
                    nvc.cusType = 4;
                }
                    break;
                case 7:{
                    nvc.cusType = 5;
                }
                    break;
                case 8:{
                    nvc.cusType = 6;
                }
                    break;
                default:{
                    nvc.cusType = 6;
                }
            }
            nvc.updateReamrkCall = ^(NSString * _Nonnull remarkTime, NSString * _Nonnull remark) {
                follow.time = remarkTime;
                follow.remark = remark;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [strongSelf.navigationController pushViewController:nvc animated:YES];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 220.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMyFollow *follow = self.clients[indexPath.row];
    RCClientDetailVC *nvc = [RCClientDetailVC new];
    if (follow.cusState == 0) {// 如果是报备客户传报备uuid
        nvc.cusUuid = follow.uuid;
    }else{// 如果不是报备客户
        if (follow.cusState == 8) {//失效客户
            nvc.cusUuid = follow.uuid;
        }else{//其他状态客户
            nvc.cusUuid = follow.cusUuid;
        }
    }
    switch (follow.cusState) {
        case 0:{
            nvc.cusType = 0;
        }
            break;
        case 2:{
            nvc.cusType = 1;
        }
            break;
        case 4:{
            nvc.cusType = 2;
        }
            break;
        case 5:{
            nvc.cusType = 3;
        }
            break;
        case 6:{
            nvc.cusType = 4;
        }
            break;
        case 7:{
            nvc.cusType = 5;
        }
            break;
        case 8:{
            nvc.cusType = 6;
        }
            break;
        default:{
            nvc.cusType = 6;
        }
    }
    nvc.updateReamrkCall = ^(NSString * _Nonnull remarkTime, NSString * _Nonnull remark) {
        follow.time = remarkTime;
        follow.remark = remark;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:nvc animated:YES];
}

@end

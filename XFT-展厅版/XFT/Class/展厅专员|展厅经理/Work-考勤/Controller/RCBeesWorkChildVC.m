//
//  RCBeesWorkChildVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBeesWorkChildVC.h"
#import "RCBeesWorkCell.h"
#import "RCBeesReportVC.h"
#import "RCBeesWork.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const BeesWorkCell = @"BeesWorkCell";

@interface RCBeesWorkChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 客户列表 */
@property(nonatomic,strong) NSMutableArray *beesWork;
@end

@implementation RCBeesWorkChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [self startShimmer];
    [self getBeeClientsListRequest:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
-(NSMutableArray *)beesWork
{
    if (_beesWork == nil) {
        _beesWork = [NSMutableArray array];
    }
    return _beesWork;
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
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCBeesWorkCell class]) bundle:nil] forCellReuseIdentifier:BeesWorkCell];
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
        [strongSelf getBeeClientsListRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getBeeClientsListRequest:NO];
    }];
}
#pragma mark -- 接口请求
-(void)getBeeClientsListRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"type"] = @(self.type);//状态(1 待报备 2报备失败)
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
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/bee/getBeeBaobeiCusList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.beesWork removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCBeesWork class] json:responseObject[@"data"][@"records"]];
                [strongSelf.beesWork addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCBeesWork class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.beesWork addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.beesWork.count) {
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.beesWork.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCBeesWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:BeesWorkCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.reportBtn setTitle:(self.type == 1)?@"一键报备":@"再次报备" forState:UIControlStateNormal];
    RCBeesWork *beesWork = self.beesWork[indexPath.row];
    cell.beesWork = beesWork;
    hx_weakify(self);
    cell.reportCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:beesWork.cusPhone constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",beesWork.cusPhone]]];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else if (index == 2) {
            NSString *phoneStr = [NSString stringWithFormat:@"%@",beesWork.cusPhone];//发短信的号码
            NSString *urlStr = [NSString stringWithFormat:@"sms://%@", phoneStr];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }else{
            RCBeesReportVC *rvc = [RCBeesReportVC new];
            rvc.beesWork = beesWork;
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

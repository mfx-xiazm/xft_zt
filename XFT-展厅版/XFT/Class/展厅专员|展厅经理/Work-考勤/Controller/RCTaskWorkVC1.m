//
//  RCTaskWorkVC1.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskWorkVC1.h"
#import "RCTaskWorkCell1.h"
#import "RCTaskWorkIngCell1.h"
#import "RCBeesWorkVC.h"
#import "RCPinNoteVC.h"
#import "RCTaskPinVC.h"
#import "RCTaskReportVC.h"
#import "RCTaskDetailVC1.h"
#import "RCTask.h"

static NSString *const TaskWorkCell1 = @"TaskWorkCell1";
static NSString *const TaskWorkIngCell1 = @"TaskWorkIngCell1";

@interface RCTaskWorkVC1 ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 任务列表 */
@property(nonatomic,strong) NSMutableArray *tasks;
@end

@implementation RCTaskWorkVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"任务考勤"];
    
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [self getTaskListRequest:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)tasks
{
    if (_tasks == nil) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskWorkCell1 class]) bundle:nil] forCellReuseIdentifier:TaskWorkCell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskWorkIngCell1 class]) bundle:nil] forCellReuseIdentifier:TaskWorkIngCell1];
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
        [strongSelf getTaskListRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getTaskListRequest:NO];
    }];
}
#pragma mark -- 接口请求
-(void)getTaskListRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
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
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomTask/getTaskList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.tasks removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCTask class] json:responseObject[@"data"][@"records"]];
                [strongSelf.tasks addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCTask class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.tasks addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.tasks.count) {
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
#pragma mark -- 点击事件
- (IBAction)beesUpClicked:(UIButton *)sender {
    RCBeesWorkVC *wvc = [RCBeesWorkVC new];
    [self.navigationController pushViewController:wvc animated:YES];
}
- (IBAction)myWorkClicked:(UIButton *)sender {
    RCPinNoteVC *nvc = [RCPinNoteVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCTask *task = self.tasks[indexPath.row];
    // 状态 1未开始 2进行中 3已结束
    if ([task.state isEqualToString:@"2"]) {
        RCTaskWorkIngCell1 *cell = [tableView dequeueReusableCellWithIdentifier:TaskWorkIngCell1 forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.task = task;
        hx_weakify(self);
        cell.taskWorkCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                RCTaskPinVC *pvc = [RCTaskPinVC new];
                pvc.task = task;
                pvc.taskPinActionCall = ^{
                    task.signCount = [NSString stringWithFormat:@"%zd",[task.signCount integerValue]+1];
                    [tableView reloadData];
                };
                [strongSelf.navigationController pushViewController:pvc animated:YES];
            }else{
                RCTaskReportVC *rvc = [RCTaskReportVC new];
                rvc.task = task;
                rvc.taskReportActionCall = ^(NSInteger num) {
                    task.haveVolume = [NSString stringWithFormat:@"%zd",[task.haveVolume integerValue]+num];
                    [tableView reloadData];
                };
                [strongSelf.navigationController pushViewController:rvc animated:YES];
            }
        };
        return cell;
    }else{
        RCTaskWorkCell1 *cell = [tableView dequeueReusableCellWithIdentifier:TaskWorkCell1 forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.task = task;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCTask *task = self.tasks[indexPath.row];
    // 状态 1未开始 2进行中 3已结束
    if ([task.state isEqualToString:@"2"]) {
        return 195.f;
    }else{
        return 155.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCTask *task = self.tasks[indexPath.row];
    // 状态 1未开始 2进行中 3已结束
    if (![task.state isEqualToString:@"1"]) {
        RCTaskDetailVC1 *dvc = [RCTaskDetailVC1 new];
        dvc.uuid = task.uuid;
        dvc.state = task.state;
        dvc.taskInfoActionCall = ^(NSInteger type, NSInteger num) {
            if (type == 1) {
                task.signCount = [NSString stringWithFormat:@"%zd",[task.signCount integerValue]+num];
            }else{
                task.haveVolume = [NSString stringWithFormat:@"%zd",[task.haveVolume integerValue]+num];
            }
            [tableView reloadData];
        };
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"任务未开始"];
    }
}

@end

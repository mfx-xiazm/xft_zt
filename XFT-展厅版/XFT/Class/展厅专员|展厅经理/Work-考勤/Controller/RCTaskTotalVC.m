//
//  RCTaskTotalVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskTotalVC.h"
#import "RCWorkTotalCell.h"
#import "RCTaskTotalCell.h"
#import "RCTaskTotalHeader.h"
#import "RCTaskTotalFilterHeader.h"
#import "WSDatePickerView.h"
#import "RCTaskStatistics.h"

static NSString *const WorkTotalCell = @"WorkTotalCell";
static NSString *const TaskTotalCell = @"TaskTotalCell";

@interface RCTaskTotalVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UILabel *reportNum;
@property (weak, nonatomic) IBOutlet UILabel *visitNum;
@property (weak, nonatomic) IBOutlet UILabel *signNum;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *taskTotal;
@property (copy, nonatomic) NSString *startTimeText;
@property (copy, nonatomic) NSString *endTimeText;
/* 平均 */
@property(nonatomic,strong) RCTaskStatistics *avgCount;
@end

@implementation RCTaskTotalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"任务统计"];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.startTime.text = [formatter stringFromDate:[NSDate date]];
    self.startTimeText = self.startTime.text;
    self.endTime.text = [formatter stringFromDate:[NSDate date]];
    self.endTimeText = self.endTime.text;
    
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [self startShimmer];
    [self getTaskTotalRequest];
}
-(NSMutableArray *)taskTotal
{
    if (_taskTotal == nil) {
        _taskTotal = [NSMutableArray array];
    }
    return _taskTotal;
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCWorkTotalCell class]) bundle:nil] forCellReuseIdentifier:WorkTotalCell];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无内容"];
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
        [strongSelf getTaskRequest:YES completedCall:^{
            [strongSelf.tableView reloadData];
            if (strongSelf.taskTotal.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getTaskRequest:NO completedCall:^{
            [strongSelf.tableView reloadData];
            if (strongSelf.taskTotal.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        }];
    }];
}
#pragma mark -- 点击事件
-(IBAction)chooseTimeClicked:(UIButton *)botton
{
    NSDate *currDate = nil;
    if (botton.tag == 1) {
        if ([self.startTime hasText]) {
            currDate = [self.startTime.text dateWithFormatter:@"yyyy-MM-dd"];
        }else{
            currDate = [NSDate date];
        }
    }else{
        if ([self.endTime hasText]) {
            currDate = [self.endTime.text dateWithFormatter:@"yyyy-MM-dd"];
        }else{
            currDate = [NSDate date];
        }
    }
    //年-月-日
    hx_weakify(self);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:currDate CompleteBlock:^(NSDate *selectDate) {
        hx_strongify(weakSelf);
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        if (botton.tag == 1) {
            strongSelf.startTime.text = dateString;
            strongSelf.startTimeText = dateString;
        }else{
            strongSelf.endTime.text = dateString;
            strongSelf.endTimeText = dateString;
        }
        [strongSelf getTaskTotalRequest];
    }];
    if (botton.tag == 1) {
        if ([self.endTime hasText]) {
            datepicker.maxLimitDate = [self.endTime.text dateWithFormatter:@"yyyy-MM-dd"];
        }else{
            datepicker.maxLimitDate = [NSDate date];
        }
    }else{
        if ([self.startTime hasText]) {
            datepicker.minLimitDate = [self.startTime.text dateWithFormatter:@"yyyy-MM-dd"];
        }
        
        datepicker.maxLimitDate = [NSDate date];
    }
    
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
#pragma mark -- 接口请求
-(void)getTaskTotalRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"startTime"] = strongSelf.startTimeText;//开始时间
        data[@"endTime"] = strongSelf.endTimeText;//结束时间
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
        data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
        data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
        parameters[@"data"] = data;
       
        [HXNetworkTool POST:HXRC_M_URL action:@"report/report/showroomLeader/taskAvgStatistics" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.avgCount = [RCTaskStatistics yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getTaskRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        hx_strongify(weakSelf);
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            [strongSelf stopShimmer];
            strongSelf.reportNum.text = strongSelf.avgCount.baobeiCount;
            strongSelf.visitNum.text = strongSelf.avgCount.visitCount;
            strongSelf.signNum.text = strongSelf.avgCount.dealCount;
            [strongSelf.tableView reloadData];
            if (strongSelf.taskTotal.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        });
    });
}
-(void)getTaskRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"startTime"] = self.startTimeText;//开始时间
    data[@"endTime"] = self.endTimeText;//结束时间
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
    data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
    data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
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
    [HXNetworkTool POST:HXRC_M_URL action:@"report/report/showroomLeader/taskStatistics" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.taskTotal removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCTaskStatistics class] json:responseObject[@"data"][@"records"]];
                [strongSelf.taskTotal addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCTaskStatistics class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.taskTotal addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (completedCall) {
            completedCall();
        }
    } failure:^(NSError *error) {
        if (completedCall) {
            completedCall();
        }
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskTotal.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCWorkTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkTotalCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fourTitleView.hidden = NO;
    cell.threeTitleView.hidden = YES;
    RCTaskStatistics *statistics = self.taskTotal[indexPath.row];
    cell.statistic = statistics;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCTaskTotalFilterHeader *header = [RCTaskTotalFilterHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
    
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

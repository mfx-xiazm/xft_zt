//
//  RCTaskDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskDetailVC.h"
#import "RCHouseDetailInfoCell.h"
#import "RCTaskDetailHeader.h"
#import "RCTaskDetailCell.h"
#import "RCTaskDayVC.h"
#import "RCTask.h"
#import "RCTaskStaff.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const HouseDetailInfoCell = @"HouseDetailInfoCell";
static NSString *const TaskDetailCell = @"TaskDetailCell";

@interface RCTaskDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 任务详情 */
@property(nonatomic,strong) RCTask *taskInfo;
/* 基本详情 */
@property(nonatomic,strong) NSArray *baseInfoData;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 人员列表 */
@property(nonatomic,strong) NSMutableArray *taskMembers;
@end

@implementation RCTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"任务详情"];

    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getTaskDetailRequest];
}
-(NSMutableArray *)taskMembers
{
    if (_taskMembers == nil) {
        _taskMembers = [NSMutableArray array];
    }
    return _taskMembers;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:HouseDetailInfoCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskDetailCell class]) bundle:nil] forCellReuseIdentifier:TaskDetailCell];
    
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf.tableView.mj_footer resetNoMoreData];
//        [strongSelf getTaskListRequest:YES];
//    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getTaskMemberRequest:NO completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
#pragma mark -- 点击事件
-(void)finishTaskClicked
{
    hx_weakify(self);
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确认终止任务？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        [strongSelf stopTaskRequest];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
#pragma mark -- 接口请求
-(void)stopTaskRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"taskUuid"] = self.uuid;//任务uuid
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomTask/stopTask" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            strongSelf.state = @"4";
            if (strongSelf.stopTaskCall) {
                strongSelf.stopTaskCall();
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新界面
                [strongSelf handleTaskDetailInfo];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getTaskDetailRequest
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
        data[@"uuid"] = strongSelf.uuid;//任务uuid
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomTask/getTaskInfo" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.taskInfo = [RCTask yy_modelWithDictionary:responseObject[@"data"]];
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
        [strongSelf getTaskMemberRequest:YES completedCall:^{
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
            
            [strongSelf handleTaskDetailInfo];
        });
    });
}
-(void)getTaskMemberRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"taskUuid"] = self.uuid;
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
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomTask/pioneerAttendance" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.taskMembers removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCTaskStaff class] json:responseObject[@"data"][@"records"]];
                [strongSelf.taskMembers addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCTaskStaff class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.taskMembers addObjectsFromArray:arrt];
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
-(void)handleTaskDetailInfo
{
    if ([self.state isEqualToString:@"1"] || [self.state isEqualToString:@"2"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(finishTaskClicked) title:@"终止任务" font:[UIFont systemFontOfSize:16] titleColor:UIColorFromRGB(0xEC142D) highlightedColor:UIColorFromRGB(0xEC142D) titleEdgeInsets:UIEdgeInsetsZero];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    // 处理基础详情
    NSMutableArray *houseInfo = [NSMutableArray array];
    NSArray *titles = @[@"任务标题",@"拓客方式",@"拓客地点",@"拓客时间",@"拓客任务量",@"拓客人员",@"任务创建者"];
    NSArray *values = @[self.taskInfo.name,self.taskInfo.twoQudaoName,self.taskInfo.address,     [NSString stringWithFormat:@"%@ 至 %@",self.taskInfo.startTime,self.taskInfo.endTime],[NSString stringWithFormat:@"%@组",self.taskInfo.volume],[NSString stringWithFormat:@"%@人",self.taskInfo.accCount],[NSString stringWithFormat:@"%@(%@)",self.taskInfo.createName,self.taskInfo.showroomName]];

    for (int i=0; i<7; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"name"] = titles[i];
        dict[@"content"] = values[i];
        [houseInfo addObject:dict];
    }
    self.baseInfoData = houseInfo;
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.baseInfoData?self.baseInfoData.count:0;
    }else{
        return self.taskMembers.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RCHouseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailInfoCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = self.baseInfoData[indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
        cell.content.text = dict[@"content"];
        return cell;
    }else{
        RCTaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskDetailCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCTaskStaff *staff = self.taskMembers[indexPath.row];
        cell.staff = staff;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section?44.f:UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section?80.f:44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section?0.1f:10.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCTaskDetailHeader *header = [RCTaskDetailHeader loadXibView];
    header.hxn_size = section?CGSizeMake(HX_SCREEN_WIDTH, 44.f):CGSizeMake(HX_SCREEN_WIDTH, 80.f);
    header.taskTitlesView.hidden = !section;
    header.fiveTitlesView.hidden = NO;
    header.fourTitlesView.hidden = YES;
    header.threeTitlesView.hidden = YES;
    if (section == 0) {
        header.titleTag.text = @"任务概况";
    }else{
        header.titleTag.text = @"拓客考勤";
    }
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        RCTaskDayVC *dvc = [RCTaskDayVC new];
        RCTaskStaff *staff = self.taskMembers[indexPath.row];
        dvc.navTitle = [NSString stringWithFormat:@"%@的考勤列表",staff.accName];
        dvc.cusUuid = staff.accUuid;
        dvc.taskUuid = self.uuid;
        dvc.accName = staff.accName;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}


@end

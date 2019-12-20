//
//  RCTaskDetailVC1.m
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskDetailVC1.h"
#import "RCHouseDetailInfoCell.h"
#import "RCTaskDetailHeader.h"
#import "RCPinNoteCell.h"
#import "RCTaskDetailReportCell.h"
#import <QMapKit/QMapKit.h>
#import "RCTask.h"
#import "RCTaskPinVC.h"
#import "RCTaskReportVC.h"
#import "RCTaskReport.h"
#import "RCMyTaskReportVC.h"
#import "RCTaskPin.h"
#import "RCPinNoteVC.h"
#import "UIImage+HXNExtension.h"

static NSString *const HouseDetailInfoCell = @"HouseDetailInfoCell";
static NSString *const PinNoteCell = @"PinNoteCell";
static NSString *const TaskDetailReportCell = @"TaskDetailReportCell";

@interface RCTaskDetailVC1 ()<UITableViewDelegate,UITableViewDataSource,QMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *taskToolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskToolViewHeight;
@property (nonatomic, strong) QMapView *mapView;
/* 任务详情 */
@property(nonatomic,strong) RCTask *taskInfo;
/* 基本详情 */
@property(nonatomic,strong) NSArray *baseInfoData;
/* 我的报备 */
@property(nonatomic,strong) NSArray *taskReports;
/* 我的考勤 */
@property(nonatomic,strong) NSArray *taskPins;
@end

@implementation RCTaskDetailVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"任务详情"];
    [self setUpTableView];
    [self startShimmer];
    [self getTaskDetailRequest];
}
-(QMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[QMapView alloc] initWithFrame:CGRectMake(15, 10, HX_SCREEN_WIDTH-30, 230)];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 12;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = QUserTrackingModeFollow;
    }
    return _mapView;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCPinNoteCell class]) bundle:nil] forCellReuseIdentifier:PinNoteCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskDetailReportCell class]) bundle:nil] forCellReuseIdentifier:TaskDetailReportCell];
}
#pragma mark -- 接口请求
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
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"taskUuid"] = strongSelf.uuid;
        NSMutableDictionary *page = [NSMutableDictionary dictionary];
        page[@"current"] = @"1";
        page[@"size"] = @"10";
        parameters[@"data"] = data;
        parameters[@"page"] = page;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"anchang/anchang/baobei/queryTaskBaobeiList" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.taskReports = [NSArray yy_modelArrayWithClass:[RCTaskReport class] json:responseObject[@"data"][@"records"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
        data[@"taskUuid"] = strongSelf.uuid;//任务uuid
        data[@"startTime"] = @([[[NSString stringWithFormat:@"%@ 00:00",[strongSelf.taskInfo.startTime substringToIndex:10]] dateWithFormatter:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970]);//所选日期起始时间戳
        data[@"endTime"] = @([[[NSString stringWithFormat:@"%@ 23:59",[strongSelf.taskInfo.startTime substringToIndex:10]] dateWithFormatter:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970]);// 所选日期结束时间戳
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomAccSign/getZySignList" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.taskPins = [NSArray yy_modelArrayWithClass:[RCTaskPin class] json:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新界面
                    [strongSelf stopShimmer];
                    
                    [strongSelf handleTaskDetailInfo];
                });
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    });
}
-(void)handleTaskDetailInfo
{
    if ([self.state isEqualToString:@"2"]) {
        self.taskToolView.hidden = NO;
        self.taskToolViewHeight.constant = 50.f;
    }else{
        self.taskToolView.hidden = YES;
        self.taskToolViewHeight.constant = CGFLOAT_MIN;
    }
    // 处理基础详情
    NSMutableArray *houseInfo = [NSMutableArray array];
    NSArray *titles = @[@"任务标题",@"拓客方式",@"拓客地点",@"拓客时间",@"拓客任务量",@"拓客人员",@"任务创建者"];
    NSArray *values = @[self.taskInfo.name,self.taskInfo.twoQudaoName,self.taskInfo.address,     [NSString stringWithFormat:@"%@ 至 %@",self.taskInfo.startTime,self.taskInfo.endTime],[NSString stringWithFormat:@"%@组",self.taskInfo.volume],[NSString stringWithFormat:@"%@人",self.taskInfo.accCount],[NSString stringWithFormat:@"%@(%@-%@)",self.taskInfo.createName,self.taskInfo.createTeamName,self.taskInfo.createGroupName]];

    for (int i=0; i<7; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"name"] = titles[i];
        dict[@"content"] = values[i];
        [houseInfo addObject:dict];
    }
    self.baseInfoData = houseInfo;
    [self.tableView reloadData];
    
    NSMutableArray *pins = [NSMutableArray array];
    for (int i=0;i<self.taskPins.count;i++) {
        RCTaskPin *pin = self.taskPins[i];
        QPointAnnotation *point = [[QPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(pin.lat, pin.lng);
        point.title = [NSString stringWithFormat:@"%d",i+1];
        [pins addObject:point];
    }
    [self.mapView addAnnotations:pins];
}
#pragma mark -- 点击事件
- (IBAction)taskToolClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        RCTaskPinVC *pvc = [RCTaskPinVC new];
        pvc.task = self.taskInfo;
        hx_weakify(self);
        pvc.taskPinActionCall = ^{
            hx_strongify(weakSelf);
            [strongSelf getTaskDetailRequest];
            if (strongSelf.taskInfoActionCall) {
                strongSelf.taskInfoActionCall(1, 1);
            }
        };
        [self.navigationController pushViewController:pvc animated:YES];
    }else{
        RCTaskReportVC *rvc = [RCTaskReportVC new];
        rvc.task = self.taskInfo;
        hx_weakify(self);
        rvc.taskReportActionCall = ^(NSInteger num) {
            hx_strongify(weakSelf);
            [strongSelf getTaskDetailRequest];
            if (strongSelf.taskInfoActionCall) {
                strongSelf.taskInfoActionCall(2, num);
            }
        };
        [self.navigationController pushViewController:rvc animated:YES];
    }
}
#pragma mark - AMapSearchDelegate
/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id <QAnnotation>)annotation;
{
    if ([annotation isKindOfClass:[QUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageSetString_image:[UIImage imageNamed:@"icon_pin"] text:annotation.title textPoint:CGPointMake(8, 2) attributedString:@{NSFontAttributeName :[ UIFont systemFontOfSize:12 weight:UIFontWeightMedium], NSForegroundColorAttributeName :[ UIColor whiteColor]}];
        annotationView.canShowCallout  = NO;
        annotationView.annotation = annotation;
        return annotationView;
    }
    return nil;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.baseInfoData?self.baseInfoData.count:0;
    }else if (section == 1) {
        return self.taskPins.count;
    }else{
        return self.taskReports.count;
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
    }else if (indexPath.section == 1) {
        RCPinNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:PinNoteCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.num.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
        RCTaskPin *pin = self.taskPins[indexPath.row];
        cell.pin = pin;
        return cell;
    }else{
        RCTaskDetailReportCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskDetailReportCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.num.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
        RCTaskReport *report = self.taskReports[indexPath.row];
        cell.report = report;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section?50.f:UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 80.f;
    }else{
        return 44.f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.f;
    }else if (section == 1) {
        return 260.f;
    }else{
        return 0.1f;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCTaskDetailHeader *header = [RCTaskDetailHeader loadXibView];
    header.hxn_size = (section == 1)?CGSizeMake(HX_SCREEN_WIDTH, 80.f):CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    header.fiveTitlesView.hidden = YES;
    header.threeTitlesView.hidden = YES;
    header.fourTitlesView.hidden = NO;
    header.taskTitlesView.hidden = !section;
    if (section == 0) {
        header.lookMoreTag.hidden = YES;
        header.titleTag.text = @"任务概况";
    }else if (section == 1) {
        header.lookMoreTag.hidden = NO;
        header.titleTag.text = @"我的考勤";
        header.firstName.text = @"打卡类型";
        header.secName.text = [self.taskInfo.startTime substringToIndex:10];
        header.trdName.text = @"地点";
        header.forName.text = @"签到图片";
    }else{
        header.lookMoreTag.hidden = NO;
        header.titleTag.text = @"我的报备";
    }
    hx_weakify(self);
    header.lookMoreCall = ^{
        hx_strongify(weakSelf);
        if (section == 1) {
            RCPinNoteVC *nvc = [RCPinNoteVC new];
            nvc.taskUuid = strongSelf.uuid;
            nvc.minLimitDate = self.taskInfo.startTime;
            nvc.maxLimitDate = self.taskInfo.endTime;
            [strongSelf.navigationController pushViewController:nvc animated:YES];
        }else if (section == 2) {
            RCMyTaskReportVC *rvc = [RCMyTaskReportVC new];
            rvc.uuid = strongSelf.uuid;
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }
    };
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footer = [UIView new];
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 260);
        
        UIView *mapBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, 250)];
        mapBgView.backgroundColor = [UIColor whiteColor];
        [footer addSubview:mapBgView];
        
        [mapBgView addSubview:self.mapView];
        
        return footer;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

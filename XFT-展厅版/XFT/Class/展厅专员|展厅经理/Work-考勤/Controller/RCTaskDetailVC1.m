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
#import <MAMapKit/MAMapKit.h>

static NSString *const HouseDetailInfoCell = @"HouseDetailInfoCell";
static NSString *const PinNoteCell = @"PinNoteCell";
static NSString *const TaskDetailReportCell = @"TaskDetailReportCell";

@interface RCTaskDetailVC1 ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation RCTaskDetailVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"任务详情"];
    
    [self setUpTableView];
}
-(MAMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(15, 10, HX_SCREEN_WIDTH-30, 230)];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 12;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
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
#pragma mark -- 点击事件

#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RCHouseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailInfoCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        RCPinNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:PinNoteCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RCTaskDetailReportCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskDetailReportCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

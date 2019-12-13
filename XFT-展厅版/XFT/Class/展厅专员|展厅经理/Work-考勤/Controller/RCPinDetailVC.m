//
//  RCPinDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPinDetailVC.h"
#import "RCPinNoteCell.h"
#import <QMapKit/QMapKit.h>
#import "RCTaskPin.h"
#import "UIImage+HXNExtension.h"

static NSString *const PinNoteCell = @"PinNoteCell";

@interface RCPinDetailVC ()<UITableViewDelegate,UITableViewDataSource,QMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (nonatomic, strong) QMapView *mapView;
/* 打点 */
@property(nonatomic,strong) NSArray *taskPins;
/* 打点 */
@property(nonatomic,strong) NSMutableArray *pins;
@end

@implementation RCPinDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.navTitle];
    self.name.text = self.accName;
    self.date.text = self.dateTime;
    [self setUpTableView];
    [self startShimmer];
    [self getSignListRequest];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)pins
{
    if (_pins == nil) {
        _pins = [NSMutableArray array];
    }
    return _pins;
}
-(QMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[QMapView alloc] initWithFrame:CGRectMake(15, 10, HX_SCREEN_WIDTH-30, 230)];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 13;
        _mapView.delegate = self;
    }
    return _mapView;
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
    
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCPinNoteCell class]) bundle:nil] forCellReuseIdentifier:PinNoteCell];
}
-(void)getSignListRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
    data[@"taskUuid"] = self.taskUuid;//任务uuid
    data[@"dateTime"] = self.dateTime;//时间
    data[@"accUuid"] = self.accUuid;//拓客人员uuid
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomTask/attendanceDetails" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.taskPins = [NSArray yy_modelArrayWithClass:[RCTaskPin class] json:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handlePinNoteData];
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
-(void)handlePinNoteData
{
    [self.tableView reloadData];
    

    if (self.pins.count) {
        [self.mapView removeAnnotations:self.pins];
    }
    [self.pins removeAllObjects];
    for (int i=0;i<self.taskPins.count;i++) {
        RCTaskPin *pin = self.taskPins[i];
        QPointAnnotation *point = [[QPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(pin.lat, pin.lng);
        point.title = [NSString stringWithFormat:@"%d",i+1];
        [self.pins addObject:point];
    }
    [self.mapView addAnnotations:self.pins];
    if (self.pins.count) {
        QPointAnnotation *point = self.pins.firstObject;
        [self.mapView setCenterCoordinate:point.coordinate animated:YES];
    }
}
#pragma mark - Map Delegate
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskPins.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCPinNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:PinNoteCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.num.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    RCTaskPin *pin = self.taskPins[indexPath.row];
    cell.pin1 = pin;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 260.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 260);
    
    UIView *mapBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, 250)];
    mapBgView.backgroundColor = [UIColor whiteColor];
    [footer addSubview:mapBgView];
    
    [mapBgView addSubview:self.mapView];
    
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

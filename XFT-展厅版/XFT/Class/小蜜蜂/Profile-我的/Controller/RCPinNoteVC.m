//
//  RCPinNoteVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPinNoteVC.h"
#import "RCPinNoteCell.h"
#import <QMapKit/QMapKit.h>
#import "WSDatePickerView.h"
#import "RCTaskPin.h"
#import "UIImage+HXNExtension.h"

static NSString *const PinNoteCell = @"PinNoteCell";
@interface RCPinNoteVC ()<UITableViewDelegate,UITableViewDataSource,QMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic, strong) QMapView *mapView;
/* 打点 */
@property(nonatomic,strong) NSArray *taskPins;
/* 当前选中的时间 */
@property(nonatomic,copy) NSString *selectDate;
/* 打点 */
@property(nonatomic,strong) NSMutableArray *pins;
@end

@implementation RCPinNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
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
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    SPButton *menu = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
    menu.hxn_size = CGSizeMake(150 , 44);
    menu.imageTitleSpace = 5.f;
    menu.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [menu setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    if (self.minLimitDate) {
        [menu setTitle:[self.minLimitDate substringToIndex:10] forState:UIControlStateNormal];
    }else{
        [menu setTitle:[[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm"] substringToIndex:10] forState:UIControlStateNormal];
    }
    [menu setImage:HXGetImage(@"Shape") forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.time.text = menu.currentTitle;
    self.navigationItem.titleView = menu;
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
#pragma mark -- 点击事件
-(void)dateClicked:(SPButton *)menuBtn
{
//    [menuBtn layoutSubviews];
    //年-月-日
    hx_weakify(self);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:[menuBtn.currentTitle dateWithFormatter:@"yyyy-MM-dd"] CompleteBlock:^(NSDate *selectDate) {
        hx_strongify(weakSelf);
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        [menuBtn setTitle:dateString forState:UIControlStateNormal];
        strongSelf.time.text = menuBtn.currentTitle;
        strongSelf.selectDate = dateString;
        [strongSelf getSignListRequest];
    }];
    if (self.minLimitDate) {
        datepicker.minLimitDate = [[self.minLimitDate substringToIndex:10] dateWithFormatter:@"yyyy-MM-dd"];
    }
    if (self.maxLimitDate) {
        datepicker.maxLimitDate = [[self.maxLimitDate substringToIndex:10] dateWithFormatter:@"yyyy-MM-dd"];
    }else{
        datepicker.maxLimitDate = [NSDate date];
    }
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
-(void)getSignListRequest
{
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 3) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
        data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
        data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
        data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//账号uuid
        if (self.selectDate) {
            data[@"accSignDate"] = [self.selectDate substringToIndex:10];//所选日期
        }else{
            data[@"accSignDate"] = [[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] substringToIndex:10];//所选日期
        }
        
        parameters[@"data"] = data;
        
        hx_weakify(self);
        [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomAccSign/getBeeSignList" parameters:parameters success:^(id responseObject) {
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

    }else{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
        data[@"taskUuid"] = (self.taskUuid && self.taskUuid.length)?self.taskUuid:@"";//任务uuid
        if (self.selectDate) {
            data[@"startTime"] = @([[[NSString stringWithFormat:@"%@ 00:00",[self.selectDate substringToIndex:10]] dateWithFormatter:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970]);//所选日期起始时间戳
            data[@"endTime"] = @([[[NSString stringWithFormat:@"%@ 23:59",[self.selectDate substringToIndex:10]] dateWithFormatter:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970]);// 所选日期结束时间戳
        }else if (self.minLimitDate){
            data[@"startTime"] = @([[[NSString stringWithFormat:@"%@ 00:00",[self.minLimitDate substringToIndex:10]] dateWithFormatter:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970]);//所选日期起始时间戳
            data[@"endTime"] = @([[[NSString stringWithFormat:@"%@ 23:59",[self.minLimitDate substringToIndex:10]] dateWithFormatter:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970]);// 所选日期结束时间戳
        }else{
            data[@"startTime"] = @([[[NSString stringWithFormat:@"%@ 00:00",[[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm"] substringToIndex:10]] dateWithFormatter:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970]);//所选日期起始时间戳
            data[@"endTime"] = @([[[NSString stringWithFormat:@"%@ 23:59",[[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm"] substringToIndex:10]] dateWithFormatter:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970]);// 所选日期结束时间戳
        }
        
        parameters[@"data"] = data;
        
        hx_weakify(self);
        [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomAccSign/getZySignList" parameters:parameters success:^(id responseObject) {
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
    cell.pin = pin;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
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

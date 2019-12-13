//
//  RCAddTaskVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddTaskVC.h"
#import <QMapKit/QMapKit.h>
#import <ZLCollectionViewVerticalLayout.h>
#import "RCAddTaskMemberCell.h"
#import "RCChooseMemberVC.h"
#import "WSDatePickerView.h"
#import "RCTaskMember.h"
#import "RCClientType.h"
#import "ZJPickerView.h"

static NSString *const AddTaskMemberCell = @"AddTaskMemberCell";

@interface RCAddTaskVC ()<QMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (nonatomic, strong) QMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextField *taskType;
@property (weak, nonatomic) IBOutlet UITextField *taskNum;
@property (weak, nonatomic) IBOutlet UITextField *taskStartTime;
@property (weak, nonatomic) IBOutlet UITextField *taskEndTime;
/** 根据选中的任务地点显示的大头针 */
@property(nonatomic,strong) QPointAnnotation *point;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/* 任务分配人员 */
@property(nonatomic,strong) NSMutableArray *taskMembers;
/* 所有的人员 */
@property(nonatomic,strong) NSArray *allMembers;
/* 拓客方式 */
@property(nonatomic,strong) NSArray *clientTypes;
/* 拓客方式code */
@property(nonatomic,copy) NSString *taskTypeCode;
@end

@implementation RCAddTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavNar];
    [self.mapSuperView addSubview:self.mapView];
    [self setUpCollectionView];
    [self getTypeListDataRequest];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.collectionViewHeight.constant = strongSelf.collectionView.contentSize.height;
    });
    
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.taskName hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入任务名称"];
            return NO;
        }
        if (![strongSelf.taskType hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择拓客方式"];
            return NO;
        }
        if (![strongSelf.taskNum hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入拓客任务量"];
            return NO;
        }
        if (![strongSelf.taskStartTime hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择开始时间"];
            return NO;
        }
        if (![strongSelf.taskEndTime hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择结束时间"];
            return NO;
        }
        if (!strongSelf.point) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择拓客地点"];
            return NO;
        }
        if (strongSelf.taskMembers.count == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请添加任务人员"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        //根据经纬度反向地理编译出地址信息
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:strongSelf.point.coordinate.latitude longitude:strongSelf.point.coordinate.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count > 0) {
                CLPlacemark *placemark = placemarks.firstObject;
                //存储位置信息
                NSString * address = [NSString stringWithFormat:@"%@%@%@%@",placemark.locality,placemark.subLocality,placemark.name,placemark.thoroughfare];
                [strongSelf creatTaskRequest:address sender:button];
            }
        }];
    }];
    
//    CGFloat width = (HX_SCREEN_WIDTH - 15*2 - 10*4)/5.0;
//    CGFloat height = width + 30;
//    //    NSInteger rowCount = (8 % 6)?(8 / 6 + 1):8 / 6;
//    self.collectionViewHeight.constant = 5.f + height*2 + 10.f*(2+1) + 5.f;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.mapSuperView.bounds;
}
-(NSMutableArray *)taskMembers
{
    if (_taskMembers == nil) {
        _taskMembers = [NSMutableArray array];
        RCTaskAgentMember *member = [RCTaskAgentMember new];
        member.name = @"分配专员";
        [_taskMembers addObject:member];
    }
    return _taskMembers;
}
-(QMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[QMapView alloc] initWithFrame:self.mapSuperView.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 12;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = QUserTrackingModeFollow;
    }
    return _mapView;
}
-(void)setNavNar
{
    [self.navigationItem setTitle:@"新建任务"];
    
    // 如果push进来的不是第一个控制器，就设置其左边的返回键
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    button.hxn_size = CGSizeMake(44, 44);
    // 让按钮内部的所有内容左对齐
    //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddTaskMemberCell class]) bundle:nil] forCellWithReuseIdentifier:AddTaskMemberCell];
}
#pragma mark -- 点击事件
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)taskTypeClicked:(UIButton *)sender {
    if (!self.clientTypes) {
        return;
    }
    if (!self.clientTypes.count) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请先添加拓客方式"];
        return;
    }
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   ZJPickerViewPropertyTipLabelTextKey  : [self.taskType hasText]?self.taskType.text:@"选择拓客方式", // 提示内容
                                   ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0xA9A9A9),
                                   ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0x232323),
                                   ZJPickerViewPropertyTipLabelTextColorKey :
                                       UIColorFromRGB(0x131D2D),
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @220.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x131D2D), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0xA9A9A9), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    NSMutableArray *titles = [NSMutableArray array];
    for (RCClientType *type in self.clientTypes) {
        [titles addObject:type.name];
    }
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:titles propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        // show select content|
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];

        NSArray *type = [results.firstObject componentsSeparatedByString:@","];

        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        
        strongSelf.taskType.text = type.firstObject;
        RCClientType *resultType = strongSelf.clientTypes[[rows.firstObject integerValue]];
        strongSelf.taskTypeCode = resultType.code;
    }];
}
- (IBAction)startTimeClicked:(UIButton *)sender {
    //年-月-日-时分
    hx_weakify(self);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        weakSelf.taskStartTime.text = dateString;
    }];
    datepicker.minLimitDate = [NSDate date];
    if ([self.taskEndTime hasText]) {
        datepicker.maxLimitDate = [self.taskEndTime.text dateWithFormatter:@"yyyy-MM-dd HH:mm"];
    }
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
- (IBAction)endTimeClicked:(UIButton *)sender {
    //年-月-日-时分
    hx_weakify(self);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        weakSelf.taskEndTime.text = dateString;
    }];
    if ([self.taskStartTime hasText]) {
        datepicker.minLimitDate = [self.taskStartTime.text dateWithFormatter:@"yyyy-MM-dd HH:mm"];
    }else{
        datepicker.minLimitDate = [NSDate date];
    }
    
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
#pragma mark -- 接口业务
/** 列表请求 */
-(void)getTypeListDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;
    parameters[@"data"] = data;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomExpandMode/getShowroomExpandModeList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.clientTypes = [NSArray yy_modelArrayWithClass:[RCClientType class] json:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)creatTaskRequest:(NSString *)address sender:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"name"] = self.taskName.text;// 任务名称
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
    data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//权限团队uuid
    data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//权限小组uuid
    data[@"twoQudaoCode"] = self.taskTypeCode;//拓客方式编码不能为空
    data[@"twoQudaoName"] = self.taskType.text;//拓客方式不能为空
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    data[@"startTime"] = @([[fmt dateFromString:self.taskStartTime.text] timeIntervalSince1970]);//开始时间不能为空
    data[@"endTime"] = @([[fmt dateFromString:self.taskEndTime.text] timeIntervalSince1970]);//结束时间不能为空
    data[@"lat"] = @(self.point.coordinate.latitude);//纬度
    data[@"lng"] = @(self.point.coordinate.longitude);//经度
    data[@"address"] = address;//地址
    data[@"volume"] = self.taskNum.text;// 拓客任务量不能为空
    NSMutableArray *list = [NSMutableArray array];
    for (RCTaskMember *member in self.allMembers) {
        for (RCTaskAgentMember *agentMember in member.list) {
            if (agentMember.isSelected) {
                [list addObject:@{@"accUuid":agentMember.uuid,
                                  @"groupUuid":member.groupUuid,
                                  @"teamUuid":member.teamUuid}];
            }
        }
    }
    data[@"list"] = list;
        
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomManager/addShowroomTask" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"创建" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
           [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
           [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"创建" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- QMapView代理
/**
 * @brief  点击地图空白处会调用此接口.
 * @param mapView 地图View
 * @param coordinate 坐标
 */
- (void)mapView:(QMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [mapView setCenterCoordinate:coordinate animated:YES];
    //根据经纬度反向地理编译出地址信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    hx_weakify(self);
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        hx_strongify(weakSelf);
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            //存储位置信息
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@",placemark.locality,placemark.subLocality,placemark.name,placemark.thoroughfare];
            if (strongSelf.point) {
                [mapView removeAnnotation:strongSelf.point];
            }else{
                strongSelf.point = [[QPointAnnotation alloc] init];
            }
            strongSelf.point.coordinate = coordinate;
            strongSelf.point.title = address;
            [mapView addAnnotation:strongSelf.point];
        }
    }];
}
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
        QPinAnnotationView *annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout  = YES;
        annotationView.annotation = annotation;
        return annotationView;
    }
    return nil;
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.taskMembers.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 5;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCAddTaskMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddTaskMemberCell forIndexPath:indexPath];
    RCTaskAgentMember *member = self.taskMembers[indexPath.item];
    cell.member = member;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.taskMembers.count-1) {
        RCChooseMemberVC *mvc = [RCChooseMemberVC new];
        if (self.allMembers) {
            mvc.members = self.allMembers;
        }
        hx_weakify(self);
        mvc.chooseMemberCall = ^(NSArray * _Nonnull selectMembers, NSArray * _Nonnull members) {
            hx_strongify(weakSelf);
            [strongSelf.taskMembers removeAllObjects];
            [strongSelf.taskMembers addObjectsFromArray:selectMembers];
            RCTaskAgentMember *member = [RCTaskAgentMember new];
            member.name = @"分配专员";
            [strongSelf.taskMembers addObject:member];
            
            strongSelf.allMembers = members;
            
            [collectionView reloadData];
        };
        [self.navigationController pushViewController:mvc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (HX_SCREEN_WIDTH - 15*2 - 10*4)/5.0;
    return CGSizeMake(w, w+30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 15, 5, 15);
}
@end

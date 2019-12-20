//
//  RCTaskPinVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskPinVC.h"
#import <QMapKit/QMapKit.h>
#import "RCNavBarView.h"
#import "RCTask.h"
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

@interface RCTaskPinVC ()<QMapViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *tadkImg;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

/* 签到照片路径 */
@property(nonatomic,copy) NSString *taskImgUrl;
@property (nonatomic, strong) QMapView *mapView;
/* 导航栏 */
@property(nonatomic,strong) RCNavBarView *navBarView;
@end

@implementation RCTaskPinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navBarView];
    
    self.taskTitle.text = [NSString stringWithFormat:@"%@【%@】",self.task.name,self.task.twoQudaoName];
    self.address.text = [NSString stringWithFormat:@"地点：%@",self.task.address];
    self.time.text = [NSString stringWithFormat:@"时间：%@ 至 %@",self.task.startTime,_task.endTime];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImgClicked:)];
    [self.tadkImg addGestureRecognizer:tap];
    
    [self.mapSuperView addSubview:self.mapView];
    
    //构造圆形，半径单位m
    QCircle *circle = [QCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(self.task.lat, self.task.lng) radius:2000];
    //添加圆形
    [self.mapView addOverlay:circle];
    
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        CLLocationDistance distance = QMetersBetweenCoordinates(CLLocationCoordinate2DMake(strongSelf.task.lat, strongSelf.task.lng), strongSelf.mapView.userLocation.location.coordinate);
        if (distance > 2000) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"不在打卡范围内"];
            return NO;
        }
        if (!strongSelf.taskImgUrl) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传签到照片"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        //根据经纬度反向地理编译出地址信息
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count > 0) {
                CLPlacemark *placemark = placemarks.firstObject;
                //存储位置信息
                NSString * address = [NSString stringWithFormat:@"%@%@%@%@",placemark.locality,placemark.subLocality,placemark.name,placemark.thoroughfare];
                [strongSelf setTaskSignRequest:address button:button];

            }
        }];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.mapSuperView.bounds;
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
}
#pragma mark -- 视图相关
-(RCNavBarView *)navBarView
{
    if (_navBarView == nil) {
        _navBarView = [RCNavBarView loadXibView];
        _navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
        _navBarView.backBtn.hidden = NO;
        [_navBarView.backBtn setImage:HXGetImage(@"whback") forState:UIControlStateNormal];
        _navBarView.titleL.text = @"任务打卡";
        _navBarView.titleL.hidden = NO;
        _navBarView.titleL.textAlignment = NSTextAlignmentCenter;
        hx_weakify(self);
        _navBarView.navBackCall = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navBarView;
}
-(QMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[QMapView alloc] initWithFrame:self.mapSuperView.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 13;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = QUserTrackingModeFollow;
    }
    return _mapView;
}
#pragma mark -- MAMapViewd代理
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QCircle class]]) {
        QCircleView *circleView = [[QCircleView alloc] initWithCircle:overlay];
        //设置描边宽度
        [circleView setLineWidth:0.f];
        //设置描边色为黑色
        [circleView setStrokeColor:[UIColor clearColor]];
        //设置填充色为红色
        [circleView setFillColor:HXRGBAColor(76, 143, 247, 0.2)];
        return circleView;
    }
    return nil;
}
#pragma mark -- 业务逻辑
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //该页面呈现时手动调用计算导航栏此时应当显示的颜色
    [self.navBarView changeColor:[UIColor whiteColor] offsetHeight:180-self.HXNavBarHeight withOffsetY:scrollView.contentOffset.y];
}
#pragma mark -- 唤起相机
- (void)chooseImgClicked:(UITapGestureRecognizer *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [strongSelf awakeImagePickerController:@"1"];
        }else{
            [strongSelf awakeImagePickerController:@"2"];
        }
    }];
}
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self isCanUseCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self isCanUsePhotos]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相册不可用"];
            return;
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        hx_strongify(weakSelf);
        // 显示保存图片
        [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl) {
            [strongSelf.tadkImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            strongSelf.taskImgUrl = imageUrl;
        }];
    }];
}
#pragma mark -- 业务逻辑
-(void)setTaskSignRequest:(NSString *)address button:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
    data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//权限团队uuid
    data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//权限小组uuid
    data[@"taskUuid"] = self.task.uuid;//任务uuid
    data[@"photo"] = self.taskImgUrl;//签到照片
    data[@"lat"] = @(self.mapView.userLocation.location.coordinate.latitude);//纬度
    data[@"lng"] = @(self.mapView.userLocation.location.coordinate.longitude);//经度
    data[@"address"] = address;//签到地址
    data[@"type"] = @"2";// 签到类型 1外勤签到 2任务签到
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomAccSign/setZySign" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
           [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            if (strongSelf.taskPinActionCall) {
                strongSelf.taskPinActionCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"sys/sys/dict/getUploadImgReturnUrl.do" parameters:@{} name:@"file" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            completedCall(responseObject[@"data"][@"url"]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end

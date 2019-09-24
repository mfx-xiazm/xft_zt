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

@interface RCTaskPinVC ()<QMapViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (nonatomic, strong) QMapView *mapView;
/* 导航栏 */
@property(nonatomic,strong) RCNavBarView *navBarView;
@end

@implementation RCTaskPinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navBarView];
    [self.mapSuperView addSubview:self.mapView];
    
    //构造圆形，半径单位m
    QCircle *circle = [QCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(30.5065508426, 114.3647167969) radius:5000];
    //添加圆形
    [self.mapView addOverlay:circle];
    
    /*
    QMapPoint point = QMapPointForCoordinate(self.mapView.userLocation.location.coordinate);
    QMapPoint center = QMapPointForCoordinate(CLLocationCoordinate2DMake(30.5065508426, 114.3647167969));
    QMetersBetweenMapPoints(point,center);
    QMetersBetweenCoordinates(point, center)
     */
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
        _mapView.zoomLevel = 12;
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
        [circleView setFillColor:HXRGBAColor(255, 159, 8, 0.1)];
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

@end

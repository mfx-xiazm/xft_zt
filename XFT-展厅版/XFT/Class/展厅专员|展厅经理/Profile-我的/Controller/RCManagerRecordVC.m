//
//  RCManagerRecordVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCManagerRecordVC.h"
#import <QMapKit/QMapKit.h>

@interface RCManagerRecordVC ()<QMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (nonatomic, strong) QMapView *mapView;

@end

@implementation RCManagerRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"外勤签到"];
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
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.mapSuperView.bounds;
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

@end

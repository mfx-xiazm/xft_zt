//
//  RCRecordVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCRecordVC.h"
#import <MAMapKit/MAMapKit.h>

@interface RCRecordVC ()<MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation RCRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"外勤签到"];
    [self.mapSuperView addSubview:self.mapView];
    
    //构造圆
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(30.5065508426, 114.3647167969) radius:5000];
    
    //在地图上添加圆
    [self.mapView addOverlay:circle];
    
    /*
    MAMapPoint point = MAMapPointForCoordinate(self.mapView.userLocation.coordinate);
    MAMapPoint center = MAMapPointForCoordinate(CLLocationCoordinate2DMake(30.5065508426, 114.3647167969));
    MACircleContainsPoint(point, center, 5000)
     */
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.mapSuperView.bounds;
}
-(MAMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] initWithFrame:self.mapSuperView.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 12;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
    return _mapView;
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay;
{
    if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth    = 0.f;
        circleRenderer.strokeColor  = [UIColor clearColor];
        circleRenderer.fillColor    = HXRGBAColor(255, 159, 8, 0.1);
        return circleRenderer;
    }
    return nil;
}
@end

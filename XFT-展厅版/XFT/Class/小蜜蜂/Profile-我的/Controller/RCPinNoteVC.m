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

static NSString *const PinNoteCell = @"PinNoteCell";
@interface RCPinNoteVC ()<UITableViewDelegate,UITableViewDataSource,QMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (nonatomic, strong) QMapView *mapView;
@end

@implementation RCPinNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self.mapSuperView addSubview:self.mapView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mapView.frame = self.mapSuperView.bounds;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    SPButton *menu = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
    menu.hxn_size = CGSizeMake(150 , 44);
    menu.imageTitleSpace = 5.f;
    menu.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [menu setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    [menu setTitle:@"2019-08-05" forState:UIControlStateNormal];
    [menu setImage:HXGetImage(@"Shape") forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = menu;
}
-(QMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[QMapView alloc] initWithFrame:self.mapSuperView.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 13;
        _mapView.delegate = self;
        
        QPointAnnotation *a1 = [[QPointAnnotation alloc] init];
        a1.coordinate = CLLocationCoordinate2DMake(30.4865508426, 114.3347167969);
        a1.title      = @"幸福里项目基地";
        [_mapView addAnnotation:a1];
        [_mapView setCenterCoordinate:a1.coordinate animated:YES];
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
}
#pragma mark - Map Delegate
/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id <QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"mappin"];
        annotationView.canShowCallout               = YES;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCPinNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:PinNoteCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

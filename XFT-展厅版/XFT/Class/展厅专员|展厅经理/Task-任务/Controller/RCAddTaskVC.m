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

static NSString *const AddTaskMemberCell = @"AddTaskMemberCell";

@interface RCAddTaskVC ()<QMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (nonatomic, strong) QMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@end

@implementation RCAddTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavNar];
    [self.mapSuperView addSubview:self.mapView];
    [self setUpCollectionView];
    
    CGFloat width = (HX_SCREEN_WIDTH - 15*2 - 10*4)/5.0;
    CGFloat height = width + 30;
    //    NSInteger rowCount = (8 % 6)?(8 / 6 + 1):8 / 6;
    self.collectionViewHeight.constant = 5.f + height*2 + 10.f*(2+1) + 5.f;
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
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 5;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCAddTaskMemberCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddTaskMemberCell forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 5) {
        HXLog(@"分配专员");
        RCChooseMemberVC *mvc = [RCChooseMemberVC new];
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

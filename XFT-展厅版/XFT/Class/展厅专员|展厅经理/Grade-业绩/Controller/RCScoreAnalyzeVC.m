//
//  RCScoreAnalyzeVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCScoreAnalyzeVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import <JXCategoryIndicatorBackgroundView.h>
#import "RCScoreRankCell.h"
#import "RCScoreBarCell.h"
#import <ZLCollectionViewHorzontalLayout.h>

static NSString *const ScoreRankCell = @"ScoreRankCell";
static NSString *const ScoreBarCell = @"ScoreBarCell";

@interface RCScoreAnalyzeVC ()<JXCategoryViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *titleCategoryView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *timeCategoryView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *rankCategoryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RCScoreAnalyzeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"业绩分析"];
    [self setUpCategoryView];
    [self setUpCollectionView];
    [self setUpTableView];
    self.tableViewHeight.constant = 50.f*6;
}

-(void)setUpCategoryView
{
    _titleCategoryView.backgroundColor = [UIColor whiteColor];
    _titleCategoryView.titleLabelZoomEnabled = NO;
    _titleCategoryView.titles = @[@"认筹", @"认购", @"签约"];
    _titleCategoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _titleCategoryView.titleColor = UIColorFromRGB(0x666666);
    _titleCategoryView.titleSelectedColor = HXControlBg;
    _titleCategoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _titleCategoryView.indicators = @[lineView];
    
    _timeCategoryView.layer.cornerRadius = 4.f;
    _timeCategoryView.layer.masksToBounds = YES;
    _timeCategoryView.titles = @[@"日",@"周",@"月",@"年"];
    _timeCategoryView.titleFont = [UIFont systemFontOfSize:15];
    _timeCategoryView.cellSpacing = 0;
    _timeCategoryView.cellWidth = 280.f/4;
    _timeCategoryView.titleColor = UIColorFromRGB(0x333333);
    _timeCategoryView.titleSelectedColor = [UIColor whiteColor];
    _timeCategoryView.titleLabelMaskEnabled = YES;
    _timeCategoryView.delegate = self;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 30.f;
    backgroundView.indicatorCornerRadius = 4;
    backgroundView.indicatorWidthIncrement = 0;
    backgroundView.indicatorColor = HXControlBg;
    _timeCategoryView.indicators = @[backgroundView];
    
    _rankCategoryView.backgroundColor = [UIColor whiteColor];
    _rankCategoryView.titleLabelZoomEnabled = NO;
    _rankCategoryView.averageCellSpacingEnabled = NO;
    _rankCategoryView.titles = @[@"团队", @"小组", @"个人"];
    _rankCategoryView.titleLabelVerticalOffset = -10.f;
    _rankCategoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _rankCategoryView.titleColor = UIColorFromRGB(0x666666);
    _rankCategoryView.titleSelectedColor = HXControlBg;
    _rankCategoryView.delegate = self;
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
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCScoreRankCell class]) bundle:nil] forCellReuseIdentifier:ScoreRankCell];
}
-(void)setUpCollectionView
{
    ZLCollectionViewHorzontalLayout *flowLayout = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCScoreBarCell class]) bundle:nil] forCellWithReuseIdentifier:ScoreBarCell];
}
#pragma mark - JXCategoryViewDelegate
// 点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCScoreRankCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreRankCell forIndexPath:indexPath];
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
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCScoreBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScoreBarCell forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, collectionView.hxn_height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsZero;
}
@end

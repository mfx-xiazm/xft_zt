//
//  RCSearchCityVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchCityVC.h"
#import "HXSearchBar.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "RCSearchTagCell.h"
#import "RCSearchTagHeader.h"
#import "RCOpenArea.h"

static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";

@interface RCSearchCityVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 搜索历史 */
@property (nonatomic,strong) NSMutableArray *citys;
@end
@implementation RCSearchCityVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择城市"];
    [self setUpCollectionView];
    [self startShimmer];
    [self getAllCitysRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)citys
{
    if (_citys == nil) {
        _citys = [NSMutableArray array];
    }
    return _citys;
}
#pragma mark -- 视图相关
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = HXGlobalBg;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
}
#pragma mark -- 接口请求
/** 查询所有城市信息 */
-(void)getAllCitysRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/city/queryCityListApp" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            [strongSelf.citys removeAllObjects];
            NSArray *citys = [NSArray yy_modelArrayWithClass:[RCOpenArea class] json:responseObject[@"data"]];
            [strongSelf.citys addObjectsFromArray:citys];
    
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.collectionView reloadData];
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
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.citys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    RCOpenArea *area = self.citys[section];
    return area.list.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    
    RCOpenArea *area = self.citys[indexPath.section];
    RCOpenCity *city = area.list[indexPath.item];
    cell.contentText.text = [NSString stringWithFormat:@"%@(%@)",city.cname,city.num];
    cell.contentText.backgroundColor = [UIColor whiteColor];
    cell.contentText.textColor = [UIColor lightGrayColor];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RCOpenArea *area = self.citys[indexPath.section];
    RCOpenCity *city = area.list[indexPath.item];
    
    if (self.changeCityCall) {
        self.changeCityCall([city.cname stringByReplacingOccurrencesOfString:@"市" withString:@""]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        RCOpenArea *area = self.citys[indexPath.section];
        headerView.tabText.text = area.aname;
        headerView.locationBtn.hidden = YES;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCOpenArea *area = self.citys[indexPath.section];
    RCOpenCity *city = area.list[indexPath.item];
    return CGSizeMake([[NSString stringWithFormat:@"%@(%@)",city.cname,city.num] boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
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

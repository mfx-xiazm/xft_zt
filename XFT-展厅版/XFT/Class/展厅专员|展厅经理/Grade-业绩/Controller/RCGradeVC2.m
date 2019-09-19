//
//  RCGradeVC2.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCGradeVC2.h"
#import "RCMyClientStateCell.h"
#import "RCMyClientCell.h"
#import "ZJPickerView.h"
#import "RCClientDetailVC.h"
#import "RCGradeClientVC.h"
#import "RCMyStoreVC.h"
#import "RCClientElementVC.h"
#import "RCSearchClientVC.h"
#import "RCMyScoreVC.h"
#import "RCClientFilterView.h"
#import <zhPopupController.h>

static NSString *const MyClientCell = @"MyClientCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";
@interface RCGradeVC2 ()<UITableViewDelegate,UITableViewDataSource,RCClientFilterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

/* 团队 */
@property(nonatomic,strong) SPButton *teamBtn;

@end

@implementation RCGradeVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    });
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    SPButton *menu = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
    menu.hxn_size = CGSizeMake(200 , 44);
    menu.imageTitleSpace = 5.f;
    menu.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [menu setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    [menu setTitle:@"展厅1-全部团队-全部小组" forState:UIControlStateNormal];
    [menu setImage:HXGetImage(@"Shape") forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(teamClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.teamBtn = menu;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    SPButton *searchItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    searchItem.hxn_size = CGSizeMake(44, 44);
    [searchItem setImage:HXGetImage(@"icon_search") forState:UIControlStateNormal];
    [searchItem addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:searchItem];
    
    self.navigationItem.rightBarButtonItem = item2;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.rightTableView.estimatedRowHeight = 100;//预估高度
    self.rightTableView.rowHeight = UITableViewAutomaticDimension;
    self.rightTableView.estimatedSectionHeaderHeight = 0;
    self.rightTableView.estimatedSectionFooterHeight = 0;
    
    self.rightTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientCell class]) bundle:nil] forCellReuseIdentifier:MyClientCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.leftTableView.estimatedRowHeight = 100;//预估高度
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.leftTableView.estimatedSectionHeaderHeight = 0;
    self.leftTableView.estimatedSectionFooterHeight = 0;
    
    self.leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    
    self.leftTableView.showsVerticalScrollIndicator = NO;
    
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientStateCell class]) bundle:nil] forCellReuseIdentifier:MyClientStateCell];
}
#pragma mark -- 点击事件
-(void)teamClicked:(SPButton *)menuBtn
{
    // 1.Custom propery（自定义属性，根据需要添加想要的属性。PS：如果在多个地方使用到自定义弹框，建议把propertyDict定义为一个宏或全局变量）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyTipLabelTextKey  : @"组织切换", // @"提示内容"
                                   ZJPickerViewPropertyCanceBtnTitleColorKey :UIColorFromRGB(0x333333),
                                   ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0xFF9F08),
                                   ZJPickerViewPropertyTipLabelTextColorKey : UIColorFromRGB(0x333333),
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xCCCCCC),
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:16.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x333333), NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x888888), NSFontAttributeName : [UIFont systemFontOfSize:14.0f]},
                                   ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xCCCCCC),
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   //                                   ZJPickerViewPropertyIsShowTipLabelKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @NO,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                   //                                   ZJPickerViewPropertyIsDividedSelectContentKey: @YES, // 选择的内容是否已经用英文逗号隔开
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    //    NSMutableArray *realArr = [NSMutableArray array];
    //    for (NSDictionary *Pro in (NSArray *)district[@"result"][@"list"]) {
    //        NSArray *sub = (NSArray *)Pro[@"city"];
    //        NSMutableArray *tempArr = [NSMutableArray array];
    //        for (NSDictionary *subPro in sub) {
    //            NSMutableArray *tempArr1 = [NSMutableArray array];
    //            for (NSDictionary *trdPro in subPro[@"area"]) {
    //                [tempArr1 addObject:trdPro[@"alias"]];
    //            }
    //            [tempArr addObject:@{subPro[@"alias"]:tempArr1}];
    //        }
    //        [realArr addObject:@{Pro[@"alias"] : tempArr}];
    //    }
    
    __weak typeof(_teamBtn) weak_teamBtn = _teamBtn;
    [ZJPickerView zj_showWithDataList:@[@{@"展厅1":@[@{@"全部团队1":@[@"全部小组1",@"全部小组1",@"全部小组1"]},@{@"全部团队2":@[@"全部小组2",@"全部小组2",@"全部小组2"]},@{@"全部团队3":@[@"全部小组3",@"全部小组3",@"全部小组3"]}]},@{@"展厅2":@[@{@"全部团队1":@[@"全部小组1",@"全部小组1",@"全部小组1"]},@{@"全部团队2":@[@"全部小组2",@"全部小组2",@"全部小组2"]},@{@"全部团队3":@[@"全部小组3",@"全部小组3",@"全部小组3"]}]},@{@"展厅3":@[@{@"全部团队1":@[@"全部小组1",@"全部小组1",@"全部小组1"]},@{@"全部团队2":@[@"全部小组2",@"全部小组2",@"全部小组2"]},@{@"全部团队3":@[@"全部小组3",@"全部小组3",@"全部小组3"]}]}] propertyDict:propertyDict completion:^(NSString *selectContent) {
        // show select content
        NSArray *selectStrings = [selectContent componentsSeparatedByString:@","];
        NSMutableString *selectStringCollection = [[NSMutableString alloc] init];
        [selectStrings enumerateObjectsUsingBlock:^(NSString *selectString, NSUInteger idx, BOOL * _Nonnull stop) {
            if (selectString.length && ![selectString isEqualToString:@""]) {
                [selectStringCollection appendString:selectString];
            }
        }];
        [weak_teamBtn setTitle:selectStringCollection forState:UIControlStateNormal];
        [weak_teamBtn layoutSubviews];
    }];
}
-(void)searchClicked
{
    RCSearchClientVC *cvc = [RCSearchClientVC  new];
    cvc.dataType = 1;
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)clientFenxiClicked:(SPButton *)sender {
    RCClientElementVC *evc = [RCClientElementVC new];
    [self.navigationController pushViewController:evc animated:YES];
}

- (IBAction)followClientClicked:(SPButton *)sender {
    RCGradeClientVC *cvc = [RCGradeClientVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)myScoreClicked:(SPButton *)sender {
    RCMyScoreVC *avc = [RCMyScoreVC new];
    [self.navigationController pushViewController:avc animated:YES];
}

- (IBAction)zhongjieStoreClicked:(SPButton *)sender {
    RCMyStoreVC *svc = [RCMyStoreVC new];
    [self.navigationController pushViewController:svc animated:YES];
}
-(IBAction)filterClientClicked:(UIButton *)sender
{
    RCClientFilterView *filter = [RCClientFilterView loadXibView];
    filter.delegate = self;
    filter.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-60, self.contentView.hxn_height);
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeRight;
    self.zh_popupController.maskAlpha = 0.15;
    [self.zh_popupController presentContentView:filter duration:0.25 springAnimated:NO inView:self.contentView];
}
#pragma mark -- RCClientFilterViewDelegate
-(void)filterDidConfirm:(RCClientFilterView *)filter beginTime:(NSString *)begin endTime:(NSString *)end
{
    HXLog(@"开始时间-%@结束时间-%@",begin,end);
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RCMyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.leftTableView) {
        return 75.f;
    }else{
        return 240.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.rightTableView) {
        RCClientDetailVC *nvc = [RCClientDetailVC new];
        [self.navigationController pushViewController:nvc animated:YES];
    }
}
@end

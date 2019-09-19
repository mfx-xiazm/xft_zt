//
//  RCClientElementVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientElementVC.h"
#import "RCMyClientStateCell.h"
#import "FSActionSheet.h"
#import <PNChart.h>
#import "RCClientLegendCell.h"

static NSString *const MyClientStateCell = @"MyClientStateCell";
static NSString *const ClientLegendCell = @"ClientLegendCell";

@interface RCClientElementVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UITableView *legendTableView;
@property (nonatomic) PNPieChart *pieChart;
@end

@implementation RCClientElementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"客户分析"];
    [self setUpTableView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    });
    
    [self setUpChartView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.pieChart.frame = self.chartView.bounds;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientStateCell class]) bundle:nil] forCellReuseIdentifier:MyClientStateCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.legendTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.legendTableView.rowHeight = 0;
    self.legendTableView.estimatedSectionHeaderHeight = 0;
    self.legendTableView.estimatedSectionFooterHeight = 0;
    
    self.legendTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.legendTableView.dataSource = self;
    self.legendTableView.delegate = self;
    self.legendTableView.bounces = NO;
    self.legendTableView.showsVerticalScrollIndicator = NO;
    
    self.legendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.legendTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCClientLegendCell class]) bundle:nil] forCellReuseIdentifier:ClientLegendCell];
}
#pragma mark -- 点击事件
- (IBAction)timeClicked:(SPButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"全部",@"今日",@"本周",@"本月",@"本年"]];
    //        hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        //            hx_strongify(weakSelf);
        
    }];
}
- (IBAction)clientTypeClicked:(SPButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"全部客户",@"报备客户",@"到访客户",@"认购客户"]];
    //        hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        //            hx_strongify(weakSelf);
        
    }];
}
- (IBAction)teamClicked:(SPButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"全部团队",@"全部小组",@"全部顾问"]];
    //        hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        //            hx_strongify(weakSelf);
        
    }];
}
-(void)setUpChartView
{
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:UIColorFromRGB(0x5FC4C0)],
                       [PNPieChartDataItem dataItemWithValue:30 color:UIColorFromRGB(0x5394F7)],
                       [PNPieChartDataItem dataItemWithValue:60 color:UIColorFromRGB(0xE47A5C)],
                       ];
    self.pieChart = [[PNPieChart alloc] initWithFrame:self.chartView.bounds items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    self.pieChart.hideValues = YES;
    [self.pieChart strokeChart];
        
    [self.chartView addSubview:self.pieChart];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 7;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RCClientLegendCell *cell = [tableView dequeueReusableCellWithIdentifier:ClientLegendCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.tableView) {
        return 75.f;
    }else{
        return 40.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

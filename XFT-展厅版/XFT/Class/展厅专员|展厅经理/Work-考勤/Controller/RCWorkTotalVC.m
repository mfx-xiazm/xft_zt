//
//  RCWorkTotalVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCWorkTotalVC.h"
#import "RCWorkTotalCell.h"
#import "RCTaskDetailHeader.h"
#import "RCWorkTotalHeader.h"

static NSString *const WorkTotalCell = @"WorkTotalCell";
@interface RCWorkTotalVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 日期头视图 */
@property(nonatomic,strong) RCWorkTotalHeader *header;
@end

@implementation RCWorkTotalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"考勤统计"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 75.f);
}
-(RCWorkTotalHeader *)header
{
    if (_header == nil) {
        _header = [RCWorkTotalHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 75.f);
    }
    return _header;
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCWorkTotalCell class]) bundle:nil] forCellReuseIdentifier:WorkTotalCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RCWorkTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkTotalCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fourTitleView.hidden = NO;
        cell.threeTitleView.hidden = YES;
        return cell;
    }else{
        RCWorkTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkTotalCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fourTitleView.hidden = YES;
        cell.threeTitleView.hidden = NO;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCTaskDetailHeader *header = [RCTaskDetailHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
    header.taskTitlesView.hidden = NO;
    header.fiveTitlesView.hidden = YES;
    if (section) {
        header.fourTitlesView.hidden = YES;
        header.threeTitlesView.hidden = NO;
    }else{
        header.fourTitlesView.hidden = NO;
        header.threeTitlesView.hidden = YES;
    }
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end

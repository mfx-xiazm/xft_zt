//
//  RCTaskTotalVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskTotalVC.h"
#import "RCWorkTotalCell.h"
#import "RCTaskTotalCell.h"
#import "RCTaskTotalHeader.h"
#import "RCTaskTotalFilterHeader.h"

static NSString *const WorkTotalCell = @"WorkTotalCell";
static NSString *const TaskTotalCell = @"TaskTotalCell";

@interface RCTaskTotalVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCTaskTotalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"任务统计"];
    [self setUpTableView];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskTotalCell class]) bundle:nil] forCellReuseIdentifier:TaskTotalCell];
    
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
        RCTaskTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskTotalCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RCWorkTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkTotalCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fourTitleView.hidden = NO;
        cell.threeTitleView.hidden = YES;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section?44.f:50.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section?40.f:100.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        RCTaskTotalHeader *header = [RCTaskTotalHeader loadXibView];
        header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
        return header;
    }else{
        RCTaskTotalFilterHeader *header = [RCTaskTotalFilterHeader loadXibView];
        header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);

        return header;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

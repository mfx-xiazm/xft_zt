//
//  RCTaskDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskDetailVC.h"
#import "RCHouseDetailInfoCell.h"
#import "RCTaskDetailHeader.h"
#import "RCTaskDetailCell.h"
#import "RCPinDetailVC.h"

static NSString *const HouseDetailInfoCell = @"HouseDetailInfoCell";
static NSString *const TaskDetailCell = @"TaskDetailCell";

@interface RCTaskDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"任务详情"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(finishTaskClicked) title:@"终止任务" font:[UIFont systemFontOfSize:16] titleColor:UIColorFromRGB(0xEC142D) highlightedColor:UIColorFromRGB(0xEC142D) titleEdgeInsets:UIEdgeInsetsZero];

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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:HouseDetailInfoCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskDetailCell class]) bundle:nil] forCellReuseIdentifier:TaskDetailCell];
    
}
#pragma mark -- 点击事件
-(void)finishTaskClicked
{
    HXLog(@"终止任务");
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RCHouseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailInfoCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RCTaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskDetailCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section?44.f:UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section?80.f:44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section?0.1f:10.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCTaskDetailHeader *header = [RCTaskDetailHeader loadXibView];
    header.hxn_size = section?CGSizeMake(HX_SCREEN_WIDTH, 44.f):CGSizeMake(HX_SCREEN_WIDTH, 80.f);
    header.taskTitlesView.hidden = !section;
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        RCPinDetailVC *dvc = [RCPinDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}


@end

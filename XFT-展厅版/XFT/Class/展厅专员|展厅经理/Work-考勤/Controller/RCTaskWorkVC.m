//
//  RCTaskWorkVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskWorkVC.h"
#import "RCTaskWorkCell.h"
#import "RCTaskDetailVC.h"
#import "RCTaskTotalVC.h"
#import "RCWorkTotalVC.h"

static NSString *const TaskWorkCell = @"TaskWorkCell";

@interface RCTaskWorkVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCTaskWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HXGlobalBg;
    [self.navigationItem setTitle:@"任务考勤"];
    
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskWorkCell class]) bundle:nil] forCellReuseIdentifier:TaskWorkCell];
}
#pragma mark -- 点击事件
- (IBAction)taskTotalClicked:(UIButton *)sender {
    RCTaskTotalVC *tvc = [RCTaskTotalVC new];
    [self.navigationController pushViewController:tvc animated:YES];
}
- (IBAction)workTotalClicked:(UIButton *)sender {
    RCWorkTotalVC *tvc = [RCWorkTotalVC new];
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCTaskWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskWorkCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCTaskDetailVC *dvc = [RCTaskDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}
@end

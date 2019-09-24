//
//  RCTaskWorkVC1.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskWorkVC1.h"
#import "RCTaskWorkCell1.h"
#import "RCTaskWorkIngCell1.h"
#import "RCBeesWorkVC.h"
#import "RCPinNoteVC.h"
#import "RCTaskPinVC.h"
#import "RCTaskReportVC.h"
#import "RCTaskDetailVC1.h"

static NSString *const TaskWorkCell1 = @"TaskWorkCell1";
static NSString *const TaskWorkIngCell1 = @"TaskWorkIngCell1";

@interface RCTaskWorkVC1 ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCTaskWorkVC1

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskWorkCell1 class]) bundle:nil] forCellReuseIdentifier:TaskWorkCell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCTaskWorkIngCell1 class]) bundle:nil] forCellReuseIdentifier:TaskWorkIngCell1];
}
#pragma mark -- 点击事件
- (IBAction)beesUpClicked:(UIButton *)sender {
    RCBeesWorkVC *wvc = [RCBeesWorkVC new];
    [self.navigationController pushViewController:wvc animated:YES];
}
- (IBAction)myWorkClicked:(UIButton *)sender {
    RCPinNoteVC *nvc = [RCPinNoteVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row %2) {
        RCTaskWorkIngCell1 *cell = [tableView dequeueReusableCellWithIdentifier:TaskWorkIngCell1 forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        hx_weakify(self);
        cell.taskWorkCall = ^(NSInteger index) {
            if (index == 1) {
                RCTaskPinVC *pvc = [RCTaskPinVC new];
                [weakSelf.navigationController pushViewController:pvc animated:YES];
            }else{
                RCTaskReportVC *rvc = [RCTaskReportVC new];
                [weakSelf.navigationController pushViewController:rvc animated:YES];
            }
        };
        return cell;
    }else{
        RCTaskWorkCell1 *cell = [tableView dequeueReusableCellWithIdentifier:TaskWorkCell1 forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %2) {
        return 195.f;
    }else{
        return 155.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCTaskDetailVC1 *dvc = [RCTaskDetailVC1 new];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end

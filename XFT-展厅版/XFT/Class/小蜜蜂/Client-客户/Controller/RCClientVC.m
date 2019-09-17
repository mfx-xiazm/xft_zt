//
//  RCClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientVC.h"
#import "RCClientCell.h"
#import "FSActionSheet.h"

static NSString *const ClientCell = @"ClientCell";
@interface RCClientVC ()<UITableViewDelegate,UITableViewDataSource,FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateImg;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UIImageView *projectImg;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
/** 选择的哪一个分类 */
@property (nonatomic,strong) UIButton *selectBtn;
/** 日期 */
@property (nonatomic,strong) NSArray *dates;
/** 项目 */
@property (nonatomic,strong) NSArray *projects;
/** 状态 */
@property (nonatomic,strong) NSArray *states;
@end

@implementation RCClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"客户"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 视图相关
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
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCClientCell class]) bundle:nil] forCellReuseIdentifier:ClientCell];
}
#pragma mark -- 点击事件
- (IBAction)filterClicked:(UIButton *)sender {
    self.selectBtn = sender;
    if (sender.tag == 1) {
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"日期" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"全部",@"今日",@"本周",@"本月",@"本年"]];
        //        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            //            hx_strongify(weakSelf);
            
        }];
    }else if (sender.tag == 2){
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"项目" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"项目1",@"项目2",@"项目3",@"项目4"]];
        //        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            //            hx_strongify(weakSelf);
            
        }];
    }else{
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"报备状态" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"专员报备失败",@"待专员报备",@"专员报备成功"]];
        //        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            //            hx_strongify(weakSelf);
            
        }];
    }

}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCClientCell *cell = [tableView dequeueReusableCellWithIdentifier:ClientCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

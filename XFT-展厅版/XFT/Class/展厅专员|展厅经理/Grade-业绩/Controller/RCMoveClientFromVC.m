//
//  RCMoveClientFromVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMoveClientFromVC.h"
#import "RCMoveClientFromCell.h"
#import "HXSearchBar.h"
#import "FSActionSheet.h"
#import "RCMoveClientToVC.h"

static NSString *const MoveClientFromCell = @"MoveClientFromCell";

@interface RCMoveClientFromVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *search;
@end

@implementation RCMoveClientFromVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择要转出的专员客户"];
    [self.searchView addSubview:self.search];
    [self setUpTableView];
}
-(HXSearchBar *)search
{
    if (_search == nil) {
        _search = [HXSearchBar searchBar];
        _search.backgroundColor = [UIColor whiteColor];
        _search.hxn_width = HX_SCREEN_WIDTH - 30.f;
        _search.hxn_height = 32;
        _search.hxn_x = 15;
        _search.hxn_centerY = self.searchView.hxn_height/2.0;
        _search.layer.cornerRadius = 32/2.f;
        _search.layer.masksToBounds = YES;
        _search.delegate = self;
    }
    return _search;
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMoveClientFromCell class]) bundle:nil] forCellReuseIdentifier:MoveClientFromCell];
}
#pragma mark -- 点击事件

- (IBAction)clientTypeClicked:(SPButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"全部客户",@"失效客户"]];
    //        hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        //            hx_strongify(weakSelf);
        
    }];
}
- (IBAction)moveCliked:(UIButton *)sender {
    RCMoveClientToVC *tvc = [RCMoveClientToVC new];
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMoveClientFromCell *cell = [tableView dequeueReusableCellWithIdentifier:MoveClientFromCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 125.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

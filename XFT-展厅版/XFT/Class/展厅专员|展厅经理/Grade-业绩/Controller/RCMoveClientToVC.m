//
//  RCMoveClientToVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMoveClientToVC.h"
#import "RCChooseMemberHeader.h"
#import "RCChooseMemberCell.h"
#import "HXSearchBar.h"

static NSString *const ChooseMemberCell = @"ChooseMemberCell";

@interface RCMoveClientToVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeight;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *search;
@end

@implementation RCMoveClientToVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"分配到某某"];
    
    if (!self.isHiddenSearch) {
        HXSearchBar *search = [HXSearchBar searchBar];
        search.backgroundColor = [UIColor whiteColor];
        search.hxn_width = HX_SCREEN_WIDTH - 30.f;
        search.hxn_height = 32;
        search.hxn_x = 15;
        search.hxn_centerY = self.searchView.hxn_height/2.0;
        search.layer.cornerRadius = 32/2.f;
        search.layer.masksToBounds = YES;
        search.delegate = self;
        self.search = search;
        [self.searchView addSubview:search];
    }else{
        self.searchViewHeight.constant = 0.f;
        self.searchView.hidden = YES;
    }
    
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.search) {
        self.search.hxn_width = HX_SCREEN_WIDTH - 30.f;
        self.search.hxn_height = 32;
        self.search.hxn_x = 15;
        self.search.hxn_centerY = self.searchView.hxn_height/2.0;
    }
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCChooseMemberCell class]) bundle:nil] forCellReuseIdentifier:ChooseMemberCell];
}
#pragma mark -- 点击事件

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
    RCChooseMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseMemberCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCChooseMemberHeader *header = [RCChooseMemberHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 66.f);
    
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

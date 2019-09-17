//
//  RCProfileVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileVC.h"
#import "RCProfileHeader.h"
#import "RCProfileFooter.h"
#import "RCProfileCell.h"
#import "RCNavBarView.h"
#import "RCChangePwdVC.h"
#import "RCProfileInfoVC.h"
#import "RCMyOrganizationVC.h"
#import "RCPinNoteVC.h"
#import "RCRecordVC.h"

static NSString *const ProfileCell = @"ProfileCell";

@interface RCProfileVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 导航栏 */
@property(nonatomic,strong) RCNavBarView *navBarView;
/* 头视图 */
@property(nonatomic,strong) RCProfileHeader *header;
/* 尾视图 */
@property(nonatomic,strong) RCProfileFooter *footer;
/* titles */
@property(nonatomic,strong) NSArray *titles;

@end

@implementation RCProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    [self setUpTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, self.HXNavBarHeight + 100.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
}
-(RCNavBarView *)navBarView
{
    if (_navBarView == nil) {
        _navBarView = [RCNavBarView loadXibView];
        _navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
        _navBarView.backBtn.hidden = YES;
        _navBarView.titleL.text = @"我的";
        _navBarView.titleL.textAlignment = NSTextAlignmentCenter;
        _navBarView.titleL.hidden = NO;
        _navBarView.moreBtn.hidden = NO;
        [_navBarView.moreBtn setImage:HXGetImage(@"icon_daka") forState:UIControlStateNormal];
        hx_weakify(self);
        _navBarView.navMoreCall = ^{
            RCRecordVC *rvc = [RCRecordVC new];
            [weakSelf.navigationController pushViewController:rvc animated:YES];
        };
    }
    return _navBarView;
}

-(RCProfileHeader *)header
{
    if (_header == nil) {
        _header = [RCProfileHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight + 100.f);
        _header.topNavBar.constant = self.HXNavBarHeight;
        hx_weakify(self);
        _header.infoClicked = ^{
            hx_strongify(weakSelf);
            RCProfileInfoVC *ivc = [RCProfileInfoVC new];
            [strongSelf.navigationController pushViewController:ivc animated:YES];
        };
    }
    return _header;
}

-(RCProfileFooter *)footer
{
    if (_footer == nil) {
        _footer = [RCProfileFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 100.f);
    }
    return _footer;
}
-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[@[@"我的组织"],@[@"我的考勤"],@[@"修改密码"],@[@"版本更新"]];
    }
    return _titles;
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
    
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = HXGlobalBg;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCProfileCell class]) bundle:nil] forCellReuseIdentifier:ProfileCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 业务逻辑
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //该页面呈现时手动调用计算导航栏此时应当显示的颜色
    [self.navBarView changeColor:[UIColor whiteColor] offsetHeight:180-self.HXNavBarHeight withOffsetY:scrollView.contentOffset.y];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.titles[section]).count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.hxn_width = HX_SCREEN_WIDTH;
    view.hxn_height = 10.f;
    view.backgroundColor = HXGlobalBg;
    
    return section?view:nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = self.titles[indexPath.section][indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RCMyOrganizationVC *ovc = [RCMyOrganizationVC new];
        [self.navigationController pushViewController:ovc animated:YES];
    }else if (indexPath.section == 1) {
        RCPinNoteVC *nvc = [RCPinNoteVC new];
        [self.navigationController pushViewController:nvc animated:YES];
    }else if (indexPath.section == 2) {
        RCChangePwdVC *pwd = [RCChangePwdVC new];
        [self.navigationController pushViewController:pwd animated:YES];
    }else{
        HXLog(@"版本更新");
    }
}

@end

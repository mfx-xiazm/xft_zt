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
#import "RCMoveClientVC.h"
#import "RCTaskMember.h"
#import "RCMoveClient.h"

static NSString *const MoveClientFromCell = @"MoveClientFromCell";

@interface RCMoveClientFromVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *moveName;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *search;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 客户列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 客户类型 */
@property(nonatomic,copy) NSString *type;
@end

@implementation RCMoveClientFromVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择要转出的专员客户"];
    [self.searchView addSubview:self.search];
    self.moveName.text = [NSString stringWithFormat:@"已选专员:%@",self.selectMoveAgent.name];
    self.type = @"";
    [self setUpTableView];
    [self setUpRefresh];
    [self getClientListDataRequest:YES];
}
-(HXSearchBar *)search
{
    if (_search == nil) {
        _search = [HXSearchBar searchBar];
        _search.backgroundColor = [UIColor whiteColor];
        _search.hxn_width = HX_SCREEN_WIDTH - 30.f;
        _search.hxn_height = 40;
        _search.hxn_x = 15;
        _search.hxn_centerY = self.searchView.hxn_height/2.0;
        _search.layer.cornerRadius = 40/2.f;
        _search.layer.masksToBounds = YES;
        _search.delegate = self;
        _search.placeholder = @"输入客户姓名检索";
    }
    return _search;
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.search) {
        self.search.hxn_width = HX_SCREEN_WIDTH - 30.f;
        self.search.hxn_height = 40;
        self.search.hxn_x = 15;
        self.search.hxn_centerY = self.searchView.hxn_height/2.0;
    }
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
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getClientListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientListDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
/** 客户筛选列表 */
-(void)getClientListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"name"] = [self.search hasText]?self.search.text:@"";
    data[@"showRoomuuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;
    data[@"uuid"] = self.selectMoveAgent.uuid;
    data[@"type"] = self.type;//类型 1.报备有效客户 2.到访有效客户 全部客户不用传
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/showroomVersionManager/showroomBaobeiCustomerList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                strongSelf.selectBtn.selected = NO;
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMoveClient class] json:responseObject[@"data"][@"records"]];
                [strongSelf.clients addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    strongSelf.selectBtn.selected = NO;
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMoveClient class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.clients addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)checkSelectAll
{
    BOOL isSelectAll = YES;
    for (RCMoveClient *client in self.clients) {
        if (!client.isSelected) {
            isSelectAll = NO;
            break;
        }
    }
    self.selectBtn.selected = isSelectAll;
}
#pragma mark -- 点击事件

- (IBAction)clientTypeClicked:(SPButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"全部客户",@"报备有效客户",@"到访有效客户"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [sender setTitle:@"全部客户" forState:UIControlStateNormal];
            strongSelf.type = @"";
        }else if (selectedIndex == 1) {
            [sender setTitle:@"报备有效客户" forState:UIControlStateNormal];
            strongSelf.type = @"1";
        }else{
            [sender setTitle:@"到访有效客户" forState:UIControlStateNormal];
            strongSelf.type = @"2";
        }
        [strongSelf getClientListDataRequest:YES];
    }];
}
- (IBAction)moveCliked:(UIButton *)sender {
    BOOL isHaveChecked = NO;
    for (RCMoveClient *client in self.clients) {
        if (client.isSelected) {
            isHaveChecked = YES;
            break;
        }
    }
    if (!isHaveChecked) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"选择要转移的客户"];
        return;
    }
    
    NSMutableArray *selectClients = [NSMutableArray array];
    for (RCMoveClient *client in self.clients) {
        if (client.isSelected) {
            [selectClients addObject:client];
        }
    }
    RCMoveClientVC *tvc = [RCMoveClientVC new];
    tvc.selectMoveAgent = self.selectMoveAgent;
    tvc.selectMoveAgentTeam = self.selectMoveAgentTeam;
    tvc.clients = selectClients;
    [self.navigationController pushViewController:tvc animated:YES];
}
- (IBAction)selectAllClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    for (RCMoveClient *client in self.clients) {
        client.isSelected = sender.isSelected;
    }
    [self.tableView reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getClientListDataRequest:YES];
    return YES;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clients.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMoveClientFromCell *cell = [tableView dequeueReusableCellWithIdentifier:MoveClientFromCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.zyName.text = [NSString stringWithFormat:@"展厅专员:%@(%@-%@)",self.selectMoveAgent.name,self.selectMoveAgentTeam.teamName,self.selectMoveAgentTeam.groupName];
    RCMoveClient *client = self.clients[indexPath.row];
    cell.client = client;
    hx_weakify(self);
    cell.targetSelectCall = ^{
        hx_strongify(weakSelf);
        client.isSelected = !client.isSelected;
        [strongSelf checkSelectAll];
        [tableView reloadData];
    };
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

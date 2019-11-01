//
//  RCGradeClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCGradeClientVC.h"
#import "RCMyClientCell.h"
#import "RCClientDetailVC.h"
#import "RCMyClient.h"

static NSString *const MyClientCell = @"MyClientCell";

@interface RCGradeClientVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIView *clientFilterView;
@property (weak, nonatomic) IBOutlet SPButton *firstFilterBtn;
@property (weak, nonatomic) IBOutlet SPButton *secondFilterBtn;
/* 选中的那个排序按钮 */
@property(nonatomic,strong) SPButton *selectFilterBtn;
/* 是否向上排序 0向下排序 1向上排序*/
@property(nonatomic,copy) NSString *sankType;
/* 筛选状态值 */
@property(nonatomic,copy) NSString *sankValue;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 客户列表 */
@property(nonatomic,strong) NSMutableArray *clients;
@end

@implementation RCGradeClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.navTitle];
    self.clientFilterView.hidden = [MSUserManager sharedInstance].curUserInfo.ulevel == 2?YES:NO;
    self.followView.hidden = [MSUserManager sharedInstance].curUserInfo.ulevel == 2?NO:YES;
    [self setFilterTitleWithCustype];
    [self setUpTableView];
    [self setUpRefresh];
    [self getClientDataRequest:YES];
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
#pragma mark -- 视图UI
-(void)setFilterTitleWithCustype
{
    switch (self.cusType) {
        case 0:{
            [self.firstFilterBtn setTitle:@"最后备注" forState:UIControlStateNormal];
        }
            break;
        case 1:{
            [self.firstFilterBtn setTitle:@"最近到访" forState:UIControlStateNormal];
        }
            break;
        case 2:{
            [self.firstFilterBtn setTitle:@"认筹时间" forState:UIControlStateNormal];
        }
            break;
        case 3:{
            [self.firstFilterBtn setTitle:@"认购时间" forState:UIControlStateNormal];
        }
            break;
        case 4:{
            [self.firstFilterBtn setTitle:@"签约时间" forState:UIControlStateNormal];
        }
            break;
        case 5:{
            [self.firstFilterBtn setTitle:@"退房时间" forState:UIControlStateNormal];
        }
            break;
        case 6:{
            [self.firstFilterBtn setTitle:@"失效时间" forState:UIControlStateNormal];
        }
            break;
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
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientCell class]) bundle:nil] forCellReuseIdentifier:MyClientCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getClientDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientDataRequest:NO];
    }];
}
#pragma mark -- 点击事件
- (IBAction)firstFilterBtn:(SPButton *)sender {
    if (self.selectFilterBtn != sender) {//如果前面选中的不是这个排序，就重置排序条件
        self.sankType = nil;
    }
    self.selectFilterBtn = sender;// 记录选中的按钮
    // 重置第二个排序
    [self.secondFilterBtn setImage:HXGetImage(@"icon_qiehuan_moren") forState:UIControlStateNormal];
    /* 是否向上排序 0向下排序 1向上排序*/
    if ([self.sankType isEqualToString:@"0"]) {//降序
        self.sankType = @"1";
        [self.firstFilterBtn setImage:HXGetImage(@"icon_qiehuan_up") forState:UIControlStateNormal];
    }else{//升序
        self.sankType = @"0";
        [self.firstFilterBtn setImage:HXGetImage(@"icon_qiehuan_down") forState:UIControlStateNormal];
    }
    /* 用户状态 0报备 1到访 2认筹 3认购 4签约 5退房 6失效 */
    if (self.cusType == 0) {
        self.sankValue = @"remarkTime";//最近报备
    }else if (self.cusType == 1) {
        self.sankValue = @"lastVistTime";//最近到访
    }else if (self.cusType == 2) {
        self.sankValue = @"tradeTime";//认筹时间
    }else if (self.cusType == 3) {
        self.sankValue = @"tradeTime";//认购时间
    }else if (self.cusType == 4) {
        self.sankValue = @"tradeTime";//签约时间
    }else if (self.cusType == 5) {
        self.sankValue = @"tradeTime";//退房时间
    }else{
        self.sankValue = @"invalidTime";//失效时间
    }
    [self getClientDataRequest:YES];
}
- (IBAction)secondFilterBtn:(SPButton *)sender {
    if (self.selectFilterBtn != sender) {//如果前面选中的不是这个排序，就重置排序条件
        self.sankType = nil;
    }
    
    self.selectFilterBtn = sender;// 记录选中的按钮
    // 重置第一个排序
    [self.firstFilterBtn setImage:HXGetImage(@"icon_qiehuan_moren") forState:UIControlStateNormal];
    /* 是否向上排序 0向下排序 1向上排序*/
    if ([self.sankType isEqualToString:@"0"]) {//降序
        self.sankType = @"1";
        [self.secondFilterBtn setImage:HXGetImage(@"icon_qiehuan_up") forState:UIControlStateNormal];
    }else{//升序
        self.sankType = @"0";
        [self.secondFilterBtn setImage:HXGetImage(@"icon_qiehuan_down") forState:UIControlStateNormal];
    }
    self.sankValue = @"baobeiTime";
    
    [self getClientDataRequest:YES];
}

#pragma mark -- 接口请求
-(void)getClientDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.selectFilterBtn) {
        if (self.sankType) {
            if ([self.sankType isEqualToString:@"1"]) {//升序
                data[@"searchFlag"] = self.sankValue;
                data[@"sortFlag"] = @"asc";
            }else{//降序
                data[@"searchFlag"] = self.sankValue;
                data[@"sortFlag"] = @"desc";
            }
        }
    }else{
        data[@"searchFlag"] = @"";
        data[@"sortFlag"] = @"";
    }
    data[@"isManager"] = ([MSUserManager sharedInstance].curUserInfo.ulevel==1)?@(1):@(0);
    data[@"isZy"] = ([MSUserManager sharedInstance].curUserInfo.ulevel==2)?@(1):@(0);
    data[@"cusLevel"] = @"";//客户等级.
    data[@"proUuid"] = @"";//项目id
    data[@"baobeiStartTime"] = @"";//报备开始时间.
    data[@"baobeiEndTime"] = @"";//报备结束时间.
    data[@"visitStartTime"] = @"";//最后到访开始时间
    data[@"visitEndTime"] = @"";//最后到访结束时间
    data[@"tradeEndTime"] = @"";//认筹、认购、签约、退房时间
    data[@"tradeStartTime"] = @"";//认筹、认购、签约、退房时间
    data[@"invalidEndTime"] = @"";//失效结束时间
    data[@"invalidStartTime"] = @"";//失效开始时间
    data[@"showroomUuid"] = self.showroomUuid;//
    data[@"teamUuid"] = self.teamUuid;//
    data[@"groupUuid"] = self.groupUuid;//
    data[@"zyAccUuid"] = self.zyUuid;//
    
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
    
    NSString *actionPath = nil;
    switch (self.cusType) {
        case 0:{
            actionPath = @"showroom/showroom/showroom/searchPageCusBaobei";
        }
            break;
        case 1:{
            actionPath = @"showroom/showroom/showroom/searchPageCusVisit";
        }
            break;
        case 2:{
            actionPath = @"showroom/showroom/showroom/searchPageCusRecognition";
        }
            break;
        case 3:{
            actionPath = @"showroom/showroom/showroom/searchPageCusSubscribe";
        }
            break;
        case 4:{
            actionPath = @"showroom/showroom/showroom/searchPageCusSign";
        }
            break;
        case 5:{
            actionPath = @"showroom/showroom/showroom/searchPageCusAbolish";
        }
            break;
        case 6:{
            actionPath = @"showroom/showroom/showroom/searchPageCusInvalid";
        }
            break;
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:actionPath parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"]];
                [strongSelf.clients addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"]];
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
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clients.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cusType = self.cusType;
    RCMyClient *client = self.clients[indexPath.row];
    cell.client = client;
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {//经理
        cell.handleToolView.hidden = YES;
        cell.handleToolViewHeight.constant = 0.f;
    }else{
        cell.handleToolView.hidden = NO;
        cell.handleToolViewHeight.constant = 40.f;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {//经理
        return 200.f;
    }else{
        return 240.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCClientDetailVC *dvc = [RCClientDetailVC new];
    RCMyClient *client = self.clients[indexPath.row];
    dvc.cusType = self.cusType;
    if (self.cusType == 0) {// 如果是报备客户传报备uuid
        dvc.cusUuid = client.uuid;
    }else{// 如果不是报备客户
        if (self.cusType == 6) {// 失效客户传报备uuid
            dvc.cusUuid = client.uuid;
        }else{//其他状态 传cusUuid
            dvc.cusUuid = client.cusUuid;
        }
    }
    dvc.updateReamrkCall = ^(NSString * _Nonnull remarkTime, NSString * _Nonnull remark) {
        client.remarkTime = remarkTime;
        client.remark = remark;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:dvc animated:YES];
}


@end

//
//  RCGradeVC2.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCGradeVC2.h"
#import "RCMyClientStateCell.h"
#import "RCMyClientCell.h"
#import "ZJPickerView.h"
#import "RCClientDetailVC.h"
#import "RCGradeClientVC.h"
#import "RCMyStoreVC.h"
#import "RCClientElementVC.h"
#import "RCSearchClientVC.h"
#import "RCMyScoreVC.h"
#import "RCClientFilterView.h"
#import <zhPopupController.h>
#import "RCMaganerGrade.h"
#import "RCMyClient.h"
#import "zhAlertView.h"
#import "RCShowRoomFilter.h"
#import "RCShowRoomProject.h"
#import "RCGoHouseVC.h"

static NSString *const MyClientCell = @"MyClientCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";
@interface RCGradeVC2 ()<UITableViewDelegate,UITableViewDataSource,RCClientFilterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet SPButton *firstFilterBtn;
@property (weak, nonatomic) IBOutlet SPButton *secondFilterBtn;
/* 选中的那个排序按钮 */
@property(nonatomic,strong) SPButton *selectFilterBtn;
/* 是否向上排序 0向下排序 1向上排序*/
@property(nonatomic,copy) NSString *sankType;
/* 筛选状态值 */
@property(nonatomic,copy) NSString *sankValue;
/* 团队信息 */
@property(nonatomic,strong) NSArray *groups;
/* 左边分组选中的索引 */
@property(nonatomic,assign) NSInteger selectIndex;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 客户列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 筛选数据模型 */
@property(nonatomic,strong) RCShowRoomFilter *filterModel;
@end

@implementation RCGradeVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    
    self.selectIndex = 0;

    [self getClientStateRuquest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    UIView *btnBg = [UIView new];
    btnBg.hxn_size = CGSizeMake(300, 44);
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    label.textColor = [UIColor blackColor];
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.groupName && [MSUserManager sharedInstance].curUserInfo.selectRole.groupName.length) {
        [label setText:[NSString stringWithFormat:@"%@-%@-%@",[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName,[MSUserManager sharedInstance].curUserInfo.selectRole.teamName,[MSUserManager sharedInstance].curUserInfo.selectRole.groupName]];
    }else if ([MSUserManager sharedInstance].curUserInfo.selectRole.teamName && [MSUserManager sharedInstance].curUserInfo.selectRole.teamName.length) {
        [label setText:[NSString stringWithFormat:@"%@-%@",[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName,[MSUserManager sharedInstance].curUserInfo.selectRole.teamName]];
    }else{
        [label setText:[NSString stringWithFormat:@"%@",[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName]];
    }
    CGSize size = [label sizeThatFits:CGSizeZero];
    if (size.width >= 300) {
        label.hxn_size = CGSizeMake(300, size.height);
    }else{
        label.hxn_size = size;
    }
    label.hxn_x = 0;
    label.hxn_centerY = 22.0;
    [btnBg addSubview:label];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBg];
    
    SPButton *searchItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    searchItem.hxn_size = CGSizeMake(44, 44);
    [searchItem setImage:HXGetImage(@"icon_search") forState:UIControlStateNormal];
    [searchItem addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:searchItem];
    
    self.navigationItem.rightBarButtonItem = item2;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.rightTableView.estimatedRowHeight = 100;//预估高度
    self.rightTableView.rowHeight = UITableViewAutomaticDimension;
    self.rightTableView.estimatedSectionHeaderHeight = 0;
    self.rightTableView.estimatedSectionFooterHeight = 0;
    
    self.rightTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientCell class]) bundle:nil] forCellReuseIdentifier:MyClientCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.leftTableView.estimatedRowHeight = 100;//预估高度
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.leftTableView.estimatedSectionHeaderHeight = 0;
    self.leftTableView.estimatedSectionFooterHeight = 0;
    
    self.leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    
    self.leftTableView.showsVerticalScrollIndicator = NO;
    
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientStateCell class]) bundle:nil] forCellReuseIdentifier:MyClientStateCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.rightTableView.mj_header.automaticallyChangeAlpha = YES;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView.mj_footer resetNoMoreData];
        [strongSelf getClientStateRuquest];
    }];
    //追加尾部刷新
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientDataRequest:NO completeCall:^{
            [strongSelf.rightTableView reloadData];
        }];
    }];
}
#pragma mark -- 点击事件
-(void)teamClicked:(SPButton *)menuBtn
{

}
-(void)searchClicked
{
    RCSearchClientVC *cvc = [RCSearchClientVC  new];
    cvc.dataType = 1;
    cvc.accUuid = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//经纪人uuid
    cvc.showroomUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
    cvc.groupUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
    cvc.teamUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)clientFenxiClicked:(SPButton *)sender {
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"功能开发中，敬请期待…"];
//    RCClientElementVC *evc = [RCClientElementVC new];
//    [self.navigationController pushViewController:evc animated:YES];
}

- (IBAction)followClientClicked:(SPButton *)sender {
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"功能开发中，敬请期待…"];
//    RCGradeClientVC *cvc = [RCGradeClientVC new];
//    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)myScoreClicked:(SPButton *)sender {
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"功能开发中，敬请期待…"];
//    RCMyScoreVC *avc = [RCMyScoreVC new];
//    [self.navigationController pushViewController:avc animated:YES];
}

- (IBAction)zhongjieStoreClicked:(SPButton *)sender {
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"功能开发中，敬请期待…"];
//    RCMyStoreVC *svc = [RCMyStoreVC new];
//    [self.navigationController pushViewController:svc animated:YES];
}
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
    if (self.selectIndex == 0) {
        //self.sankValue = @"remarkTime";//最近备注
        self.sankValue = @"baobeiTime";
    }else if (self.selectIndex == 1) {
        self.sankValue = @"lastVistTime";//最近到访
    }else if (self.selectIndex == 2) {
        self.sankValue = @"tradeTime";//认筹时间
    }else if (self.selectIndex == 3) {
        self.sankValue = @"tradeTime";//认购时间
    }else if (self.selectIndex == 4) {
        self.sankValue = @"tradeTime";//签约时间
    }else if (self.selectIndex == 5) {
        self.sankValue = @"tradeTime";//退房时间
    }else{
        self.sankValue = @"invalidTime";//失效时间
    }
    hx_weakify(self);
    [self getClientDataRequest:YES completeCall:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView reloadData];
    }];
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
    
    hx_weakify(self);
    [self getClientDataRequest:YES completeCall:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView reloadData];
    }];
}
-(IBAction)filterClientClicked:(UIButton *)sender
{
    RCClientFilterView *filter = [RCClientFilterView loadXibView];
    filter.cusType = self.selectIndex;
    filter.filterModel = self.filterModel;
    
    filter.delegate = self;
    filter.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-60, self.contentView.hxn_height);
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeRight;
    self.zh_popupController.maskAlpha = 0.15;
    [self.zh_popupController presentContentView:filter duration:0.25 springAnimated:NO inView:self.contentView];
}
#pragma mark -- 接口请求
-(void)getClientStateRuquest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;// 展厅id
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroom/getProByShowroomUuid" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (!strongSelf.filterModel) {
                    NSArray *projects = [NSArray yy_modelArrayWithClass:[RCShowRoomProject class] json:responseObject[@"data"]];
                    strongSelf.filterModel = [[RCShowRoomFilter alloc] init];
                    strongSelf.filterModel.projects = projects;
                }
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//经纪人uuid
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
        data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
        data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
        data[@"baobeiEndTime"] = @"";
        data[@"baobeiStartTime"] = @"";
        data[@"invalidEndTime"] = @"";
        data[@"invalidStartTime"] = @"";
        data[@"proUuid"] = @"";
        data[@"tradeEndTime"] = @"";
        data[@"tradeStartTime"] = @"";
        data[@"visitEndTime"] = @"";
        data[@"visitStartTime"] = @"";
        data[@"invalidEndTime"] = @"";//失效结束时间
        data[@"invalidStartTime"] = @"";//失效开始时间
        data[@"timeFlag"] = @"";//时间筛选条件 week month year 传空表示全部
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroom/searchCusBaobeiNumsNew" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.groups = [NSArray yy_modelArrayWithClass:[RCMaganerGrade class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getClientDataRequest:YES completeCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序10
        hx_strongify(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.leftTableView.hidden = NO;
            strongSelf.rightTableView.hidden = NO;
            [strongSelf.leftTableView reloadData];
            [strongSelf.rightTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            });
        });
    });
}
-(void)getClientDataRequest:(BOOL)isRefresh completeCall:(void(^)(void))completeCall
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
    data[@"cusLevel"] = (self.filterModel.cusLevel && self.filterModel.cusLevel.length)?self.filterModel.cusLevel:@"";//客户等级
    data[@"proUuid"] = (self.filterModel.selectPro && self.filterModel.selectPro.uuid.length)?self.filterModel.selectPro.uuid:@"";//项目id
    data[@"baobeiStartTime"] = (self.filterModel.reportStart==0)?@"":@(self.filterModel.reportStart);//报备开始时间
    data[@"baobeiEndTime"] = (self.filterModel.reportEnd==0)?@"":@(self.filterModel.reportEnd);;//报备结束时间
    data[@"visitStartTime"] = (self.filterModel.visitStart==0)?@"":@(self.filterModel.visitStart);//最后到访开始时间
    data[@"visitEndTime"] = (self.filterModel.visitEnd==0)?@"":@(self.filterModel.visitEnd);;//最后到访结束时间
    data[@"tradeEndTime"] = @"";//认筹、认购、签约、退房时间
    data[@"tradeStartTime"] = @"";//认筹、认购、签约、退房时间
    data[@"invalidEndTime"] = @"";//失效结束时间
    data[@"invalidStartTime"] = @"";//失效开始时间
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//
    data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//
    data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//
    data[@"zyAccUuid"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//
    
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
    switch (self.selectIndex) {
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
                [strongSelf.rightTableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"]];
                [strongSelf.clients addObjectsFromArray:arrt];
            }else{
                [strongSelf.rightTableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"]];
                    [strongSelf.clients addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.rightTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (completeCall) {
            completeCall();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completeCall) {
            completeCall();
        }
    }];
}
#pragma mark -- RCClientFilterViewDelegate
-(void)filterDidConfirm:(RCClientFilterView *)filter cusLevel:(NSString *)level selectProId:(NSString *)proId reportBeginTime:(NSInteger)reportBegin reportEndTime:(NSInteger)reportEnd visitBeginTime:(NSInteger)visitBegin visitEndTime:(NSInteger)visitEnd
{
    [self.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
    
    hx_weakify(self);
    [self getClientDataRequest:YES completeCall:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView reloadData];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.groups.count?7:0;
    }else{
        return self.clients.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMaganerGrade *grade = self.groups.firstObject;
        switch (indexPath.row) {
            case 0:{
                cell.clientState.text = @"已报备";
                cell.clientNum.text = [NSString stringWithFormat:@"%zd",grade.cusBaoBeiReportNum];
            }
                break;
            case 1:{
                cell.clientState.text = @"已到访";
                cell.clientNum.text = [NSString stringWithFormat:@"%zd",grade.cusBaoBeiVisitNum];
            }
                break;
            case 2:{
                cell.clientState.text = @"已认筹";
                cell.clientNum.text = [NSString stringWithFormat:@"%zd",grade.cusBaoBeiRecognitionNum];
            }
                break;
            case 3:{
                cell.clientState.text = @"已认购";
                cell.clientNum.text = [NSString stringWithFormat:@"%zd",grade.cusBaoBeiSubscribeNum];
            }
                break;
            case 4:{
                cell.clientState.text = @"已签约";
                cell.clientNum.text = [NSString stringWithFormat:@"%zd",grade.cusBaoBeiSignNum];
            }
                break;
            case 5:{
                cell.clientState.text = @"已退房";
                cell.clientNum.text = [NSString stringWithFormat:@"%zd",grade.cusBaoBeiAbolishNum];
            }
                break;
            case 6:{
                cell.clientState.text = @"已失效";
                cell.clientNum.text = [NSString stringWithFormat:@"%zd",grade.cusBaoBeiInvalidNum];
            }
                break;
                
            default:
                break;
        }
        return cell;
    }else{
        RCMyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cusType = self.selectIndex;
        RCMyClient *client = self.clients[indexPath.row];
        cell.client = client;
        hx_weakify(self);
        cell.clientHandleCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                HXLog(@"关注");
            }else if (index == 2) {
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:client.phone constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",client.phone]]];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }else if (index == 3) {
                NSString *phoneStr = [NSString stringWithFormat:@"%@",client.phone];//发短信的号码
                NSString *urlStr = [NSString stringWithFormat:@"sms://%@", phoneStr];
                NSURL *url = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication] openURL:url];
            }else if (index == 4) {
                RCGoHouseVC *hvc = [RCGoHouseVC new];
                hvc.cusUuid = client.uuid;
                [strongSelf.navigationController pushViewController:hvc animated:YES];
            }else{
                RCClientDetailVC *nvc = [RCClientDetailVC new];
                nvc.cusType = strongSelf.selectIndex;
                if (strongSelf.selectIndex == 0) {// 如果是报备客户传报备uuid
                    nvc.cusUuid = client.uuid;
                }else{// 如果不是报备客户
                    if (strongSelf.selectIndex == 6) {//失效客户
                        nvc.cusUuid = client.uuid;
                    }else{//其他状态客户
                        nvc.cusUuid = client.cusUuid;
                    }
                }
                nvc.updateReamrkCall = ^(NSString * _Nonnull remarkTime, NSString * _Nonnull remark) {
                    client.remarkTime = remarkTime;
                    client.remark = remark;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [strongSelf.navigationController pushViewController:nvc animated:YES];
            }
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.leftTableView) {
        return 75.f;
    }else{
        return 240.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        self.selectIndex = indexPath.row;
        switch (indexPath.row) {
            case 0:{
                [self.firstFilterBtn setTitle:@"报备时间" forState:UIControlStateNormal];
            }
                break;
            case 1:{
                [self.firstFilterBtn setTitle:@"到访时间" forState:UIControlStateNormal];
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
        
        //重置筛选条件
//        self.filterModel.cusLevel = @"";
//        self.filterModel.selectPro = nil;
//        self.filterModel.reportStart = 0;
//        self.filterModel.reportStartStr = @"";
//        self.filterModel.reportEnd = 0;
//        self.filterModel.reportEndStr = @"";
//        self.filterModel.visitStart = 0;
//        self.filterModel.visitStartStr = @"";
//        self.filterModel.visitEnd = 0;
//        self.filterModel.visitEndStr = @"";
        
        hx_weakify(self);
        [self getClientDataRequest:YES completeCall:^{
            hx_strongify(weakSelf);
            [strongSelf.rightTableView reloadData];
        }];
    }else {
        RCMyClient *client = self.clients[indexPath.row];
        RCClientDetailVC *nvc = [RCClientDetailVC new];
        nvc.cusType = self.selectIndex;
        if (self.selectIndex == 0) {// 如果是报备客户传报备uuid
             nvc.cusUuid = client.uuid;
        }else{// 如果不是报备客户
            if (self.selectIndex == 6) {//失效客户
                nvc.cusUuid = client.uuid;
            }else{//其他状态客户
                nvc.cusUuid = client.cusUuid;
            }
        }
        nvc.updateReamrkCall = ^(NSString * _Nonnull remarkTime, NSString * _Nonnull remark) {
            client.remarkTime = remarkTime;
            client.remark = remark;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:nvc animated:YES];
    }
}
@end

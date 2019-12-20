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
#import "RCClientPro.h"
#import "ZJPickerView.h"
#import "RCBeeClient.h"

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
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 报备状态 专员报备失败 1  待专员报备 0 */
@property(nonatomic,copy) NSString *state;
/* 归属项目id */
@property(nonatomic,copy) NSString *proUuid;
/* 报备时间类型 0：年；1：季度；2：月；3：周；4：日 */
@property(nonatomic,copy) NSString *timeType;

@end

@implementation RCClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"客户"];
    self.state = @"";
    self.proUuid = @"";
    self.timeType = @"";
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getClientDataRequest];
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
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getClientListDataRequest:YES completedCall:^{
            [strongSelf.tableView reloadData];
            if (strongSelf.clients.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientListDataRequest:NO completedCall:^{
            [strongSelf.tableView reloadData];
            if (strongSelf.clients.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        }];
    }];
}
#pragma mark -- 接口请求
-(void)getClientDataRequest
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
                NSArray *pros = [NSArray yy_modelArrayWithClass:[RCClientPro class] json:responseObject[@"data"]];
                NSMutableArray *tempPro = [NSMutableArray arrayWithArray:pros];
                RCClientPro *pro = [RCClientPro new];
                pro.proName = @"全部";
                pro.proUuid = @"";
                [tempPro insertObject:pro atIndex:0];
                strongSelf.projects = tempPro;
                dispatch_semaphore_signal(semaphore);
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getClientListDataRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        hx_strongify(weakSelf);
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            [strongSelf stopShimmer];
            
            [strongSelf.tableView reloadData];
        });
    });
}
/** 列表请求 */
-(void)getClientListDataRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;
    data[@"xqzyAccUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.xqzyAccUuid;
    data[@"state"] = self.state;//报备状态
    data[@"proUuid"] = self.proUuid;//归属项目id
    data[@"timeType"] = self.timeType;//报备时间类型(高级筛选)：0：年；1：季度；2：月；3：周；4：日
    
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    page[@"descs"] = @[@"create_time"];
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/bee/getBeeCusPageList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCBeeClient class] json:responseObject[@"data"][@"records"]];
                [strongSelf.clients addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCBeeClient class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.clients addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (completedCall) {
            completedCall();
        }
    } failure:^(NSError *error) {
        if (completedCall) {
            completedCall();
        }
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
- (IBAction)filterClicked:(UIButton *)sender {
    self.selectBtn = sender;
    NSString *textKey = nil;
    NSMutableArray *titles = [NSMutableArray array];
    if (sender.tag == 1) {
        if ([self.dateLabel.text isEqualToString:@"全部日期"]) {
            textKey = @"全部";
        }else{
            textKey = self.dateLabel.text;
        }
        [titles addObjectsFromArray:@[@"全部",@"今日",@"本周",@"本月",@"本季",@"本年"]];
    }else if (sender.tag == 2){
        if ([self.projectLabel.text isEqualToString:@"全部项目"]) {
            textKey = @"全部";
        }else{
            textKey = self.projectLabel.text;
        }
        for (RCClientPro *pro in self.projects) {
            [titles addObject:pro.proName];
        }
    }else{
        if ([self.stateLabel.text isEqualToString:@"报备状态"]) {
            textKey = @"全部";
        }else{
            textKey = self.stateLabel.text;
        }
        [titles addObjectsFromArray:@[@"全部",@"专员报备失败",@"待专员报备"]];
    }
    
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   ZJPickerViewPropertyTipLabelTextKey  : textKey, // 提示内容
                                   ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0xA9A9A9),
                                   ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0x232323),
                                   ZJPickerViewPropertyTipLabelTextColorKey :
                                       UIColorFromRGB(0x131D2D),
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @220.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x131D2D), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0xA9A9A9), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:titles propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        // show select content|
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];

        NSArray *type = [results.firstObject componentsSeparatedByString:@","];

        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        if (sender.tag == 1) {
            strongSelf.dateLabel.text = type.firstObject;
            /* 报备时间类型 0：年；1：季度；2：月；3：周；4：日 */
            if ([rows.firstObject integerValue] == 0) {
                strongSelf.timeType = @"";
            }else if ([rows.firstObject integerValue] == 1) {
                strongSelf.timeType = @"4";
            }else if ([rows.firstObject integerValue] == 2) {
                strongSelf.timeType = @"3";
            }else if ([rows.firstObject integerValue] == 3) {
                strongSelf.timeType = @"2";
            }else if ([rows.firstObject integerValue] == 4) {
                strongSelf.timeType = @"1";
            }else{
                strongSelf.timeType = @"0";
            }
        }else if(sender.tag == 2) {
            strongSelf.projectLabel.text = type.firstObject;
            RCClientPro *pro = strongSelf.projects[[rows.firstObject integerValue]];
            strongSelf.proUuid = pro.proUuid;
        }else{
            strongSelf.stateLabel.text = type.firstObject;
            if ([rows.firstObject integerValue] == 0) {
                strongSelf.state = @"";
            }else if ([rows.firstObject integerValue] == 1) {
                strongSelf.state = @"2";
            }else{
                strongSelf.state = @"1";
            }
        }
        [strongSelf getClientListDataRequest:YES completedCall:^{
            [strongSelf.tableView reloadData];
            if (strongSelf.clients.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        }];
    }];

}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clients.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCClientCell *cell = [tableView dequeueReusableCellWithIdentifier:ClientCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCBeeClient *client = self.clients[indexPath.row];
    cell.client = client;
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

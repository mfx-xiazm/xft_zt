//
//  RCHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseVC.h"
#import "RCHouseCell.h"
#import "RCHouseHeader.h"
#import "RCSearchCityVC.h"
#import "RCSearchHouseVC.h"
#import "RCHouseDetailVC.h"
#import "RCNoticeVC.h"
#import "RCManagerMsgVC.h"
#import "RCReportClientVC.h"
#import "zhAlertView.h"
#import <zhPopupController/zhPopupController.h>
#import "RCHouseBanner.h"
#import "RCHouseNotice.h"
#import "RCHouseList.h"

static NSString *const HouseCell = @"HouseCell";

@interface RCHouseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头部视图 */
@property(nonatomic,strong) RCHouseHeader *header;
/* 轮播图 */
@property(nonatomic,strong) NSArray *banners;
/* 公告 */
@property(nonatomic,strong) NSArray *notices;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 房源列表 */
@property(nonatomic,strong) NSMutableArray *houses;
/* 选择的城市名称 */
@property(nonatomic,copy) NSString *chooseCity;
/* 定位按钮 */
@property(nonatomic,strong) SPButton *locationBtn;
@end

@implementation RCHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self queryAppVersion];
    [self startShimmer];
    [self getCityRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
}
-(RCHouseHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseHeader loadXibView];
        hx_weakify(self);
        _header.houseHeaderBtnClicked = ^(NSInteger type, NSInteger index) {
            if (type == 0) {
                RCNoticeVC *nvc = [RCNoticeVC new];
                nvc.navTitle = @"公告";
                [weakSelf.navigationController pushViewController:nvc animated:YES];
            }else{
                
            }
        };
    }
    return _header;
}
-(NSMutableArray *)houses
{
    if (_houses == nil) {
        _houses = [NSMutableArray array];
    }
    return _houses;
}
-(void)setChooseCity:(NSString *)chooseCity
{
    if (![_chooseCity isEqualToString:chooseCity]) {
        _chooseCity = chooseCity;
        [self getCityRequest];
    }
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    SPButton *item = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    item.hxn_size = CGSizeMake(70, 30);
    item.imageTitleSpace = 5.f;
    item.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [item setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [item setImage:HXGetImage(@"icon_home_place") forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName]){
        [item setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName] forState:UIControlStateNormal];
    }else{
        [item setTitle:@"武汉" forState:UIControlStateNormal];
    }
    [item addTarget:self action:@selector(cityClicked) forControlEvents:UIControlEventTouchUpInside];
    self.locationBtn = item;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
    SPButton *msgBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    msgBtn.hxn_size = CGSizeMake(44, 44);
    [msgBtn setImage:HXGetImage(@"icon_news") forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(messageClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc] initWithCustomView:msgBtn];
    
//    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClicked) nomalImage:HXGetImage(@"icon_search") higeLightedImage:HXGetImage(@"icon_search") imageEdgeInsets:UIEdgeInsetsZero];
    
    self.navigationItem.rightBarButtonItem = msgItem;
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
    self.tableView.estimatedRowHeight = 120;//预估高度
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
    
    self.tableView.tableHeaderView = self.header;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getHouseListDataRequest:YES completeCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getHouseListDataRequest:NO completeCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
#pragma mark -- 点击事件
-(void)cityClicked
{
    RCSearchCityVC *hvc = [RCSearchCityVC new];
    hx_weakify(self);
    hvc.changeCityCall = ^(NSString * _Nonnull city) {
        hx_strongify(weakSelf);
        strongSelf.chooseCity = city;
        [strongSelf.locationBtn setTitle:city forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:hvc animated:YES];
}
-(void)searchClicked
{
    RCSearchHouseVC *hvc = [RCSearchHouseVC new];
    [self.navigationController pushViewController:hvc animated:YES];
}
-(void)messageClicked
{
    RCManagerMsgVC *mvc = [RCManagerMsgVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
#pragma mark -- 接口请求
/** 城市模糊查询列表 */
-(void)getCityRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.chooseCity && self.chooseCity.length) {
        data[@"name"] = self.chooseCity;
    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName]) {
        data[@"name"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName];
    }else{
        data[@"name"] = @"武汉";
    }
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/city/cityCodeByNameLike" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"cityCode"] forKey:HXCityCode];
//            [[NSUserDefaults standardUserDefaults] setObject:@"510100" forKey:HXCityCode];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [strongSelf getHouseDataRequest];
        }else{
            [strongSelf stopShimmer];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getHouseDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    /*
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        data[@"showRoomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;
        NSMutableDictionary *page = [NSMutableDictionary dictionary];
        page[@"current"] = @"1";
        page[@"size"] = @"10";
        parameters[@"data"] = data;
        parameters[@"page"] = page;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"marketing/marketing/xcxBanner/showbannerList" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.banners = [NSArray yy_modelArrayWithClass:[RCHouseBanner class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);

        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);

        }];
    });
     */
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        data[@"num"] = @"1";
        NSMutableDictionary *page = [NSMutableDictionary dictionary];
        page[@"current"] = @"1";
        page[@"size"] = @"3";
        parameters[@"data"] = data;
        parameters[@"page"] = page;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/notice/noticeList" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.notices = [NSArray yy_modelArrayWithClass:[RCHouseNotice class] json:responseObject[@"data"]];
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
        [strongSelf getHouseListDataRequest:YES completeCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });

    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            strongSelf.tableView.hidden = NO;
            strongSelf.header.banners = self.banners;
            strongSelf.header.notices = self.notices;
            [strongSelf.tableView reloadData];
        });
    });
}
/** 房源筛选列表 */
-(void)getHouseListDataRequest:(BOOL)isRefresh completeCall:(void(^)(void))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"cityUuid"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
    data[@"queryName"] = @"";
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
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/home/getHomeProList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.houses removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseList class] json:responseObject[@"data"][@"records"]];
                [strongSelf.houses addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseList class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.houses addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (completeCall) {
            completeCall();
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completeCall) {
            completeCall();
        }
    }];
}
#pragma mark -- 业务逻辑
-(void)queryAppVersion
{
    hx_weakify(self);
    [self queryAppVersionRequest:^(NSDictionary *version) {
        hx_strongify(weakSelf);
        //                currentVersion  最新版本号
        //                downlondUrl 下载地址
        //                isForce    是否强制更新 0不强制 1强制
        //                upremark 更新内容
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"更新版本" message:[NSString stringWithFormat:@"%@",version[@"upremark"]] constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"下载" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",version[@"downlondUrl"]]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        
        strongSelf.zh_popupController = [[zhPopupController alloc] init];
        if ([version[@"isForce"] integerValue] == 0) {
            strongSelf.zh_popupController.dismissOnMaskTouched = YES;
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        }else{
            strongSelf.zh_popupController.dismissOnMaskTouched = NO;
            [alert addAction:okButton];
        }
        [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }];
}
-(void)queryAppVersionRequest:(void(^)(NSDictionary *version))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"applicationMarket"] = @"";
    NSString *key = @"CFBundleShortVersionString";
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    data[@"currentVersion"] = currentVersion;
    
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/appversion/queryAppVersion" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (((NSDictionary *)responseObject[@"data"]).allKeys.count) {
                    if (![(NSString *)responseObject[@"data"][@"upVesion"] isEqualToString:currentVersion]) {
                        if (completedCall) {
                            completedCall(responseObject[@"data"]);
                        }
                    }
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
                }
            }
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
    return self.houses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCHouseList *house = self.houses[indexPath.row];
    cell.house = house;
    hx_weakify(self);
    cell.reportCall = ^{
        RCReportClientVC *cvc = [RCReportClientVC new];
        cvc.houseUuid = house.proUuid;
        cvc.houseName = house.name;
        [weakSelf.navigationController pushViewController:cvc animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    label.text = @"   文旅项目";
    
    return label;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCHouseDetailVC *dvc = [RCHouseDetailVC new];
    RCHouseList *house = self.houses[indexPath.row];
    dvc.lat = house.dimension;
    dvc.lng = house.longitude;
    dvc.uuid = house.proUuid;
    [self.navigationController pushViewController:dvc animated:YES];
}
@end

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

static NSString *const HouseCell = @"HouseCell";

@interface RCHouseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头部视图 */
@property(nonatomic,strong) RCHouseHeader *header;

@end

@implementation RCHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpTableHeaderView];
    [self queryAppVersion];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f+50.f);
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
    [item setTitle:@"武汉" forState:UIControlStateNormal];
    [item addTarget:self action:@selector(cityClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
    SPButton *msgBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    msgBtn.hxn_size = CGSizeMake(44, 44);
    [msgBtn setImage:HXGetImage(@"icon_news") forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(messageClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc] initWithCustomView:msgBtn];
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClicked) nomalImage:HXGetImage(@"icon_search") higeLightedImage:HXGetImage(@"icon_search") imageEdgeInsets:UIEdgeInsetsZero];
    
    self.navigationItem.rightBarButtonItems = @[msgItem,searchItem];
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
}
-(void)setUpTableHeaderView
{
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
-(void)cityClicked
{
//    RCSearchCityVC *hvc = [RCSearchCityVC new];
//    [self.navigationController pushViewController:hvc animated:YES];
}
-(void)searchClicked
{
//    RCSearchHouseVC *hvc = [RCSearchHouseVC new];
//    [self.navigationController pushViewController:hvc animated:YES];
}
-(void)messageClicked
{
//    RCManagerMsgVC *mvc = [RCManagerMsgVC new];
//    [self.navigationController pushViewController:mvc animated:YES];
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
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    hx_weakify(self);
    cell.reportCall = ^{
        RCReportClientVC *cvc = [RCReportClientVC new];
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
    [self.navigationController pushViewController:dvc animated:YES];
}
@end

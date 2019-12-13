//
//  RCDevelopClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/12/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCDevelopClientVC.h"
#import "RCDevelopClientCell.h"
#import "RCAddClientTypeVC.h"
#import "RCClientType.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const DevelopClientCell = @"DevelopClientCell";
@interface RCDevelopClientVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *clientTypes;
/* 编辑 */
@property(nonatomic,strong) UIButton *editBtn;
@end

@implementation RCDevelopClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpEmptyView];
    [self getTypeListDataRequest];
}
-(NSMutableArray *)clientTypes
{
    if (_clientTypes == nil) {
        _clientTypes = [NSMutableArray array];
    }
    return _clientTypes;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"拓客方式"];

    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    [edit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    [edit setTitle:@"完成" forState:UIControlStateSelected];
    edit.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    edit.hxn_size = CGSizeMake(60, 44);
    [edit addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn = edit;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:edit];
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
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCDevelopClientCell class]) bundle:nil] forCellReuseIdentifier:DevelopClientCell];
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
#pragma mark -- 点击事件
-(void)editClicked:(UIButton *)btn
{
    self.editBtn.selected = !self.editBtn.isSelected;
    
    [self.tableView reloadData];
}
- (IBAction)addTypeClicked:(UIButton *)sender {
    RCAddClientTypeVC *tvc = [RCAddClientTypeVC new];
    hx_weakify(self);
    tvc.addTypeCall = ^{
        hx_strongify(weakSelf);
        [strongSelf getTypeListDataRequest];
    };
    [self.navigationController pushViewController:tvc animated:YES];
}
#pragma mark -- 接口请求
/** 列表请求 */
-(void)getTypeListDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;
    parameters[@"data"] = data;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomExpandMode/getShowroomExpandModeList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [strongSelf.clientTypes removeAllObjects];
            
            NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCClientType class] json:responseObject[@"data"]];
            [strongSelf.clientTypes addObjectsFromArray:arrt];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.clientTypes.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                }else{
                    [strongSelf.tableView ly_showEmptyView];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)delClientTypeRequest:(NSString *)uuid completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = uuid;
    parameters[@"data"] = data;

    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomExpandMode/deleteShowroomExpandModeName" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if (completedCall) {
                completedCall();
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
    return self.clientTypes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDevelopClientCell *cell = [tableView dequeueReusableCellWithIdentifier:DevelopClientCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delBtn.hidden = !self.editBtn.isSelected;
    RCClientType *type = self.clientTypes[indexPath.row];
    cell.type = type;
    hx_weakify(self);
    cell.delClientCall = ^{
        hx_strongify(weakSelf);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确认推荐客户？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
            [strongSelf delClientTypeRequest:type.uuid completedCall:^{
                [strongSelf.clientTypes removeObject:type];
                [tableView reloadData];
            }];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        strongSelf.zh_popupController = [[zhPopupController alloc] init];
        [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

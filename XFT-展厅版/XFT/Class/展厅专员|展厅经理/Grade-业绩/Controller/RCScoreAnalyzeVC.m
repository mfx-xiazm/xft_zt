//
//  RCScoreAnalyzeVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCScoreAnalyzeVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import <JXCategoryIndicatorBackgroundView.h>
#import "RCScoreRankCell.h"

static NSString *const ScoreRankCell = @"ScoreRankCell";
static NSString *const ScoreBarCell = @"ScoreBarCell";

@interface RCScoreAnalyzeVC ()<JXCategoryViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *titleCategoryView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *timeCategoryView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *rankCategoryView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *typeCategoryView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *topScoreTitle;
@property (weak, nonatomic) IBOutlet UILabel *topScoreCount;
@property (weak, nonatomic) IBOutlet UILabel *topScoreCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *topScoreNum;
@property (weak, nonatomic) IBOutlet UILabel *topScoreNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
/* 查询类型 1.认筹 2.认购 3.签约 4.回款 */
@property(nonatomic,copy) NSString *type;
/* 时间类型 1.日 2.周 3.月 4.年 5.季度 */
@property(nonatomic,copy) NSString *dataTimeType;
/* 数据类型 1.套数 2.金额 */
@property(nonatomic,copy) NSString *dataType;
/* 团队类型 1.团队 2.小组 3.个人 */
@property(nonatomic,copy) NSString *teamType;
/* 业绩总览 */
@property(nonatomic,strong) NSDictionary *totalBaseInfo;
/* 排行榜 */
@property(nonatomic,strong) NSArray *ranks;
@end

@implementation RCScoreAnalyzeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"业绩分析"];
    self.type = @"1";
    self.dataTimeType = @"1";
    self.dataType = @"1";
    self.teamType = @"1";
    [self setUpCategoryView];
    [self setUpTableView];
    [self startShimmer];
    [self getScoreDetailRequest];
}

-(void)setUpCategoryView
{
    _titleCategoryView.backgroundColor = [UIColor whiteColor];
    _titleCategoryView.titleLabelZoomEnabled = NO;
    _titleCategoryView.titles = @[@"认筹", @"认购", @"签约", @"回款"];
    _titleCategoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _titleCategoryView.titleColor = UIColorFromRGB(0x666666);
    _titleCategoryView.titleSelectedColor = HXControlBg;
    _titleCategoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _titleCategoryView.indicators = @[lineView];
    
    _timeCategoryView.layer.cornerRadius = 4.f;
    _timeCategoryView.layer.masksToBounds = YES;
    _timeCategoryView.titles = @[@"日",@"周",@"月",@"季",@"年"];
    _timeCategoryView.titleFont = [UIFont systemFontOfSize:15];
    _timeCategoryView.cellSpacing = 0;
    _timeCategoryView.cellWidth = 300.f/5;
    _timeCategoryView.titleColor = UIColorFromRGB(0x333333);
    _timeCategoryView.titleSelectedColor = [UIColor whiteColor];
    _timeCategoryView.titleLabelMaskEnabled = YES;
    _timeCategoryView.delegate = self;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 30.f;
    backgroundView.indicatorCornerRadius = 4;
    backgroundView.indicatorWidthIncrement = 0;
    backgroundView.indicatorColor = HXControlBg;
    _timeCategoryView.indicators = @[backgroundView];
    
    _rankCategoryView.backgroundColor = [UIColor whiteColor];
    _rankCategoryView.titleLabelZoomEnabled = NO;
    _rankCategoryView.averageCellSpacingEnabled = NO;
    _rankCategoryView.titles = @[@"团队", @"小组", @"专员"];
    _rankCategoryView.titleLabelVerticalOffset = -10.f;
    _rankCategoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _rankCategoryView.titleColor = UIColorFromRGB(0x666666);
    _rankCategoryView.titleSelectedColor = HXControlBg;
    _rankCategoryView.delegate = self;
    
    
    _typeCategoryView.backgroundColor =  UIColorFromRGB(0xDDDDDD);
    _typeCategoryView.layer.cornerRadius = 4.f;
    _typeCategoryView.layer.masksToBounds = YES;
    _typeCategoryView.titles = @[@"笔数",@"金额"];
    _typeCategoryView.titleFont = [UIFont systemFontOfSize:12];
    _typeCategoryView.cellSpacing = 0;
    _typeCategoryView.cellWidth = 40.f;
    _typeCategoryView.titleColor = [UIColor whiteColor];
    _typeCategoryView.titleSelectedColor = [UIColor whiteColor];
    _typeCategoryView.titleLabelMaskEnabled = YES;
    _typeCategoryView.delegate = self;
    
    JXCategoryIndicatorBackgroundView *backgroundView1 = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView1.indicatorHeight = 30.f;
    backgroundView1.indicatorCornerRadius = 4;
    backgroundView1.indicatorWidthIncrement = 0;
    backgroundView1.indicatorColor = UIColorFromRGB(0x3C3B3A);
    _typeCategoryView.indicators = @[backgroundView1];
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
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCScoreRankCell class]) bundle:nil] forCellReuseIdentifier:ScoreRankCell];
}
#pragma mark - JXCategoryViewDelegate
// 点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    if (categoryView == _titleCategoryView) {
        if (_titleCategoryView.selectedIndex == 0) {
            self.type = @"1";
            self.moneyLabel.hidden = YES;
            _typeCategoryView.hidden = NO;
            self.rankNum.text = @"笔数(笔)";
        }else if (_titleCategoryView.selectedIndex == 1) {
            self.type = @"2";
            self.moneyLabel.hidden = YES;
            _typeCategoryView.hidden = NO;
            self.rankNum.text = @"笔数(笔)";
        }else if (_titleCategoryView.selectedIndex == 2) {
            self.type = @"3";
            self.moneyLabel.hidden = YES;
            _typeCategoryView.hidden = NO;
            self.rankNum.text = @"笔数(笔)";
        }else{
            self.type = @"4";
            self.moneyLabel.hidden = NO;
            _typeCategoryView.hidden = YES;
            self.rankNum.text = @"金额(万元)";
        }
    }else if (categoryView == _timeCategoryView) {
        if (_timeCategoryView.selectedIndex == 0) {
            self.dataTimeType = @"1";
        }else if (_timeCategoryView.selectedIndex == 1) {
            self.dataTimeType = @"2";
        }else if (_timeCategoryView.selectedIndex == 2) {
            self.dataTimeType = @"3";
        }else if (_timeCategoryView.selectedIndex == 3) {
            self.dataTimeType = @"5";
        }else{
            self.dataTimeType = @"4";
        }
    }else if (categoryView == _rankCategoryView) {
        if (_rankCategoryView.selectedIndex == 0) {
            self.teamType = @"1";
        }else if (_rankCategoryView.selectedIndex == 1) {
            self.teamType = @"2";
        }else {
            self.teamType = @"3";
        }
    }else{
        if (_typeCategoryView.selectedIndex == 0) {
            self.dataType = @"1";
        }else{
            self.dataType = @"2";
        }
    }
    [self getScoreDetailRequest];
}
#pragma mark -- 接口请求
-(void)getScoreDetailRequest
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
        data[@"type"] = self.type;//查询类型 1.认筹 2.认购 3.签约 4.回款
        data[@"dataTimeType"] = self.dataTimeType;//时间类型 1.日 2.周 3.月 4.年 5.季度
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
        data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
        data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"report/report/showroomLeader/total" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.totalBaseInfo = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
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
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"type"] = self.type;//查询类型 1.认筹 2.认购 3.签约 4.回款
        data[@"dataTimeType"] = self.dataTimeType;//时间类型 1.日 2.周 3.月 4.年 5.季度
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅uuid
        data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
        data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
        data[@"dataType"] = [self.type isEqualToString:@"4"]?@"2":self.dataType;//数据类型 1.套数 2.金额
        data[@"teamType"] = self.teamType;//团队类型 1.团队 2.小组 3.个人
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"report/report/showroomLeader/ranking" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.ranks = [NSArray arrayWithArray:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
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
            [strongSelf handleScoreData];
        });
    });
}
-(void)handleScoreData
{
    if ([self.type isEqualToString:@"1"]) {
        self.topScoreTitle.text = @"认筹业绩";
        self.topScoreCountLabel.text = @"认筹(笔)";
        self.topScoreNumLabel.text = @"认筹(万元)";
        self.topScoreCount.text = [NSString stringWithFormat:@"%@",self.totalBaseInfo[@"count"]];
        self.topScoreNum.text = [NSString stringWithFormat:@"%@",self.totalBaseInfo[@"amount"]];
    }else if ([self.type isEqualToString:@"2"]) {
        self.topScoreTitle.text = @"认购业绩";
        self.topScoreCountLabel.text = @"认购(笔)";
        self.topScoreNumLabel.text = @"认购(万元)";
        self.topScoreCount.text = [NSString stringWithFormat:@"%@",self.totalBaseInfo[@"count"]];
        self.topScoreNum.text = [NSString stringWithFormat:@"%@",self.totalBaseInfo[@"amount"]];
    }else if ([self.type isEqualToString:@"3"]) {
        self.topScoreTitle.text = @"签约业绩";
        self.topScoreCountLabel.text = @"签约(笔)";
        self.topScoreNumLabel.text = @"签约(万元)";
        self.topScoreCount.text = [NSString stringWithFormat:@"%@",self.totalBaseInfo[@"count"]];
        self.topScoreNum.text = [NSString stringWithFormat:@"%@",self.totalBaseInfo[@"amount"]];
    }else{
        self.topScoreTitle.text = @"回款业绩";
        self.topScoreCountLabel.text = @"——";
        self.topScoreNumLabel.text = @"回款(万元)";
        self.topScoreCount.text = @"-";
        self.topScoreNum.text = [NSString stringWithFormat:@"%@",self.totalBaseInfo[@"amount"]];
    }
    
    self.tableViewHeight.constant = 50.f*self.ranks.count;
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ranks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCScoreRankCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreRankCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.num.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    if (indexPath.row <= 2) {
        cell.num.textColor = HXControlBg;
    }else{
        cell.num.textColor = [UIColor blackColor];
    }
    NSDictionary *dict = self.ranks[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    cell.count.text = [NSString stringWithFormat:@"%@",dict[@"count"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end

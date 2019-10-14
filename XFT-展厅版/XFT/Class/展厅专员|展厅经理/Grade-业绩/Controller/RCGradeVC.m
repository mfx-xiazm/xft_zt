//
//  RCGradeVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCGradeVC.h"
#import "RCMyClientStateCell.h"
#import "RCClientGradeCell.h"
#import "FSActionSheet.h"
#import "ZJPickerView.h"
#import "RCGradeNumVC.h"
#import "RCMoveClientFromVC.h"
#import "RCMyStoreVC.h"
#import "RCClientElementVC.h"
#import "RCSearchClientVC.h"
#import "RCScoreAnalyzeVC.h"
#import "RCMaganerGrade.h"
#import "RCClientDetailVC.h"
#import "RCGradeClientVC.h"

static NSString *const ClientGradeCell = @"ClientGradeCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";

@interface RCGradeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/* 团队切换按键 */
@property(nonatomic,strong) SPButton *teamBtn;
/* 团队信息 */
@property(nonatomic,strong) NSArray *groups;
/* 左边分组选中的索引 */
@property(nonatomic,assign) NSInteger selectIndex;
/* 时间筛选值 */
@property(nonatomic,copy) NSString *timeFlag;
@end

@implementation RCGradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.hidden = YES;
    [self setUpNavBar];
    [self setUpTableView];
    self.selectIndex = 0;
    [self getGradeDataRequest];
}
-(void)setTimeFlag:(NSString *)timeFlag
{
    if (![_timeFlag isEqualToString:timeFlag]) {
        _timeFlag = timeFlag;
        [self getGradeDataRequest];
    }
}
#pragma mark -- 视图UI
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    SPButton *menu = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
    menu.hxn_size = CGSizeMake(200 , 44);
    menu.imageTitleSpace = 5.f;
    menu.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [menu setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    [menu setTitle:[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName forState:UIControlStateNormal];
    [menu setImage:HXGetImage(@"Shape") forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(teamClicked:) forControlEvents:UIControlEventTouchUpInside];
    menu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.teamBtn = menu;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
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
    self.rightTableView.rowHeight = 0;
    self.rightTableView.estimatedSectionHeaderHeight = 0;
    self.rightTableView.estimatedSectionFooterHeight = 0;
    
    self.rightTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCClientGradeCell class]) bundle:nil] forCellReuseIdentifier:ClientGradeCell];
    
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
#pragma mark -- 点击事件
-(void)teamClicked:(SPButton *)menuBtn
{
    
}
-(void)searchClicked
{
    RCSearchClientVC *cvc = [RCSearchClientVC  new];
    cvc.dataType = 1;
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.manageRole == 1) {//展厅经理
        cvc.showroomUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
    }else if ([MSUserManager sharedInstance].curUserInfo.selectRole.manageRole == 2) {//团队经理
        cvc.showroomUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
        cvc.teamUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//小组uuid
    }else{//小组经理
        cvc.showroomUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
        cvc.teamUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//小组uuid
        cvc.groupUuid = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
    }
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)teamFilterClicked:(UIButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"日期" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"全部",@"本周",@"本月",@"本年"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            strongSelf.timeFlag = @"";
            strongSelf.timeLabel.text = @"全部";
        }else if (selectedIndex == 1){
            strongSelf.timeFlag = @"week";
            strongSelf.timeLabel.text = @"本周";
        }else if (selectedIndex == 2){
            strongSelf.timeFlag = @"month";
            strongSelf.timeLabel.text = @"本月";
        }else{
            strongSelf.timeFlag = @"year";
            strongSelf.timeLabel.text = @"本年";
        }
    }];
}
- (IBAction)clientFenxiClicked:(SPButton *)sender {
    RCClientElementVC *evc = [RCClientElementVC new];
    [self.navigationController pushViewController:evc animated:YES];
}

- (IBAction)moveClientClicked:(SPButton *)sender {
    RCMoveClientFromVC *fvc = [RCMoveClientFromVC new];
    [self.navigationController pushViewController:fvc animated:YES];
}
- (IBAction)scoreFenxiClicked:(SPButton *)sender {
    RCScoreAnalyzeVC *avc = [RCScoreAnalyzeVC new];
    [self.navigationController pushViewController:avc animated:YES];
}

- (IBAction)zhongjieStoreClicked:(SPButton *)sender {
    RCMyStoreVC *svc = [RCMyStoreVC new];
    [self.navigationController pushViewController:svc animated:YES];
}
#pragma mark -- 接口数据请求
-(void)getGradeDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.manageRole == 1) {//展厅经理
        data[@"accUuid"] = @"";//经纪人uuid
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
        data[@"groupUuid"] = @"";//小组uuid
        data[@"teamUuid"] = @"";//团队uuid
    }else if ([MSUserManager sharedInstance].curUserInfo.selectRole.manageRole == 2) {//团队经理
        data[@"accUuid"] = @"";//经纪人uuid
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
        data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
        data[@"groupUuid"] = @"";//小组uuid
    }else{//小组经理
        data[@"accUuid"] = @"";//经纪人uuid
        data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//展厅id
        data[@"groupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//小组uuid
        data[@"teamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//团队uuid
    }
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
    data[@"timeFlag"] = (self.timeFlag && self.timeFlag.length)?self.timeFlag:@"";//时间筛选条件 week month year 传空表示全部
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroom/searchCusBaobeiNumsNew" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.groups = [NSArray yy_modelArrayWithClass:[RCMaganerGrade class] json:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.contentView.hidden = NO;
            [strongSelf.leftTableView reloadData];
            [strongSelf.rightTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            });
        });
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.groups.count;
    }else{
        return (self.groups && self.groups.count)?7:0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMaganerGrade *grade = self.groups[indexPath.row];
        cell.clientNum.text = [NSString stringWithFormat:@"%zd",grade.totalNum];
        if ([MSUserManager sharedInstance].curUserInfo.selectRole.manageRole == 1) {//展厅经理
            cell.clientState.text = grade.teamName;
        }else if ([MSUserManager sharedInstance].curUserInfo.selectRole.manageRole == 2){//团队经理
            cell.clientState.text = grade.groupName;
        }else{//小组经理
            cell.clientState.text = grade.zyName;
        }
        
        return cell;
    }else{
        RCClientGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:ClientGradeCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMaganerGrade *grade = self.groups[self.selectIndex];
        switch (indexPath.row) {
            case 0:{
                cell.typeName.text = @"报备客户";
                cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiReportNum];
            }
                break;
            case 1:{
                cell.typeName.text = @"到访客户";
                cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiVisitNum];
            }
                break;
            case 2:{
                cell.typeName.text = @"认筹客户";
                cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiRecognitionNum];
            }
                break;
            case 3:{
                cell.typeName.text = @"认购客户";
                cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiSubscribeNum];
            }
                break;
            case 4:{
                cell.typeName.text = @"签约客户";
                cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiSignNum];
            }
                break;
            case 5:{
                cell.typeName.text = @"退房客户";
                cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiAbolishNum];
            }
                break;
            case 6:{
                cell.typeName.text = @"失效客户";
                cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiInvalidNum];
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.leftTableView) {
        return 75.f;
    }else{
        return 50.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        self.selectIndex = indexPath.row;
        [self.rightTableView reloadData];
    }else {
        if ([MSUserManager sharedInstance].curUserInfo.selectRole.manageRole == 1) {//展厅经理
            RCGradeNumVC *nvc = [RCGradeNumVC new];
            RCMaganerGrade *grade = self.groups[self.selectIndex];
            nvc.showroomUuid = grade.showroomUuid;
            nvc.teamUuid = grade.teamUuid;
            nvc.cusType = indexPath.row;
            switch (indexPath.row) {
                case 0:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@报备客户",grade.teamName];
                }
                    break;
                case 1:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@到访客户",grade.teamName];
                }
                    break;
                case 2:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@认筹客户",grade.teamName];
                }
                    break;
                case 3:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@认购客户",grade.teamName];
                }
                    break;
                case 4:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@签约客户",grade.teamName];
                }
                    break;
                case 5:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@退房客户",grade.teamName];
                }
                    break;
                case 6:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@失效客户",grade.teamName];
                }
                    break;
                    
                default:
                    break;
            }
            [self.navigationController pushViewController:nvc animated:YES];
        }else if ([MSUserManager sharedInstance].curUserInfo.selectRole.manageRole == 2){//团队经理
            RCGradeNumVC *nvc = [RCGradeNumVC new];
            RCMaganerGrade *grade = self.groups[self.selectIndex];
            nvc.showroomUuid = grade.showroomUuid;
            nvc.teamUuid = grade.teamUuid;
            nvc.groupUuid = grade.groupUuid;
            nvc.cusType = indexPath.row;
            switch (indexPath.row) {
                case 0:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@报备客户",grade.groupName];
                }
                    break;
                case 1:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@到访客户",grade.groupName];
                }
                    break;
                case 2:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@认筹客户",grade.groupName];
                }
                    break;
                case 3:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@认购客户",grade.groupName];
                }
                    break;
                case 4:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@签约客户",grade.groupName];
                }
                    break;
                case 5:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@退房客户",grade.groupName];
                }
                    break;
                case 6:{
                    nvc.navTitle = [NSString stringWithFormat:@"%@失效客户",grade.groupName];
                }
                    break;
                    
                default:
                    break;
            }
            [self.navigationController pushViewController:nvc animated:YES];
        } else{//专员
            RCGradeClientVC *cvc = [RCGradeClientVC new];
            RCMaganerGrade *grade = self.groups[self.selectIndex];
            cvc.showroomUuid = grade.showroomUuid;
            cvc.teamUuid = grade.teamUuid;
            cvc.groupUuid = grade.groupUuid;
            cvc.zyUuid = grade.zyUuid;
            cvc.navTitle = grade.zyName;
            cvc.cusType = indexPath.row;
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }
}

@end

//
//  RCGradeNumVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCGradeNumVC.h"
#import "RCClientGradeCell.h"
#import "RCGradeClientVC.h"
#import "RCMaganerGrade.h"

static NSString *const ClientGradeCell = @"ClientGradeCell";

@interface RCGradeNumVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 小组数据 */
@property(nonatomic,strong) NSArray *groups;
@end

@implementation RCGradeNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:(self.navTitle && self.navTitle.length)?self.navTitle:@"客户"];
    [self setUpTableView];
    [self getGradeDataRequest];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCClientGradeCell class]) bundle:nil] forCellReuseIdentifier:ClientGradeCell];
    
    self.tableView.hidden = YES;
}
#pragma mark -- 接口数据请求
-(void)getGradeDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accUuid"] = @"";//经纪人uuid
    data[@"showroomUuid"] = self.showroomUuid;//展厅id
    data[@"groupUuid"] = (self.groupUuid && self.groupUuid.length)?self.groupUuid:@"";//小组uuid
    data[@"teamUuid"] = (self.teamUuid && self.teamUuid.length)?self.teamUuid:@"";//团队uuid
    data[@"timeFlag"] = @"";//时间筛选条件 week month year 传空表示全部
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
    parameters[@"data"] = data;
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroom/searchCusBaobeiNumsNew" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.groups = [NSArray yy_modelArrayWithClass:[RCMaganerGrade class] json:responseObject[@"data"]];
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
    return self.groups.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCClientGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:ClientGradeCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCMaganerGrade *grade = self.groups[indexPath.row];
    if (!self.teamUuid || !self.teamUuid.length) {
        cell.typeName.text = grade.teamName;
    }else if (!self.groupUuid || !self.groupUuid.length) {
        cell.typeName.text = grade.groupName;
    }else{
        cell.typeName.text = grade.zyName;
    }
    switch (self.cusType) {
        case 0:{
            cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiReportNum];
        }
            break;
        case 1:{
            cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiVisitNum];
        }
            break;
        case 2:{
            cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiRecognitionNum];
        }
            break;
        case 3:{
            cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiSubscribeNum];
        }
            break;
        case 4:{
            cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiSignNum];
        }
            break;
        case 5:{
            cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiAbolishNum];
        }
            break;
        case 6:{
            cell.num.text = [NSString stringWithFormat:@"%zd人",grade.cusBaoBeiInvalidNum];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.teamUuid || !self.teamUuid.length) {
        RCGradeNumVC *nvc = [RCGradeNumVC new];
        RCMaganerGrade *grade = self.groups[indexPath.row];
        nvc.showroomUuid = self.showroomUuid;
        nvc.teamUuid = grade.teamUuid;
        nvc.cusType = self.cusType;
        switch (self.cusType) {
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
    }else if (!self.groupUuid || !self.groupUuid.length) {//小组ID没有值，页面展示的是团队的小组
        RCGradeNumVC *nvc = [RCGradeNumVC new];
        RCMaganerGrade *grade = self.groups[indexPath.row];
        nvc.showroomUuid = self.showroomUuid;
        nvc.teamUuid = grade.teamUuid;
        nvc.groupUuid = grade.groupUuid;
        nvc.cusType = self.cusType;
        switch (self.cusType) {
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
    }else{
        RCGradeClientVC *cvc = [RCGradeClientVC new];
        RCMaganerGrade *grade = self.groups[indexPath.row];
        cvc.showroomUuid = grade.showroomUuid;
        cvc.teamUuid = grade.teamUuid;
        cvc.groupUuid = grade.groupUuid;
        cvc.zyUuid = grade.zyUuid;
        cvc.navTitle = grade.zyName;
        cvc.cusType = self.cusType;
        [self.navigationController pushViewController:cvc animated:YES];
    }
}
@end

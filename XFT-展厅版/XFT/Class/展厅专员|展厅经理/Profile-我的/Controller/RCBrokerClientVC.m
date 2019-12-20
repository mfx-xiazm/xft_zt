//
//  RCBrokerClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBrokerClientVC.h"
#import "RCBrokerClientCell.h"
#import "RCMyClientStateCell.h"
#import "RCBrokerClient.h"

static NSString *const BrokerClientCell = @"BrokerClientCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";
@interface RCBrokerClientVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
/* 左边的数量 */
@property(nonatomic,strong) NSMutableDictionary *clietNumInfo;
/* 左边分组选中的索引 */
@property(nonatomic,assign) NSInteger selectIndex;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 客户列表 */
@property(nonatomic,strong) NSMutableArray *clients;
@end

@implementation RCBrokerClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.navTitle];
    self.selectIndex = 0;
    [self setUpTableView];
    [self setUpRefresh];
    [self getClientNumRequest];
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
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
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCBrokerClientCell class]) bundle:nil] forCellReuseIdentifier:BrokerClientCell];
    
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
        [strongSelf getBrokerClientRequest:YES completeCall:^{
            [strongSelf.rightTableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getBrokerClientRequest:NO completeCall:^{
            [strongSelf.rightTableView reloadData];
        }];
    }];
}
#pragma mark -- 接口请求
-(void)getClientNumRequest
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
        data[@"accUuid"]  = self.accUuid;
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusbaobeilist/getShowroomAgentsCusNum" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.clietNumInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
                
                strongSelf.clietNumInfo[@"totalNum"] = @([self.clietNumInfo[@"cusBaoBeiReportNum"] integerValue]+[self.clietNumInfo[@"cusBaoBeiVisitNum"] integerValue]+[self.clietNumInfo[@"cusBaoBeiRecognitionNum"] integerValue]+[self.clietNumInfo[@"cusBaoBeiSubscribeNum"] integerValue]+[self.clietNumInfo[@"cusBaoBeiSignNum"] integerValue]+[self.clietNumInfo[@"cusBaoBeiAbolishNum"] integerValue]+[self.clietNumInfo[@"cusBaoBeiInvalidNum"] integerValue]);
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
        [strongSelf getBrokerClientRequest:YES completeCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
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
-(void)getBrokerClientRequest:(BOOL)isRefresh completeCall:(void(^)(void))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accUuid"]  = self.accUuid;
    switch (self.selectIndex) {
        case 0:{
            data[@"cusState"] = @"";//0 报备成功 2到访 4认筹 5认购 6签约 7退房
            data[@"isValid"]  = @"";//0 无效 1有效
        }
            break;
        case 1:{
            data[@"cusState"] = @"0";//0 报备成功 2到访 4认筹 5认购 6签约 7退房
            data[@"isValid"]  = @"1";//0 无效 1有效
        }
            break;
        case 2:{
            data[@"cusState"] = @"2";//0 报备成功 2到访 4认筹 5认购 6签约 7退房
            data[@"isValid"]  = @"1";//0 无效 1有效
        }
            break;
        case 3:{
            data[@"cusState"] = @"4";//0 报备成功 2到访 4认筹 5认购 6签约 7退房
            data[@"isValid"]  = @"1";//0 无效 1有效
        }
            break;
        case 4:{
            data[@"cusState"] = @"5";//0 报备成功 2到访 4认筹 5认购 6签约 7退房
            data[@"isValid"]  = @"1";//0 无效 1有效
        }
            break;
        case 5:{
            data[@"cusState"] = @"6";//0 报备成功 2到访 4认筹 5认购 6签约 7退房
            data[@"isValid"]  = @"1";//0 无效 1有效
        }
            break;
        case 6:{
            data[@"cusState"] = @"7";//0 报备成功 2到访 4认筹 5认购 6签约 7退房
            data[@"isValid"]  = @"1";//0 无效 1有效
        }
            break;
        case 7:{
            data[@"cusState"] = @"";//0 报备成功 2到访 4认筹 5认购 6签约 7退房
            data[@"isValid"]  = @"0";//0 无效 1有效
        }
            break;
            
        default:
            break;
    }
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
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusbaobeilist/getShowroomAgentsCus" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.rightTableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCBrokerClient class] json:responseObject[@"data"]];
                [strongSelf.clients addObjectsFromArray:arrt];
            }else{
                [strongSelf.rightTableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCBrokerClient class] json:responseObject[@"data"]];
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.clietNumInfo?8:0;
    }else{
        return self.clients.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:{
                cell.clientState.text = @"全部客户";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"totalNum"]];
            }
                break;
            case 1:{
                cell.clientState.text = @"已报备";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiReportNum"]];
            }
                break;
            case 2:{
                cell.clientState.text = @"已到访";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiVisitNum"]];
            }
                break;
            case 3:{
                cell.clientState.text = @"已认筹";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiRecognitionNum"]];
            }
                break;
            case 4:{
                cell.clientState.text = @"已认购";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiSubscribeNum"]];
            }
                break;
            case 5:{
                cell.clientState.text = @"已签约";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiSignNum"]];
            }
                break;
            case 6:{
                cell.clientState.text = @"已退房";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiAbolishNum"]];
            }
                break;
            case 7:{
                cell.clientState.text = @"已失效";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiInvalidNum"]];
            }
                break;
                
            default:
                break;
        }
        return cell;
    }else{
        RCBrokerClientCell *cell = [tableView dequeueReusableCellWithIdentifier:BrokerClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cusState.hidden = YES;
        RCBrokerClient *client = self.clients[indexPath.row];
        cell.client = client;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.leftTableView) {
        return 75.f;
    }else{
        return 130.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        self.selectIndex = indexPath.row;
        hx_weakify(self);
        [self getBrokerClientRequest:YES completeCall:^{
            hx_strongify(weakSelf);
            [strongSelf.rightTableView reloadData];
        }];
    }
}

@end

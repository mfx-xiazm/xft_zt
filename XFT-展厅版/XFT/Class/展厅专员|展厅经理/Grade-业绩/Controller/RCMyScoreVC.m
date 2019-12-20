//
//  RCMyScoreVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyScoreVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "RCMyPerformance.h"

@interface RCMyScoreVC ()<JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *titleCategoryView;
/* 报备业绩-报备录入(组) */
@property(nonatomic,weak) IBOutlet UILabel *baobeiCount;
/* 转访业绩-报备转访(组) */
@property(nonatomic,weak) IBOutlet UILabel *baobeiVisitCount;
/* 成交业绩-认筹笔数(笔) */
@property(nonatomic,weak) IBOutlet UILabel *identify;
/* 成交业绩-认筹金额(万) */
@property(nonatomic,weak) IBOutlet UILabel *identifyAmount;
/* 成交业绩-认购数(笔) */
@property(nonatomic,weak) IBOutlet UILabel *subscriptionCount;
/* 成交业绩-认购额(万) */
@property(nonatomic,weak) IBOutlet UILabel *subscriptionAmount;
/* 成交业绩-签约数(笔) */
@property(nonatomic,weak) IBOutlet UILabel *dealCount;
/* 成交业绩-签约额(万) */
@property(nonatomic,weak) IBOutlet UILabel *dealAmount;
/* 成交业绩-回款金额(万) */
@property(nonatomic,weak) IBOutlet UILabel *paybackAmount;
/* 业绩 */
@property(nonatomic,strong) RCMyPerformance *performance;
@end

@implementation RCMyScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的业绩"];
    [self setUpCategoryView];
    [self startShimmer];
    [self getPerformanceRequest];
}
-(void)setUpCategoryView
{
    _titleCategoryView.backgroundColor = [UIColor whiteColor];
    _titleCategoryView.titleLabelZoomEnabled = NO;
    _titleCategoryView.titles = @[@"今日", @"本周", @"本月", @"本季", @"本年"];
    _titleCategoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _titleCategoryView.titleColor = UIColorFromRGB(0x666666);
    _titleCategoryView.titleSelectedColor = HXControlBg;
    _titleCategoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _titleCategoryView.indicators = @[lineView];
}
#pragma mark - JXCategoryViewDelegate
// 点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    [self getPerformanceRequest];
}
#pragma markk -- 接口请求
-(void)getPerformanceRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.titleCategoryView.selectedIndex == 0) {
        data[@"type"] = @"1";//时间类型 1.今日 2.本周 3.本月 4.本年 5.本季度
    }else if (self.titleCategoryView.selectedIndex == 1) {
        data[@"type"] = @"2";//时间类型 1.今日 2.本周 3.本月 4.本年 5.本季度
    }else if (self.titleCategoryView.selectedIndex == 2) {
        data[@"type"] = @"3";//时间类型 1.今日 2.本周 3.本月 4.本年 5.本季度
    }else if (self.titleCategoryView.selectedIndex == 3) {
        data[@"type"] = @"5";//时间类型 1.今日 2.本周 3.本月 4.本年 5.本季度
    }else{
        data[@"type"] = @"4";//时间类型 1.今日 2.本周 3.本月 4.本年 5.本季度
    }
    parameters[@"data"] = data;
    
    [MBProgressHUD showLoadToView:nil title:@"加载中..."];
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/universalChannel/myPerformanceByZy" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD hideHUD];
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.performance = [RCMyPerformance yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showPerformanceInfo];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showPerformanceInfo
{
    /* 报备业绩-报备录入(组) */
    self.baobeiCount.text = (self.performance.baobeiCount && self.performance.baobeiCount.length)?self.performance.baobeiCount:@"0";
    /* 转访业绩-报备转访(组) */
    self.baobeiVisitCount.text = (self.performance.baobeiVisitCount && self.performance.baobeiVisitCount.length)?self.performance.baobeiVisitCount:@"0";
    /* 成交业绩-认筹笔数(笔) */
    self.identify.text = (self.performance.identify && self.performance.identify.length)?self.performance.identify:@"0";
    /* 成交业绩-认筹金额(万) */
    self.identifyAmount.text = (self.performance.identifyAmount && self.performance.identifyAmount.length)?self.performance.identifyAmount:@"0";
    /* 成交业绩-认购数(笔) */
    self.subscriptionCount.text = (self.performance.subscriptionCount && self.performance.subscriptionCount.length)?self.performance.subscriptionCount:@"0";
    /* 成交业绩-认购额(万) */
    self.subscriptionAmount.text = (self.performance.subscriptionAmount && self.performance.subscriptionAmount.length)?self.performance.subscriptionAmount:@"0";
    /* 成交业绩-签约数(笔) */
    self.dealCount.text = (self.performance.dealCount && self.performance.dealCount.length)?self.performance.dealCount:@"0";
    /* 成交业绩-签约额(万) */
    self.dealAmount.text = (self.performance.dealAmount && self.performance.dealAmount.length)?self.performance.dealAmount:@"0";
    /* 成交业绩-回款金额(万) */
    self.paybackAmount.text = (self.performance.paybackAmount && self.performance.paybackAmount.length)?self.performance.paybackAmount:@"0";
}
@end

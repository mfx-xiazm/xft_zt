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

@interface RCMyScoreVC ()<JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *titleCategoryView;

@end

@implementation RCMyScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的业绩"];
    [self setUpCategoryView];
}
-(void)setUpCategoryView
{
    _titleCategoryView.backgroundColor = [UIColor whiteColor];
    _titleCategoryView.titleLabelZoomEnabled = NO;
    _titleCategoryView.titles = @[@"今日", @"本周", @"本月", @"本年", @"全部", @"自定义"];
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
    
}
@end

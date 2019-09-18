//
//  RCTaskTotalHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskTotalHeader.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>

@interface RCTaskTotalHeader ()<JXCategoryViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;

@end
@implementation RCTaskTotalHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpCategoryView];
}

-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.averageCellSpacingEnabled = NO;
    _categoryView.titles = @[@"报备量", @"到访量", @"成交量"];
    _categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _categoryView.titleColor = UIColorFromRGB(0x666666);
    _categoryView.titleSelectedColor = HXControlBg;
    _categoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
}
#pragma mark - JXCategoryViewDelegate
// 点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    
}
@end

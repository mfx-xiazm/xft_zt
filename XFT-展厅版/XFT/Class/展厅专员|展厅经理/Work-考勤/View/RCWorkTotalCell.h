//
//  RCWorkTotalCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTaskStatistics,RCPinStatistics;
@interface RCWorkTotalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *threeTitleView;
@property (weak, nonatomic) IBOutlet UIView *fourTitleView;
/* 任务统计 */
@property(nonatomic,strong) RCTaskStatistics *statistic;
/* 考勤统计 */
@property(nonatomic,strong) RCPinStatistics *pinStatistic;
@end

NS_ASSUME_NONNULL_END

//
//  RCWorkTotalCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCWorkTotalCell.h"
#import "RCTaskStatistics.h"
#import "RCPinStatistics.h"

@interface RCWorkTotalCell ()
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *baobeiCount;
@property (weak, nonatomic) IBOutlet UILabel *visitCount;
@property (weak, nonatomic) IBOutlet UILabel *dealCount;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *taskClockCount;
@property (weak, nonatomic) IBOutlet UILabel *attendanceClockCount;

@end
@implementation RCWorkTotalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setStatistic:(RCTaskStatistics *)statistic
{
    _statistic = statistic;
    self.taskName.text = _statistic.taskName;
    self.baobeiCount.text = _statistic.baobeiCount;
    self.visitCount.text = _statistic.visitCount;
    self.dealCount.text = _statistic.dealCount;
}
-(void)setPinStatistic:(RCPinStatistics *)pinStatistic
{
    _pinStatistic = pinStatistic;
    self.name.text = _pinStatistic.name;
    self.taskClockCount.text = _pinStatistic.taskClockCount;
    self.attendanceClockCount.text = _pinStatistic.attendanceClockCount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

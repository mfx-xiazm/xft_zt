//
//  RCTaskDetailCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskDetailCell.h"
#import "RCTaskStaff.h"
#import "RCTaskDayInfo.h"

@interface RCTaskDetailCell ()
@property (weak, nonatomic) IBOutlet UIView *dayInfoView;
@property (weak, nonatomic) IBOutlet UIView *staffView;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *clientCount;
@property (weak, nonatomic) IBOutlet UILabel *firTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *pinCount;

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *dayPinCount;

@end
@implementation RCTaskDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setStaff:(RCTaskStaff *)staff
{
    _staff = staff;
    self.name.text = _staff.accName;
    self.clientCount.text = _staff.pioneerCount;
    self.firTime.text = _staff.startTime;
    self.endTime.text = _staff.endTime;
    self.pinCount.text = _staff.clockInCount;
}
-(void)setDayInfo:(RCTaskDayInfo *)dayInfo
{
    _dayInfo = dayInfo;
    self.dayInfoView.hidden = NO;
    self.staffView.hidden = YES;
    self.date.text = _dayInfo.dateTime;
    self.dayPinCount.text = _dayInfo.clockInCount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  RCTaskDetailCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTaskStaff,RCTaskDayInfo;
@interface RCTaskDetailCell : UITableViewCell
/* 任务人员 */
@property(nonatomic,strong) RCTaskStaff *staff;
/* 考勤列表 */
@property(nonatomic,strong) RCTaskDayInfo *dayInfo;
@end

NS_ASSUME_NONNULL_END

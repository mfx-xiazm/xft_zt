//
//  RCTaskReportVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class RCTask;
typedef void(^taskReportActionCall)(NSInteger num);
@interface RCTaskReportVC : HXBaseViewController
/* 任务 */
@property(nonatomic,strong) RCTask *task;
/* 点击 */
@property(nonatomic,copy) taskReportActionCall taskReportActionCall;
@end

NS_ASSUME_NONNULL_END

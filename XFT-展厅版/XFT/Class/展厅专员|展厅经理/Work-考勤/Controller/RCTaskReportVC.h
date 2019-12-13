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
@interface RCTaskReportVC : HXBaseViewController
/* 任务 */
@property(nonatomic,strong) RCTask *task;
@end

NS_ASSUME_NONNULL_END

//
//  RCTaskPinVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RCTask;
typedef void(^taskPinActionCall)(void);
@interface RCTaskPinVC : HXBaseViewController
/* 任务 */
@property(nonatomic,strong) RCTask *task;
/* 点击 */
@property(nonatomic,copy) taskPinActionCall taskPinActionCall;
@end

NS_ASSUME_NONNULL_END

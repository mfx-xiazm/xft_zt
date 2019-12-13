//
//  RCTaskWorkIngCell1.h
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTask;
typedef void(^taskWorkCall)(NSInteger index);
@interface RCTaskWorkIngCell1 : UITableViewCell
/* 任务打卡、报备 */
@property(nonatomic,copy) taskWorkCall taskWorkCall;
/* 任务 */
@property(nonatomic,strong) RCTask *task;
@end

NS_ASSUME_NONNULL_END

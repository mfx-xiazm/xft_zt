//
//  RCTaskDetailVC1.h
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^taskInfoActionCall)(NSInteger type,NSInteger num);
@interface RCTaskDetailVC1 : HXBaseViewController
/* uuid */
@property(nonatomic,copy) NSString *uuid;
/* 任务状态 */
@property(nonatomic,copy) NSString *state;
/* 点击 1打卡 2拓组 */
@property(nonatomic,copy) taskInfoActionCall taskInfoActionCall;
@end

NS_ASSUME_NONNULL_END

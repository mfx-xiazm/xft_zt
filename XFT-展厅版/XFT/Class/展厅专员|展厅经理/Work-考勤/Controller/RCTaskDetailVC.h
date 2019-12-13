//
//  RCTaskDetailVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^stopTaskCall)(void);
@interface RCTaskDetailVC : HXBaseViewController
/* uuid */
@property(nonatomic,copy) NSString *uuid;
/* 任务状态 */
@property(nonatomic,copy) NSString *state;
/* 终止 */
@property(nonatomic,copy) stopTaskCall stopTaskCall;
@end

NS_ASSUME_NONNULL_END

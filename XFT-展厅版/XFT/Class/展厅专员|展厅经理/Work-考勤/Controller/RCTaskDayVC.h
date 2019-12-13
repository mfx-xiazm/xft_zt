//
//  RCTaskDayVC.h
//  XFT
//
//  Created by 夏增明 on 2019/12/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCTaskDayVC : HXBaseViewController
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
/* 拓客人员id */
@property(nonatomic,copy) NSString *cusUuid;
/* 任务id */
@property(nonatomic,copy) NSString *taskUuid;
/* 拓客名字 */
@property(nonatomic,copy) NSString *accName;
@end

NS_ASSUME_NONNULL_END

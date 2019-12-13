//
//  RCPinNoteVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCPinNoteVC : HXBaseViewController
/** 限制最小时间 */
@property (nonatomic, copy) NSString *minLimitDate;
/** 限制最大时间 */
@property (nonatomic, copy) NSString *maxLimitDate;
/** 任务uuid */
@property(nonatomic,copy) NSString *taskUuid;
@end

NS_ASSUME_NONNULL_END

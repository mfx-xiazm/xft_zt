//
//  RCPinDetailVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCPinDetailVC : HXBaseViewController
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
/* 拓客人员id */
@property(nonatomic,copy) NSString *accUuid;
/* 任务id */
@property(nonatomic,copy) NSString *taskUuid;
/* 时间 */
@property(nonatomic,copy) NSString *dateTime;
/* 拓客名字 */
@property(nonatomic,copy) NSString *accName;
@end

NS_ASSUME_NONNULL_END

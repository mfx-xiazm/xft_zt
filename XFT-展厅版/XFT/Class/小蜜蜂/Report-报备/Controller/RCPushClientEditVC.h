//
//  RCPushClientEditVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RCReportTarget;
typedef void(^editDoneCall)(void);
@interface RCPushClientEditVC : HXBaseViewController
/* 编辑客户 */
@property(nonatomic,strong) RCReportTarget *reportTarget;
/* 客户编辑完成 */
@property(nonatomic,copy) editDoneCall editDoneCall;
@end

NS_ASSUME_NONNULL_END

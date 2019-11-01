//
//  RCRenewRemarkVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^renewReamrkCall)(NSString *remarkTime,NSString *remark);
@interface RCRenewRemarkVC : HXBaseViewController
/* 客户uuid */
@property(nonatomic,copy) NSString *cusUuid;
/* 客户名字 */
@property(nonatomic,copy) NSString *nameStr;
/* 客户电话 */
@property(nonatomic,copy) NSString *phoneStr;
/* 备注时间 */
@property(nonatomic,copy) NSString *remarkTimeStr;
/* 备注更新回调 */
@property(nonatomic,copy) renewReamrkCall renewReamrkCall;
@end

NS_ASSUME_NONNULL_END

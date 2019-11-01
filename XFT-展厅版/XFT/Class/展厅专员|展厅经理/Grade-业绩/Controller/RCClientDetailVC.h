//
//  RCClientDetailVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^updateReamrkCall)(NSString *remarkTime,NSString *remark);
@interface RCClientDetailVC : HXBaseViewController
/* 客户uuid */
@property(nonatomic,copy) NSString *cusUuid;
/* 客户状态 0-6*/
@property(nonatomic,assign) NSInteger cusType;
/* 更新备注 */
@property(nonatomic,copy) updateReamrkCall updateReamrkCall;
@end

NS_ASSUME_NONNULL_END

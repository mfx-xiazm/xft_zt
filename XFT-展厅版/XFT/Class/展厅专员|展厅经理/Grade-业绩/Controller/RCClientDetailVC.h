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
typedef void(^followCall)(void);
@interface RCClientDetailVC : HXBaseViewController
/* 报备uuid */
@property(nonatomic,copy) NSString *uuid;
/* 客户uuid */
@property(nonatomic,copy) NSString *cusUuid;
/* 客户状态 0-6*/
@property(nonatomic,assign) NSInteger cusType;
/* 更新备注 */
@property(nonatomic,copy) updateReamrkCall updateReamrkCall;
/* 关注客户 */
@property(nonatomic,copy) followCall followCall;
@end

NS_ASSUME_NONNULL_END

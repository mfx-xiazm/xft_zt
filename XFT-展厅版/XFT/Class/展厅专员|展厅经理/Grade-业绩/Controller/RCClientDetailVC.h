//
//  RCClientDetailVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface RCClientDetailVC : HXBaseViewController
/* 客户uuid */
@property(nonatomic,copy) NSString *cusUuid;
/* 客户状态 0-6*/
@property(nonatomic,assign) NSInteger cusType;
@end

NS_ASSUME_NONNULL_END

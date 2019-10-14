//
//  RCClientDetailInfoVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RCMyClient;
@interface RCClientDetailInfoVC : HXBaseViewController
/* 客户 */
@property(nonatomic,strong) RCMyClient *client;
@end

NS_ASSUME_NONNULL_END

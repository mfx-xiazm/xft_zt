//
//  RCStoreClientVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCStoreClientVC : HXBaseViewController
/* 中介uuid */
@property(nonatomic,copy) NSString *agentUuid;
/* 门店uuid */
@property(nonatomic,copy) NSString *storeUuid;
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
@end

NS_ASSUME_NONNULL_END

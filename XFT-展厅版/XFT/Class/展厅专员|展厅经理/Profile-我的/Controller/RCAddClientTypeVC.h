//
//  RCAddClientTypeVC.h
//  XFT
//
//  Created by 夏增明 on 2019/12/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^addTypeCall)(void);
@interface RCAddClientTypeVC : HXBaseViewController
/* 点击 */
@property(nonatomic,copy) addTypeCall addTypeCall;
@end

NS_ASSUME_NONNULL_END

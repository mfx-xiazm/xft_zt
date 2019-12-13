//
//  RCRegisterVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^registerCall)(void);
@interface RCRegisterVC : HXBaseViewController
/* 二维码字符串 */
@property(nonatomic,copy) NSString *codeStr;
/* 注册 */
@property(nonatomic,copy) registerCall registerCall;
@end

NS_ASSUME_NONNULL_END

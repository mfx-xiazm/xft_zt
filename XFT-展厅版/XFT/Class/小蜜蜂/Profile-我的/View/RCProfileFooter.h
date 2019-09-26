//
//  RCProfileFooter.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^logOutCall)(void);
@interface RCProfileFooter : UIView
/* 退出 */
@property(nonatomic,copy) logOutCall logOutCall;
@end

NS_ASSUME_NONNULL_END

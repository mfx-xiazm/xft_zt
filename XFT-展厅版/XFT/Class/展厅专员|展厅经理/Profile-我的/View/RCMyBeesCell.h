//
//  RCMyBeesCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMyBee;
typedef void(^resetPwdActionCall)(void);
@interface RCMyBeesCell : UITableViewCell
/* 小蜜蜂 */
@property(nonatomic,strong) RCMyBee *bee;
/* 点击 */
@property(nonatomic,copy) resetPwdActionCall resetPwdActionCall;
@end

NS_ASSUME_NONNULL_END

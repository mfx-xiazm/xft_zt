//
//  RCMyBrokerCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyBroker;
typedef void(^phoneClickedCall)(void);
@interface RCMyBrokerCell : UITableViewCell
/* 经纪人 */
@property(nonatomic,strong) RCMyBroker *broker;
/* 点击 */
@property(nonatomic,copy) phoneClickedCall phoneClickedCall;
@end

NS_ASSUME_NONNULL_END

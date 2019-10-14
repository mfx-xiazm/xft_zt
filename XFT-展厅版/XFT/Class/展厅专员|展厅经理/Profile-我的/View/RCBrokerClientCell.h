//
//  RCBrokerClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCBrokerClient;
@interface RCBrokerClientCell : UITableViewCell
/* 客户 */
@property(nonatomic,strong) RCBrokerClient *client;
@end

NS_ASSUME_NONNULL_END

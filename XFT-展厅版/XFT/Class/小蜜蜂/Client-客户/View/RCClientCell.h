//
//  RCClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCBeeClient;
@interface RCClientCell : UITableViewCell
/* 客户 */
@property(nonatomic,strong) RCBeeClient *client;
@end

NS_ASSUME_NONNULL_END

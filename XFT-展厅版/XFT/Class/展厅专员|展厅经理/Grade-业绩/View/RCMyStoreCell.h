//
//  RCMyStoreCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMyAgent;
@interface RCMyStoreCell : UITableViewCell
/* 中介 */
@property(nonatomic,strong) RCMyAgent *agent;
@end

NS_ASSUME_NONNULL_END

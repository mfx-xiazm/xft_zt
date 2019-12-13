//
//  RCMoveClientFromCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMoveClient;
typedef void(^targetSelectCall)(void);
@interface RCMoveClientFromCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zyName;
/* 专员客户 */
@property(nonatomic,strong) RCMoveClient *client;
/* 选中 */
@property(nonatomic,copy) targetSelectCall targetSelectCall;
@end

NS_ASSUME_NONNULL_END

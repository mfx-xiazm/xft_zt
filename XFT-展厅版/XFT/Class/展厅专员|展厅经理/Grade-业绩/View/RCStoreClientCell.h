//
//  RCStoreClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCStoreClient;
@interface RCStoreClientCell : UITableViewCell
/* 客户 */
@property(nonatomic,strong) RCStoreClient *client;
@end

NS_ASSUME_NONNULL_END

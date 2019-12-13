//
//  RCNoticeCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseNotice;
@interface RCNoticeCell : UITableViewCell
/* 公告 */
@property(nonatomic,strong) RCHouseNotice *notice;
@end

NS_ASSUME_NONNULL_END

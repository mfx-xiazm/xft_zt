//
//  RCTaskWorkCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTask;
@interface RCTaskWorkCell : UITableViewCell
/* 任务 */
@property(nonatomic,strong) RCTask *task;
@end

NS_ASSUME_NONNULL_END

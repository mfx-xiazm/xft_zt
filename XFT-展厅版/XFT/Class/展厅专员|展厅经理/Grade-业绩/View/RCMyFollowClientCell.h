//
//  RCMyFollowClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyFollow;
typedef void(^fillowHandleCall)(NSInteger index);
@interface RCMyFollowClientCell : UITableViewCell
/* 目标控制器 */
@property (nonatomic,weak) UIViewController *target;
/* z关注客户 */
@property(nonatomic,strong) RCMyFollow *follow;
/* 操作点击 */
@property(nonatomic,copy) fillowHandleCall fillowHandleCall;
@end

NS_ASSUME_NONNULL_END

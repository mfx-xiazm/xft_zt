//
//  RCMyClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyClient;
typedef void(^clientHandleCall)(NSInteger index);
@interface RCMyClientCell : UITableViewCell
/* 目标控制器 */
@property (nonatomic,weak) UIViewController *target;
/* 客户类别 0-7 */
@property(nonatomic,assign) NSInteger cusType;
/* 客户 */
@property(nonatomic,strong) RCMyClient *client;
/* 底部操作视图 */
@property (weak, nonatomic) IBOutlet UIView *handleToolView;
/* 底部操作视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleToolViewHeight;
/* 操作点击 */
@property(nonatomic,copy) clientHandleCall clientHandleCall;
@end

NS_ASSUME_NONNULL_END

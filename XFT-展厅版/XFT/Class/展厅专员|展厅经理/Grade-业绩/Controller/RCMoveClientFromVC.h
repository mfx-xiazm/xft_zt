//
//  RCMoveClientFromVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class RCTaskMember,RCTaskAgentMember;
@interface RCMoveClientFromVC : HXBaseViewController
/* 选择的要转移的专员 */
@property(nonatomic,strong) RCTaskAgentMember *selectMoveAgent;
/* 选择的要转移的专员的所属的团队 */
@property(nonatomic,strong) RCTaskMember *selectMoveAgentTeam;
@end

NS_ASSUME_NONNULL_END

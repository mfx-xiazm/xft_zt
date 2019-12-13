//
//  RCMoveClientVC.h
//  XFT
//
//  Created by 夏增明 on 2019/12/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class RCTaskMember,RCTaskAgentMember;
@interface RCMoveClientVC : HXBaseViewController
/* 选择的要转移的专员 */
@property(nonatomic,strong) RCTaskAgentMember *selectMoveAgent;
/* 选择的要转移的专员的所属的团队 */
@property(nonatomic,strong) RCTaskMember *selectMoveAgentTeam;
/* 选择的要转出的客户 */
@property(nonatomic,strong) NSArray *clients;
@end

NS_ASSUME_NONNULL_END

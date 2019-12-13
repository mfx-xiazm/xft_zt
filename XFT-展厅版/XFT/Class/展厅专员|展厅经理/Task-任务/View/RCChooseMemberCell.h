//
//  RCChooseMemberCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTaskAgentMember;
typedef void(^selectedCall)(void);
@interface RCChooseMemberCell : UITableViewCell
/* 专员 */
@property(nonatomic,strong) RCTaskAgentMember *agentMember;
/* 选择的要转移的专员 */
@property(nonatomic,strong) RCTaskAgentMember *selectMoveAgent;
/* 点击 */
@property(nonatomic,copy) selectedCall selectedCall;
@end

NS_ASSUME_NONNULL_END

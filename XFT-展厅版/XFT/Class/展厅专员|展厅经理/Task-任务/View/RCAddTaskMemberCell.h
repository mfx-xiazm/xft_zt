//
//  RCAddTaskMemberCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTaskAgentMember;
@interface RCAddTaskMemberCell : UICollectionViewCell
/* 人员 */
@property(nonatomic,strong) RCTaskAgentMember *member;
@end

NS_ASSUME_NONNULL_END

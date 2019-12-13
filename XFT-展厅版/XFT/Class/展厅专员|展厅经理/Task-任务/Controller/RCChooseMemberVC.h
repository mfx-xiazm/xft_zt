//
//  RCChooseMemberVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^chooseMemberCall)(NSArray *selectMembers,NSArray *members);
@interface RCChooseMemberVC : HXBaseViewController
/* 专员数组 */
@property(nonatomic,strong) NSArray *members;
/* 点击 */
@property(nonatomic,copy) chooseMemberCall chooseMemberCall;
@end

NS_ASSUME_NONNULL_END

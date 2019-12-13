//
//  RCChooseMemberHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTaskMember;
typedef void(^expandCall)(void);
typedef void(^checkAllCall)(void);
@interface RCChooseMemberHeader : UIView
/* 小组 */
@property(nonatomic,strong) RCTaskMember *member;
/* 点击 */
@property(nonatomic,copy) expandCall expandCall;
/* 点击 */
@property(nonatomic,copy) checkAllCall checkAllCall;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;

@end

NS_ASSUME_NONNULL_END

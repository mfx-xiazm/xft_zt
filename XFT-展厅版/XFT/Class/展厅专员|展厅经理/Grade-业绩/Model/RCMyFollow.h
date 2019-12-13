//
//  RCMyFollow.h
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyFollow : NSObject
/* 报备保护逾期时间 */
@property(nonatomic,copy) NSString *baobeiYuqiTime;
/* 报备时间 */
@property(nonatomic,copy) NSString *createTime;
/* 头像 */
@property(nonatomic,copy) NSString *cusPic;
/* 用户状态(0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 8:失效) */
@property(nonatomic,assign) NSInteger cusState;
/* 客户uuid */
@property(nonatomic,copy) NSString *cusUuid;
/* 是否关注 0不是 1是 */
@property(nonatomic,copy) NSString *isLove;
/* 是否有效 0 无效 1 有效 */
@property(nonatomic,copy) NSString *isValid;
/* 最近到访时间 */
@property(nonatomic,copy) NSString *lastVistTime;
/* 姓名 */
@property(nonatomic,copy) NSString *name;
/* 手机号 */
@property(nonatomic,copy) NSString *phone;
/* 项目名称 */
@property(nonatomic,copy) NSString *proName;
/* 项目uuid */
@property(nonatomic,copy) NSString *proUuid;
/* 备注内容 */
@property(nonatomic,copy) NSString *remark;
/* 最后备注时间 */
@property(nonatomic,copy) NSString *time;
/* 拓客方式 */
@property(nonatomic,copy) NSString *twoQudaoName;
/* 报备uuid */
@property(nonatomic,copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END

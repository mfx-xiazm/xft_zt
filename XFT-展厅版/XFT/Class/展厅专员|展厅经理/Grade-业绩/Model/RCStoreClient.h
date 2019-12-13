//
//  RCStoreClient.h
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCStoreClient : NSObject
/* 报备人名称 */
@property(nonatomic,copy) NSString *accName;
/* 报备人类型, 5:统一报备人 6:门店管理员 7:门店经纪人 */
@property(nonatomic,copy) NSString *accType;
/* 报备人uuid */
@property(nonatomic,copy) NSString *accUuid;
/* 报备时间 */
@property(nonatomic,copy) NSString *createTime;
/* 客户状态 0:报备,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效 */
@property(nonatomic,copy) NSString *cusState;
/* 顾问归属小组名称 */
@property(nonatomic,copy) NSString *groupName;
/* 失效时间 */
@property(nonatomic,copy) NSString *invalidTime;
/* 到访时间 */
@property(nonatomic,copy) NSString *lastVistTime;
/* 客户名称 */
@property(nonatomic,copy) NSString *name;
/* 顾问名称 */
@property(nonatomic,copy) NSString *salesName;
/* 顾问uuid */
@property(nonatomic,copy) NSString *salesUuid;
/* 客户性别 0:未知 1:男 2:女 */
@property(nonatomic,copy) NSString *sex;
/* 归属团队名称 */
@property(nonatomic,copy) NSString *teamName;
/* 交易时间(认筹 /认购 /签约 /退房) */
@property(nonatomic,copy) NSString *transTime;
/* 报备uuid */
@property(nonatomic,copy) NSString *uuid;
@end

NS_ASSUME_NONNULL_END

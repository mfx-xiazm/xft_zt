//
//  RCBeesWork.h
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCBeesWork : NSObject
/* 小蜜蜂uuid */
@property(nonatomic,copy) NSString *accUuid;
/* 添加时间 */
@property(nonatomic,copy) NSString *createTime;
/* 客户姓名 */
@property(nonatomic,copy) NSString *cusName;
/* 手机号 */
@property(nonatomic,copy) NSString *cusPhone;
/* 上报人姓名 */
@property(nonatomic,copy) NSString *name;
/* 报备uuid */
@property(nonatomic,copy) NSString *uuid;
/* 客户头像 */
@property(nonatomic,copy) NSString *showroomBeeCusPic;
/* 报备项目uuid */
@property(nonatomic,copy) NSString *proUuid;
/* 报备项目名称 */
@property(nonatomic,copy) NSString *proName;
/* 客户备注 */
@property(nonatomic,copy) NSString *cusRemarks;
/* 客户身份证 */
@property(nonatomic,copy) NSString *idNo;
@end

NS_ASSUME_NONNULL_END

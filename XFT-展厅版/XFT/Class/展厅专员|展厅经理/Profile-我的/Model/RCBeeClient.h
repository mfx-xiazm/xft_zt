//
//  RCBeeClient.h
//  XFT
//
//  Created by 夏增明 on 2019/12/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCBeeClient : NSObject
@property(nonatomic,copy) NSString *accUuid;
@property(nonatomic,copy) NSString *baobeiRemarks;
@property(nonatomic,copy) NSString *createTime;
/** 0：小蜜蜂报备 1:专员放弃报备 2：专员报备成功 3：专员报备失败 */
@property(nonatomic,copy) NSString *cusBaobeiState;
/** 报备客户姓名 */
@property(nonatomic,copy) NSString *cusName;
/** 报备客户电话 */
@property(nonatomic,copy) NSString *cusPhone;
@property(nonatomic,copy) NSString *cusRemarks;
@property(nonatomic,copy) NSString *cusSex;
@property(nonatomic,copy) NSString *editTime;
@property(nonatomic,copy) NSString *isDel;
/** 报备项目名称 */
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *proUuid;
@property(nonatomic,copy) NSString *state;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *xqzyAccUuid;

@end

NS_ASSUME_NONNULL_END

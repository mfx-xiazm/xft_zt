//
//  RCBrokerClient.h
//  XFT
//
//  Created by 夏增明 on 2019/10/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCBrokerClient : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * cusUuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * baobeiTime;
@property (nonatomic, strong) NSString * lastVistTime;
@property (nonatomic, strong) NSString * transTime;
@property (nonatomic, strong) NSString * invalidTime;
@property (nonatomic, strong) NSString * isValid;
@property (nonatomic, strong) NSString * cusState;
@property (nonatomic, strong) NSString * phone;

/* 客户状态 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 其他101:已失效 */
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END

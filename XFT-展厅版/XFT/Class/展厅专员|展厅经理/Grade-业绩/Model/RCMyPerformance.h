//
//  RCMyPerformance.h
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyPerformance : NSObject
/* 报备业绩-报备录入(组) */
@property(nonatomic,copy) NSString *baobeiCount;
/* 转访业绩-报备转访(组) */
@property(nonatomic,copy) NSString *baobeiVisitCount;
/* 成交业绩-认筹笔数(笔) */
@property(nonatomic,copy) NSString *identify;
/* 成交业绩-认筹金额(万) */
@property(nonatomic,copy) NSString *identifyAmount;
/* 成交业绩-认购数(笔) */
@property(nonatomic,copy) NSString *subscriptionCount;
/* 成交业绩-认购额(万) */
@property(nonatomic,copy) NSString *subscriptionAmount;
/* 成交业绩-签约数(笔) */
@property(nonatomic,copy) NSString *dealCount;
/* 成交业绩-签约额(万) */
@property(nonatomic,copy) NSString *dealAmount;
/* 成交业绩-回款金额(万) */
@property(nonatomic,copy) NSString *paybackAmount;
@end

NS_ASSUME_NONNULL_END

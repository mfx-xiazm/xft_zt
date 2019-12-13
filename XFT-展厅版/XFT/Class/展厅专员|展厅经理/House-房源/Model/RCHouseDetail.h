//
//  RCHouseDetail.h
//  XFT
//
//  Created by 夏增明 on 2019/12/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCHousebBaseInfo,RCHouseTopCycle,RCHouseStyle;
@interface RCHouseDetail : NSObject
/* 基础信息 */
@property(nonatomic,strong) RCHousebBaseInfo *baseInfoVo;
/* 轮播图 */
@property(nonatomic,strong) NSArray<RCHouseTopCycle *> *proPicInfoList;
/* 户型 */
@property(nonatomic,strong) NSArray<RCHouseStyle *> *responseApartment;
@end

@interface RCHousebBaseInfo : NSObject
@property(nonatomic,copy) NSString *areaInterval;
@property(nonatomic,copy) NSString *buldAddr;
@property(nonatomic,copy) NSString *buldType;
@property(nonatomic,copy) NSString *mainHuxingName;
@property(nonatomic,copy) NSString *meritsIntr;
@property(nonatomic,copy) NSString *meritsList;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *openTime;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *salesState;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *salesTel;
@property(nonatomic,assign) CGFloat longitude;
@property(nonatomic,assign) CGFloat dimension;
@end

@interface RCHouseTopCycle : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * picUrl;
@end

@interface RCHouseStyle : NSObject
@property (nonatomic, strong) NSString * buldArea;
@property (nonatomic, strong) NSString * housePic;
@property (nonatomic, strong) NSString * hxType;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * roomArea;
@property (nonatomic, strong) NSString * salesState;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString * totalPrice;
@property (nonatomic, strong) NSString * uuid;

@end
NS_ASSUME_NONNULL_END

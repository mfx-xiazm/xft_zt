//
//  RCHouseDetail.m
//  XFT
//
//  Created by 夏增明 on 2019/12/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseDetail.h"

@implementation RCHouseDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"baseInfoVo":[RCHousebBaseInfo class],
             @"proPicInfoList":[RCHouseTopCycle class],
             @"responseApartment":[RCHouseStyle class]
             };
}
@end

@implementation RCHousebBaseInfo

@end

@implementation RCHouseTopCycle

@end

@implementation RCHouseStyle

@end

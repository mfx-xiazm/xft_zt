//
//  RCClientFilter.m
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientFilter.h"

@implementation RCClientFilter
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"agentList":[RCFilterAgent class],
             @"proList":[RCFilterPro class]
             };
}
@end

@implementation RCFilterAgent

@end

@implementation RCFilterPro

@end

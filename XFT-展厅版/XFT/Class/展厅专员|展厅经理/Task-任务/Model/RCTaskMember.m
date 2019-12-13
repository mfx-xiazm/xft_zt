//
//  RCTaskMember.m
//  XFT
//
//  Created by 夏增明 on 2019/12/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskMember.h"

@implementation RCTaskMember
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":[RCTaskAgentMember class]
             };
}
@end

@implementation RCTaskAgentMember

@end

//
//  RCBeeClient.m
//  XFT
//
//  Created by 夏增明 on 2019/12/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBeeClient.h"

@implementation RCBeeClient
- (void)setCreateTime:(NSString *)createTime
{
    _createTime = [createTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
}
@end

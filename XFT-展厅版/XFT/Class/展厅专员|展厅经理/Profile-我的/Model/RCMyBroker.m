//
//  RCMyBroker.m
//  XFT
//
//  Created by 夏增明 on 2019/10/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBroker.h"

@implementation RCMyBroker
-(void)setCreateTime:(NSString *)createTime
{
    if ([createTime integerValue]>0) {
        _createTime = [createTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _createTime = @"无";
    }
}
@end

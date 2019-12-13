//
//  RCMyBee.m
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBee.h"

@implementation RCMyBee
-(void)setCreateTime:(NSString *)createTime
{
    if ([createTime integerValue]>0) {
        _createTime = [createTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _createTime = @"无";
    }
}
@end

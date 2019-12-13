//
//  RCTaskPin.m
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskPin.h"

@implementation RCTaskPin
-(void)setCreateDate:(NSString *)createDate
{
    if ([createDate integerValue]>0) {
        _createDate = [createDate getTimeFromTimestamp:@"HH:mm"];
    }else{
        _createDate = @"无";
    }
}
-(void)setCreateTime:(NSString *)createTime
{
    if ([createTime integerValue]>0) {
        _createTime = [createTime getTimeFromTimestamp:@"HH:mm"];
    }else{
        _createTime = @"无";
    }
}
@end

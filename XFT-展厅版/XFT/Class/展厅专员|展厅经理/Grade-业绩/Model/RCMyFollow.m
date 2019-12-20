//
//  RCMyFollow.m
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyFollow.h"

@implementation RCMyFollow
-(void)setCreateTime:(NSString *)createTime
{
    if ([createTime integerValue]>0) {
        _createTime = [createTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _createTime = @"无";
    }
}
-(void)setLastVistTime:(NSString *)lastVistTime
{
    if ([lastVistTime integerValue]>0) {
        _lastVistTime = [lastVistTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _lastVistTime = @"无";
    }
}

-(void)setTime:(NSString *)time
{
    if ([time integerValue]>0) {
        _time = [time getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _time = @"无";
    }
}
-(NSString *)baobeiYuqiTime
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentDateInt = [currentDate timeIntervalSince1970];

    return [NSString stringWithFormat:@"%.f",ceil(([_baobeiYuqiTime integerValue]-currentDateInt)/(3600*24))];//向上取整
}
@end

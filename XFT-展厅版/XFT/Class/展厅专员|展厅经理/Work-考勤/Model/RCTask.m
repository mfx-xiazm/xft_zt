//
//  RCTask.m
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTask.h"

@implementation RCTask
-(void)setStartTime:(NSString *)startTime
{
    if ([startTime integerValue]>0) {
        _startTime = [startTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _startTime = @"无";
    }
}
-(void)setEndTime:(NSString *)endTime
{
    if ([endTime integerValue]>0) {
        _endTime = [endTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _endTime = @"无";
    }
}
@end

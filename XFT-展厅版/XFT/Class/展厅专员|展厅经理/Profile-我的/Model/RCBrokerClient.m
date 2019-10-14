//
//  RCBrokerClient.m
//  XFT
//
//  Created by 夏增明 on 2019/10/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBrokerClient.h"

@implementation RCBrokerClient

-(void)setBaobeiTime:(NSString *)baobeiTime
{
    if ([baobeiTime integerValue]>0) {
        _baobeiTime = [baobeiTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _baobeiTime = @"无";
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
-(void)setTransTime:(NSString *)transTime
{
    if ([transTime integerValue]>0) {
        _transTime = [transTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _transTime = @"无";
    }
}
-(void)setInvalidTime:(NSString *)invalidTime
{
    if ([invalidTime integerValue]>0) {
        _invalidTime = [invalidTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _invalidTime = @"无";
    }
}

@end

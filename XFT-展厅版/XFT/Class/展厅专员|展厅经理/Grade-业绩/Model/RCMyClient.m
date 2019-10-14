//
//  RCMyClient.m
//  XFT
//
//  Created by 夏增明 on 2019/9/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClient.h"
#import "NSDate+HXNExtension.h"

@implementation RCMyClient
-(void)setRemarkTime:(NSString *)remarkTime
{
    if ([remarkTime integerValue]>0) {
        _remarkTime = [remarkTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _remarkTime = @"无";
    }
}
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

-(void)setStatus:(NSInteger)status
{
    /* status客户状态值 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 101:已失效 */
    _status = status;
    if (_status == 0) {
        /* 自定义cusType客户状态值 0报备 1到访 2认筹 3认购 4签约 5退房 6失效*/
        _cusType = 0;
    }else if (_status == 2) {
        _cusType = 1;
    }else if (_status == 4) {
        _cusType = 2;
    }else if (_status == 5) {
        _cusType = 3;
    }else if (_status == 6) {
        _cusType = 4;
    }else if (_status == 7) {
        _cusType = 5;
    }else{
        _cusType = 6;
    }
}
@end

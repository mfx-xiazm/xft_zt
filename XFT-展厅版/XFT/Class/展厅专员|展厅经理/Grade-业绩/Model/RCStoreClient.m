//
//  RCStoreClient.m
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCStoreClient.h"

@implementation RCStoreClient
-(void)setTransTime:(NSString *)transTime
{
    _transTime = [transTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
-(void)setLastVistTime:(NSString *)lastVistTime
{
    _lastVistTime = [lastVistTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
-(void)setCreateTime:(NSString *)createTime
{
    _createTime = [createTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
-(void)setInvalidTime:(NSString *)invalidTime
{
    _invalidTime = [invalidTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
@end

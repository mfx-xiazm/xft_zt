//
//  RCMoveClient.m
//  XFT
//
//  Created by 夏增明 on 2019/12/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMoveClient.h"

@implementation RCMoveClient
-(void)setCreateTime:(NSString *)createTime
{
    if ([createTime integerValue]>0) {
        _createTime = [createTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _createTime = @"";
    }
}
@end

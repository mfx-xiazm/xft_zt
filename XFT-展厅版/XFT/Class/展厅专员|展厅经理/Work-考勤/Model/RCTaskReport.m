//
//  RCTaskReport.m
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskReport.h"

@implementation RCTaskReport
-(void)setCreateTime:(NSString *)createTime
{
    if ([createTime integerValue]>0) {
        _createTime = [createTime getTimeFromTimestamp:@"yyyy-MM-dd"];
    }else{
        _createTime = @"无";
    }
}
@end

//
//  RCTaskStaff.h
//  XFT
//
//  Created by 夏增明 on 2019/12/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTaskStaff : NSObject
@property(nonatomic,copy) NSString *accName;//拓客人员
@property(nonatomic,copy) NSString *accUuid;//拓客人员uuid
@property(nonatomic,copy) NSString *clockInCount;//打卡次数
@property(nonatomic,copy) NSString *endTime;//末次
@property(nonatomic,copy) NSString *pioneerCount;//拓客量
@property(nonatomic,copy) NSString *startTime;//首次

@end

NS_ASSUME_NONNULL_END

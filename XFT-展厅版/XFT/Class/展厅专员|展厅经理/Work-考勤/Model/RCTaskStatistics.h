//
//  RCTaskStatistics.h
//  XFT
//
//  Created by 夏增明 on 2019/12/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTaskStatistics : NSObject
@property(nonatomic,copy) NSString *baobeiCount;
@property(nonatomic,copy) NSString *dealCount;
@property(nonatomic,copy) NSString *taskName;
@property(nonatomic,copy) NSString *visitCount;
@end

NS_ASSUME_NONNULL_END

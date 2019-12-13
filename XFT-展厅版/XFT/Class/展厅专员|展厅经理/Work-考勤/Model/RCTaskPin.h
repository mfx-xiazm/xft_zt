//
//  RCTaskPin.h
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTaskPin : NSObject
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *accUuid;//专员uuid
@property(nonatomic,copy) NSString *showroomUuid;//展厅uuid
@property(nonatomic,assign) CGFloat lng;//经度
@property(nonatomic,assign) CGFloat lat;//纬度
@property(nonatomic,copy) NSString *address;//地址
@property(nonatomic,copy) NSString *photo;//签到照片
@property(nonatomic,copy) NSString *type;//签到类型 1.外勤签到 2.任务签到
@property(nonatomic,copy) NSString *createDate;//签到时间

@property(nonatomic,copy) NSString *name;//签到类型
@property(nonatomic,copy) NSString *createTime;//签到时间

@end

NS_ASSUME_NONNULL_END

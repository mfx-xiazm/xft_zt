//
//  RCTask.h
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTask : NSObject
/* 拓展地点-地址 */
@property(nonatomic,copy) NSString *address;
/* 结束时间 */
@property(nonatomic,copy) NSString *endTime;
/* 已拓 */
@property(nonatomic,copy) NSString *haveVolume;
/* 拓展地点-纬度 */
@property(nonatomic,assign) CGFloat lat;
/* 拓展地点-经度 */
@property(nonatomic,assign) CGFloat lng;
/* 任务名称 */
@property(nonatomic,copy) NSString *name;
/* 打卡次数 */
@property(nonatomic,copy) NSString *signCount;
/* 开始时间 */
@property(nonatomic,copy) NSString *startTime;
/* 状态 专员：1未开始 2进行中 3已结束 经理：1.未开始 2.进行中 3.已完成 4.已终止*/
@property(nonatomic,copy) NSString *state;
/* 拓客任务量 */
@property(nonatomic,copy) NSString *volume;
/* 拓客方式 */
@property(nonatomic,copy) NSString *twoQudaoName;
/* 任务uuid */
@property(nonatomic,copy) NSString *uuid;
/* 任务uuid */
@property(nonatomic,copy) NSString *taskUuid;
/* 已拓进度 */
@property(nonatomic,copy) NSString *finished;
/* 参与人数 */
@property(nonatomic,copy) NSString *participantCount;

@property(nonatomic,copy) NSString *showroomUuid;
@property(nonatomic,copy) NSString *showroomName;
@property(nonatomic,copy) NSString *twoQudaoCode;
@property(nonatomic,copy) NSString *accCount;
@property(nonatomic,copy) NSString *createRole;
@property(nonatomic,copy) NSString *createUuid;
@property(nonatomic,copy) NSString *createName;
@property(nonatomic,copy) NSString *createTeamUuid;
@property(nonatomic,copy) NSString *createTeamName;
@property(nonatomic,copy) NSString *createGroupUuid;
@property(nonatomic,copy) NSString *createGroupName;
@end

NS_ASSUME_NONNULL_END

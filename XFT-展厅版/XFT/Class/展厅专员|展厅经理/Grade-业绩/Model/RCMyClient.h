//
//  RCMyClient.h
//  XFT
//
//  Created by 夏增明 on 2019/9/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClient : NSObject
@property (nonatomic, strong) NSString * name;//客户姓名
@property (nonatomic, strong) NSString * oneQudaoCode;//线索一级渠道编号
@property (nonatomic, strong) NSString * oneQudaoName;//线索一级渠道名称
@property (nonatomic, strong) NSString * remark;//备注
@property (nonatomic, strong) NSString * remarkTime;//最后备注时间
@property (nonatomic, strong) NSString * twoQudaoCode;//线索二级渠道编码
@property (nonatomic, strong) NSString * twoQudaoName;//线索二级渠道名称
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * cusUuid;//客户uuid
@property (nonatomic, strong) NSString * yuqiTime;//逾期时间
@property (nonatomic, strong) NSString * headpic;//用户头像
@property (nonatomic, strong) NSString * phone;//手机号
@property (nonatomic, strong) NSString * idNo;//身份证
@property (nonatomic, strong) NSString * cusLevel;//客户等级
@property (nonatomic, strong) NSString * salesUuid;//案场顾问id
@property (nonatomic, strong) NSString * salesName;//案场顾问
@property (nonatomic, strong) NSString * proUuid;//项目uuid
@property (nonatomic, strong) NSString * proName;//报备项目名称
@property (nonatomic, strong) NSString * groupUuid;//小组id
@property (nonatomic, strong) NSString * groupName;//小组名称
@property (nonatomic, strong) NSString * teamUuid;//团队id
@property (nonatomic, strong) NSString * teamName;//团队名称
@property (nonatomic, strong) NSString * isLove;//是否关注
@property (nonatomic, strong) NSString * baobeiYuqiTime;//是否关注

@property (nonatomic, strong) NSString * baobeiTime;//报备时间
@property (nonatomic, strong) NSString * lastVistTime;//最后到访时间
@property (nonatomic, strong) NSString * transTime;//列表认购，认筹，签约，退房时间
@property (nonatomic, strong) NSString * invalidTime;//失效时间
/* 客户状态 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 其他101:已失效 */
@property (nonatomic, assign) NSInteger status;//用户状态

@property (nonatomic, assign) NSInteger cusType;//自定字段，表客户状态

@property (nonatomic, strong) NSString * showroomTwoQudaoCode;//展厅线索二级渠道编码
@property (nonatomic, strong) NSString * showroomTwoQudaoName;//展厅线索二级渠道名称
@property (nonatomic, strong) NSString * accUuid;//报备人uuid
@property (nonatomic, strong) NSString * accName;//报备人姓名
@property (nonatomic, strong) NSString * accTeamUuid;//归属团队uuid
@property (nonatomic, strong) NSString * accTeamName;//归属团队名称
@property (nonatomic, strong) NSString * accGroupUuid;//归属小组uuid
@property (nonatomic, strong) NSString * accGroupName;//归属小组名称
@end
NS_ASSUME_NONNULL_END

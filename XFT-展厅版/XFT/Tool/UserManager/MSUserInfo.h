//
//  MSUserInfo.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSUserShowInfo,MSUserAccessInfo,MSUserRoles;
@interface MSUserInfo : NSObject
@property (nonatomic,strong) MSUserShowInfo *showroomLoginInside;
@property (nonatomic,strong) MSUserAccessInfo *userAccessInfo;
@property (nonatomic,strong) NSArray<MSUserRoles *> *responseCheckRoles;

@property (nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *userAccessStr;
/** 自定义的账号角色 1:展厅管理经理 2 展厅顾问专员 3展厅小蜜蜂 */
@property (nonatomic,assign) NSInteger ulevel;
/** 用户切换选择组织角色 */
@property(nonatomic,strong) MSUserRoles *selectRole;
@end

@interface MSUserShowInfo : NSObject
@property (nonatomic, strong) NSString * accNo;
/** 账号角色 1:展厅管理经理/展厅顾问专员 2:展厅小蜜蜂 */
@property (nonatomic, assign) NSInteger accRole;
@property (nonatomic, strong) NSString * addr;
@property (nonatomic, strong) NSString * bankAccNo;
@property (nonatomic, strong) NSString * bankOpen;
@property (nonatomic, strong) NSString * bankPhone;
@property (nonatomic, strong) NSString * cardNo;
@property (nonatomic, strong) NSString * cardType;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger editTime;
@property (nonatomic, strong) NSString * headpic;
@property (nonatomic, strong) NSString * idmOrgName;
@property (nonatomic, assign) NSInteger isDel;
@property (nonatomic, assign) NSInteger isIdmAcc;
@property (nonatomic, assign) NSInteger isOwner;
@property (nonatomic, assign) NSInteger isRegYgAcc;
@property (nonatomic, assign) NSInteger isStaff;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nick;
@property (nonatomic, strong) NSString * pwd;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * regPhone;
@property (nonatomic, strong) NSString * remarks;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString * uuid;
@end

@interface MSUserAccessInfo : NSObject
@property (nonatomic, strong) NSString * accessTime;
@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic, strong) NSString * bizParam;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * extParam;
@property (nonatomic, strong) NSString * ip;
@property (nonatomic, strong) NSString * loginId;
@property (nonatomic, strong) NSString * receiveTime;
@property (nonatomic, strong) NSString * traceId;
@property (nonatomic, strong) NSString * userDevice;
@property (nonatomic, strong) NSString * userLbs;
@end

@interface MSUserRoles : NSObject
/* 展厅归属集团文旅还是区域文旅 1 集团文旅 2 区域文旅 */
@property (nonatomic, strong) NSString * showRoomType;
/* 所属展厅名称 */
@property (nonatomic, strong) NSString * showRoomName;
/* 所属展厅的uuid */
@property (nonatomic, strong) NSString * showRoomUuid;
/* 所属小组的名称 */
@property (nonatomic, strong) NSString * groupName;
/* 所属小组uuid */
@property (nonatomic, strong) NSString * groupUuid;
/* 所属团队名称 */
@property (nonatomic, strong) NSString * teamName;
/* 所属团队Uuid */
@property (nonatomic, strong) NSString * teamUuid;
/* 是否展厅经理 0 否 1是 */
@property (nonatomic, assign) NSInteger isManager;
/* 是否展厅专员 0 否 1是 */
@property (nonatomic, assign) NSInteger isZy;
/* 管理角色权限 1展厅经理 2团队经理 3小组经理 */
@property (nonatomic, assign) NSInteger manageRole;
/* 是否有看中介渠道权限 0 否 1是 */
@property (nonatomic, assign) NSInteger isQudaoPem;
@property (nonatomic, strong) NSString * managerData;
@property (nonatomic, strong) NSString * managerType;
@property (nonatomic, strong) NSString * qudaoAgentData;
/* 选定的是经理还是专员 1经理 2专员 */
@property(nonatomic,assign) NSInteger roleType;
/* 是否选择该组 */
@property (nonatomic, assign) BOOL isSelected;

@end

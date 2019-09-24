//
//  MSUserInfo.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSUserShowInfo,MSUserAccessInfo,MSDropValues;
@interface MSUserInfo : NSObject
@property (nonatomic,strong) MSUserShowInfo *showroomLoginInside;
@property (nonatomic,strong) MSUserAccessInfo *userAccessInfo;
@property (nonatomic,strong) NSArray<MSDropValues *> *responOrgCheck;
@property (nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *userAccessStr;
/** 账号角色 1:展厅管理经理 2:展厅顾问专员 3:展厅小蜜蜂 */
@property (nonatomic,assign) NSInteger ulevel;
@end

@interface MSUserShowInfo : NSObject
@property (nonatomic, strong) NSString * accNo;
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

@interface MSDropValues : NSObject
@property (nonatomic, strong) NSString * orgName;
@property (nonatomic, strong) NSString * managerData;
@property (nonatomic, assign) NSInteger roleType;
@end

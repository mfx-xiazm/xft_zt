//
//  RCMyBroker.h
//  XFT
//
//  Created by 夏增明 on 2019/10/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyBroker : NSObject
@property (nonatomic, strong) NSString * headpic;
@property (nonatomic, strong) NSString * accUuid;
@property (nonatomic, strong) NSString * proUuid;
@property (nonatomic, strong) NSString * accRole;
@property (nonatomic, strong) NSString * isStaff;
@property (nonatomic, strong) NSString * isOwner;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * regPhone;
@property (nonatomic, strong) NSString * cusNum;
@property (nonatomic, strong) NSString * createTime;

@end

NS_ASSUME_NONNULL_END

//
//  RCTaskMember.h
//  XFT
//
//  Created by 夏增明 on 2019/12/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTaskAgentMember;
@interface RCTaskMember : NSObject
@property (nonatomic, strong) NSString * groupUuid;
@property (nonatomic, strong) NSString * teamUuid;
@property (nonatomic, strong) NSString * groupName;
@property (nonatomic, strong) NSString * teamName;

@property(nonatomic,strong) NSArray<RCTaskAgentMember *> *list;
/* 是否展开 */
@property(nonatomic,assign) BOOL isExpand;
/* 是否全选 */
@property(nonatomic,assign) BOOL isCheckAll;
@end

@interface RCTaskAgentMember : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * uuid;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END

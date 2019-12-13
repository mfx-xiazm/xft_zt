//
//  RCClientFilter.h
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCFilterAgent,RCFilterPro;
@interface RCClientFilter : NSObject
/* 经纪人列表 */
@property(nonatomic,strong) NSArray<RCFilterAgent *> *agentList;
/* 项目列表 */
@property(nonatomic,strong) NSArray<RCFilterPro *> *proList;
/* 选中的经纪人 */
@property(nonatomic,strong) RCFilterAgent *selectAgent;
/* 选中的项目 */
@property(nonatomic,strong) RCFilterPro *selectPro;
/* 报备开始时间戳 */
@property(nonatomic,assign) NSInteger reportStart;
/* 报备结束时间戳 */
@property(nonatomic,assign) NSInteger reportEnd;
/* 报备开始时间字符串 */
@property(nonatomic,copy,nullable) NSString *reportStartStr;
/* 报备结束时间字符串 */
@property(nonatomic,copy,nullable) NSString *reportEndStr;
@end

@interface RCFilterAgent : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *uuid;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

@interface RCFilterPro : NSObject
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *proUuid;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end
NS_ASSUME_NONNULL_END

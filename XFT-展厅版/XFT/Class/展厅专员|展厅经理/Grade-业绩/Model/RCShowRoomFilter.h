//
//  RCShowRoomFilter.h
//  XFT
//
//  Created by 夏增明 on 2019/10/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCShowRoomProject;
@interface RCShowRoomFilter : NSObject
/* 展厅下的所有项目数据 */
@property(nonatomic,strong) NSArray *projects;
/* 报备开始时间戳 */
@property(nonatomic,assign) NSInteger reportStart;
/* 报备结束时间戳 */
@property(nonatomic,assign) NSInteger reportEnd;
/* 到访开始时间戳 */
@property(nonatomic,assign) NSInteger visitStart;
/* 到访结束时间戳 */
@property(nonatomic,assign) NSInteger visitEnd;
/* 报备开始时间字符串 */
@property(nonatomic,copy,nullable) NSString *reportStartStr;
/* 报备结束时间字符串 */
@property(nonatomic,copy,nullable) NSString *reportEndStr;
/* 到访开始时间字符串 */
@property(nonatomic,copy,nullable) NSString *visitStartStr;
/* 到访结束时间字符串 */
@property(nonatomic,copy,nullable) NSString *visitEndStr;
/* 选中的客户等级 A B C D*/
@property(nonatomic,copy,nullable) NSString *cusLevel;
/* 选中的那个项目 */
@property(nonatomic,strong,nullable) RCShowRoomProject *selectPro;
@end

NS_ASSUME_NONNULL_END

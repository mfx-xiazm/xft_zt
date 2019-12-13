//
//  RCClientFilterView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCClientFilterView,RCShowRoomFilter,RCClientFilter;

#pragma mark - 协议
@protocol RCClientFilterViewDelegate <NSObject>

@optional
//点击事件
- (void)filterDidConfirm:(RCClientFilterView *)filter cusLevel:(NSString *)level selectProId:(NSString *)proId reportBeginTime:(NSInteger)reportBegin reportEndTime:(NSInteger)reportEnd visitBeginTime:(NSInteger)visitBegin visitEndTime:(NSInteger)visitEnd;

- (void)filterDidConfirm:(RCClientFilterView *)filter selectProId:(NSString *)proId selectAgentId:(NSString *)agentId reportBeginTime:(NSInteger)reportBegin reportEndTime:(NSInteger)reportEnd;
@end


@interface RCClientFilterView : UIView
/* 目标控制器 */
@property (nonatomic,weak) UIViewController *target;
@property (nonatomic, weak) id<RCClientFilterViewDelegate> delegate;
/* 客户类别 0-6 0报备 1到访 2认筹 3认购 4签约 5退房 6失效*/
@property(nonatomic,assign) NSInteger cusType;
/* 筛选数据模型 */
@property(nonatomic,strong) RCShowRoomFilter *filterModel;
/* 合作中介的门店客户列表筛选条件 */
@property(nonatomic,strong) RCClientFilter *filterData;
@end

NS_ASSUME_NONNULL_END

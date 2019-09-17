//
//  RCPushHouseFilterView.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^pushHouseFilterCall)(NSInteger, NSInteger);

@interface RCPushHouseFilterView : UIView
@property (nonatomic,strong) UIViewController *target;
@property(nonatomic,strong) UITableView *tableView;
/** 区域 */
@property (nonatomic,strong) NSArray *areas;
/** 物业 */
@property (nonatomic,strong) NSArray *wuye;
/** 户型 */
@property (nonatomic,strong) NSArray *huxing;
/** 面积 */
@property (nonatomic,strong) NSArray *mianji;
/** 筛选点击回调 */
@property (nonatomic,copy) pushHouseFilterCall pushHouseFilterCall;
@end

NS_ASSUME_NONNULL_END

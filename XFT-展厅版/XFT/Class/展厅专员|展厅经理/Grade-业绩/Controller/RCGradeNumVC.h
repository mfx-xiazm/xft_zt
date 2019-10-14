//
//  RCGradeNumVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCGradeNumVC : HXBaseViewController
/* 展厅uuid */
@property(nonatomic,copy) NSString *showroomUuid;
/* 团队uuid */
@property(nonatomic,copy) NSString *teamUuid;
/* 小组uuid */
@property(nonatomic,copy) NSString *groupUuid;
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
/* 客户类别 0-7 0报备 1到访 2认筹 3认购 4签约 5退房 6失效*/
@property(nonatomic,assign) NSInteger cusType;
@end

NS_ASSUME_NONNULL_END

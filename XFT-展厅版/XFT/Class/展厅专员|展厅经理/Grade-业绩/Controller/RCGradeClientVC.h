//
//  RCGradeClientVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCGradeClientVC : HXBaseViewController
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
/* 团队uuid */
@property(nonatomic,copy) NSString *teamUuid;
/* 小组uuid */
@property(nonatomic,copy) NSString *groupUuid;
/* 专员Uuid */
@property(nonatomic,copy) NSString *zyUuid;
/* 展厅Uuid */
@property(nonatomic,copy) NSString *showroomUuid;
/* 客户类别 0-6 0报备 1到访 2认筹 3认购 4签约 5退房 6失效*/
@property(nonatomic,assign) NSInteger cusType;
@end

NS_ASSUME_NONNULL_END

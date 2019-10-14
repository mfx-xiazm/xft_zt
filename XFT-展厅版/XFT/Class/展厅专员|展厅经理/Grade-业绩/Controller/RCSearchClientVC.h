//
//  RCSearchClientVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSearchClientVC : HXBaseViewController
/* 数据类型 1客户 2中介门店 3门店客户*/
@property(nonatomic,assign) NSInteger dataType;
/* 展厅uuid */
@property(nonatomic,copy) NSString *showroomUuid;
/* 团队uuid */
@property(nonatomic,copy) NSString *teamUuid;
/* 小组uuid */
@property(nonatomic,copy) NSString *groupUuid;
/* 专员uuid */
@property(nonatomic,copy) NSString *accUuid;

@end

NS_ASSUME_NONNULL_END

//
//  RCReportClientVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCReportClientVC : HXBaseViewController
/* 楼盘名字 */
@property(nonatomic,copy) NSString *houseName;
/* 楼盘id */
@property(nonatomic,copy) NSString *houseUuid;
@end

NS_ASSUME_NONNULL_END

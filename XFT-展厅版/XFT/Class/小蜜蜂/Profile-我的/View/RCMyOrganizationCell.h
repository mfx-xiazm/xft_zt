//
//  RCMyOrganizationCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^phoneCall)(void);
@interface RCMyOrganizationCell : UITableViewCell
/* 点击 */
@property(nonatomic,copy) phoneCall phoneCall;
/* 组织 */
@property(nonatomic,strong) MSUserRoles *role;
@end

NS_ASSUME_NONNULL_END

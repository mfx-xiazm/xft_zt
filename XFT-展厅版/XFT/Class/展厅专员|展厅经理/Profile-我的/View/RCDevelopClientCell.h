//
//  RCDevelopClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/12/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCClientType;
typedef void(^delClientCall)(void);
@interface RCDevelopClientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
/* 点击 */
@property(nonatomic,copy) delClientCall delClientCall;
/* 拓客方式 */
@property(nonatomic,strong) RCClientType *type;
@end

NS_ASSUME_NONNULL_END

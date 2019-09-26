//
//  RCChangeRoleCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectCall)(void);
@interface RCChangeRoleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *work;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

/* 选中 */
@property(nonatomic,copy) selectCall selectCall;
@end

NS_ASSUME_NONNULL_END

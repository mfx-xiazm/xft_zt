//
//  RCBeesWorkCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCBeesWork;
typedef void(^reportCall)(NSInteger index);
@interface RCBeesWorkCell : UITableViewCell
/* 报备 */
@property(nonatomic,copy) reportCall reportCall;
/* 上报客户 */
@property(nonatomic,strong) RCBeesWork *beesWork;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;

@end

NS_ASSUME_NONNULL_END

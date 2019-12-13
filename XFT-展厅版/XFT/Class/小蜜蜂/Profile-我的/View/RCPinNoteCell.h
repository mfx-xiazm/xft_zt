//
//  RCPinNoteCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTaskPin;
@interface RCPinNoteCell : UITableViewCell
/* 打卡 */
@property(nonatomic,strong) RCTaskPin *pin;
/* 打卡 */
@property(nonatomic,strong) RCTaskPin *pin1;

@property (weak, nonatomic) IBOutlet UILabel *num;
@end

NS_ASSUME_NONNULL_END

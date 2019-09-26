//
//  RCMyClientStateCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMaganerGrade;
@interface RCMyClientStateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *oneTitleView;
@property (weak, nonatomic) IBOutlet UIView *twoTitlesView;
/* 团队 */
@property(nonatomic,strong) RCMaganerGrade *grade;
@end

NS_ASSUME_NONNULL_END

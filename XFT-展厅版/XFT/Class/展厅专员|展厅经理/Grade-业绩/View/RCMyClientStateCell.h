//
//  RCMyClientStateCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClientStateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *oneTitleView;
@property (weak, nonatomic) IBOutlet UIView *twoTitlesView;
@property (weak, nonatomic) IBOutlet UILabel *clientNum;
@property (weak, nonatomic) IBOutlet UILabel *clientState;
@property (weak, nonatomic) IBOutlet UILabel *clientType;
@end

NS_ASSUME_NONNULL_END

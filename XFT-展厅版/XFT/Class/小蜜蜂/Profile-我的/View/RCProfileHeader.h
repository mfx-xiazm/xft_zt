//
//  RCProfileHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^infoClicked)(void);
@interface RCProfileHeader : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavBar;
/* 个人信息 */
@property(nonatomic,copy) infoClicked infoClicked;
@end

NS_ASSUME_NONNULL_END

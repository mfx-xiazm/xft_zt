//
//  RCManagerProfileHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^infoClicked)(NSInteger index);
@interface RCManagerProfileHeader : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavBar;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

/* 个人信息 */
@property(nonatomic,copy) infoClicked infoClicked;
@end

NS_ASSUME_NONNULL_END

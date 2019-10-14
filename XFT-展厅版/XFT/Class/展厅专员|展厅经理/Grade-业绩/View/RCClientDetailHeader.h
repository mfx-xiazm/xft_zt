//
//  RCClientDetailHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyClient;
typedef void(^clientDetailCall)(NSInteger index);
@interface RCClientDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *clientToolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clientViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
/* 点击 */
@property(nonatomic,copy) clientDetailCall clientDetailCall;
/* 客户状态 0-6*/
@property(nonatomic,assign) NSInteger cusType;
/* 客户 */
@property(nonatomic,strong) RCMyClient *client;
@end

NS_ASSUME_NONNULL_END

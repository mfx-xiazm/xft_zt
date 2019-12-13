//
//  RCTaskDetailHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^lookMoreCall)(void);
@interface RCTaskDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *taskTitlesView;
@property (weak, nonatomic) IBOutlet UIView *threeTitlesView;
@property (weak, nonatomic) IBOutlet UIView *fourTitlesView;
@property (weak, nonatomic) IBOutlet UIView *fiveTitlesView;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *secName;
@property (weak, nonatomic) IBOutlet UILabel *trdName;
@property (weak, nonatomic) IBOutlet UILabel *forName;
@property (weak, nonatomic) IBOutlet UILabel *titleTag;
@property (weak, nonatomic) IBOutlet UILabel *lookMoreTag;
/* 点击 */
@property(nonatomic,copy) lookMoreCall lookMoreCall;
@end

NS_ASSUME_NONNULL_END

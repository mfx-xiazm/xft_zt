//
//  RCRegisterVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCRegisterVC.h"
#import "FSActionSheet.h"

@interface RCRegisterVC ()<FSActionSheetDelegate>

@end
@implementation RCRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册成为小蜜蜂"];
}
- (IBAction)registerHandleClicked:(UIButton *)sender {
    if (sender.tag == 2) {
        [sender startWithTime:60 title:@"发送验证码" countDownTitle:@"s" mainColor:HXControlBg countColor:HXControlBg];
    }else{
        HXLog(@"注册");
    }
}

@end

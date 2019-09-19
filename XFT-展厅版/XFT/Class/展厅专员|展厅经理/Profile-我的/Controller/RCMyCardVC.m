//
//  RCMyCardVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyCardVC.h"
#import "SGQRCode.h"

@interface RCMyCardVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;

@end

@implementation RCMyCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的名片"];
    
    self.codeImg.image = [SGQRCodeObtain generateQRCodeWithData:@"来一个字符串" size:self.codeImg.hxn_width];
}


@end

//
//  RCLoginVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoginVC.h"
#import "RCWebContentVC.h"
#import "HXTabBarController.h"
#import "RCScanVC.h"

@interface RCLoginVC ()
/* 扫描跳转 */
@property(nonatomic,assign) BOOL isScan;
@end

@implementation RCLoginVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isScan = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.isScan animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)loginBtnClicked:(UIButton *)sender {
        HXTabBarController *tab = [[HXTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
        //推出主界面出来
        CATransition *ca = [CATransition animation];
        ca.type = @"movein";
        ca.duration = 0.5;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
}
- (IBAction)sacnClicked:(UIButton *)sender {
    self.isScan = YES;
    RCScanVC *svc = [RCScanVC new];
    [self.navigationController pushViewController:svc animated:YES];
}

@end

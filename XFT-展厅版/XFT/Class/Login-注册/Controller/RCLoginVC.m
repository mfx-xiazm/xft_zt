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
#import "RCChangeRoleVC.h"

@interface RCLoginVC ()
/* 扫描跳转 */
@property(nonatomic,assign) BOOL isScan;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
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
- (IBAction)changeYuMing:(UIButton *)sender {
    NSString *ipKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"RCIPkey"];

    if ([ipKey isEqualToString:@"dev"]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"uat环境域名"];
        [[NSUserDefaults standardUserDefaults] setObject:@"uat" forKey:@"RCIPkey"];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"dev环境域名"];
        [[NSUserDefaults standardUserDefaults] setObject:@"dev" forKey:@"RCIPkey"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hx_weakify(self);
    [self.loginBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.account hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入账号"];
            return NO;
        }
        if (![strongSelf.pwd hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf loginBtnClicked:button];
    }];
}
- (void)loginBtnClicked:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accNo"] = self.account.text;
    data[@"pwd"] = self.pwd.text;
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/system/showRoomlogin" parameters:parameters success:^(id responseObject) {
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            // 经理/专员
            if ([responseObject[@"data"][@"showroomLoginInside"][@"accRole"] integerValue] == 1) {
                RCChangeRoleVC *rvc = [RCChangeRoleVC new];
                rvc.userInfo = responseObject[@"data"];
                [weakSelf.navigationController pushViewController:rvc animated:YES];
            }else{
                MSUserInfo *userInfo = [MSUserInfo yy_modelWithDictionary:responseObject[@"data"]];
                userInfo.ulevel = 3;
                [MSUserManager sharedInstance].curUserInfo = userInfo;
                [[MSUserManager sharedInstance] saveUserInfo];
                
                HXTabBarController *tab = [[HXTabBarController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                
                //推出主界面出来
                CATransition *ca = [CATransition animation];
                ca.type = @"movein";
                ca.duration = 0.5;
                [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
    }];
}
- (IBAction)sacnClicked:(UIButton *)sender {
    self.isScan = YES;
    RCScanVC *svc = [RCScanVC new];
    [self.navigationController pushViewController:svc animated:YES];
}

@end

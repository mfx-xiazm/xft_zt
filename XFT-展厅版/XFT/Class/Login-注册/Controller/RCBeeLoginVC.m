//
//  RCBeeLoginVC.m
//  XFT
//
//  Created by 夏增明 on 2019/12/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBeeLoginVC.h"
#import "HXTabBarController.h"

@interface RCBeeLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation RCBeeLoginVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginBtnClicked:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accNo"] = self.account.text;
    data[@"pwd"] = self.pwd.text;
    
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomBeeLoginInside/showRoomBeeLogin" parameters:parameters success:^(id responseObject) {
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            
            MSUserInfo *userInfo = [MSUserInfo yy_modelWithDictionary:responseObject[@"data"]];
            userInfo.ulevel = 3;
            MSUserRoles *role = userInfo.responseCheckRoles.firstObject;
            userInfo.selectRole = role;
            [MSUserManager sharedInstance].curUserInfo = userInfo;
            [[MSUserManager sharedInstance] saveUserInfo];
            
            HXTabBarController *tab = [[HXTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tab;
            
            //推出主界面出来
            CATransition *ca = [CATransition animation];
            ca.type = @"movein";
            ca.duration = 0.5;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
            
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
    }];
}

@end

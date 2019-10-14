//
//  RCChangePwdVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCChangePwdVC.h"

@interface RCChangePwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *reNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *checkPwd;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation RCChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"修改密码"];
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.oldPwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入旧密码"];
            return NO;
        }
        if (![strongSelf.reNewPwd hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入新密码"];
            return NO;
        }
        if (![strongSelf.checkPwd hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请再次输入新密码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf updatePasswordRequest:button];
    }];
}
-(void)updatePasswordRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"checkPassword"] = self.checkPwd.text;
    data[@"newPassword"] = self.reNewPwd.text;
    data[@"oldPassword"] = self.oldPwd.text;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/userDate/updatePassword" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        [btn stopLoading:@"修改" image:nil textColor:nil backgroundColor:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [btn stopLoading:@"修改" image:nil textColor:nil backgroundColor:nil];
    }];
}
@end

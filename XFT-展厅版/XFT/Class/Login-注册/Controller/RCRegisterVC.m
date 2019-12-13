//
//  RCRegisterVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCRegisterVC.h"
#import "FSActionSheet.h"
#import "UITextField+GYExpand.h"

@interface RCRegisterVC ()<FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *upRole;
@property (weak, nonatomic) IBOutlet UITextField *idCard;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UITextField *bankNo;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/* 二维码 */
@property(nonatomic,strong) NSDictionary *codeResult;
@end
@implementation RCRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册成为小蜜蜂"];
    if (self.codeStr) {
        self.codeResult = [NSDictionary dictionaryWithDictionary:[self.codeStr dictionaryWithJsonString]];
        self.upRole.text = [NSString stringWithFormat:@"%@",self.codeResult[@"name"]];
    }else{
        self.upRole.text = [NSString stringWithFormat:@"%@",[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.name];
    }
    hx_weakify(self);
    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length > 11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入姓名"];
            return NO;
        }
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
            return NO;
        }
        if (strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式不对"];
            return NO;
        }
        if (![strongSelf.code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入验证码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf regidterBeeRequest:button];
    }];
}
- (IBAction)getCodeClicked:(UIButton *)sender {
    if (![self.phone hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
        return;
    }
    if (self.phone.text.length != 11) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式不对"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"phone"] = self.phone.text;//注册账号
    data[@"type"] = @"1";//类型1:注册,2登录
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomBeeLoginInside/SendSmsCode" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [sender startWithTime:60 title:@"发送验证码" countDownTitle:@"s" mainColor:HXControlBg countColor:HXControlBg];
           
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)regidterBeeRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accNo"] = self.phone.text;//注册账号
    data[@"accRole"] = (self.codeStr && self.codeStr.length)?@"1":@"2";//账号角色 1:融客展厅[展厅管理/展厅专员] 2:展厅小蜜蜂
    data[@"bankAccNo"] = [self.bankNo hasText]?self.bankNo.text:@"";//银行账号
    data[@"bankOpen"] = [self.bankName hasText]?self.bankName.text:@"";//开户银行
    data[@"cardNo"] = [self.idCard hasText]?self.idCard.text:@"";//身份证件号码
    data[@"cardType"] = @"1";//身份证件类别 1:身份证
    data[@"name"] = self.name.text;//注册姓名
    data[@"realName"] = self.name.text;//注册姓名
    data[@"regPhone"] = self.phone.text;//注册电话
    data[@"showroomUuid"] = (self.codeStr && self.codeStr.length)?self.codeResult[@"uuid"]:[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;//归属展厅
    data[@"smsCheckCode"] = self.code.text;//短信验证码
    data[@"smsCheckCodeType"] = @"1";//短信验证码类型
    data[@"xqzyAccUuid"] = (self.codeStr && self.codeStr.length)?self.codeResult[@"xqzyAccUuid"]:[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//渠道专员uuid
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomBeeLoginInside/addShowRoomBee" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确认" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            if (strongSelf.registerCall) {
                strongSelf.registerCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确认" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end

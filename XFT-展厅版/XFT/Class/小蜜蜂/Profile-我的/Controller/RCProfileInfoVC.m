//
//  RCProfileInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileInfoVC.h"

@interface RCProfileInfoVC ()
@property (weak, nonatomic) IBOutlet UITextField *idNO;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UITextField *cardNo;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation RCProfileInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"个人信息"];
    
    if ([MSUserManager sharedInstance].curUserInfo.showroomLoginInside.cardNo && [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.cardNo.length) {
        self.idNO.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.cardNo;
        self.idNO.enabled = NO;
    }
    
    if ([MSUserManager sharedInstance].curUserInfo.showroomLoginInside.bankOpen && [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.bankOpen.length) {
        self.bankName.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.bankOpen;
        self.bankName.enabled = NO;
    }
    
    if ([MSUserManager sharedInstance].curUserInfo.showroomLoginInside.bankAccNo && [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.bankAccNo.length) {
        self.cardNo.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.bankAccNo;
        self.cardNo.enabled = NO;
    }
    
    if (self.idNO.isEnabled || self.bankName.isEnabled || self.cardNo.isEnabled) {
        self.sureBtn.hidden = NO;
    }else{
        self.sureBtn.hidden = YES;
    }
    
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.idNO hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入身份证号"];
            return NO;
        }
        if (![strongSelf.bankName hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户行"];
            return NO;
        }
        if (![strongSelf.cardNo hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行卡号"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf updateBeeBankInfoRequest:button];
    }];
}

-(void)updateBeeBankInfoRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"bankAccNo"] = self.cardNo.text;// 银行账号
    data[@"bankOpen"] = self.bankName.text;//开户银行
    data[@"cardNo"] = self.idNO.text;//身份证件号码
    data[@"cardType"] = @"1";//身份证件类别 1:身份证
    data[@"uuid"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//uuid
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomAccSign/getBeeSignList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"保存" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.cardNo = strongSelf.idNO.text;
            [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.bankOpen = strongSelf.bankName.text;
            [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.bankAccNo = strongSelf.cardNo.text;
            [[MSUserManager sharedInstance] saveUserInfo];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"保存" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

@end

//
//  RCAddClientTypeVC.m
//  XFT
//
//  Created by 夏增明 on 2019/12/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddClientTypeVC.h"

@interface RCAddClientTypeVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation RCAddClientTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"新增拓客方式"];
    
    hx_weakify(self);
    [self.saveBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入拓客方式"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf addClientTypeRequet:button];
    }];
}
-(void)addClientTypeRequet:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"name"] = self.name.text;
    data[@"showroomUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;
    parameters[@"data"] = data;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/showroomExpandMode/addShowroomExpandModeName" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"保存" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            if (strongSelf.addTypeCall) {
                strongSelf.addTypeCall();
            }
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

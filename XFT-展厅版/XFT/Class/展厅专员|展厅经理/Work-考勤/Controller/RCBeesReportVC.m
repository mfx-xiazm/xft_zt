//
//  RCBeesReportVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBeesReportVC.h"
#import "HXPlaceholderTextView.h"
#import "RCAddPhoneCell.h"
#import "WSDatePickerView.h"
#import "RCReportResultVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "FSActionSheet.h"
#import "RCBeesWork.h"
#import "RCReportHouse.h"

@interface RCBeesReportVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *houseName;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *idCard;
@property (weak, nonatomic) IBOutlet UIImageView *clientHeadPic;
@property (weak, nonatomic) IBOutlet UIButton *sureReportBtn;
@end

@implementation RCBeesReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"报备客户"];
    // 复制信息
    self.houseName.text = self.beesWork.proName;//楼盘名字
    self.name.text = self.beesWork.cusName;
    self.phone.text = self.beesWork.cusPhone;
    
    if (self.beesWork.idNo && self.beesWork.idNo.length) {
        self.idCard.enabled = NO;
        self.idCard.text = self.beesWork.idNo;
    }
    self.idCard.delegate = self;
    
    if (self.beesWork.showroomBeeCusPic && self.beesWork.showroomBeeCusPic.length) {
        [self.clientHeadPic sd_setImageWithURL:[NSURL URLWithString:self.beesWork.showroomBeeCusPic]];
    }
    
    if (self.beesWork.cusRemarks && self.beesWork.cusRemarks.length) {
        self.remark.text = self.beesWork.cusRemarks;
    }
    self.remark.delegate = self;
    self.remark.placeholder = @"请输入客户购房的补充说明(选填)";
    
    hx_weakify(self);
    [self.sureReportBtn BindingBtnJudgeBlock:^BOOL{
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf pushDoneClicked:button];
    }];
}
#pragma mark -- UITextField代理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.idCard) {
        self.beesWork.idNo = [textField hasText]?textField.text:@"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.remark) {
        self.beesWork.cusRemarks = [textView hasText]?textView.text:@"";
    }
}
#pragma mark -- 点击事件
- (IBAction)choosePushRoleClicked:(UIButton *)sender {
    //  如果已经有客户头像，不可编辑
    if (self.beesWork.showroomBeeCusPic && self.beesWork.showroomBeeCusPic.length) {
        return;
    }
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [strongSelf awakeImagePickerController:@"1"];
        }else{
            [strongSelf awakeImagePickerController:@"2"];
        }
    }];
}
- (void)pushDoneClicked:(UIButton *)sender {
    hx_weakify(self);
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确认报备客户？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        [strongSelf submitReportDataRequest:sender];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
#pragma mark -- 唤起相机
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self isCanUseCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self isCanUsePhotos]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相册不可用"];
            return;
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        hx_strongify(weakSelf);
        // 显示保存图片
        [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl) {
            [strongSelf.clientHeadPic sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            strongSelf.beesWork.showroomBeeCusPic = imageUrl;
        }];
    }];
}
#pragma mark -- 业务逻辑
-(void)submitReportDataRequest:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];

    data[@"proIds"] = @[self.beesWork.proUuid];//项目列表 必填
    data[@"uuid"] = self.beesWork.uuid;//小蜜蜂上报记录
    data[@"idNo"] = [self.idCard hasText]?self.idCard.text:@"";
    data[@"cusPicInfo"] = @[(self.beesWork.showroomBeeCusPic && self.beesWork.showroomBeeCusPic.length)?self.beesWork.showroomBeeCusPic:@""];
    data[@"remark"] = [self.remark hasText]?self.remark.text:@"";
    data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//推荐人id 必填
    data[@"userRole"] = @([MSUserManager sharedInstance].curUserInfo.showroomLoginInside.accRole);//推荐人角色 必填
    data[@"accName"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.name;//推荐人名称
    data[@"accType"] = @"4";//推荐人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一推荐人 6 门店管理员
    if ([[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomType isEqualToString:@"1"]) {//1 集团文旅 2 区域文旅
        data[@"oneQudaoCode"] = @"K-0018";//一级渠道id
        data[@"oneQudaoName"] = @"集团文旅";//一级渠道名称
    }else{
        data[@"oneQudaoCode"] = @"K-0019";//一级渠道id
        data[@"oneQudaoName"] = @"区域文旅";//一级渠道名称
    }
    data[@"twoQudaoName"] = ([MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName && [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName.length)?[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName:@"";//推荐人所属机构名称
    data[@"twoQudaoCode"] =([MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid && [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid.length)?[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid:@"";//推荐人所属机构id
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.teamName && [MSUserManager sharedInstance].curUserInfo.selectRole.teamName.length) {
        data[@"accTeamName"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamName;//归属团队名称
    }else{
        data[@"accTeamName"] = @"";//归属团队名称
    }
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid && [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid.length) {
        data[@"accTeamUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.teamUuid;//归属团队uuid
    }else{
        data[@"accTeamUuid"] = @"";//归属团队uuid
    }
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid && [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid.length) {
        data[@"accGroupUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupUuid;//归属小组uuid
    }else{
        data[@"accGroupUuid"] = @"";//归属小组uuid
    }
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.groupName && [MSUserManager sharedInstance].curUserInfo.selectRole.groupName.length) {
        data[@"accGroupName"] = [MSUserManager sharedInstance].curUserInfo.selectRole.groupName;//归属小组名称
    }else{
        data[@"accGroupName"] = @"";//归属小组名称
    }
    parameters[@"data"] = data;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/bee/oneKeyBaobei" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"一键报备" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            RCReportResultVC *rvc = [RCReportResultVC new];
            rvc.results = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"一键报备" image:nil textColor:nil backgroundColor:nil];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"sys/sys/dict/getUploadImgReturnUrl.do" parameters:@{} name:@"file" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            completedCall(responseObject[@"data"][@"url"]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

@end

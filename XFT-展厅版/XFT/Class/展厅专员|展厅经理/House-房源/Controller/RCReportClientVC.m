//
//  RCReportClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportClientVC.h"
#import "HXPlaceholderTextView.h"
#import "RCAddPhoneCell.h"
#import <ZLCollectionViewHorzontalLayout.h>
#import "RCReportResultVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "FSActionSheet.h"
#import "RCReportTarget.h"

static NSString *const AddPhoneCell = @"AddPhoneCell";
@interface RCReportClientVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *morePhoneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *morePhoneViewHeight;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UITextField *proName;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *idCard;
@property (weak, nonatomic) IBOutlet UIImageView *clientHeadPic;
@property (weak, nonatomic) IBOutlet UIButton *sureReportBtn;
/* 记录当前正在操作的报备客户 */
@property(nonatomic,strong) RCReportTarget *currentReportTarget;
@end

@implementation RCReportClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"推荐"];
    self.proName.text = self.houseName;
    self.name.delegate = self;
    self.phone.delegate = self;
    self.idCard.delegate = self;
    self.remark.delegate = self;
    self.remark.placeholder = @"请输入补充说明(选填)";
    [self setUpTableView];
    
    // 创建一个操作客户
    RCReportTarget *reportTarget = [RCReportTarget new];
    self.currentReportTarget = reportTarget;
    
    hx_weakify(self);
    [self.sureReportBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        // 判断推荐对象信息是否完整
        BOOL isOK = YES;
        if (strongSelf.currentReportTarget.morePhones && strongSelf.currentReportTarget.morePhones.count) {
            for (RCReportPhone *phone in strongSelf.currentReportTarget.morePhones) {
                if (!phone.cusPhone.length) {
                    isOK = NO;
                    break;
                }
            }
        }
        if (!isOK || !strongSelf.currentReportTarget.cusName.length || !strongSelf.currentReportTarget.cusPhone.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf pushSubmitDoneClicked:button];
    }];
}
-(void)setUpTableView
{
    self.morePhoneView.estimatedSectionHeaderHeight = 0;
    self.morePhoneView.estimatedSectionFooterHeight = 0;
    self.morePhoneView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.morePhoneView.dataSource = self;
    self.morePhoneView.delegate = self;
    self.morePhoneView.showsVerticalScrollIndicator = NO;
    self.morePhoneView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.morePhoneView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddPhoneCell class]) bundle:nil] forCellReuseIdentifier:AddPhoneCell];
}
#pragma mark -- UITextField代理
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.name) {
        self.currentReportTarget.cusName = [textField hasText]?textField.text:@"";
    }else if (textField == self.phone) {
        self.currentReportTarget.cusPhone = [textField hasText]?textField.text:@"";
    }else{
        self.currentReportTarget.idCard = [textField hasText]?textField.text:@"";
    }
}
#pragma mark -- UITextView代理
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.currentReportTarget.remark = [textView hasText]?textView.text:@"";
}
#pragma mark -- 点击事件
- (IBAction)addPhoneClicked:(UIButton *)sender {
    if (self.currentReportTarget.morePhones && self.currentReportTarget.morePhones.count==2) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"1个客户最多3个电话"];
        return;
    }
    RCReportPhone *phone = [RCReportPhone new];
    if (!self.currentReportTarget.morePhones) {
        self.currentReportTarget.morePhones = [NSMutableArray array];
    }
    [self.currentReportTarget.morePhones addObject:phone];
    self.morePhoneViewHeight.constant = 50.f*self.currentReportTarget.morePhones.count;
    [self.morePhoneView reloadData];
}
- (IBAction)choosePushRoleClicked:(UIButton *)sender {
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
- (void)pushSubmitDoneClicked:(UIButton *)sender {
    hx_weakify(self);
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确认推荐客户？" constantWidth:HX_SCREEN_WIDTH - 50*2];
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
            strongSelf.currentReportTarget.headPic = imageUrl;
        }];
    }];
}
#pragma mark -- 业务逻辑
-(void)submitReportDataRequest:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];

    data[@"proIds"] = @[self.houseUuid];//项目列表 必填
    
    NSMutableArray *phones = [NSMutableArray array];
    [phones addObject:self.currentReportTarget.cusPhone];
    if (self.currentReportTarget.morePhones && self.currentReportTarget.morePhones.count) {
        for (RCReportPhone *phone in self.currentReportTarget.morePhones) {
            [phones addObject:phone.cusPhone];
        }
    }
    data[@"cusInfo"] = @[@{@"name":self.currentReportTarget.cusName,//客户姓名
                         @"phone":phones,//客户手机号
                         @"idNo":(self.currentReportTarget.idCard && self.currentReportTarget.idCard.length)?self.currentReportTarget.idCard:@"", // 身份证号
                         @"cusPicInfo":(self.currentReportTarget.headPic && self.currentReportTarget.headPic.length)?@[self.currentReportTarget.headPic]:@[],
                         @"remark":(self.currentReportTarget.remark && self.currentReportTarget.remark.length) ?self.currentReportTarget.remark:@"",//客户备注
                         @"twoQudaoName":([MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName && [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName.length)?[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName:@"",//推荐人所属机构名称
                         @"twoQudaoCode":([MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid && [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid.length)?[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid:@"",//推荐人所属机构id
                        }];//客户信息 必填
    data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//推荐人id 必填
    data[@"userRole"] = @([MSUserManager sharedInstance].curUserInfo.showroomLoginInside.accRole);//推荐人角色 必填
    data[@"accName"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.name;//推荐人名称
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
    data[@"accType"] = @"4";//推荐人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一推荐人 6 门店管理员
    if ([[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomType isEqualToString:@"1"]) {//1 集团文旅 2 区域文旅
        data[@"oneQudaoCode"] = @"K-0018";//一级渠道id
        data[@"oneQudaoName"] = @"集团文旅";//一级渠道名称
    }else{
        data[@"oneQudaoCode"] = @"K-0019";//一级渠道id
        data[@"oneQudaoName"] = @"区域文旅";//一级渠道名称
    }
    parameters[@"data"] = data;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusbaobeilist/addReportCust" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"推荐" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            RCReportResultVC *rvc = [RCReportResultVC new];
            rvc.results = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"推荐" image:nil textColor:nil backgroundColor:nil];
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentReportTarget.morePhones.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCAddPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPhoneCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCReportPhone *phone = self.currentReportTarget.morePhones[indexPath.row];
    cell.phone = phone;
    hx_weakify(self);
    cell.cutBtnCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.currentReportTarget.morePhones removeObjectAtIndex:indexPath.row];
        strongSelf.morePhoneViewHeight.constant = 50.f*strongSelf.currentReportTarget.morePhones.count;
        [tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end

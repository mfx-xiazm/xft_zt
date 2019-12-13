//
//  RCBeePushClientEditVC.m
//  XFT
//
//  Created by 夏增明 on 2019/12/13.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBeePushClientEditVC.h"
#import "RCAddPhoneCell.h"
#import "HXPlaceholderTextView.h"
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCReportTarget.h"

static NSString *const AddPhoneCell = @"AddPhoneCell";

@interface RCBeePushClientEditVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *idCard;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *morePhoneViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *morePhoneView;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

@end

@implementation RCBeePushClientEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"推荐客户"];
    self.name.delegate = self;
    self.phone.delegate = self;
    self.idCard.delegate = self;
    self.remark.delegate = self;
    self.remark.placeholder = @"请输入客户购房的补充说明(选填)";
    [self setUpTableView];
    [self showReportClientData];
}
-(void)setUpTableView
{
    self.morePhoneView.estimatedRowHeight = 0;
    self.morePhoneView.estimatedSectionHeaderHeight = 0;
    self.morePhoneView.estimatedSectionFooterHeight = 0;
    self.morePhoneView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.morePhoneView.scrollEnabled = NO;
    self.morePhoneView.dataSource = self;
    self.morePhoneView.delegate = self;
    self.morePhoneView.showsVerticalScrollIndicator = NO;
    self.morePhoneView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.morePhoneView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddPhoneCell class]) bundle:nil] forCellReuseIdentifier:AddPhoneCell];
}
-(void)setReportTarget:(RCReportTarget *)reportTarget
{
    _reportTarget = reportTarget;
}
-(void)showReportClientData
{
    self.name.text = self.reportTarget.cusName;
    self.phone.text = self.reportTarget.cusPhone;
    self.idCard.text = self.reportTarget.idCard;
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:self.reportTarget.headPic]];
    self.remark.text = self.reportTarget.remark;
    
    self.morePhoneViewHeight.constant = 50.f*self.reportTarget.morePhones.count;
    [self.morePhoneView reloadData];
}
#pragma mark -- UITextField代理
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.name) {
        self.reportTarget.cusName = [textField hasText]?textField.text:@"";
    }else if (textField == self.phone) {
        self.reportTarget.cusPhone = [textField hasText]?textField.text:@"";
    }else{
        self.reportTarget.idCard = [textField hasText]?textField.text:@"";
    }
}
#pragma mark -- UITextView代理
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.reportTarget.remark = [textView hasText]?textView.text:@"";
}
#pragma mark -- 点击事件

- (IBAction)editDoneClicked:(UIButton *)sender {
    BOOL isOK = YES;
    if (self.reportTarget.morePhones && self.reportTarget.morePhones.count) {
        for (RCReportPhone *phone in self.reportTarget.morePhones) {
            if (!phone.cusPhone.length) {
                isOK = NO;
                break;
            }
        }
    }
    if (!isOK || !self.reportTarget.cusName.length || !self.reportTarget.cusPhone.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
        return;
    }
    
    if (self.editDoneCall) {
        self.editDoneCall();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addPhoneClicked:(UIButton *)sender {
    RCReportPhone *phone = [RCReportPhone new];
    if (!self.reportTarget.morePhones) {
        self.reportTarget.morePhones = [NSMutableArray array];
    }
    [self.reportTarget.morePhones addObject:phone];
    self.morePhoneViewHeight.constant = 50.f*self.reportTarget.morePhones.count;
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
            [strongSelf.headPic sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            strongSelf.reportTarget.headPic = imageUrl;
        }];
    }];
}
#pragma mark -- 业务逻辑
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
    return self.reportTarget.morePhones.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCAddPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPhoneCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCReportPhone *phone = self.reportTarget.morePhones[indexPath.row];
    cell.phone = phone;
    hx_weakify(self);
    cell.cutBtnCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.reportTarget.morePhones removeObjectAtIndex:indexPath.row];
        strongSelf.morePhoneViewHeight.constant = 50.f*strongSelf.reportTarget.morePhones.count;
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

//
//  RCBeePushVC.m
//  XFT
//
//  Created by 夏增明 on 2019/12/13.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBeePushVC.h"
#import "RCPushHouseVC.h"
#import "HXPlaceholderTextView.h"
#import "RCAddPhoneCell.h"
#import <ZLCollectionViewHorzontalLayout.h>
#import "RCHouseTagsCell.h"
#import "RCAddedClientCell.h"
#import "RCReportResultVC.h"
#import "RCBeePushClientEditVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "FSActionSheet.h"
#import "RCWishHouseVC.h"
#import "RCReportHouse.h"
#import "RCReportTarget.h"

static NSString *const AddPhoneCell = @"AddPhoneCell";
static NSString *const HouseTagsCell = @"HouseTagsCell";
static NSString *const AddedClientCell = @"AddedClientCell";

@interface RCBeePushVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *clientTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clientTableViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *morePhoneViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *morePhoneView;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UITextField *idCard;
@property (weak, nonatomic) IBOutlet UIImageView *clientHeadPic;
@property (weak, nonatomic) IBOutlet UIButton *againAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureReportBtn;
/* 记录当前正在操作的推荐客户 */
@property(nonatomic,strong) RCReportTarget *currentReportTarget;
/* 存放已经填写好信息的推荐客户 */
@property(nonatomic,strong) NSMutableArray *clients;

@end

@implementation RCBeePushVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"推荐客户"];
    
    self.name.delegate = self;
    self.phone.delegate = self;
    self.idCard.delegate = self;
    self.remark.delegate = self;
    self.remark.placeholder = @"请输入客户购房的补充说明(选填)";
    [self setUpTableView];
    [self setUpCollectionView];
    
    // 创建当前第一个操作的客户
    RCReportTarget *reportTarget = [RCReportTarget new];
    self.currentReportTarget = reportTarget;
    
    hx_weakify(self);
    [self.sureReportBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        // 判断推荐对象信息是否完整
        if (!strongSelf.currentReportTarget.selectHouses || !strongSelf.currentReportTarget.selectHouses.count) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择楼盘"];
            return NO;
        }
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

-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
-(void)setUpTableView
{
    self.clientTableView.estimatedRowHeight = 0;
    self.clientTableView.estimatedSectionHeaderHeight = 0;
    self.clientTableView.estimatedSectionFooterHeight = 0;
    self.clientTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.clientTableView.dataSource = self;
    self.clientTableView.delegate = self;
    self.clientTableView.showsVerticalScrollIndicator = NO;
    self.clientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.clientTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddedClientCell class]) bundle:nil] forCellReuseIdentifier:AddedClientCell];
    
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
-(void)setUpCollectionView
{
    ZLCollectionViewHorzontalLayout *flowLayout = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseTagsCell class]) bundle:nil] forCellWithReuseIdentifier:HouseTagsCell];
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
- (IBAction)chooseHouseClicked:(UIButton *)sender {
    RCWishHouseVC *hvc = [RCWishHouseVC new];
    
    if (self.clients && self.clients.count) {// 如果数组中已经有待推荐的对象，就是批量
        hvc.isBatchReport = YES;
    }else{
        hvc.isBatchReport = NO;
    }
    
    if (self.currentReportTarget.selectHouses && self.currentReportTarget.selectHouses.count) {
        hvc.lastHouses = self.currentReportTarget.selectHouses;
    }
    hx_weakify(self);
    hvc.wishHouseCall = ^(NSArray * _Nonnull houses) {
        hx_strongify(weakSelf);
        strongSelf.currentReportTarget.selectHouses = [NSMutableArray arrayWithArray:houses];
        if (strongSelf.currentReportTarget.selectHouses.count) {
            strongSelf.houseViewHeight.constant = 50.f+60.f;
        }else{
            strongSelf.houseViewHeight.constant = 50.f;
        }
        // 切换了楼盘，需要更新已添加推荐对象中的楼盘信息
        if (strongSelf.clients.count) {
            for (RCReportTarget *target in strongSelf.clients) {
                target.selectHouses = strongSelf.currentReportTarget.selectHouses;
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.collectionView reloadData];
        });
    };
    [self.navigationController pushViewController:hvc animated:YES];
}
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
- (IBAction)pushAgainClicked:(UIButton *)sender {
    
    // 要判断是否可以批量推荐
    if (self.currentReportTarget.selectHouses.count > 1) {//多个楼盘不可以批量推荐
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"多个楼盘不可批量推荐"];
        return;
    }
    
    // 判断推荐对象信息是否完整
    if (!self.currentReportTarget.selectHouses || !self.currentReportTarget.selectHouses.count) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择楼盘"];
        return;
    }
    
    if (self.clients && self.clients.count == 4) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"1次最多推荐5个客户"];
        return;
    }
    
    BOOL isOK = YES;
    if (self.currentReportTarget.morePhones && self.currentReportTarget.morePhones.count) {
        for (RCReportPhone *phone in self.currentReportTarget.morePhones) {
            if (!phone.cusPhone.length) {
                isOK = NO;
                break;
            }
        }
    }
    if (!isOK || !self.currentReportTarget.cusName.length || !self.currentReportTarget.cusPhone.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
        return;
    }
    
    // 如果必填信息完整就加入推荐数组，并清空页面数据，创建新的推荐对象
    [self.clients addObject:self.currentReportTarget];
    self.clientTableViewHeight.constant = 55.f*self.clients.count;
    [self.clientTableView reloadData];
    
    RCReportTarget *reportTarget = [RCReportTarget new];
    reportTarget.selectHouses = self.currentReportTarget.selectHouses;//批量推荐楼盘不可变
    self.currentReportTarget = reportTarget;
    
    self.houseViewHeight.constant = 50.f+60.f;
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        [strongSelf.collectionView reloadData];
    });
    self.name.text = @"";
    self.phone.text = @"";

    self.morePhoneViewHeight.constant = 50.f*self.currentReportTarget.morePhones.count;
    [self.morePhoneView reloadData];

    self.idCard.text = @"";
    self.clientHeadPic.image = nil;
    self.remark.text = @"";
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
    
    NSMutableArray *proIds = [NSMutableArray array];
    for (RCReportHouse *house in self.currentReportTarget.selectHouses) {//每个推荐对象的楼盘信息都一样，所以可以直接去当前的推荐对象
        [proIds addObject:house.uuid];
    }
    data[@"proIds"] = proIds;//项目列表 必填
    data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid;//推荐人id 必填
    data[@"xqzyAccUuid"] = [MSUserManager sharedInstance].curUserInfo.selectRole.xqzyAccUuid;//上级专员id 必填
    // 临时推荐对象数组
    NSMutableArray *tempTargets = [NSMutableArray arrayWithArray:self.clients];
    // 将当前页面展示的这个需要推荐的对象加入临时数组
    [tempTargets addObject:self.currentReportTarget];
    
    NSMutableArray *cusInfo = [NSMutableArray array];
    for (RCReportTarget *target in tempTargets) {
        NSMutableArray *phones = [NSMutableArray array];
        [phones addObject:target.cusPhone];
        if (target.morePhones && target.morePhones.count) {
            for (RCReportPhone *phone in target.morePhones) {
                [phones addObject:phone.cusPhone];
            }
        }
        [cusInfo addObject:@{@"name":target.cusName,//客户姓名
                             @"phone":phones,//客户手机号
                             @"idNo":(target.idCard && target.idCard.length)?target.idCard:@"", // 身份证号
                             @"cusPicInfo":(target.headPic && target.headPic.length)?@[target.headPic]:@[],
                             @"remark":(target.remark && target.remark.length) ?target.remark:@""//客户备注
        }];
    }
    data[@"cusInfo"] = cusInfo;//客户信息 必填
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/bee/addBaobeiList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"马上推荐客户" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [strongSelf clearReportData];
            RCReportResultVC *rvc = [RCReportResultVC new];
            rvc.results = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"马上推荐客户" image:nil textColor:nil backgroundColor:nil];
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
-(void)clearReportData
{
    RCReportTarget *reportTarget = [RCReportTarget new];
    reportTarget.selectHouses = [NSMutableArray array];
    self.currentReportTarget = reportTarget;
    
    self.houseViewHeight.constant = 50.f;
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
    
    self.name.text = @"";
    self.phone.text = @"";
    self.idCard.text = @"";
    self.clientHeadPic.image = nil;
    self.remark.text = @"";

    self.morePhoneViewHeight.constant = 50.f*self.currentReportTarget.morePhones.count;
    [self.morePhoneView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.currentReportTarget.selectHouses.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseTagsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:HouseTagsCell forIndexPath:indexPath];
    RCReportHouse *house = self.currentReportTarget.selectHouses[indexPath.item];
    cell.delImg.hidden = YES;
    cell.name.text = house.name;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [self.currentReportTarget.selectHouses removeObjectAtIndex:indexPath.item];
//
//    if (!self.currentReportTarget.selectHouses.count) {
//        self.houseViewHeight.constant = 50.f;
//    }else{
//        self.houseViewHeight.constant = 50.f + 60.f;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [collectionView reloadData];
//    });
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCReportHouse *house = self.currentReportTarget.selectHouses[indexPath.item];

    return CGSizeMake([house.name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 50, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(15, 15, 15, 15);
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.clientTableView)?self.clients.count:self.currentReportTarget.morePhones.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.clientTableView) {
        RCAddedClientCell *cell = [tableView dequeueReusableCellWithIdentifier:AddedClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCReportTarget *client = self.clients[indexPath.row];
        cell.client = client;
        hx_weakify(self);
        cell.cutBtnCall = ^{
            hx_strongify(weakSelf);
            [strongSelf.clients removeObjectAtIndex:indexPath.row];
            strongSelf.clientTableViewHeight.constant = 55.f*strongSelf.clients.count;
            [tableView reloadData];
        };
        return cell;
    }else{
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return (tableView == self.clientTableView)?55.f:50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.clientTableView) {
        RCBeePushClientEditVC *evc = [RCBeePushClientEditVC new];
        RCReportTarget *client = self.clients[indexPath.row];
        evc.reportTarget = client;
        evc.editDoneCall = ^{
            [tableView reloadData];
        };
        [self.navigationController pushViewController:evc animated:YES];
    }
}

@end

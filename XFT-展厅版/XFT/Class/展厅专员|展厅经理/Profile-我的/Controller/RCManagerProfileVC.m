//
//  RCManagerProfileVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCManagerProfileVC.h"
#import "RCManagerProfileHeader.h"
#import "RCProfileFooter.h"
#import "RCProfileCell.h"
#import "RCNavBarView.h"
#import "RCChangePwdVC.h"
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCManagerRecordVC.h"
#import "RCManagerMsgVC.h"
#import "RCChangeRoleVC.h"
#import "RCMyBrokerVC.h"
#import "RCMyBeesVC.h"
#import "RCLoginVC.h"
#import "HXNavigationController.h"

static NSString *const ProfileCell = @"ProfileCell";

@interface RCManagerProfileVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 导航栏 */
@property(nonatomic,strong) RCNavBarView *navBarView;
/* 头视图 */
@property(nonatomic,strong) RCManagerProfileHeader *header;
/* 尾视图 */
@property(nonatomic,strong) RCProfileFooter *footer;
/* titles */
@property(nonatomic,strong) NSArray *titles;

@end

@implementation RCManagerProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    [self setUpTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, self.HXNavBarHeight + 100.f + 85.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
}
-(RCNavBarView *)navBarView
{
    if (_navBarView == nil) {
        _navBarView = [RCNavBarView loadXibView];
        _navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
        _navBarView.backBtn.hidden = YES;
        _navBarView.titleL.text = @"我的";
        _navBarView.titleL.textAlignment = NSTextAlignmentCenter;
        _navBarView.titleL.hidden = NO;
        _navBarView.moreBtn.hidden = NO;
        [_navBarView.moreBtn setImage:HXGetImage(@"icon_daka") forState:UIControlStateNormal];
        hx_weakify(self);
        _navBarView.navMoreCall = ^{
            RCManagerRecordVC *rvc = [RCManagerRecordVC new];
            [weakSelf.navigationController pushViewController:rvc animated:YES];
        };
    }
    return _navBarView;
}

-(RCManagerProfileHeader *)header
{
    if (_header == nil) {
        _header = [RCManagerProfileHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight + 100.f + 85.f);
        _header.topNavBar.constant = self.HXNavBarHeight;
        hx_weakify(self);
        _header.infoClicked = ^(NSInteger index) {
            if (index == 1) {
                FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
                [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
                    if (selectedIndex == 0) {
                        [weakSelf awakeImagePickerController:@"1"];
                    }else{
                        [weakSelf awakeImagePickerController:@"2"];
                    }
                }];
            }else{
                RCChangeRoleVC *rvc = [RCChangeRoleVC new];
                [weakSelf.navigationController pushViewController:rvc animated:YES];
            }
        };
    }
    return _header;
}

-(RCProfileFooter *)footer
{
    if (_footer == nil) {
        _footer = [RCProfileFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 100.f);
        _footer.logOutCall = ^{
            FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"确定要退出登录吗" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"退出"]];
            [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
                if (selectedIndex == 0) {
                    [[MSUserManager sharedInstance] logout:nil];
                    
                    RCLoginVC *lvc = [RCLoginVC new];
                    HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
                    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                    
                    //推出主界面出来
                    CATransition *ca = [CATransition animation];
                    ca.type = @"movein";
                    ca.duration = 0.5;
                    [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
                }
            }];
        };
    }
    return _footer;
}
-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = ([MSUserManager sharedInstance].curUserInfo.ulevel==2)?@[@[@"发展经纪人",@"我的小蜜蜂",@"消息中心",@"修改密码",@"版本更新"]]: @[@[@"消息中心",@"修改密码",@"版本更新"]];
    }
    return _titles;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = HXGlobalBg;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCProfileCell class]) bundle:nil] forCellReuseIdentifier:ProfileCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- UIScrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //该页面呈现时手动调用计算导航栏此时应当显示的颜色
    [self.navBarView changeColor:[UIColor whiteColor] offsetHeight:180-self.HXNavBarHeight withOffsetY:scrollView.contentOffset.y];
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
-(void)updateUserPhotoRequest:(NSString *)imageUrl
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"headpic"] = imageUrl;
    
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"showroom/showroom/userDate/updatePhoto" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)queryAppVersionRequest:(void(^)(NSDictionary *version))completedCall
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"applicationMarket"] = @"";
    NSString *key = @"CFBundleShortVersionString";
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    data[@"currentVersion"] = currentVersion;
    
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/appversion/queryAppVersion" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (((NSDictionary *)responseObject[@"data"]).allKeys.count) {
                    if (completedCall) {
                        completedCall(responseObject[@"data"]);
                    }
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
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
            [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.headpic = imageUrl;
            [[MSUserManager sharedInstance] saveUserInfo];
            [strongSelf.header.headImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            [strongSelf updateUserPhotoRequest:imageUrl];
        }];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.titles[section]).count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.hxn_width = HX_SCREEN_WIDTH;
    view.hxn_height = 10.f;
    view.backgroundColor = HXGlobalBg;
    
    return section?view:nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = self.titles[indexPath.section][indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([MSUserManager sharedInstance].curUserInfo.ulevel==2) {
        if (indexPath.row == 0) {
            RCMyBrokerVC *bvc = [RCMyBrokerVC new];
            [self.navigationController pushViewController:bvc animated:YES];
        }else if (indexPath.row == 1){
            RCMyBeesVC *bvc = [RCMyBeesVC new];
            [self.navigationController pushViewController:bvc animated:YES];
        }else if (indexPath.row == 2) {
            RCManagerMsgVC *mvc = [RCManagerMsgVC new];
            [self.navigationController pushViewController:mvc animated:YES];
        }else if (indexPath.row == 3) {
            RCChangePwdVC *pwd = [RCChangePwdVC new];
            [self.navigationController pushViewController:pwd animated:YES];
        }else{
            [self queryAppVersionRequest:^(NSDictionary *version) {
//                appType app类型1:ios2安卓
//                currentVersion  最新版本号
//                downlondUrl 下载地址
//                name  app名称
//                upVesion 可升级版本号
//                upWay  更新渠道
//                upremark 更新内容
//                uptime 更新时间
//                uuid    版本uuid
                // https://www.xxxx.com/ipa/manifest.plist
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",version[@"downlondUrl"]]]];
            }];
        }
    }else{
        if (indexPath.row == 0) {
            RCManagerMsgVC *mvc = [RCManagerMsgVC new];
            [self.navigationController pushViewController:mvc animated:YES];
        }else if (indexPath.row == 1) {
            RCChangePwdVC *pwd = [RCChangePwdVC new];
            [self.navigationController pushViewController:pwd animated:YES];
        }else{
            [self queryAppVersionRequest:^(NSDictionary *version) {
                //                appType app类型1:ios2安卓
                //                currentVersion  最新版本号
                //                downlondUrl 下载地址
                //                name  app名称
                //                upVesion 可升级版本号
                //                upWay  更新渠道
                //                upremark 更新内容
                //                uptime 更新时间
                //                uuid    版本uuid
                // https://www.xxxx.com/ipa/manifest.plist
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",version[@"downlondUrl"]]]];
            }];
        }
    }
}


@end

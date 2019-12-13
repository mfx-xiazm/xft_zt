//
//  RCScanVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCScanVC.h"
#import "SGQRCode.h"
#import "RCRegisterVC.h"

@interface RCScanVC ()
{
    SGQRCodeObtain *obtain;
}
@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
/* 扫描结果处理 */
@property(nonatomic,assign) BOOL isScanResult;
@end

@implementation RCScanVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.isScanResult = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // 二维码开启方法
    [obtain startRunningWithBefore:nil completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    [self.scanView removeTimer];
    [self removeFlashlightBtn];
    [obtain stopRunning];
}

- (void)dealloc {
    NSLog(@"WCQRCodeVC - dealloc");
    [self removeScanningView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    [self.view addSubview:self.bottomView];
    
    [self setupNavigationBar];
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;
    
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.sampleBufferDelegate = YES;
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result) {
            // 在这里处理扫描结果
            weakSelf.isScanResult = YES;
            
            [obtain stopRunning];
            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
            if ([result dictionaryWithJsonString]) {
                NSDictionary *resultDict = [result dictionaryWithJsonString];
                if ([resultDict[@"isShowRoomAddBee"] integerValue] == 1) {
                    RCRegisterVC *rvc = [RCRegisterVC  new];
                    rvc.codeStr = result;
                    [weakSelf.navigationController pushViewController:rvc animated:YES];
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请扫描融客+展厅版APP专员二维码"];
                }
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请扫描融客+展厅版APP专员二维码"];
            }
        }
    }];
    [obtain setBlockWithQRCodeObtainScanBrightness:^(SGQRCodeObtain *obtain, CGFloat brightness) {
        if (brightness < - 1) {
            [weakSelf.view addSubview:weakSelf.flashlightBtn];
        } else {
            if (weakSelf.isSelectedFlashlightBtn == NO) {
                [weakSelf removeFlashlightBtn];
            }
        }
    }];
}

- (void)setupNavigationBar {
    SPButton *item = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    item.frame = CGRectMake(0, self.HXStatusHeight, 70, 44);
    item.imageTitleSpace = 5.f;
    item.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [item setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [item setImage:HXGetImage(@"whback") forState:UIControlStateNormal];
    [item setTitle:@"返回" forState:UIControlStateNormal];
    [item addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:item];
}
-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 扫描相册
- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;
    
    [obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        [weakSelf.view addSubview:weakSelf.scanView];
    }];
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
        } else {
            NSLog(@"识别出二维码");
        }
    }];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
        _scanView.scanImageName = @"ScanLine";
        /** 边框颜色，默认白色 */
        _scanView.borderColor = HXControlBg;
        /** 边角颜色，默认微信颜色 */
        _scanView.cornerColor = HXControlBg;
        /** 边角宽度，默认 2.f */
        _scanView.cornerWidth = 3.f;
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.68 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.58 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [obtain openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    [obtain closeFlashlight];
    self.isSelectedFlashlightBtn = NO;
    self.flashlightBtn.selected = NO;
    [self.flashlightBtn removeFromSuperview];
}


@end

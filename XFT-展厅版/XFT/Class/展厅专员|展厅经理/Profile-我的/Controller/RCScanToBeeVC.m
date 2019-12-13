//
//  RCScanToBeeVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCScanToBeeVC.h"
#import "RCNavBarView.h"
#import "SGQRCode.h"

@interface RCScanToBeeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@property (weak, nonatomic) IBOutlet UILabel *name;

/* 导航栏 */
@property(nonatomic,strong) RCNavBarView *navBarView;
@end

@implementation RCScanToBeeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    self.name.text = [NSString stringWithFormat:@"%@-展厅专员专属码",[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.name];
    self.codeImg.image = [SGQRCodeObtain generateQRCodeWithData:[@{@"isShowRoomAddBee":@"1",@"name":[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.name,@"uuid":[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid,@"xqzyAccUuid":[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.uuid} yy_modelToJSONString] size:self.codeImg.hxn_width];
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
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
}
-(RCNavBarView *)navBarView
{
    if (_navBarView == nil) {
        _navBarView = [RCNavBarView loadXibView];
        _navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
        _navBarView.backBtn.hidden = NO;
        [_navBarView.backBtn setImage:HXGetImage(@"whback") forState:UIControlStateNormal];
        _navBarView.titleL.text = @"二维码扫码";
        _navBarView.titleL.hidden = NO;
        _navBarView.titleL.textAlignment = NSTextAlignmentCenter;
        hx_weakify(self);
        _navBarView.navBackCall = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navBarView;
}
@end

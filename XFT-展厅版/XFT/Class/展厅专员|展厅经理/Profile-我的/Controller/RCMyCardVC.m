//
//  RCMyCardVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyCardVC.h"
#import "SGQRCode.h"
#import <ZLPhotoBrowser.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface RCMyCardVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *name;
/* 要分享的内容 */
@property(nonatomic,strong) NSDictionary *shareInfo;
@end

@implementation RCMyCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的名片"];
    
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.headpic]];
    self.name.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.name;
    self.phone.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.regPhone;
    
   // self.codeImg.image = [SGQRCodeObtain generateQRCodeWithData:@"来一个字符串" size:self.codeImg.hxn_width];
    [self getShareInfoRequest];
}
-(void)getShareInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"showRoomuuid"]  = [MSUserManager sharedInstance].curUserInfo.selectRole.showRoomUuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/universalCaseSiteAdviser/DevelopAgent" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.shareInfo = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(IBAction)saveSnapshotCart
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(HX_SCREEN_WIDTH, 220),NO,0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(UIWindow*window in [[UIApplication sharedApplication] windows]) {
        if(![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
     
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width* [[window layer]anchorPoint].x,
                                  -([window bounds].size.height)* [[window layer]anchorPoint].y-110);
            [[window layer]renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [ZLPhotoManager saveImageToAblum:image completion:^(BOOL suc, PHAsset * _Nonnull asset) {
        if (suc) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"保存成功"];
            });
        }
    }];
}
-(IBAction)shareClicked
{
    if (self.shareInfo) {
        if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未安装微信客户端"];
        }else{
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession)]];
            hx_weakify(self);
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                hx_strongify(weakSelf);
                [strongSelf shareMiniProgramToPlatformType:UMSocialPlatformType_WechatSession];
            }];
        }
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未获取到分享内容"];
    }
}
- (void)shareMiniProgramToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:self.shareInfo[@"title"] descr:self.shareInfo[@"description"] thumImage:self.shareInfo[@"thumbData"]];
    /* 低版本微信网页链接 */
    shareObject.webpageUrl = @"https://www.jianshu.com/p/c75ba7561011";//self.shareInfo[@"webpageUrl"]
    /* 小程序username */
    shareObject.userName = self.shareInfo[@"userName"];
    /* 小程序页面的路径 */
    shareObject.path = self.shareInfo[@"path"];
    /* 小程序新版本的预览图 128k */
    shareObject.hdImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareInfo[@"thumbData"]]];
    /* 分享小程序的版本（正式，开发，体验）*/
    
    NSInteger miniprogramType = [self.shareInfo[@"miniprogramType"] integerValue];//正式版:0，测试版:1，体验版:2
    if (miniprogramType == 0) {
        shareObject.miniProgramType = UShareWXMiniProgramTypeRelease;
    }else if (miniprogramType == 1) {
        shareObject.miniProgramType = UShareWXMiniProgramTypeTest;
    }else{
        shareObject.miniProgramType = UShareWXMiniProgramTypePreview;
    }
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:resp.message];
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
@end

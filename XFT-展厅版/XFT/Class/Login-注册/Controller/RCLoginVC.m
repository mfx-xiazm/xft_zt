//
//  RCLoginVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoginVC.h"
#import "RCWebContentVC.h"
#import "HXTabBarController.h"
#import "RCScanVC.h"

@interface RCLoginVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *agreeMentTV;
/* 扫描跳转 */
@property(nonatomic,assign) BOOL isScan;
@end

@implementation RCLoginVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isScan = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.isScan animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAgreeMentProtocol];
}

-(void)setAgreeMentProtocol
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"登录即代表同意《幸福通用户协议》和《幸福通隐私协议》"];
    [attributedString addAttribute:NSLinkAttributeName value:@"yhxy://" range:[[attributedString string] rangeOfString:@"《幸福通用户协议》"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"ysxy://" range:[[attributedString string] rangeOfString:@"《幸福通隐私协议》"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, attributedString.length)];
    
    _agreeMentTV.attributedText = attributedString;
    _agreeMentTV.linkTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightBold],NSForegroundColorAttributeName: UIColorFromRGB(0x4C8FF7),NSUnderlineColorAttributeName: UIColorFromRGB(0x4C8FF7),NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    _agreeMentTV.delegate = self;
    _agreeMentTV.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    _agreeMentTV.scrollEnabled = NO;
    _agreeMentTV.textAlignment = NSTextAlignmentCenter;
}

- (IBAction)loginBtnClicked:(UIButton *)sender {
        HXTabBarController *tab = [[HXTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
        //推出主界面出来
        CATransition *ca = [CATransition animation];
        ca.type = @"movein";
        ca.duration = 0.5;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
}
- (IBAction)sacnClicked:(UIButton *)sender {
    self.isScan = YES;
    RCScanVC *svc = [RCScanVC new];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark -- UITextView代理
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"yhxy"]) {
        RCWebContentVC *wvc = [RCWebContentVC new];
        wvc.navTitle = @"幸福通用户协议";
        wvc.url = @"https://www.baidu.com/";
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }else if ([[URL scheme] isEqualToString:@"ysxy"]) {
        RCWebContentVC *wvc = [RCWebContentVC new];
        wvc.navTitle = @"幸福通隐私协议";
        wvc.url = @"https://www.baidu.com/";
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }
    return YES;
}

@end

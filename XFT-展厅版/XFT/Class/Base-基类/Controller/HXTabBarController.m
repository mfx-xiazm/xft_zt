//
//  HXTabBarController.m
//  HX
//
//  Created by hxrc on 17/3/2.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "HXTabBarController.h"
#import "UIImage+HXNExtension.h"
#import "HXNavigationController.h"
#import "RCPushVC.h"
#import "RCClientVC.h"
#import "RCProfileVC.h"
#import "RCHouseVC.h"
#import "RCManagerProfileVC.h"
#import "RCTabBar.h"
#import "RCAddTaskVC.h"
#import "RCTaskWorkVC.h"
#import "RCGradeVC.h"
#import "RCGradeVC2.h"
#import "RCTaskWorkVC1.h"

@interface HXTabBarController ()<UITabBarControllerDelegate,RCTabBarDelegate>

@end

@implementation HXTabBarController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x999999);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = HXControlBg;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // 添加子控制器
    /** 账号角色 1:展厅管理经理 2:展厅顾问专员 3:展厅小蜜蜂 */
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {
        // 展厅经理
        [self setupChildVc:[[RCHouseVC alloc] init] title:@"首页房源" image:@"icon_home" selectedImage:@"icon_home_yellow"];
        [self setupChildVc:[[RCGradeVC alloc] init] title:@"客户业绩" image:@"icon_kehu" selectedImage:@"icon_kehu_yellow"];
        [self setupChildVc:[[RCTaskWorkVC alloc] init] title:@"任务考勤" image:@"iocn_renwu" selectedImage:@"iocn_renwu_yellow"];
        [self setupChildVc:[[RCManagerProfileVC alloc] init] title:@"我的更多" image:@"icon_mine" selectedImage:@"icon_mine_yellow"];
        // 替换系统tabBar
        RCTabBar *tab = [[RCTabBar alloc]init];
        tab.rcDelegate = self;
        [self setValue:tab forKey:@"tabBar"];
        
    }else if ([MSUserManager sharedInstance].curUserInfo.ulevel == 2) {
        // 展厅专员
        [self setupChildVc:[[RCHouseVC alloc] init] title:@"首页房源" image:@"icon_home" selectedImage:@"icon_home_yellow"];
        [self setupChildVc:[[RCGradeVC2 alloc] init] title:@"客户业绩" image:@"icon_kehu" selectedImage:@"icon_kehu_yellow"];
        [self setupChildVc:[[RCTaskWorkVC1 alloc] init] title:@"任务考勤" image:@"iocn_renwu" selectedImage:@"iocn_renwu_yellow"];
        [self setupChildVc:[[RCManagerProfileVC alloc] init] title:@"我的更多" image:@"icon_mine" selectedImage:@"icon_mine_yellow"];
        
        // 替换系统tabBar
        RCTabBar *tab = [[RCTabBar alloc]init];
        tab.rcDelegate = self;
        [self setValue:tab forKey:@"tabBar"];
    }else{
        // 小蜜蜂
        [self setupChildVc:[[RCPushVC alloc] init] title:@"报备" image:@"icon_baobei" selectedImage:@"icon_baobei_yellow"];
        [self setupChildVc:[[RCClientVC alloc] init] title:@"客户" image:@"icon_kehu" selectedImage:@"icon_kehu_yellow"];
        [self setupChildVc:[[RCProfileVC alloc] init] title:@"我的" image:@"icon_mine" selectedImage:@"icon_mine_yellow"];
    }
    self.delegate = self;
    
    // 设置透明度和背景颜色
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.translucent = NO;//这句表示取消tabBar的透明效果。
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage imageWithColor:HXRGBAColor(235, 235, 235, 0.8) size:CGSizeMake(1, 0.5)]];
}
-(void)tabBarDidClickPlusButton:(RCTabBar *)tabBar
{
    // 新增任务
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {//展厅经理
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"功能开发中，敬请期待…"];
//        RCAddTaskVC *tvc = [RCAddTaskVC new];
//        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:tvc];
//        [self.selectedViewController presentViewController:nav animated:YES completion:nil];
    }else{
        // 报备客户
        RCPushVC *pvc = [RCPushVC new];
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:pvc];
        [self.selectedViewController presentViewController:nav animated:YES completion:nil];
    }
}
/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个自定义的导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}
#pragma mark -- ————— UITabBarController 代理 —————
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    /*
     if ([viewController.tabBarItem.title isEqualToString:@"聊天"] || [viewController.tabBarItem.title isEqualToString:@"订单"]){
     if (![MSUserManager sharedInstance].isLogined){
     MULoginVC *lvc = [MULoginVC new];
     HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
     [tabBarController.selectedViewController presentViewController:nav animated:YES completion:nil];
     return NO;
     }else{ // 如果已登录
     return YES;
     }
     }else{
     return YES;
     }
     */
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

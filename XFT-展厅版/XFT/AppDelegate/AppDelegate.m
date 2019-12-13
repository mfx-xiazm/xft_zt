//
//  AppDelegate.m
//  STHZ
//
//  Created by hxrc on 2018/11/21.
//  Copyright © 2018 xzm. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+MSAppService.h"
#import "AppDelegate+MSPushService.h"
#import "HXLocationTool_.h"

@interface AppDelegate ()<HXLocationTool_Delegate>
/** 定位属性 */
@property (nonatomic,strong) HXLocationTool_ *locationTool;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 监听网络
//    [self monitorNetworkStatus];
    
    //初始化window
    [self initWindow];
    
    //初始化 app服务
    [self initService];
    
    // 访问定位
    [self.locationTool beginUpdatingLocation];
    
    //初始化用户系统(根据自己的业务判断如何展示)
    [self initUserManager];
    
    // 注册推送
    [self initPushService:launchOptions];

    // 通知点击检测
    [self checkPushNotification:launchOptions];
    
    return YES;
}
#pragma mark -- 懒加载创建自定制的位置类对象
- (HXLocationTool_ *)locationTool {
    
    if (!_locationTool) {
        _locationTool = [[HXLocationTool_ alloc] init];
        _locationTool.delegate = self;
    }
    return _locationTool;
}
#pragma mark -- HXLocationTool 代理
- (void)locationDidEndUpdatingLongitude:(CGFloat)longitude latitude:(CGFloat)latitude city:(NSString *)city {
    //将GPS转成高德坐标
//    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake(latitude,longitude), AMapCoordinateTypeGPS);
//    [[NSUserDefaults standardUserDefaults] setDouble:amapcoord.longitude forKey:HXUserLongitude];
//    [[NSUserDefaults standardUserDefaults] setDouble:amapcoord.latitude forKey:HXUserLatitude];
    
    [[NSUserDefaults standardUserDefaults] setObject:[city stringByReplacingOccurrencesOfString:@"市" withString:@""] forKey:HXUserCityName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end

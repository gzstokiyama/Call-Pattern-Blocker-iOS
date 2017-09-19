//
//  AppDelegate.m
//  batchPhoneBlock
//
//  Created by legend on 2017/9/7.
//  Copyright © 2017年 legend. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "APP_CONSTANTS.h"
#import "SharedFileOperator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    FirstViewController *fvc = [[FirstViewController alloc]init];
    
    
    self.navController = [[UINavigationController alloc] init];
    [[UINavigationBar appearance]setBarTintColor:RGBCOLOR(40, 140, 210)];
    [[UINavigationBar appearance]setTintColor:RGBCOLOR(255, 255, 255)];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navController pushViewController:fvc animated:YES];
    [self.window setRootViewController:self.navController];
    
    //初始化默认数据
    //    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.batchblocker"];
    SharedFileOperator *shared = [[SharedFileOperator alloc]initWithSuiteName:@"group.batchblocker" fileName:@"last.plist"];
    NSDate *lastEdit = [shared valueForKey:@"last_edit"];
    NSDate *lastSync = [shared valueForKey:@"last_sync"];
    
    NSLog(@"app delegate : edit: %@ ,sync:%@",lastEdit,lastSync);
    
    NSDate *now = [NSDate date];
    if ([lastSync timeIntervalSince1970] ==0){
            [shared setValue:now forKey:@"last_edit"];
    }
    if ([lastSync timeIntervalSince1970] ==0){
            [shared setValue:now forKey:@"last_sync"];
    }
    [shared synchronize];
    


    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//禁用第三方输入键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end

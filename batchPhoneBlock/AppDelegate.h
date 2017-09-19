//
//  AppDelegate.h
//  batchPhoneBlock
//
//  Created by legend on 2017/9/7.
//  Copyright © 2017年 legend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;  
+(AppDelegate *)sharedAppDelegate;
@end


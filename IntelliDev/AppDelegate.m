//
//  AppDelegate.m
//  IntelliDev
//
//  Created by chenchao on 16/4/27.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "AppDelegate.h"
#import "CCTabBarController.h"



//UnixPosix 接口 socket pthread.
// TCP/IP UDP
// C/C++


@implementation AppDelegate

@synthesize window;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window=[[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    CCTabBarController* controller=[[[CCTabBarController alloc] init] autorelease];
    self.window.rootViewController=controller;
    
    self.window.backgroundColor=[UIColor whiteColor];
    
    [self.window makeKeyAndVisible];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end

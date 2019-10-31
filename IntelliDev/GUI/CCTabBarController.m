//
//  CCTabBarController.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "CCTabBarController.h"
#import "DeviceListViewController.h"
#import "AddDeviceController.h"

@implementation CCTabBarController

- (id)init
{
    if(self=[super init])
    {
        CGRect winSize=[[UIScreen mainScreen] bounds];
        
        UIImageView* bgImageView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar_bg.png"]] autorelease];
        [bgImageView setFrame:CGRectMake(0, 0, winSize.size.width, 64)];
        [self.tabBar addSubview:bgImageView];
        
        NSString* devListString=NSLocalizedString(@"Devices", nil);
        DeviceListViewController* devListController=[[[DeviceListViewController alloc] init] autorelease];
        
        UITabBarItem *tabBarItem1=[[[UITabBarItem alloc] initWithTitle:devListString image:[UIImage imageNamed:@"devicelist.png"] selectedImage:[UIImage imageNamed:@"devicelist.png"]] autorelease];
        [devListController setTabBarItem:tabBarItem1];
        
        UINavigationController* navController1=[[UINavigationController alloc] initWithRootViewController:devListController];
        [navController1.navigationItem setTitle:devListString];
        
        
        
        NSString* addDevString=NSLocalizedString(@"Add", nil);
        AddDeviceController* addController=[[[AddDeviceController alloc] init] autorelease];
        
        UITabBarItem *tabBarItem2=[[[UITabBarItem alloc] initWithTitle:addDevString image:[UIImage imageNamed:@"addDevice.png"]selectedImage:[UIImage imageNamed:@"addDevice.png"]] autorelease];
        
        [addController setTabBarItem:tabBarItem2];
        UINavigationController* navController2=[[UINavigationController alloc] initWithRootViewController:addController];
        


        
        NSArray* controllers=[NSArray arrayWithObjects:navController1,navController2,nil];
        [self setViewControllers:controllers];
        
        
        
    }
    
    return self;
}
- (void)dealloc
{
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{


    [super viewWillAppear:animated];
}

@end

// MFC Qt vxWidget miniGUI Unity3D


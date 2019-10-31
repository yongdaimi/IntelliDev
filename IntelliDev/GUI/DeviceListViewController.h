//
//  DeviceListViewController.h
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceListInstance.h"
#import "CCNavigationController.h"




@interface DeviceListViewController : UIViewController<UIScrollViewDelegate>
{
    
    int                                     tempViewIndex;
    NSMutableArray*                         signalVCArray;
    
    UIScrollView*                           scrollView;

}
@end
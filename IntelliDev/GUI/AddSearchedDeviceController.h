//
//  AddSearchedDevice.h
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchedDeviceInfoCell.h"
#import "DeviceListInstance.h"

@interface AddSearchedDeviceController : UITableViewController
{
    
    
    UITextField* userName_TF;
    UITextField* passwd_TF;
    
    SearchedDeviceInfoCell *cell;
    
    NSDictionary *searchedDeviceInfoDictionary;
}

- (void)saveSearchedDevice;
- (void)setupSearchedDeviceInfo:(NSDictionary *)infoDic;

@end

//
//  DeviceListInstance.h
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceListInstance : NSObject


+ (DeviceListInstance*) getInstance;
- (BOOL)addDevice:(NSDictionary*)deviceInfo;
- (BOOL)removeDeviceByName: (NSString*)camName;
- (BOOL)removeDeviceAtIndexPath: (NSInteger)index;
- (NSArray*)getDeviceArrayList;
- (BOOL)setDeviceByIndex:(int)index withInfo: (NSDictionary*)info;

@end
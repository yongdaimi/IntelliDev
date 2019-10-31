//
//  DeviceListInstance.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "DeviceListInstance.h"

static DeviceListInstance* deviceInstance=nil;

@implementation DeviceListInstance

+ (DeviceListInstance*) getInstance
{
    @synchronized(self)
    {
        if(deviceInstance==nil)
        {
            deviceInstance=[[DeviceListInstance alloc] init];
        }
    }
    return deviceInstance;
}
- (id)init
{
    if(self=[super init]){
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (BOOL)addDevice:(NSDictionary*)deviceInfo
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    NSString *realPath=[path stringByAppendingPathComponent:@"DeviceList.plist"];
    
    NSFileManager *FM=[NSFileManager defaultManager];
    if([FM fileExistsAtPath:realPath]==NO)
    {
        NSLog(@"No plist file in sandBox copy it from boundle!\n");
        NSError *error;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DeviceList" ofType:@"plist"];
        [FM copyItemAtPath:plistPath toPath:realPath error:&error];
    }
    
    NSMutableArray* deviceArray=[[NSMutableArray alloc] initWithContentsOfFile:realPath];
    
    
    
    NSMutableDictionary* infoDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                         [deviceInfo objectForKey:@"deviceName"],@"deviceName",
                                         [deviceInfo objectForKey:@"ip"],@"key_ip",
                                         [deviceInfo objectForKey:@"port"],@"key_port",
                                         [deviceInfo objectForKey:@"userName"],@"userName",
                                         [deviceInfo objectForKey:@"passwd"],@"passwd",nil];
    
    [deviceArray addObject:infoDictionary];
    
    
    [deviceArray writeToFile:realPath atomically:YES];
    
    [deviceArray release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceInfomationChanged" object:nil];
    
    return YES;
    
    
}

- (BOOL)setCameraDevice: (NSDictionary*)deviceInfo
{
    
    return YES;
    
}
- (NSArray*)getDeviceArrayList
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    NSString *realPath=[path stringByAppendingPathComponent:@"DeviceList.plist"];
    
    NSMutableArray* deviceArray=[[NSMutableArray alloc] initWithContentsOfFile:realPath];
    
    
    return deviceArray;
}

- (BOOL)removeDeviceByName: (NSString*)camName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"DeviceList.plist"];
    
    
    NSMutableArray* deviceArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    
    //检查设备名.
    NSString* newInfoDeviceName=camName;
    for(int i=0; i<deviceArray.count; i++)
    {
        NSDictionary* tmpDic=[deviceArray objectAtIndex:i];
        if(newInfoDeviceName==[tmpDic objectForKey:@"deviceName"])
        {
            [deviceArray removeObjectAtIndex:i];
            [deviceArray writeToFile:filename atomically:YES];
            [deviceArray release];
            
            return YES;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceInfomationChanged" object:nil];
    
    return YES;
}
- (BOOL)removeDeviceAtIndexPath: (NSInteger)index
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"DeviceList.plist"];
    
    
    NSMutableArray* deviceArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    
    if(index<=deviceArray.count)
    {
        [deviceArray removeObjectAtIndex:index];
    }
    
    [deviceArray writeToFile:filename atomically:YES];
    
    [deviceArray release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceInfomationChanged" object:nil];
    
    return YES;
}
- (BOOL)setDeviceByIndex:(int)index withInfo: (NSDictionary*)updateInfo
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"DeviceList.plist"];
    
    
    NSMutableArray* deviceArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    
    if((index <= deviceArray.count)&&(index >= 0))
    {
        [deviceArray replaceObjectAtIndex:index withObject:updateInfo];
        
    }
    
    
    [deviceArray writeToFile:filename atomically:YES];
    
    [deviceArray release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceInfomationChanged" object:nil];
    
    return YES;
    
}
@end

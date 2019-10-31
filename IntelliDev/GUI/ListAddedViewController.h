//
//  ListAddedViewController.h
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListAddedViewController : UITableViewController
{
    NSArray* deviceArray;

}

- (void)updateSearchedDeviceView:(NSArray*)camArray;

@end

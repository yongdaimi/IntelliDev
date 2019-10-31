//
//  SearchedDeviceInfoCell.h
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchedDeviceInfoCell : UITableViewCell<UITextFieldDelegate>
{
    UILabel* nameLabel;
    UITextField *editableTextFeild;
}
@property(nonatomic,retain) UILabel* nameLabel;
@property(nonatomic,retain) UITextField *editableTextFeild;
@end

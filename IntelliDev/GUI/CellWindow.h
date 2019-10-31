//
//  CellWindow.h
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellWindow : UIView
{
    UIImageView* imgView;
}
@property(nonatomic,retain) UILabel* nameLabel;

-(void)updateImage:(UIImage*)image;
@end

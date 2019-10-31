//
//  SearchedDeviceInfoCell.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "SearchedDeviceInfoCell.h"

@implementation SearchedDeviceInfoCell
@synthesize  nameLabel;
@synthesize  editableTextFeild;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        
        UIView* screenView=[[UIView alloc] initWithFrame:CGRectMake(15, 2,290, 39)];
        [screenView setBackgroundColor:[UIColor whiteColor]];
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 38)];
        
        
        editableTextFeild=[[UITextField alloc] initWithFrame:CGRectMake(100,14, 190, 20)];
        editableTextFeild.delegate=self;
        editableTextFeild.rightViewMode=UITextFieldViewModeWhileEditing;
        editableTextFeild.clearButtonMode=UITextFieldViewModeWhileEditing;
        
        
        [screenView addSubview:nameLabel];
        [screenView addSubview:editableTextFeild];
        [self addSubview:screenView];
        
        [nameLabel release];
        [editableTextFeild release];
        [screenView release];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.editableTextFeild resignFirstResponder];
    
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
    
}

@end
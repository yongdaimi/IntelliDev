//
//  CellWindow.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "CellWindow.h"

@implementation CellWindow

@synthesize nameLabel;

- (id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        
        imgView=[[[UIImageView alloc] initWithFrame:frame] autorelease];
        [imgView setImage:[UIImage imageNamed:@"videoClip.png"]];
        [self addSubview:imgView];
        
        UILabel* titleBGLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0,0,frame.size.width,20)] autorelease];
        [titleBGLabel setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2]];
        [titleBGLabel setUserInteractionEnabled:NO];
        [self addSubview:titleBGLabel];
        
        
        UIFont* font=[UIFont fontWithName:@"ArialMT" size:8];
        NSString* noDeviceStr=NSLocalizedString(@"No device", nil);
        self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(5,5,100,10)];
        [self.nameLabel setFont:font];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setTextColor:[UIColor whiteColor]];
        [self.nameLabel setText:[noDeviceStr uppercaseString]];
        [self.nameLabel setUserInteractionEnabled:NO];
        [self addSubview:self.nameLabel];
        
        
        
        [self.nameLabel release];
        
    }
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}

-(void)updateImage:(UIImage*)_image
{
    if(_image){
        [imgView setImage:_image];
    }
    
}
@end
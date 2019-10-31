//
//  CellWindowController.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "CellWindowController.h"


@implementation CellWindowController


@synthesize cellWindow;

- (id)init
{
    if (self = [super init])
    {

        
        
        
        float SCREENVIEW_WIDTH              =160.0;
        float SCREENVIEW_HEIGHT             =117.0;
        float SIGNALFRAMEVIEW_WIDTH         =158.0;
        float SIGNALFRAMEVIEW_HEIGHT        =118.0;
        float ACTIVITYINDICATORVIEW_STARTX  =70.0;
        float ACTIVITYINDICATORVIEW_STARTY  =50.0;
        float ACTIVITYINDICATORVIEW_WIDTH   =20.0;
        float ACTIVITYINDICATORVIEW_HEIGHT  =20.0;
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            SCREENVIEW_WIDTH=378.0;
            SCREENVIEW_HEIGHT=276.0;
            SIGNALFRAMEVIEW_WIDTH=378.0;
            SIGNALFRAMEVIEW_HEIGHT=276.0;
            ACTIVITYINDICATORVIEW_STARTX=160.0;
            ACTIVITYINDICATORVIEW_STARTY=117.0;
            ACTIVITYINDICATORVIEW_WIDTH=30.0;
            ACTIVITYINDICATORVIEW_HEIGHT=30.0;
        }
        
        UIView* screenView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 117)] autorelease];
        
        cellWindow=[[[CellWindow alloc] initWithFrame:CGRectMake(0, 0, 158, 118)] autorelease];
        
        [screenView addSubview:cellWindow];
        
        self.view=screenView;

    
        
    }
    return self;
}
- (void)dealloc
{

    
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSString* postString=[NSString stringWithFormat:@"%d",(int)self.view.tag ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchesInViewSelected" object:postString];
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end

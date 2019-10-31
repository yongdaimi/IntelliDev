//
//  DeviceListViewController.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "DeviceListViewController.h"
#import "CellWindowController.h"
#import "PopupViewController.h"

@implementation DeviceListViewController

- (id)init
{
    if(self=[super init])
    {
        tempViewIndex=-1;

        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesInViewSelected:) name:@"touchesInViewSelected" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDeviceName:) name:@"deviceInfomationChanged" object:nil];
        
        
        
        scrollView=[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [scrollView setAutoresizesSubviews:YES];
        [scrollView setMultipleTouchEnabled:YES];
        [scrollView setContentMode:UIViewContentModeScaleToFill];
        [scrollView setContentSize:CGSizeMake(320 , 960)];
        
        
        signalVCArray=[[NSMutableArray alloc] initWithCapacity:16];
        
        NSArray* tableDeviceArray=[[DeviceListInstance getInstance] getDeviceArrayList];
        
        int aixisX=0, aixisY=0;
        for(int i=0; i<16; i++)
        {
            
            if(i%2==0)
            {
                aixisX=2;
                aixisY=2+120*i/2;
            }
            else{
                aixisX=161;
            }
            
            CellWindowController* cellController=[[CellWindowController alloc] init];
            [cellController.view setFrame:CGRectMake(aixisX, aixisY, 160, 117)];
            [cellController.view setTag:i];
            [self addChildViewController:cellController];
    
            
            [signalVCArray addObject:cellController];
            
            [scrollView addSubview:cellController.view];
            [cellController release];
            
            
            if((tableDeviceArray!=nil)&&((tableDeviceArray.count>i)))
            {
                NSString* deviceName=[[tableDeviceArray objectAtIndex:i] objectForKey:@"deviceName"];
                [cellController.cellWindow.nameLabel setText:deviceName.uppercaseString];
            }

            
        }
        [tableDeviceArray release];
        
        
        self.view=scrollView;
        [scrollView release];
        
        
        
        UIButton* editButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [editButton setBackgroundImage:[UIImage imageNamed:@"editDevices.png"] forState:UIControlStateNormal];
        [editButton setBackgroundImage:[UIImage imageNamed:@"editDevices.png"] forState:UIControlStateHighlighted];
        [editButton setBackgroundImage:[UIImage imageNamed:@"editDevices.png"] forState:UIControlStateSelected];
        [editButton addTarget:self action:@selector(onGenerateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *listButtonItem=[[UIBarButtonItem alloc] initWithCustomView:editButton];
        [listButtonItem setTag:10];
        [self.navigationItem  setRightBarButtonItem:listButtonItem];
        
        
        [editButton release];
        [listButtonItem release];
        
        
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    NSString* devListString=NSLocalizedString(@"Device List", nil);
    [self.navigationItem setTitle:devListString];
    [super viewWillAppear:animated];
}



- (void)touchesInViewSelected: (NSNotification*)notifacation
{
    
    //打开点击当前的signalViewController
    
    NSString* getString=(NSString*)notifacation.object;
    int realValue=[getString intValue];
    tempViewIndex=realValue;
    
    //NSLog(@"NOTIFICATION TOUCH VALUE: %d \n",tempViewIndex);
    
    
    NSArray* tableDeviceArray=[[DeviceListInstance getInstance] getDeviceArrayList];
    
    CellWindowController* activeController=(CellWindowController*)[signalVCArray objectAtIndex:tempViewIndex];
    if(tempViewIndex<tableDeviceArray.count)
    {
        
        NSDictionary* activeDeviceInfo=[tableDeviceArray objectAtIndex:tempViewIndex];
        
        //重设Decoder
        //[activeController setSocketConnectInfo:activeDeviceInfo];
        
    }
    
    
    PopupViewController* popUpViewController=[[[PopupViewController alloc] init] autorelease];
    //[activeController setDecoderDelegate:popUpViewController];
    //[activeController setSignalVCIsEnabled:true];
    //[popUpViewController resetAllUpdateDataInFrameView];
    
    

    
    UINavigationController* tmpNavigationController=[[[UINavigationController alloc] initWithRootViewController:popUpViewController] autorelease];


    [self presentViewController:tmpNavigationController animated:YES completion:^{}];
    
    
    [tableDeviceArray release];
    
    
}


- (void)dealloc
{
    if(signalVCArray!=nil)
    {
        for(int i=0; i<signalVCArray.count; i++)
        {
            CellWindowController* disableController=(CellWindowController*)[signalVCArray objectAtIndex:i];
            
            //[disableController releaseDataModel];
            [disableController release];
            
        }
        [signalVCArray release];
    }

    
    
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (NSString *) pathForDocumentsResource:(NSString *) relativePath
{
    
    NSString* documentsPath = nil;
    
    if (nil == documentsPath)
    {
        
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [dirs objectAtIndex:0];
    }
    
    return [[documentsPath stringByAppendingPathComponent:relativePath] retain];
}

- (BOOL)shouldAutorotate
{
    return NO;
}




- (void)onEditButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editButtonMessageForTableView" object:sender];
}
- (void)onBackButtonClicked:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)refreshDeviceName: (NSNotification*)notification
{
    NSArray* tableDeviceArray=[[DeviceListInstance getInstance] getDeviceArrayList];
    
    if(signalVCArray!=nil)
    {
        for (int i=0; i<signalVCArray.count; i++)
        {
            CellWindowController* viewController=[signalVCArray objectAtIndex:i];
            if((tableDeviceArray!=nil)&&((tableDeviceArray.count>i)))
            {
                NSString* deviceName=[[tableDeviceArray objectAtIndex:i] objectForKey:@"deviceName"];
                [viewController.cellWindow.nameLabel setText:deviceName.uppercaseString];
            }
            else
            {
                NSString* noDeviceStr=NSLocalizedString(@"No device", nil);
                [viewController.cellWindow.nameLabel setText:[noDeviceStr uppercaseString]];
            }
        }
        
    }
    
    [tableDeviceArray release];
}

- (void)onGenerateButtonClicked:(id)sender
{
    
}


@end

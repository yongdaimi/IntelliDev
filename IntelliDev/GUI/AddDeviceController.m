//
//  AddDeviceController.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "AddDeviceController.h"
#import "CCProgressHUD.h"
#import "ListAddedViewController.h"

@interface AddDeviceController ()

@property (nonatomic,retain)UIButton* refreshButton;
@property (nonatomic,retain)ListAddedViewController* listAddedViewController;

@end


@implementation AddDeviceController

- (id)init
{
    if(self=[super init])
    {
        CGSize screenSize=[[UIScreen mainScreen] bounds].size;
        
        UIView* screenView=[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        self.view=screenView;
        
        UIView* topView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 90)] autorelease];
        [topView setBackgroundColor:[UIColor whiteColor]];
        
        UIButton* addButton=[[[UIButton alloc] initWithFrame:CGRectMake(60, 22, 50, 50)] autorelease];
        [addButton setBackgroundImage:[UIImage imageNamed:@"addButton.png"] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[UIImage imageNamed:@"addButton.png"] forState:UIControlStateHighlighted];
        [addButton setBackgroundImage:[UIImage imageNamed:@"addButton.png"] forState:UIControlStateSelected];
        [addButton addTarget:self action:@selector(onAddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.refreshButton=[[[UIButton alloc] initWithFrame:CGRectMake(200, 22, 50, 50)] autorelease];
        [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"refreshButton.png"] forState:UIControlStateNormal];
        [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"refreshButton_selected.png"] forState:UIControlStateHighlighted];
        [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"refreshButton_selected.png"] forState:UIControlStateSelected];
        [self.refreshButton addTarget:self action:@selector(onSearchingCamera:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [topView addSubview:addButton];
        [topView addSubview:self.refreshButton];
        
        
        UIView* bottomView=[[[UIView alloc] initWithFrame:CGRectMake(0, 90, screenSize.width, 390)] autorelease];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        
        self.listAddedViewController=[[[ListAddedViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        [bottomView addSubview: self.listAddedViewController.view];
        [self addChildViewController:self.listAddedViewController];
        
        
        
        [screenView addSubview:topView];
        [screenView addSubview:bottomView];
        

         m_localSearchClient=[[CCLocalSearchClient alloc] init];
        
        
    }
    return self;
}
- (void)dealloc
{
    [ m_localSearchClient release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    NSString* addDevString=NSLocalizedString(@"Add", nil);
    [self.navigationItem setTitle:addDevString];
    [super viewWillAppear:animated];
}

- (void)onAddButtonClicked:(id)sender
{
    
}
- (void)onSearchingCamera:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshButton setEnabled:NO];
        [CCProgressHUD showWithStatus:NSLocalizedString(@"Searching...",nil)];
        [self.listAddedViewController updateSearchedDeviceView:@[]];
    });
    

    //SEARCH.....
    if( m_localSearchClient!=nil)
    {
        [ m_localSearchClient startLocalSearchWithBlock:^(NSArray* tmpArray){
            
            NSLog(@"ARRAY: %@",tmpArray);

            dispatch_async(dispatch_get_main_queue(), ^{

                if(tmpArray!=nil){
                    [self.listAddedViewController updateSearchedDeviceView:tmpArray];
                }
                [CCProgressHUD dismiss];
                [self.refreshButton setEnabled:YES];
            });
            
            
        }];
        
        [self performSelector:@selector(onStopSearch) withObject:nil afterDelay:2];
    }

    
    
    
}
- (void)onStopSearch
{
    [m_localSearchClient stopLocalSearch];
}
@end

//
//  ListAddedViewController.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//


#import "ListAddedViewController.h"
#import "CCNavigationController.h"
#import "AddSearchedDeviceController.h"

@implementation ListAddedViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    
    if (self = [super initWithStyle:style])
    {
        
        int sWidth=[[UIScreen mainScreen] bounds].size.width;
        int sHeight=[[UIScreen mainScreen] bounds].size.height-210;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            sHeight=[[UIScreen mainScreen] bounds].size.height-110;
        }
        self.view.frame=CGRectMake(0, 0, sWidth, sHeight);
        deviceArray=nil;
        
        
        
    }
    return self;
}

- (void)dealloc
{
    if(deviceArray!=nil)
    {
        [deviceArray release];
    }

    [super dealloc];
}

- (void)updateSearchedDeviceView:(NSArray*)camArray
{
    if(camArray==nil)
        return;
    
    if(deviceArray!=nil)
    {
        [deviceArray release];
        deviceArray=nil;
    }
    
    deviceArray=[[NSArray alloc] initWithArray:camArray];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [deviceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(deviceArray!=nil)
    {
        UIFont *font=[UIFont systemFontOfSize:15.0f];
        UIFont *font1=[UIFont systemFontOfSize:15.0f];
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        NSDictionary* tmpDic=[deviceArray objectAtIndex:indexPath.row];
        
        cell.textLabel.font=font;
        cell.textLabel.text=[[NSString stringWithFormat:@"IP: %@",[tmpDic objectForKey:@"key_ip"]] uppercaseString];
        cell.textLabel.font=font;
        cell.detailTextLabel.font=font;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"Port: %@",[tmpDic objectForKey:@"key_port"]];
        cell.detailTextLabel.font=font1;
        
        
        return cell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor colorWithRed:0.75  green:0.75 blue:0.75  alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 22)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    NSString* searchedStr=NSLocalizedString(@"Searched", nil);
    NSString* devicesStr=NSLocalizedString(@"devices", nil);
    titleLabel.text=[NSString stringWithFormat:@"%@ %d %@",searchedStr,deviceArray.count,devicesStr];
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDictionary=nil;
    tmpDictionary=[deviceArray objectAtIndex:indexPath.row];
    if(tmpDictionary!=nil)
    {
        
        AddSearchedDeviceController* addSearchedDeviceViewController=[[[AddSearchedDeviceController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        
        
        CCNavigationController *addInfoNavigationController=[[[CCNavigationController alloc] initWithRootViewController:addSearchedDeviceViewController] autorelease];
        [addSearchedDeviceViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
        



        [addSearchedDeviceViewController setupSearchedDeviceInfo:tmpDictionary];
        
        [self presentViewController:addInfoNavigationController animated:YES completion:nil];
        
    }
    
    
    
}





- (BOOL)shouldAutorotate
{
    return NO;
}


@end

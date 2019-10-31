//
//  AddSearchedDevice.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "AddSearchedDeviceController.h"

@implementation AddSearchedDeviceController

- (id)initWithStyle:(UITableViewStyle)style
{
    
    if (self = [super initWithStyle:style])
    {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        searchedDeviceInfoDictionary=nil;
        cell=nil;
        
        UIButton* saveButton=[[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
        [saveButton setBackgroundImage:[UIImage imageNamed:@"saveButton.png"] forState:UIControlStateNormal];
        [saveButton setBackgroundImage:[UIImage imageNamed:@"saveButton.png"] forState:UIControlStateHighlighted];
        [saveButton setBackgroundImage:[UIImage imageNamed:@"saveButton.png"] forState:UIControlStateSelected];
        [saveButton addTarget:self action:@selector(onButtonSaveClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *saveButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:saveButton] autorelease];
        
        self.navigationItem.rightBarButtonItem=saveButtonItem;
        
        
        
        UIButton* cancelButton=[[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateHighlighted];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateSelected];
        [cancelButton addTarget:self action:@selector(onButtonCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *cancelButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
        
        self.navigationItem.leftBarButtonItem=cancelButtonItem;
        
        
        
    }
    return self;
}

- (void)dealloc
{
    if(searchedDeviceInfoDictionary!=nil)
    {
        [searchedDeviceInfoDictionary release];
        searchedDeviceInfoDictionary=nil;
    }
    if(cell!=nil)
    {
        [cell release];
    }
    [super dealloc];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //return 2; 屏蔽更多设置功能
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 4;
    }
    else if(section==1)
    {
        return 1;
    }
    return 0;
}

- (void)setupSearchedDeviceInfo:(NSDictionary *)infoDic
{
    if(infoDic==nil)
        return;
    
    if(searchedDeviceInfoDictionary!=nil)
    {
        [searchedDeviceInfoDictionary release];
        searchedDeviceInfoDictionary=nil;
    }
    searchedDeviceInfoDictionary=[[NSDictionary alloc] initWithDictionary:infoDic];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellIdentifier = @"searchedDeviceCell";
    cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[SearchedDeviceInfoCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIFont* font=[UIFont fontWithName:@"ArialMT" size:14];
    UIFont* fontB=[UIFont fontWithName:@"Arial-BoldMT" size:14];
    
    [cell.nameLabel setFont:fontB];
    [cell.editableTextFeild setFont:font];
    cell.editableTextFeild.autocapitalizationType= UITextAutocapitalizationTypeNone;
    
    if(searchedDeviceInfoDictionary!=nil)
    {
        if(indexPath.section==0)
        {
            if(indexPath.row==0)
            {
                NSString* deviceNameStr=NSLocalizedString(@"Device name:", nil);
                
                cell.tag=0;
                cell.nameLabel.text=deviceNameStr;
                cell.editableTextFeild.text=@"My Device";
                cell.editableTextFeild.enabled=false;
            }
            else if(indexPath.row==1)
            {
                NSString* portStr=NSLocalizedString(@"Port:", nil);
                
                cell.tag=1;
                cell.nameLabel.text=portStr;
                cell.editableTextFeild.text=@"88";
                cell.editableTextFeild.enabled=false;
                
            }
            else if(indexPath.row==2)
            {
                NSString* userNameStr=NSLocalizedString(@"User name:", nil);
                
                cell.tag=1;
                cell.nameLabel.text=userNameStr;
                

                cell.editableTextFeild.text=@"admin";
                cell.editableTextFeild.enabled=false;
                userName_TF=cell.editableTextFeild;
                
            }
            else if(indexPath.row==3)
            {
                NSString* passwordStr=NSLocalizedString(@"Password:", nil);
                
                cell.tag=2;
                cell.nameLabel.text=passwordStr;
                cell.editableTextFeild.text=nil;
                passwd_TF=cell.editableTextFeild;
                cell.editableTextFeild.secureTextEntry = YES;
            }
        }
        else if(indexPath.section==1)
        {
            if(indexPath.row==0)
            {
                NSString* moreInfoStr=NSLocalizedString(@"More info", nil);
                UIButton *accessViewButton= [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                accessViewButton.backgroundColor = [UIColor clearColor];
                [accessViewButton setTag:4];
                
                cell.nameLabel.text=moreInfoStr;
                cell.accessoryView=accessViewButton;
                cell.editableTextFeild.enabled=false;
                cell.editableTextFeild.hidden=true;
                
                
            }
        }
    }
    
    
    
    return cell;
}

- (void)onButtonSaveClicked:(id)sender
{

    NSString* devName=nil;
    devName=@"My Device";
    NSString* ip=nil;
    ip=[searchedDeviceInfoDictionary objectForKey:@"key_ip"];
    NSString* port=nil;
    port=[searchedDeviceInfoDictionary objectForKey:@"key_port"];
    NSString* userName=[userName_TF text];
    NSString* passWord=[passwd_TF text];
    
    
    
    if((ip!=nil)&&(port!=nil)&&(userName!=nil))
    {
        if(passWord==nil)
        {
            passWord=@"";
        }
        NSDictionary *updateDic=[[NSDictionary alloc] initWithObjectsAndKeys:
                                 ip,@"key_ip",port,@"key_port",userName,@"userName",passWord,@"passwd",devName,@"deviceName",nil];
        DeviceListInstance* instance=[DeviceListInstance getInstance];
        [instance addDevice:updateDic];
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Device info" message:@"IP address,user or password incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceTableView" object:nil];
    
    
    [self  dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    NSString* addDevString=NSLocalizedString(@"Add Searched Device", nil);
    [self.navigationItem setTitle:addDevString];
    
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)onButtonCancelClicked:(id)sender
{
    [self  dismissViewControllerAnimated:YES completion:nil];
    
}
@end

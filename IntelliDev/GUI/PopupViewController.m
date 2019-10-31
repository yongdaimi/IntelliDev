//
//  PopupViewController.m
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "PopupViewController.h"


@interface PopupViewController ()<TCPSocketClientDelegate>
@property (nonatomic,retain)CCTCPSocketClient* socketClient;
@end

@implementation PopupViewController
@synthesize currentRecordType;
@synthesize isRecordingVideo;

@synthesize activityIndicatorView;

@synthesize selectedChannel;
@synthesize selectedAudioMode;

@synthesize recordStartTime;

- (id)init
{
    
    if (self = [super init])
    {
        
        
        //self.navigationItem.title = NSLocalizedString(@"Live View", @"");
        
        recordBeatTimer             =nil;
        __currentDeviceOrientation  =DEVICE_ORIENTATION_PORTRAIT;
        isRecordingVideo            =FALSE;
        currentRecordType           =CURRENT_RECORDTYPE_NONE;
  
        wrongPwdRetryTime           = 0;
        
        listenModeState             =-1;
        recordModeState             =-1;
        talkModeState               =-1;
        
        CGRect screenRect=[[UIScreen mainScreen] bounds];
        
        float TITLEVIEW_STARTY=65;
        
        
        float   OPENGLESVIEW_STARTX=0.0;
        float   OPENGLESVIEW_STARTY=130.0;
        float   OPENGLESVIEW_WIDTH=320.0;
        float   OPENGLESVIEW_HEIGHT=180.0;
        
        float   ACTIVITYINDICATORVIEW_STARTX=145.0;
        float   ACTIVITYINDICATORVIEW_STARTY=60.0;
        float   ACTIVITYINDICATORVIEW_WIDTH=30.0;
        float   ACTIVITYINDICATORVIEW_HEIGHT=30.0;
        
        float   RECORDBEATIMAGE_STARTX=250.0;
        float   RECORDTIMELABEL_STARTX=260.0;
        
        
        
        //7.1版本坐标不一致，从导航栏下开始计算frame.origin.y=0,y上移动64。
        if([self getIOSVersion] !=70)
        {
            TITLEVIEW_STARTY=25;
            OPENGLESVIEW_STARTY=80.0;
        }
        
        
        if (screenRect.size.height==568)
        {
            TITLEVIEW_STARTY=140;
            
            
            OPENGLESVIEW_STARTX=0.0;
            OPENGLESVIEW_STARTY=180.0;
            OPENGLESVIEW_WIDTH=320.0;
            OPENGLESVIEW_HEIGHT=180.0;
            
            ACTIVITYINDICATORVIEW_STARTX=145.0;
            ACTIVITYINDICATORVIEW_STARTY=70.0;
            ACTIVITYINDICATORVIEW_WIDTH=30.0;
            ACTIVITYINDICATORVIEW_HEIGHT=30.0;
            
            //7.1版本坐标不一致，从导航栏下开始计算frame.origin.y=0,y上移动64。
            if([self getIOSVersion] !=70)
            {
                TITLEVIEW_STARTY=25;
                OPENGLESVIEW_STARTY=120.0;
            }
        }
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            TITLEVIEW_STARTY=180;
            
            
            
            OPENGLESVIEW_STARTX=0.0;
            OPENGLESVIEW_STARTY=240.0;
            OPENGLESVIEW_WIDTH=768.0;
            OPENGLESVIEW_HEIGHT=432.0;
            
            ACTIVITYINDICATORVIEW_STARTX=370.0;
            ACTIVITYINDICATORVIEW_STARTY=200.0;
            ACTIVITYINDICATORVIEW_WIDTH=30.0;
            ACTIVITYINDICATORVIEW_HEIGHT=30.0;
            
            RECORDBEATIMAGE_STARTX=708.0;
            RECORDTIMELABEL_STARTX=718.0;
            
            //7.1版本坐标不一致，从导航栏下开始计算frame.origin.y=0,y上移动64。
            if([self getIOSVersion] !=70)
            {
                TITLEVIEW_STARTY=120;
                OPENGLESVIEW_STARTY=180.0;
            }
        }
        
        UIView *screenView=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [screenView setBackgroundColor:[UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1]];
        screenView.autoresizesSubviews=YES;
        
        
        titleView=[[UIView alloc] initWithFrame:CGRectMake(screenRect.size.width-80, TITLEVIEW_STARTY, 75, 15)];
        [titleView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        
        UIFont*     labelFont=[UIFont fontWithName:@"Verdana" size:12];

        
        videoWH_Label=[[UILabel alloc] initWithFrame:CGRectMake(-screenRect.size.width+90, 5, 80, 15)];
        [videoWH_Label setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [videoWH_Label setText:@"00x00"];
        [videoWH_Label setFont:labelFont];
        [videoWH_Label setTextAlignment:NSTextAlignmentLeft];
        [videoWH_Label setTextColor:[UIColor whiteColor]];
        [titleView addSubview:videoWH_Label];
        
        ////////////////////////////////////////////////////////////////////
        
        openGLESView=[[OpenGLFrameView alloc] initWithFrame:CGRectMake(OPENGLESVIEW_STARTX, OPENGLESVIEW_STARTY, OPENGLESVIEW_WIDTH, OPENGLESVIEW_HEIGHT)];
        openGLESView.openGLESViewPTZDelegate=self;
        
        ////////////////////////////////////////////////////////////////////
//        
//        self.videoLayer = [[AVSampleBufferDisplayLayer alloc] init];
//        //self.videoLayer.bounds = self.view.bounds;
//        self.videoLayer.frame=CGRectMake(OPENGLESVIEW_STARTX, OPENGLESVIEW_STARTY, OPENGLESVIEW_WIDTH, OPENGLESVIEW_HEIGHT);
//        self.videoLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//        self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//        self.videoLayer.backgroundColor = [[UIColor blackColor] CGColor];
//        
//        //set Timebase
//        CMTimebaseRef controlTimebase;
//        CMTimebaseCreateWithMasterClock( CFAllocatorGetDefault(), CMClockGetHostTimeClock(), &controlTimebase );
//        
//        self.videoLayer.controlTimebase = controlTimebase;
//        CMTimebaseSetTime(self.videoLayer.controlTimebase, CMTimeMake(5, 1));
//        CMTimebaseSetRate(self.videoLayer.controlTimebase, 1.0);
//        ////////////////////////////////////////////////////////////////////
        
        
        scrollView=[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [scrollView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]];
        scrollView.delegate=self;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 4.0;
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.showsVerticalScrollIndicator=NO;
        scrollView.contentSize = openGLESView.frame.size;
        scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [scrollView setAutoresizesSubviews:YES];
        [scrollView setMultipleTouchEnabled:YES];
        [scrollView addSubview:openGLESView];
//        [[screenView layer] addSublayer:self.videoLayer];
//        [self.videoLayer release];
        
        
        
        self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(ACTIVITYINDICATORVIEW_STARTX,ACTIVITYINDICATORVIEW_STARTY,ACTIVITYINDICATORVIEW_WIDTH,ACTIVITYINDICATORVIEW_HEIGHT)] autorelease];
        self.activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhite;
        self.activityIndicatorView.hidesWhenStopped=YES;
        self.activityIndicatorView.userInteractionEnabled=NO;
        [openGLESView addSubview:self.activityIndicatorView];

        
        
        CGSize screenSize=[[UIScreen mainScreen] bounds].size;
        

        
        
        
        recordButton=[[UIButton alloc] initWithFrame:CGRectMake(screenSize.width/2-20, openGLESView.frame.origin.y+OPENGLESVIEW_HEIGHT+40, 40, 40)];
        recordButton.tag=0;
        [recordButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        [recordButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateSelected];
        [recordButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateHighlighted];
        [recordButton addTarget:self action:@selector(selectRecrod:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        
        
        
        
        updateVideoIsReady=FALSE;
        
        [screenView addSubview: scrollView];
        [screenView addSubview:titleView];
        

        [screenView addSubview:recordButton];
        [recordButton release];
        
        self.view=screenView;
        
        [titleView release];
        [openGLESView release];
        [scrollView release];
        [screenView release];
        
        
    }

    
    self.socketClient=[[CCTCPSocketClient alloc] init];
    self.socketClient.tcpSocketDelegate=self;
    
    
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated
{


    [self preferredStatusBarStyle];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    
    UIButton* backButton=[[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
    [backButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateHighlighted];
    [backButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(onBackButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
    
    NSString* videoInfoStr=NSLocalizedString(@"Live show", nil);

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setTitle:videoInfoStr];
    
    char* serverIP="192.168.1.104";
    char* userName="admin";
    char* password="123456";
    
    CC_NetConnectInfo connectionInfo;
    memcpy(connectionInfo.server_ip, serverIP, sizeof(connectionInfo.server_ip));
    memcpy(connectionInfo.user_name, userName, sizeof(connectionInfo.user_name));
    memcpy(connectionInfo.pass_word, password, sizeof(connectionInfo.pass_word));
    connectionInfo.port=30000;
    
    [self.socketClient startTCPSocketConnection:&connectionInfo];
    
    [self.activityIndicatorView startAnimating];
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{

    [self.activityIndicatorView stopAnimating];
    [super viewDidDisappear:animated];
}
- (void)dealloc
{
//    if(self.videoLayer){
//        CFRelease(self.videoLayer);
//        self.videoLayer=nil;
//    }
    
    if(recordBeatTimer){
        [recordBeatTimer invalidate];
    }

    openGLESView.openGLESViewPTZDelegate=nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

   
    if(self.socketClient!=nil)
    {
        [self.socketClient release];
    }
    [super dealloc];
}
- (void)onBackButtonItemClicked:(id)sender
{
    [self.socketClient stopTCPSocketClient];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return openGLESView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    
}

- (void)scrollViewDidZoom:(UIScrollView *)_zoomView
{
    
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    
    CGFloat xcenter = _zoomView.center.x;
    CGFloat ycenter = _zoomView.center.y;
    
    if(__currentDeviceOrientation==DEVICE_ORIENTATION_PORTRAIT)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            if([self getIOSVersion] !=70)
            {
                ycenter=ycenter-60;
            }
        }
        else
        {
            if (screenRect.size.height==568)
            {
                if([self getIOSVersion] !=70)
                {
                    ycenter=ycenter-40;
                }
            }
            else
            {
                if([self getIOSVersion] !=70)
                {
                    ycenter=ycenter-50;
                }
            }
        }
    }
    
    xcenter = _zoomView.contentSize.width > _zoomView.frame.size.width ? _zoomView.contentSize.width/2 : xcenter;
    ycenter = _zoomView.contentSize.height > _zoomView.frame.size.height ? _zoomView.contentSize.height/2 : ycenter;
    
    //printf("SCROLLVIEW ZOOM: %f %f %f %f\n",xcenter,ycenter,_zoomView.contentSize.width/2,_zoomView.contentSize.height/2);
    
    [openGLESView  setCenter:CGPointMake(xcenter, ycenter)];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}
-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    CGSize screenSize=[[UIScreen mainScreen] bounds].size;
    
    float   OPENGLVIEW_PORTRAIT_STARTX=0.0;
    float   OPENGLVIEW_PORTRAIT_STARTY=130.0;
    float   OPENGLVIEW_PORTRAIT_WIDTH=320.0;
    float   OPENGLVIEW_PORTRAIT_HEIGHT=180.0;
    
    float   OPENGLVIEW_LANDSCAPE_STARTX=0.0;
    float   OPENGLVIEW_LANDSCAPE_STARTY=25.0;
    float   OPENGLVIEW_LANDSCAPE_WIDTH=480.0;
    float   OPENGLVIEW_LANDSCAPE_HEIGHT=270.0;
    
    float   ACTIVITYINDICATORVIEW_PORTRAIT_STARTX=145.0;
    float   ACTIVITYINDICATORVIEW_PORTRAIT_STARTY=60.0;
    float   ACTIVITYINDICATORVIEW_PORTRAIT_WIDTH=30.0;
    float   ACTIVITYINDICATORVIEW_PORTRAIT_HEIGHT=30.0;
    
    float   ACTIVITYINDICATORVIEW_LANDSCAPE_STARTX=195.0;
    float   ACTIVITYINDICATORVIEW_LANDSCAPE_STARTY=145.0;
    float   ACTIVITYINDICATORVIEW_LANDSCAPE_WIDTH=30.0;
    float   ACTIVITYINDICATORVIEW_LANDSCAPE_HEIGHT=30.0;
    
    float   TITLEVIEW_PORTRAIT_STARTX =245;
    float   TITLEVIEW_LANDSCAP_STARTX =405;
    float   TITLEVIEW_PORTRAIT_STARTY =65;
    float   TITLEVIEW_LANDSCAP_STARTY =26;
    
    
    
    float   RECORDBEATIMAGE_PRORAIT_STARTX=250.0;
    float   RECORDTIMELABEL_PRORAIT_STARTX=260.0;
    
    float   RECORDBEATIMAGE_LANDSCAPE_STARTX=420.0;
    float   RECORDTIMELABEL_LANDSCAPE_STARTX=430.0;
    
    
    //7.1版本坐标不一致，从导航栏下开始计算frame.origin.y=0,y上移动64。
    if([self getIOSVersion] !=70)
    {
        OPENGLVIEW_PORTRAIT_STARTY=130.0;
        TITLEVIEW_PORTRAIT_STARTY =25;
        
    }
    
    
    if(screenSize.height==568)
    {
        
        OPENGLVIEW_PORTRAIT_STARTX=0.0;
        OPENGLVIEW_PORTRAIT_STARTY=180.0;
        OPENGLVIEW_PORTRAIT_WIDTH=320.0;
        OPENGLVIEW_PORTRAIT_HEIGHT=180.0;
        
        OPENGLVIEW_LANDSCAPE_STARTX=0.0;
        OPENGLVIEW_LANDSCAPE_STARTY=0.0;
        OPENGLVIEW_LANDSCAPE_WIDTH=568.0;
        OPENGLVIEW_LANDSCAPE_HEIGHT=320.0;
        
        ACTIVITYINDICATORVIEW_PORTRAIT_STARTX=145.0;
        ACTIVITYINDICATORVIEW_PORTRAIT_STARTY=70.0;
        ACTIVITYINDICATORVIEW_PORTRAIT_WIDTH=30.0;
        ACTIVITYINDICATORVIEW_PORTRAIT_HEIGHT=30.0;
        
        ACTIVITYINDICATORVIEW_LANDSCAPE_STARTX=268.0;
        ACTIVITYINDICATORVIEW_LANDSCAPE_STARTY=145.0;
        ACTIVITYINDICATORVIEW_LANDSCAPE_WIDTH=30.0;
        ACTIVITYINDICATORVIEW_LANDSCAPE_HEIGHT=30.0;
        
        TITLEVIEW_PORTRAIT_STARTX =245;
        TITLEVIEW_LANDSCAP_STARTX =493;
        TITLEVIEW_PORTRAIT_STARTY =140;
        TITLEVIEW_LANDSCAP_STARTY =1;
        
        
        
        RECORDBEATIMAGE_PRORAIT_STARTX=250.0;
        RECORDTIMELABEL_PRORAIT_STARTX=260.0;
        
        RECORDBEATIMAGE_LANDSCAPE_STARTX=508.0;
        RECORDTIMELABEL_LANDSCAPE_STARTX=518.0;
        
        
        //7.1版本坐标不一致，从导航栏下开始计算frame.origin.y=0,y上移动64。
        if([self getIOSVersion] !=70)
        {
            OPENGLVIEW_PORTRAIT_STARTY=120.0;
            TITLEVIEW_PORTRAIT_STARTY =25;
            
        }
        
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        OPENGLVIEW_PORTRAIT_STARTX=0.0;
        OPENGLVIEW_PORTRAIT_STARTY=240.0;
        OPENGLVIEW_PORTRAIT_WIDTH=768.0;
        OPENGLVIEW_PORTRAIT_HEIGHT=432.0;
        
        OPENGLVIEW_LANDSCAPE_STARTX=0.0;
        OPENGLVIEW_LANDSCAPE_STARTY=96.0;
        OPENGLVIEW_LANDSCAPE_WIDTH=1024.0;
        OPENGLVIEW_LANDSCAPE_HEIGHT=576.0;
        
        ACTIVITYINDICATORVIEW_PORTRAIT_STARTX=370.0;
        ACTIVITYINDICATORVIEW_PORTRAIT_STARTY=200.0;
        ACTIVITYINDICATORVIEW_PORTRAIT_WIDTH=30.0;
        ACTIVITYINDICATORVIEW_PORTRAIT_HEIGHT=30.0;
        
        ACTIVITYINDICATORVIEW_LANDSCAPE_STARTX=500.0;
        ACTIVITYINDICATORVIEW_LANDSCAPE_STARTY=270.0;
        ACTIVITYINDICATORVIEW_LANDSCAPE_WIDTH=30.0;
        ACTIVITYINDICATORVIEW_LANDSCAPE_HEIGHT=30.0;
        
        TITLEVIEW_PORTRAIT_STARTX =688;
        TITLEVIEW_LANDSCAP_STARTX =940;
        TITLEVIEW_PORTRAIT_STARTY =180;
        TITLEVIEW_LANDSCAP_STARTY =60;
        
        
        RECORDBEATIMAGE_PRORAIT_STARTX=704.0;
        RECORDTIMELABEL_PRORAIT_STARTX=714.0;
        
        RECORDBEATIMAGE_LANDSCAPE_STARTX=960.0;
        RECORDTIMELABEL_LANDSCAPE_STARTX=970.0;
        
        
        //7.1版本坐标不一致，从导航栏下开始计算frame.origin.y=0,y上移动64。
        if([self getIOSVersion] !=70)
        {
            OPENGLVIEW_PORTRAIT_STARTY=180.0;
            TITLEVIEW_PORTRAIT_STARTY =120;
            
        }
    }
    
    [scrollView setZoomScale:1.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordModeDialog_makeMainDialogDisappeared" object:nil];
    if(toInterfaceOrientation==UIDeviceOrientationPortrait)
    {
        __currentDeviceOrientation=DEVICE_ORIENTATION_PORTRAIT;
        
        [openGLESView setFrame:CGRectMake(OPENGLVIEW_PORTRAIT_STARTX, OPENGLVIEW_PORTRAIT_STARTY, OPENGLVIEW_PORTRAIT_WIDTH, OPENGLVIEW_PORTRAIT_HEIGHT)];
        
        [self.navigationController.navigationBar setHidden:NO];
        [[UIApplication sharedApplication ]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        
        [activityIndicatorView setFrame:CGRectMake(ACTIVITYINDICATORVIEW_PORTRAIT_STARTX,ACTIVITYINDICATORVIEW_PORTRAIT_STARTY,ACTIVITYINDICATORVIEW_PORTRAIT_WIDTH,ACTIVITYINDICATORVIEW_PORTRAIT_HEIGHT)];
        
        [titleView setFrame:CGRectMake(TITLEVIEW_PORTRAIT_STARTX, TITLEVIEW_PORTRAIT_STARTY, 75, 15)];
        
        
        
        
    }
    else if((toInterfaceOrientation==UIDeviceOrientationLandscapeLeft)||(toInterfaceOrientation==UIDeviceOrientationLandscapeRight))
    {
        
        __currentDeviceOrientation=DEVICE_ORIENTATION_LANDSCAP;
        [self.navigationController.navigationBar setHidden:YES];
        
        [openGLESView setFrame:CGRectMake(OPENGLVIEW_LANDSCAPE_STARTX, OPENGLVIEW_LANDSCAPE_STARTY, OPENGLVIEW_LANDSCAPE_WIDTH, OPENGLVIEW_LANDSCAPE_HEIGHT)];
        
        
        [[UIApplication sharedApplication ]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
        [activityIndicatorView setFrame:CGRectMake(ACTIVITYINDICATORVIEW_LANDSCAPE_STARTX,ACTIVITYINDICATORVIEW_LANDSCAPE_STARTY,ACTIVITYINDICATORVIEW_LANDSCAPE_WIDTH,ACTIVITYINDICATORVIEW_LANDSCAPE_HEIGHT)];
        [titleView setFrame:CGRectMake(TITLEVIEW_LANDSCAP_STARTX, TITLEVIEW_LANDSCAP_STARTY, 75, 15)];
        
        
        
    }
    
}
- (int)getIOSVersion
{
    float versionValue= [[[UIDevice currentDevice] systemVersion] floatValue];
    //NSLog(@"IOS VERSION: %d\n",(int)(versionValue*10));
    return (int)(versionValue*10);
}

- (void)cameraUpdateDecodedH264FrameData:(H264YUV_Frame*)yuvFrame
{
    
    if([self.activityIndicatorView isAnimating])
    {
        [self.activityIndicatorView stopAnimating];
    }
    [videoWH_Label setText:[NSString stringWithFormat:@"%dx%d",yuvFrame->width,yuvFrame->height]];
    [openGLESView render:yuvFrame];//渲染YUV
    updateVideoIsReady=TRUE;
    
    
}
- (void)CameraUpdateDecodedH264SampleBuffer:(CMSampleBufferRef)sampleBuffer
{
//    if([activityIndicatorView isAnimating])
//    {
//        [activityIndicatorView stopAnimating];
//    }
    [self.videoLayer enqueueSampleBuffer:sampleBuffer];
    updateVideoIsReady=TRUE;
}
- (void)selectRecrod:(id)sender
{
    if(!updateVideoIsReady){
        return;
    }
    
    UIButton* button=(UIButton*)sender;
    
    if(button.tag==0){
        button.tag=1;
        [recordButton setBackgroundImage:[UIImage imageNamed:@"recording.png"] forState:UIControlStateNormal];
        [recordButton setBackgroundImage:[UIImage imageNamed:@"recording.png"] forState:UIControlStateHighlighted];
        [recordButton setBackgroundImage:[UIImage imageNamed:@"recording.png"] forState:UIControlStateSelected];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startRecordingVideo" object:nil];
        
        
    }
    else if(button.tag==1)
    {
        button.tag=0;
        [recordButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        [recordButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateHighlighted];
        [recordButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateSelected];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRecordingVideo" object:nil];
    }
}



@end

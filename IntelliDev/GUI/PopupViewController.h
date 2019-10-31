//
//  PopupViewController.h
//  IntelliDev
//
//  Created by chenchao on 16/4/28.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/CALayer.h>
#import "OpenGLFrameView.h"

#import "CCTCPSocketClient.h"
typedef enum
{
    AUDIO_MODE_OFF          = 0,
    AUDIO_MODE_SPEAKER      = 1,
    AUDIO_MODE_MICROPHONE   = 2,
}ENUM_AUDIO_MODE;


typedef enum DeviceOrientation
{
    DEVICE_ORIENTATION_PORTRAIT=0,
    DEVICE_ORIENTATION_LANDSCAP,
    DEVICE_ORIENTATION_NONE
}CurrentDeviceOrientation;

typedef enum RecordType
{
    CURRENT_RECORDTYPE_LOCAL=0,
    CURRENT_RECORDTYPE_SDCARD,
    CURRENT_RECORDTYPE_NONE
    
}CURRENT_RECORDTYPE;





@interface PopupViewController : UIViewController<UIAlertViewDelegate,UIScrollViewDelegate,OpenGLESViewPTZDelegate>
{
    
    CURRENT_RECORDTYPE                  currentRecordType;
    unsigned short                      mCodecId;
    
    int                                 listenModeState;
    int                                 recordModeState;
    int                                 talkModeState;
    
    NSString                            *directoryPath;
    
    
    NSInteger                           selectedChannel;
    ENUM_AUDIO_MODE                     selectedAudioMode;
    
    int                                 wrongPwdRetryTime;
    
    
    UIButton*                           recordButton;
    
    

    UILabel*                            videoWH_Label;
    
    UIView*                             titleView;
    UIScrollView*                       scrollView;
    
    
    BOOL                                updateVideoIsReady;
    BOOL                                isRecordingVideo;
    
    OpenGLFrameView*                    openGLESView;
    

    
    
    
    NSTimer*                            recordBeatTimer;
    NSString*                           recordStartTime;
    //全局变量，定义当前屏幕的旋转方向.
    CurrentDeviceOrientation            __currentDeviceOrientation;

    
}
@property (nonatomic,readwrite)CURRENT_RECORDTYPE                   currentRecordType;
@property (nonatomic,readwrite)BOOL                                 isRecordingVideo;

@property (nonatomic,retain)NSString*                               recordStartTime;
@property (nonatomic,retain)UIActivityIndicatorView*                activityIndicatorView;
@property NSInteger selectedChannel;
@property ENUM_AUDIO_MODE selectedAudioMode;;

@property (nonatomic, retain) AVSampleBufferDisplayLayer *videoLayer;

@end

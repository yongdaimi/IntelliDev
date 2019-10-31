//
//  CCTCPSocketClient.h
//  IntelliDev
//
//  Created by chenchao on 16/4/29.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnixInterfaceDefine.h"
#import "CCTCPDataDefine.h"
#include "H264Decoder.h"
#include "H264HWDecoder.h"


@protocol TCPSocketClientDelegate <NSObject>
@optional

- (void)cameraUpdateDecodedH264FrameData:(H264YUV_Frame*)yuvFrame;
- (void)CameraUpdateDecodedH264SampleBuffer: (CMSampleBufferRef)sampleBuffer;

@end

@interface CCTCPSocketClient : NSObject<updateDecodedH264FrameDelegate,UpdateDecodedSampleBufferDelegate>
{
    
    //保留网络登陆用户信息
    char                        m_IPAdress[64];                 //camIP
    int                         m_port;                       //端口
    char                        m_userName[13];                  //用户名
    char                        m_password[13];                  //密码
    
    int                         m_cSockfd;                      //命令套接字.
    int                         m_dSockfd;                      //数据通道套接字.
    
    int                         m_videoID;      //视频ID
    
    struct   sockaddr_in        m_cSockaddr_in;
    struct   sockaddr_in        m_dSockaddr_in;
    
    bool                        m_recvDataToggle;
    bool                        m_recvCommandToggle;
    
    NSTimer*                    keeepAliveTimer;
    
    pthread_mutex_t             mutex_cRecv;
    pthread_mutex_t             mutex_cSend;
    pthread_mutex_t             mutex_dRecv;
    pthread_mutex_t             mutex_dSend;
}
@property (nonatomic, assign) id<TCPSocketClientDelegate> tcpSocketDelegate;
- (bool)startTCPSocketConnection: (CC_NetConnectInfo*)  connectionInfo;
- (void)stopTCPSocketClient;
- (bool)stopListenCommand;
- (bool)startListenCommand;
@end

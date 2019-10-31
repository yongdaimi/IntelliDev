//
//  CCTCPDataDefine.h
//  IntelliDev
//
//  Created by chenchao on 16/4/29.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#ifndef CCTCPDataDefine_h
#define CCTCPDataDefine_h

#include "DataStructDefine.h"

#define         CONTROLCODE_LOGIN_REQUEST                       0
#define         CONTROLCODE_LOGIN_REPLY                         1
#define         CONTROLCODE_VERIFY_REQUEST                      2
#define         CONTROLCODE_VERIFY_REPLY                        3

#define         LOGIN_REQUEST_REPLY_VALUE_OK                    0
#define         LOGIN_REQUEST_REPLY_VALUE_BADACCESS             2

#define         VERIFY_REPLY_VALUE_OK                           0 //登陆正确
#define         VERIFY_REPLY_VALUE_USER_ERROR                   1
#define         VERIFY_REPLY_VALUE_PASS_ERROR                   5

#define         CONTROLLCODE_LISTENSTART_COMMAND                8    //开始监听  (操作命令)
#define         CONTROLLCODE_LISTENSTART_REPLY                  9    //音频回应  (操作命令)
#define         CONTROLLCODE_LISTENSTOP_COMMAND                 10   //停止监听  (操作命令)


#define         CONTROLLCODE_VIDEOTRANSLATION_REQUEST           4    //视频请求  (操作命令)
#define         CONTROLLCODE_VIDEOTRANSLATION_REPLY             5    //视频回应  (操作命令)
#define         CONTROLLCODE_VIDEOTRANSLATION_STOP              6    //视频停止  (操作命令)

#define         CONTROLLCODE_DECODER_CONTROLL                   14   //解码器控制  (操作命令)

#define         VIDEOIREQUESTREPLY_OK                           0   //同意连接
#define         VIDEOIREQUESTREPLY_USERFULL                     2   //用户已经满
#define         VIDEOIREQUESTREPLY_FORBIDEN                     8   //禁止连接


#define         CODECONTROLL_VIDEOTRANS_WIDTHID_REQUEST         0   //视频请求
#define         CODECONTROLL_VIDEOTRANS_WIDTHID_REPLY           1
#define         CONTROLLCODE_LISTENTRANSPORTREPLY               2   //音频

#define         CODECONTROLL_GET_DEVICEPARAMS_REPLY             17   //设备信息.

#define         CODECONTROLL_SEND_KEEPALIVE_REQUEST             255   //心跳包.

#pragma pack(push, 1)

//网络连接信息结构体
typedef struct NetConnectInfomation
{
    char server_ip[64];   //camIP
    int  port;            //端口
    char user_name[13];	  //用户名
    char pass_word[13];	  //密码
    
}CC_NetConnectInfo;

//包头
typedef struct MessageHeader
{
    unsigned char           messageHeader[4];   //协议头 MO_O 命令  MO_V 传数据.
    short                   controlMask;        //操作码，区分同个协议的命令。
    unsigned char           reserved0;
    unsigned char           reserved1[8];
    int                     commandLength;      //包后面跟的数据的长度。
    int                     reserved2;
}CC_MsgHeader;


//登陆回应结构体
typedef struct  LoginRequest_Reply
{
    CC_MsgHeader            msgHeader;
    short                   result;             //0:ok 2:已达到最大的连接许可数,连接 将断开
    unsigned char           devID[13];          //设备ID
    unsigned char           reserved0[4];
    unsigned char           reserved1[4];
    unsigned char           devVersion[4];      //摄像头固件版本。
    
}CC_LoginRequestReply;

//校验请求正文结构体
typedef struct verifyReqeustContent
{
    unsigned char           userName[13]; //用户名
    unsigned char           password[13]; //密码
    
}CC_VerifyRequestContent;

typedef struct verifyReply
{
    CC_MsgHeader            msgHeader;
    short                   result; //0 较验正确 1 用户名出错 5 密码出错.
    char                    reserved;
    
}CC_VerifyReply;


typedef struct signalDeviceInfo
{
    char  msid[13];
    char  alias[21];
    
    char  host[65];
    short port;
    
    char  user[13];
    char  pwd[13];
    
    char  mode;
    
}SignalDeviceInfo;


//视频传输正文
typedef struct videoTranslationRequest
{
    CC_MsgHeader msgHeader;
    char          reserved;   //保留
    
}CC_videoTranslationRequest;


//视频响应.
typedef struct videoTranslationRequestReply
{
    CC_MsgHeader msgHeader;
    short           result;   //0: 同意 2 超过最大连接数被拒绝.
    unsigned int             videoID;  //当Result=0 并且之前没有进行因视频传输时，本字段才存在.用来标识数据连接的ID.
    
}CC_videoTranslationRequestReply;

//请求视频数据。
typedef struct videoTransRequestWithID
{
    CC_MsgHeader    msgHeader;
    int             videoID;
    
}CC_VideoTransRequestWithID;


//视频正文结构体
typedef struct videoDataContent
{
    unsigned int             timeStamp; //时间戳
    unsigned int             frameTime; //帧采集时间
    unsigned char            reserved;  //保留
    unsigned int             videoLength;  //图片长度
    
}CC_videoDataContent;

//音频请求结构体
typedef struct audioRequestCommand
{
    CC_MsgHeader msgHeader;
    char            reserved;    //保留
}CC_audioRequestCommand;



//音频接收响应正文
typedef struct audioRequestCommandReply
{
    CC_MsgHeader msgHeader;
    short           result; //0：同意 2:超过最大连接数拒绝 7: 机器不支持此功能
    int             audioID; //数据连接ID.
}CC_audioRequestCommandReply;

//音频正文结构体
typedef struct audioDataContent
{
    unsigned int             timeStamp;//时间戳
    unsigned int             packageNumber; //包序号
    unsigned int             collectionTime; //采集时间
    char                     audioFormat;    //音频格式
    unsigned int             dataLength;     //数据长度
    
}CC_audioDataContent;



#pragma pack(pop)


#endif /* CCTCPDataDefine_h */

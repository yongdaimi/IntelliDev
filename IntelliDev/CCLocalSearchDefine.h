//
//  CCLocalSearchDefine.h
//  IntelliDev
//
//  Created by chenchao on 16/4/27.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#ifndef CCLocalSearchDefine_h
#define CCLocalSearchDefine_h

#include "DataStructDefine.h"



static  INT16    CONTROLLCODE_SEARCH_BROADCAST_REQUEST    =0;   //广播请求操作码
static  INT16    CONTROLLCODE_SEARCH_BROADCAST_REPLY      =1;   //广播回应操作码

#define Big2Little16(A)  ((((unsigned short)(A) & 0xff00) >> 8) | \
(((unsigned short)(A) & 0x00ff) << 8))
#define Big2Little32(A)  ((((unsigned int)(A) & 0xff000000) >> 24) | \
(((unsigned int)(A) & 0x00ff0000) >> 8) | \
(((unsigned int)(A) & 0x0000ff00) << 8) | \
(((unsigned int)(A) & 0x000000ff) << 24))

#define SOCK_SEND_PORT 10000   //发送端口

#pragma pack(push, 1)


typedef struct searchBrodcastHeader
{
    char            protocolHeader[4];   //协议头
    short           controlMask;         //操作码
    char            reserved;            //保留
    char            reserved2[8];        //保留
    int             contentLength;       //正文长度
    int             reserved3;           //保留
    
}CC_searchBrodcastHeader;

typedef struct searchCommandContent
{
    char            reserved0;
    char            reserved1;
    char            reserved2;
    char            reserved3;
    
}CC_searchCommandContent;

typedef struct searchCommandContentReply
{
    CC_searchBrodcastHeader  header; //头部
    char            camID[13];          //摄像头ID
    char            camName[21];        //摄像头名称
    unsigned int    IP;                 //IP; 大端
    unsigned int    netMask;            //掩码  大端
    unsigned int    getwayIP;           //网关IP;  大端
    unsigned int    DNS;                //DNS;  大端
    char            reserved[4];        //保留
    char            sysVersion[4];      //系统版本
    char            appVersion[4];       //App software 版本
    unsigned short           port;               //端口 大端
    char            dhcpEnabled;        //DHCP状态
    
}CC_searchCommandContentReply;

#pragma pack(pop)

#endif /* CCLocalSearchDefine_h */

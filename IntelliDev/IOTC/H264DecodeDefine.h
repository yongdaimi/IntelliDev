//
//  H264DecodeDefine.h
//  IntelliDev
//
//  Created by chenchao on 16/11/4.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#ifndef H264DecodeDefine_h
#define H264DecodeDefine_h

#pragma pack(push, 1)

typedef struct H264FrameDef
{
    unsigned int    length;
    unsigned char*  dataBuffer;
    
}H264Frame;

typedef struct  H264YUVDef
{
    unsigned int    width;
    unsigned int    height;
    H264Frame       luma;
    H264Frame       chromaB;
    H264Frame       chromaR;
    
}H264YUV_Frame;

// NALU
typedef struct _MP4ENC_NaluUnit
{
    int type;
    int size;
    unsigned char *data;
    
}MP4ENC_NaluUnit;

#pragma pack(pop)

#endif /* H264DecodeDefine_h */

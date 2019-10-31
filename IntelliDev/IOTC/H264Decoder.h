//
//  H264Decoder.h
//  IntelliDev
//
//  Created by chenchao on 16/11/4.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include "H264DecodeDefine.h"


@protocol updateDecodedH264FrameDelegate <NSObject>

@optional
- (void)updateDecodedH264FrameData: (H264YUV_Frame*)yuvFrame;
@end

@interface H264Decoder : NSObject
{
    AVCodec*            pCodec;
    AVCodecContext*     pCodecCtx;
    AVFrame*            pVideoFrame;
    
    AVPacket            pAvPackage;
    
    int                 pictureWidth;
    int                 setRecordResolveState;
    int                 startCodeType;
}

@property (nonatomic,assign)id<updateDecodedH264FrameDelegate> updateDelegate;

- (id)init;
- (int)DecodeH264Frames: (unsigned char*)inputBuffer withLength:(int)aLength;

@end

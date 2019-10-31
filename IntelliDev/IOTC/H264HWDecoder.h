//
//  H264HWDecoder.h
//  IntelliDev
//
//  Created by chenchao on 16/11/7.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

@protocol UpdateDecodedSampleBufferDelegate <NSObject>

@optional
- (void)updateDecodedSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end

@interface H264HWDecoder : NSObject

@property (nonatomic, assign) CMVideoFormatDescriptionRef formatDesc;
@property (nonatomic, assign) VTDecompressionSessionRef decompressionSession;

@property (nonatomic,assign) id<UpdateDecodedSampleBufferDelegate> updateDelegate;


@property (nonatomic, assign) int spsSize;
@property (nonatomic, assign) int ppsSize;

- (id)init;
- (int)DecodeH264Frames: (unsigned char*)inputBuffer withLength: (int)aLength;

@end

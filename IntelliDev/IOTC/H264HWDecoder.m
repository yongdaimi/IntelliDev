//
//  H264HWDecoder.m
//  IntelliDev
//
//  Created by chenchao on 16/11/7.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "H264HWDecoder.h"

@implementation H264HWDecoder



- (id)init
{
    if(self=[super init])
    {
    }
    return self;
}
- (void)dealloc
{
    if(self.decompressionSession != NULL){
        VTDecompressionSessionInvalidate(self.decompressionSession);
        CFRelease(self.decompressionSession);
        self.decompressionSession=NULL;
    }
    [super dealloc];
}
- (int)DecodeH264Frames:(unsigned char *)frame withLength:(int)frameSize
{
    OSStatus status;
    
    uint8_t *data = NULL;
    uint8_t *pps = NULL;
    uint8_t *sps = NULL;
    
    int startCodeIndex = 0;
    int secondStartCodeIndex = 0;
    int thirdStartCodeIndex = 0;
    
    long blockLength = 0;
    
    CMSampleBufferRef sampleBuffer = NULL;
    CMBlockBufferRef blockBuffer = NULL;
    
    int nalu_type = (frame[startCodeIndex + 4] & 0x1F);
    
    if (nalu_type != 7 && _formatDesc == NULL)
    {
        NSLog(@"Video error: Frame is not an I Frame and format description is null");
        return -1;
    }
    
    
    if (nalu_type == 7)
    {
        for (int i = startCodeIndex + 4; i < startCodeIndex + 256; i++)
        {
            if (frame[i] == 0x00 && frame[i+1] == 0x00 && frame[i+2] == 0x00 && frame[i+3] == 0x01)
            {
                secondStartCodeIndex = i;
                _spsSize = secondStartCodeIndex;
                break;
            }
        }
        nalu_type = (frame[secondStartCodeIndex + 4] & 0x1F);
        
    }
    
    if(nalu_type == 8)
    {
        
        for (int i = _spsSize + 4; i < _spsSize + 128; i++)
        {
            if (frame[i] == 0x00 && frame[i+1] == 0x00 &&  frame[i+2] == 0x01)
            {
                thirdStartCodeIndex = i;
                _ppsSize = thirdStartCodeIndex - _spsSize;
                break;
            }
        }
        
        
        sps = malloc(_spsSize - 4);
        pps = malloc(_ppsSize - 4);
        
        memcpy (sps, &frame[4], _spsSize-4);
        memcpy (pps, &frame[_spsSize+4], _ppsSize-4);
        
        
        uint8_t*  parameterSetPointers[2] = {sps, pps};
        size_t parameterSetSizes[2] = {_spsSize-4, _ppsSize-4};
        
        status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault, 2,
                                                                     (const uint8_t *const*)parameterSetPointers,
                                                                     parameterSetSizes, 4,
                                                                     &_formatDesc);
        
        if(status != noErr){
            NSLog(@"MVideoFormatDescriptionCreateFromH264ParameterSets ERROR type: %d", (int)status);
        }
        
        nalu_type = (frame[thirdStartCodeIndex + 3] & 0x1F);
    }
    
    //    if((status == noErr) && (_decompressionSession == NULL))
    //    {
    //        [self createDecompSession];
    //    }
    
    if(nalu_type == 5)
    {
        
        int offset = _spsSize + _ppsSize;
        blockLength = frameSize - offset;
        data = malloc(blockLength);
        data = memcpy(data, &frame[offset], blockLength);
        
        uint32_t dataLength32 = htonl (blockLength - 4);
        memcpy (data, &dataLength32, sizeof (uint32_t));
        
        
        status = CMBlockBufferCreateWithMemoryBlock(NULL, data,
                                                    blockLength,
                                                    kCFAllocatorNull, NULL,
                                                    0,
                                                    blockLength,
                                                    0, &blockBuffer);
        if(status != noErr){
            NSLog(@"I Frame: CMBlockBufferCreateWithMemoryBlock Error type: %d", (int)status);
        }
        
    }
    
    
    if (nalu_type == 1)
    {
        
        blockLength = frameSize;
        data = malloc(blockLength);
        data = memcpy(data, &frame[0], blockLength);
        
        uint32_t dataLength32 = htonl (blockLength - 4);
        memcpy (data, &dataLength32, sizeof (uint32_t));
        
        status = CMBlockBufferCreateWithMemoryBlock(NULL, data,
                                                    blockLength,
                                                    kCFAllocatorNull, NULL,
                                                    0,
                                                    blockLength,
                                                    0, &blockBuffer);
        if(status != noErr){
            NSLog(@"P Frame: CMBlockBufferCreateWithMemoryBlock Error type: %d", (int)status);
        }
        
    }
    
    if(status == noErr)
    {
        const size_t sampleSize = blockLength;
        status = CMSampleBufferCreate(kCFAllocatorDefault,
                                      blockBuffer, true, NULL, NULL,
                                      _formatDesc, 1, 0, NULL, 1,
                                      &sampleSize, &sampleBuffer);
        if(status != noErr){
            NSLog(@"CMSampleBufferCreate Error type: %d", (int)status);
        }
        
    }
    
    if(status == noErr)
    {
        
        CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, YES);
        CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
        CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
        
        if([self.updateDelegate respondsToSelector:@selector(updateDecodedSampleBuffer:)]){
            [self.updateDelegate updateDecodedSampleBuffer:sampleBuffer];
            
            
        }
        
        //CFRelease(blockBuffer);
        //CFRelease(sampleBuffer);
        
        
        //[self render:sampleBuffer];
    }
    
    if (data != NULL)
    {
        free (data);
        data = NULL;
    }
    if(sps != NULL)
    {
        free(sps);
        sps = NULL;
    }
    if(pps != NULL)
    {
        free(pps);
        pps = NULL;
    }
    
    
    return 0;
}
@end

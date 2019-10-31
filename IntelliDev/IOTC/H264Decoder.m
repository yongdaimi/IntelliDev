//
//  H264Decoder.m
//  IntelliDev
//
//  Created by chenchao on 16/11/4.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "H264Decoder.h"

@implementation H264Decoder

@synthesize updateDelegate;

- (id) init
{
    if(self=[super init])
    {
        pCodec      =NULL;
        pCodecCtx   =NULL;
        pVideoFrame =NULL;
        
        pictureWidth=0;
        setRecordResolveState=0;
        
        startCodeType=0;
        
        av_register_all();
        avcodec_register_all();
        
        pCodec=avcodec_find_decoder(CODEC_ID_H264);
        if(!pCodec){
            printf("Codec not find\n");
        }
        pCodecCtx=avcodec_alloc_context3(pCodec);
        if(!pCodecCtx){
            printf("allocate codec context error\n");
        }
        
        avcodec_open2(pCodecCtx, pCodec, NULL);
        
        pVideoFrame=avcodec_alloc_frame();
        
    }
    
    return self;
}

- (void)dealloc
{
    if(!pCodecCtx){
        avcodec_close(pCodecCtx);
        pCodecCtx=NULL;
    }
    if(!pVideoFrame){
        avcodec_free_frame(&pVideoFrame);
        pVideoFrame=NULL;
    }
    [super dealloc];
}
//h.264 -> yuv420  y u v -> RGB 1280x720  1365 655 655
- (int)DecodeH264Frames: (unsigned char*)inputBuffer withLength:(int)aLength
{

    int gotPicPtr=0;
    int result=0;
    
    av_init_packet(&pAvPackage);
    pAvPackage.data=(unsigned char*)inputBuffer;
    pAvPackage.size=aLength;
    //解码
    result=avcodec_decode_video2(pCodecCtx, pVideoFrame, &gotPicPtr, &pAvPackage);
    
    //如果视频尺寸更改，我们丢掉这个frame
    if((pictureWidth!=0)&&(pictureWidth!=pCodecCtx->width)){
        setRecordResolveState=0;
        pictureWidth=pCodecCtx->width;
        return -1;
    }
    
    //YUV 420 Y U V  -> RGB  pCtx->width:1280 pVideoFrame->lineSize[0]: 690
    if(gotPicPtr)
    {

        
        unsigned int lumaLength= (pCodecCtx->height)*(MIN(pVideoFrame->linesize[0], pCodecCtx->width));
        unsigned int chromBLength=((pCodecCtx->height)/2)*(MIN(pVideoFrame->linesize[1], (pCodecCtx->width)/2));
        unsigned int chromRLength=((pCodecCtx->height)/2)*(MIN(pVideoFrame->linesize[2], (pCodecCtx->width)/2));
        
        
        H264YUV_Frame    yuvFrame;
        memset(&yuvFrame, 0, sizeof(H264YUV_Frame));
        
        yuvFrame.luma.length = lumaLength;
        yuvFrame.chromaB.length = chromBLength;
        yuvFrame.chromaR.length =chromRLength;
        
        yuvFrame.luma.dataBuffer=(unsigned char*)malloc(lumaLength);
        yuvFrame.chromaB.dataBuffer=(unsigned char*)malloc(chromBLength);
        yuvFrame.chromaR.dataBuffer=(unsigned char*)malloc(chromRLength);
        
        copyDecodedFrame(pVideoFrame->data[0],yuvFrame.luma.dataBuffer,pVideoFrame->linesize[0],
                         pCodecCtx->width,pCodecCtx->height);
        copyDecodedFrame(pVideoFrame->data[1], yuvFrame.chromaB.dataBuffer,pVideoFrame->linesize[1],
                         pCodecCtx->width / 2,pCodecCtx->height / 2);
        copyDecodedFrame(pVideoFrame->data[2], yuvFrame.chromaR.dataBuffer,pVideoFrame->linesize[2],
                         pCodecCtx->width / 2,pCodecCtx->height / 2);
        
        yuvFrame.width=pCodecCtx->width;
        yuvFrame.height=pCodecCtx->height;
        
        if(setRecordResolveState==0){
            setRecordResolveState=1;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self updateYUVFrameOnMainThread:(H264YUV_Frame*)&yuvFrame];
        });
        
        free(yuvFrame.luma.dataBuffer);
        free(yuvFrame.chromaB.dataBuffer);
        free(yuvFrame.chromaR.dataBuffer);
        
    }
    av_free_packet(&pAvPackage);
    
    return 0;
}
void copyDecodedFrame(unsigned char *src, unsigned char *dist,int linesize, int width, int height)
{
    
    width = MIN(linesize, width);
    
    for (NSUInteger i = 0; i < height; ++i) {
        memcpy(dist, src, width);
        dist += width;
        src += linesize;
    }
    
}
- (void)updateYUVFrameOnMainThread:(H264YUV_Frame*)yuvFrame
{
    if(yuvFrame!=NULL){
        if([self.updateDelegate respondsToSelector:@selector(updateDecodedH264FrameData: )]){
            [self.updateDelegate updateDecodedH264FrameData:yuvFrame];
        }
    }
}
- (void)testNaluData:(uint8_t *)frame withSize: (uint32_t)frameSize
{

    startCodeType=0;
//    printf("\n");
//    for(int i=0; i<frameSize; i++){
//        printf(" %x",frame[i]);
//    }
//    printf("\n");
    MP4ENC_NaluUnit nalu;
    memset(&nalu, 0, sizeof(nalu));
    
    int  len = 0;
    int pos = 0;
    
    int firstIFrame=0;
    while ((len = [self readOneNaluFromBuffer:frame withSize:frameSize withOffSet:pos nalUnit: &nalu]))
    {
        //printf("NALU TYPE: %d\n",nalu.type);
        if(nalu.type==0x07)//SPS
        {
            if(nalu.size>0){
                printf("SPS \n");
            }
        }
        
        if(nalu.type==0x08)//PPS
        {
            printf("PPS \n");
            if(nalu.size>0){
                
            }
        }
        
        if(nalu.type == 0x05) //i帧
        {
            printf("I Frame \n");
            firstIFrame=1;
            break;
            
        }
        else if(nalu.type == 0x01)//p帧 B
        {
            printf("P B Frame \n");
            
        }
        pos += len;
        
    }
}
- (int)readOneNaluFromBuffer: (const unsigned char*)buffer withSize: (unsigned int)nBufferSize withOffSet :(unsigned int)aOffSet nalUnit: (MP4ENC_NaluUnit *)nalu
{
    
    int i = aOffSet;

    while(i<nBufferSize)
    {
        if(startCodeType==0)
        {
            if((buffer[i++] == 0x00) && (buffer[i++] == 0x00 )&& (buffer[i++] == 0x00) && (buffer[i++] == 0x01))
            {
                
                int pos = i;
                
                while (pos<nBufferSize)
                {
                    //printf(" : %d ",pos);
                    int j=pos; int k=pos;
                    if((buffer[j++] == 0x00) && (buffer[j++] == 0x00) && (buffer[j++] == 0x00) && (buffer[j++] == 0x01))
                    {
                        pos+=4;
                        startCodeType=0;
                        break;
                    }
                    else if((buffer[k++] == 0x00) && (buffer[k++] == 0x00) && (buffer[k++] == 0x01))
                    {
                        pos+=3;
                        startCodeType=1;
                        break;
                    }else{
                        pos+=1;
                    }
                    //printf(" %d ",pos);
                }
                
                if(pos == nBufferSize)
                {
                    nalu->size = pos-i;
                }
                else
                {
                    if(startCodeType==0){
                        nalu->size = (pos-4)-i;
                    }else if(startCodeType==1){
                        nalu->size = (pos-3)-i;
                    }
                }
                
                nalu->type = buffer[i]&0x1f;
                nalu->data =(unsigned char*)&buffer[i];
                
                
                return (nalu->size+i-aOffSet);
            }

            
        }
        else if(startCodeType==1){
            
            if((buffer[i++] == 0x00) && (buffer[i++] == 0x00 )&&(buffer[i++] == 0x01))
            {
                
                int pos = i;
                
                while (pos<nBufferSize)
                {
                    //printf(" : %d ",pos);
                    int j=pos; int k=pos;
                    if((buffer[j++] == 0x00) && (buffer[j++] == 0x00) && (buffer[j++] == 0x00) && (buffer[j++] == 0x01))
                    {
                        pos+=4;
                        startCodeType=0;
                        break;
                    }
                    else if((buffer[k++] == 0x00) && (buffer[k++] == 0x00) && (buffer[k++] == 0x01))
                    {
                        pos+=3;
                        startCodeType=1;
                        break;
                    }else{
                        pos+=1;
                    }
                    //printf(" %d ",pos);
                }
                
                if(pos == nBufferSize)
                {
                    nalu->size = pos-i;
                }
                else
                {
                    if(startCodeType==0){
                        nalu->size = (pos-4)-i;
                    }else if(startCodeType==1){
                        nalu->size = (pos-3)-i;
                    }
                }
                
                nalu->type = buffer[i]&0x1f;
                nalu->data =(unsigned char*)&buffer[i];

                
                return (nalu->size+i-aOffSet);
            }
            
        }
    }

    return 0;
}


@end

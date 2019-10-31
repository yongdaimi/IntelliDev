//
//  CCMusicConverter.m
//  P2PCamera
//
//  Created by chenchao on 16/6/16.
//  Copyright © 2016年 TUTK. All rights reserved.
//

#import "CCMusicConverter.h"
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswresample/swresample.h>
#include <lame/lame.h>

#define MAX_AUDIO_FRAME_SIZE 192000

@implementation CCMusicConverter
- (id)init
{
    if(self=[super init])
    {
        
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}


- (void)ConvertPCM2MP3WithPath:(const char *) inputPath outFilePath: (const char *)outputPath
{
    size_t readSize, writeSize;
    
    FILE *pcmFile = fopen(inputPath, "rb");
    if (!pcmFile){
        fprintf(stderr, "could not open %s\n", inputPath);
        return;
    }
    FILE *mp3File = fopen(outputPath, "wb");
    if (!mp3File){
        fprintf(stderr, "could not open %s\n", outputPath);
        return;
    }
    
    const int PCM_BUFF_SIZE = 8192;
    const int MP3_BUFF_SIZE = 8192;
    
    short int pcm_buffer[PCM_BUFF_SIZE*2];
    unsigned char mp3_buffer[MP3_BUFF_SIZE];
    
    lame_t lame = lame_init();
    lame_set_in_samplerate(lame, 44100);
    lame_set_VBR(lame, vbr_default);
    lame_init_params(lame);
    
    do {
        
        readSize = fread(pcm_buffer, 2*sizeof(short int), PCM_BUFF_SIZE, pcmFile);
        
        printf("MP3::::::::::::: readSize: %ld \n",readSize);
        if (readSize == 0){
            writeSize = lame_encode_flush(lame, mp3_buffer, MP3_BUFF_SIZE);
        }
        else{
            writeSize = lame_encode_buffer_interleaved(lame, pcm_buffer,(int)readSize, mp3_buffer, MP3_BUFF_SIZE);
        }
        
        fwrite(mp3_buffer, writeSize, 1, mp3File);
        
    } while (readSize != 0);
    
    lame_close(lame);
    fclose(mp3File);
    fclose(pcmFile);
}


- (void)ConvertAuidoToPCMWithPath:(const char *) inputPath outFilePath: (const char *)outputPath
{
    AVFormatContext *pFormatCtx=NULL;
    
    
    FILE *pFile = fopen(outputPath,"wb");
    if (!pFile){
        fprintf(stderr, "could not open %s\n", outputPath);
        return;
    }
    
    
    av_register_all();
    
    avformat_network_init();
    
    pFormatCtx = avformat_alloc_context();
    
    if (avformat_open_input(&pFormatCtx, inputPath, NULL, NULL)!=0){
        printf("Couldn't open input stream.");
        return ;
    }
    
    if (avformat_find_stream_info(pFormatCtx, NULL) < 0){
        printf("Couldn't find stream information.");
        return ;
    }
    
    //是一个手工调试的函数，能使我们看到pFormatCtx->streams里面有什么内容。
    av_dump_format(pFormatCtx, 0, inputPath, false);
    
    int audioStreamIndex=-1;
    
    for (int i = 0; i < pFormatCtx->nb_streams; ++i){
        
        if (pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO){
            audioStreamIndex = i;
            break;
        }
    }
    if (audioStreamIndex == -1){
        printf("Didn't find a audio stream .");
        return ;
    }
    
    AVCodecContext *pCodecCtx = pFormatCtx->streams[audioStreamIndex]->codec;
    
    AVCodec *pCodec = avcodec_find_decoder(pCodecCtx->codec_id);
    if (NULL == pCodec){
        printf("Codec not found .");
        return ;
    }
    
    if (avcodec_open2(pCodecCtx, pCodec, NULL) < 0){
        printf("Could not open codec.");
        return ;
    }
    
    AVPacket *packet = (AVPacket *)av_malloc(sizeof(AVPacket));
    av_init_packet(packet);
    
    uint64_t out_channel_layout = AV_CH_LAYOUT_STEREO;
    int out_nb_samples = pCodecCtx->frame_size;
    
    enum AVSampleFormat out_sample_fmt = AV_SAMPLE_FMT_S16;
    int out_sample_rate = 44100;
    int out_channels = av_get_channel_layout_nb_channels(out_channel_layout);
    
    int out_buffer_size = av_samples_get_buffer_size(NULL, out_channels, out_nb_samples, out_sample_fmt, 1);
    uint8_t *out_buffer = (uint8_t *)av_malloc(MAX_AUDIO_FRAME_SIZE * 2);
    
    AVFrame *pFrame = av_frame_alloc();
    int64_t in_channel_layout = av_get_default_channel_layout(pCodecCtx->channels);
    
    struct SwrContext *au_convert_ctx = swr_alloc();
    au_convert_ctx = swr_alloc_set_opts(au_convert_ctx, out_channel_layout, out_sample_fmt, out_sample_rate, in_channel_layout, pCodecCtx->sample_fmt, pCodecCtx->sample_rate, 0, NULL);
    
    swr_init(au_convert_ctx);
    
    int index= 0;
    int ret=0;
    int got_picture=0;
    
    while (av_read_frame(pFormatCtx, packet) >=0)
    {
        if (packet->stream_index == audioStreamIndex)
        {
            ret = avcodec_decode_audio4( pCodecCtx, pFrame, &got_picture, packet);
            
            if (ret < 0)
            {
                printf("Error in decoding audio frame.");
                return ;
            }
            if (got_picture > 0)
            {
                swr_convert(au_convert_ctx, &out_buffer, MAX_AUDIO_FRAME_SIZE, (const uint8_t **)pFrame->data, pFrame->nb_samples);
                
                printf("index:  %d pts: %lld packet size: %d\n",index,packet->pts,packet->size);
                
                fwrite(out_buffer, 1, out_buffer_size, pFile);
                ++ index;
            }
        }
        
        av_free_packet(packet);
    }
    
    swr_free(&au_convert_ctx);
    fclose(pFile);
    
    av_free(out_buffer);
    avcodec_close(pCodecCtx);
    avformat_close_input(&pFormatCtx);
    
    printf("END...");
    
    return;
}


@end

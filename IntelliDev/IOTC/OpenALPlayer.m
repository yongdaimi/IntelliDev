//
//  OpenALPlayer.m
//  IOTCamViewer
//
//  Created by chenchao on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "OpenALPlayer.h"

@interface OpenALPlayer()
{
    ALCcontext              *m_alContext;
    ALCdevice               *m_alDevice;
    ALuint                  m_alHandle;
    
    ALuint                  m_audioQueuebuff;
    
    ALenum                  m_audioFormat;
    int                     m_sampleRate;
}
@property (nonatomic) ALenum                        m_audioFormat;
@property (nonatomic) ALCcontext                    *m_alContext;
@property (nonatomic) ALCdevice                     *m_alDevice;

@end

@implementation OpenALPlayer


@synthesize m_audioFormat;
@synthesize m_alDevice;
@synthesize m_alContext;

-(void)initOpenALWithParams:(int)format :(int)sampleRate
{

    m_audioFormat = format;
    m_sampleRate = sampleRate;
    
    m_alDevice=alcOpenDevice(NULL);
    if (m_alDevice)
    {
        m_alContext=alcCreateContext(m_alDevice, NULL);
        alcMakeContextCurrent(m_alContext);
    }

    alGenSources(1, &m_alHandle);

    alSpeedOfSound(1.0);
    alDopplerVelocity(1.0);
    alDopplerFactor(1.0);
    alSourcef(m_alHandle, AL_PITCH, 1.0f);
    alSourcef(m_alHandle, AL_GAIN, 1.0f);
    alSourcei(m_alHandle, AL_LOOPING, AL_FALSE);
    alSourcef(m_alHandle, AL_SOURCE_TYPE, AL_STREAMING);

    alSourcef(m_alHandle, AL_CHANNELS, 1);

}


- (bool) updateQueueBuffer
{
    ALint stateVaue;
    int processed, queued;
    
    alGetSourcei(m_alHandle, AL_SOURCE_STATE, &stateVaue);
    
    if (stateVaue == AL_STOPPED){
        return false;
    }    
    
    alGetSourcei(m_alHandle, AL_BUFFERS_PROCESSED, &processed);
    alGetSourcei(m_alHandle, AL_BUFFERS_QUEUED, &queued);
    
    while(processed--)
    {
        alSourceUnqueueBuffers(m_alHandle, 1, &m_audioQueuebuff);
        alDeleteBuffers(1, &m_audioQueuebuff);
    }
    
    return true;
}

- (void)playAudioWithBuffer:(unsigned char *)inputBuffer length: (unsigned int)aLength
{

    NSCondition* ticketCondition= [[NSCondition alloc] init];
    [ticketCondition lock];
    
    [self updateQueueBuffer];
    
    ALuint bufferID = 0;
    alGenBuffers(1, &bufferID);
    
    alBufferData(bufferID, m_audioFormat, inputBuffer, aLength, m_sampleRate);
    alSourceQueueBuffers(m_alHandle, 1, &bufferID);
        
    ALint stateVaue;
    alGetSourcei(m_alHandle, AL_SOURCE_STATE, &stateVaue);
    
    if (stateVaue != AL_PLAYING){
        alSourcePlay(m_alHandle);
    }
    
    [ticketCondition unlock];
    [ticketCondition release];
    ticketCondition = nil;
    

}

- (void)stopPlay
{
    alSourceStop(m_alHandle);
}

-(void)cleanOpenAL
{
    int processed = 0;

    alGetSourcei(m_alHandle, AL_BUFFERS_PROCESSED, &processed);

    while(processed--) {
        alSourceUnqueueBuffers(m_alHandle, 1, &m_audioQueuebuff);
        alDeleteBuffers(1, &m_audioQueuebuff);
    }

    alDeleteSources(1, &m_alHandle);
    alcMakeContextCurrent(NULL);
    alcDestroyContext(m_alContext);
    alcCloseDevice(m_alDevice);

}


-(void)dealloc
{
    [super dealloc];
}

@end

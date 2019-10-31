//
//  OpenALPlayer.h
//  IOTCamViewer
//
//  Created by chenchao on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>

@interface OpenALPlayer : NSObject

- (void)initOpenALWithParams:(int)format :(int)sampleRate;
- (void)playAudioWithBuffer:(unsigned char *)buffer length: (unsigned int)aLength;
- (void)stopPlay;
- (void)cleanOpenAL;

@end

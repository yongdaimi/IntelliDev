//
//  CCMusicConverter.h
//  P2PCamera
//
//  Created by chenchao on 16/6/16.
//  Copyright © 2016年 TUTK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCMusicConverter : NSObject


- (void)ConvertAuidoToPCMWithPath:(const char *) inputPath outFilePath: (const char *)outputPath;
- (void)ConvertPCM2MP3WithPath:(const char *) inputPath outFilePath: (const char *)outputPath;

@end

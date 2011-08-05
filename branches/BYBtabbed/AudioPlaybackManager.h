//
//  AudioPlaybackManager.h
//  
//
//  Created by Zachary King on July 31, 2011.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import <OpenGLES/ES1/gl.h>
#import <AVFoundation/AVFoundation.h>

#import "DrawingDataManager.h"
#import "mach/mach_time.h"
#import "Constants.h"
#import "BBFile.h"


@interface AudioPlaybackManager : DrawingDataManager {

    BBFile *file;
    AudioFileID fileHandle; // should use pure-C for speed.
    int numBytesToRead; 
	AudioConverterRef audioConverter;
    
    // Instance variables that are not properties
	AVAudioPlayer *audioPlayer;
	NSTimer *timerThread;
    
    UIImage *playImage, *pauseImage;
}

@property (nonatomic, retain) BBFile *file;
@property AudioFileID fileHandle;

@property (nonatomic, retain) UIImage *playImage, *pauseImage;

- (void)grabNewFile;

- (void)updateCurrentTimeTo:(float)time;

- (void)playPause;

- (void)stop;

- (void)startUpdateTimer;
- (void)updateCurrentTime;

//Redefined from superclass:
//- (void)fillVertexBufferWithAudioData;
//- (void)pause;
//- (void)play;


@end


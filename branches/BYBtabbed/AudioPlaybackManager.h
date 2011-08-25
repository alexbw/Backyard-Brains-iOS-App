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
    @protected
    BBFile *file;
    
	AudioConverterRef audioConverter;
    
    //see: http://stackoverflow.com/questions/1905010/iphone-combine-audio-files
    
    
    // Instance variables that are not properties
	AVAudioPlayer *audioPlayer;
	NSTimer *timerThread;
    
    UIImage *playImage, *pauseImage;
    
    BOOL playing;
    
    Float64 lastTime;
    
    @public
        AudioFileID fileHandle;
        UInt64 numBytesRead, dataOffset, bitRate, byteCount;
}

@property (nonatomic, retain) BBFile *file;
@property AudioFileID fileHandle;

@property UInt64 numBytesRead, dataOffset, bitRate, byteCount;

@property (nonatomic, retain) UIImage *playImage, *pauseImage;

@property BOOL playing;

@property Float64 lastTime;

//@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (void)grabNewFile;

- (void)updateCurrentTimeTo:(float)time;

- (BOOL)playPause;

- (void)stop;

- (void)startUpdateTimer;
- (void)updateCurrentTime;

//Redefined from superclass:
//- (void)fillVertexBufferWithAudioData;
//- (void)pause;
//- (void)play;

- (id)initWithBBFile:(BBFile *)theFile;
- (UInt32)CalculateBytesForTime:(Float64)inSeconds;



@end


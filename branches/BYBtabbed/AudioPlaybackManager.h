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

#import "DrawingDataManager.h"
#import "mach/mach_time.h"
#import "Constants.h"
#import "BBFile.h"


@interface AudioPlaybackManager : DrawingDataManager {

    BBFile *file;
    AudioFileID fileHandle; // should use pure-C for speed.
    int numBytesToRead; 
	AudioConverterRef audioConverter;
}

@property (nonatomic, retain) BBFile *file;
@property AudioFileID fileHandle;

- (id)initWithFile:(BBFile *)theFile;

//Redefined from superclass:
//- (void)fillVertexBufferWithAudioData;
//- (void)pause;
//- (void)play;


@end


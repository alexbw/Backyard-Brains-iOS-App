//
//  DrawingDataManager.h
//  Backyard Brains
//
//  Created by Zachary King on 8/1/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//
//  Superclass with subclasses AudioSignalManager, AudioPlaybackManager
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "Constants.h"


struct wave_s {
	GLfloat x;
	GLfloat y;
};




@protocol DrawingDataManagerDelegate

- (void)shouldAutoSetFrame;

@end


@interface DrawingDataManager : NSObject {
    
	BOOL paused; 
    int nWaitFrames;
	struct wave_s *vertexBuffer; // this buffer is for actual display
}


@property BOOL paused;
@property int nWaitFrames;
@property struct wave_s *vertexBuffer;

- (void)fillVertexBufferWithAudioData;
- (void)pause;
- (void)play;

@end

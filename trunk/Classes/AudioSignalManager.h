//
//  AudioSignalManager.h
//  TESTAGAIN
//
//  Created by Alex Wiltschko on 9/26/09.
//  Modified by Zachary King:
//      6/6/2011 Added delegate and methods to automatically set the viewing frame.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import <OpenGLES/ES1/gl.h>

#import "mach/mach_time.h"
#import "Constants.h"
#import "BBFile.h"

// AudioSignalManager encapsulates an audio unit graph
// and callbacks for grabbing audio straight from the mic (headset or external)
// as well as continuous threshold-crossing detection.
// 
// In order to render audio acquired through AudioSignalManager,
// methods are provided for passing in a pointer to a vertex buffer
// and having this class fill it up.

 // accepts samples directly from mic

//GLfloat firstStageBuffer[kNumPointsInWave]; // accepts mic inputs
//GLfloat secondStageBuffer[kNumPointsInWave]; // this buffer holds audio signal ready to be grabbed by the view and displayed


typedef struct _triggeredSegmentHistory {
	SInt16 triggeredSegments[kNumSegmentsInTriggerAverage][kNumPointsInTriggerBuffer];
	UInt32 lastReadSample[kNumSegmentsInTriggerAverage];
	UInt32 lastWrittenSample[kNumSegmentsInTriggerAverage];
	UInt32 currentSegment;
	UInt32 sizeOfMovingAverage; //Although there are kNumSegmentsInTriggerAverage,
                                // we may choose to use a moving average less than that.
    UInt32 movingAverageIncrement; //This will start at 1 and increment
                                   // until sizeOfMovingAverage is reached
} triggeredSegmentHistory;

struct wave_s {
	GLfloat x;
	GLfloat y;
};

typedef struct _continuousCallbackData {
	AudioUnit *au; // audioUnit
	ringBuffer *ssb; // secondStageBuffer
} continuousCallbackData;


// C-function for threshold detection
int findThresholdCrossing(SInt16 *firstStageBuffer, UInt32 inNumberFrames, float thresholdValue, BOOL triggerType);


@protocol AudioSignalManagerDelegate

- (void)shouldAutoSetFrame;

@end


@interface AudioSignalManager : NSObject <UIAlertViewDelegate> {

	// Audio Unit for acquiring single samples from the microphone (headset, I think)
	
	AudioUnit audioUnit;
		
	// We have two separate audio storage buffers, 
	// One for directly accepting audio samples, and one for holding data ready to be displayed.
	// We separate these so that we can have a "pause" functionality, where a static signal
	// is being displayed, while we continuously monitor the incoming audio, ready at a moment's notice to display something new.
		
	BOOL paused; 
	BOOL triggering; // YES - we're in triggering mode
	BOOL triggered; // YES - the signal has exceeded thresholdValue;
	BOOL triggerType; // YES - sample must increase after trigger val, NO - sample must decrease after trigger val
	float thresholdValue;
	UInt32 lastFreshSample;
	UInt32 numSamplesJustAcquired;
	
	float gain;
	
	SInt16 *firstStageBuffer;
	ringBuffer *secondStageBuffer;
	struct wave_s *vertexBuffer; // this buffer is for actual display	
	triggeredSegmentHistory *triggerSegmentData;
		
	UInt32 firstSampleBeingViewed;
	UInt32 numSamplesBeingViewed;		
	
	AudioBufferList auBufferList;
	
	Float64 lastTime;
	Float64 samplingRate;
	
	
	BOOL playThroughEnabled;
	
	BOOL hasAudioInput;
	UInt32 myCallbackType;
    
    int nWaitFrames, nTrigWaitFrames;
    
    id <AudioSignalManagerDelegate> delegate;
	
}


@property AudioUnit audioUnit;

@property SInt16 *firstStageBuffer;
@property ringBuffer *secondStageBuffer;
@property struct wave_s *vertexBuffer;
@property triggeredSegmentHistory *triggerSegmentData;

@property AudioBufferList auBufferList;
@property Float64 lastTime;
@property Float64 samplingRate;

@property BOOL triggering;
@property BOOL triggered;
@property BOOL triggerType;
@property float thresholdValue;
@property UInt32 lastFreshSample;
@property UInt32 numSamplesJustAcquired;

@property UInt32 firstSampleBeingViewed;
@property UInt32 numSamplesBeingViewed;

@property BOOL paused;
@property BOOL playThroughEnabled;

@property float gain;

@property BOOL hasAudioInput;
@property UInt32 myCallbackType;

@property int nWaitFrames;
@property int nTrigWaitFrames;

@property (nonatomic,assign) id <AudioSignalManagerDelegate> delegate;

- (void)ifAudioInputIsAvailableThenSetupAudioSessionWithCallbackType:(UInt32)callbackType;
- (id)init;
- (id)initWithCallbackType:(UInt32)callbackType;
- (void)setupAudioSession:(UInt32)callbackType;
- (void)setVertexBufferXRangeFrom:(GLfloat)xBegin to:(GLfloat)xEnd;

- (void)fillVertexBufferWithAudioData;
- (void)fillVertexBufferWithAverageTriggeredSegments;
- (void)changeCallbackTo:(int)callbackType;

- (void)pause;
- (void)play;
- (void)pauseplay;
- (void)togglePlaythru;


@end


typedef struct _averageTriggerCallbackData {
	AudioUnit au; // audioUnit
	struct wave_s *vb; // vertexBuffer
	ringBuffer *ssb; // secondStageBuffer
	AudioSignalManager *asm;
	triggeredSegmentHistory *th;
} averageTriggerCallbackData;

typedef struct _singleShotTriggerCallbackData {
	AudioUnit au; // audioUnit
	struct wave_s *vb; // vertexBuffer
	ringBuffer *ssb; // secondStageBuffer
	AudioSignalManager *asm;
} singleShotTriggerCallbackData;

typedef struct _playThruCallbackData {
	//	ringBuffer *ssb;
	//	AudioUnit *au;
	AudioSignalManager *asm;
} playThruCallbackData;


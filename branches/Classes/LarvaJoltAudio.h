//
//  LarvaJoltAudio.h
//  LarvaJolt
//
//  Created by Zachary King on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//Adapted from:
//  Created by Matt Gallagher on 2010/10/20.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>


@class LarvaJoltAudio;

@protocol LarvaJoltAudioDelegate
- (void)pulseIsPlaying;
- (void)pulseIsStopped;
@end


@interface LarvaJoltAudio : NSObject {
	id <LarvaJoltAudioDelegate> delegate;
    
	AudioComponentInstance toneUnit; 
		
@public					// req'd by render function
    double dutyCycle;
	double frequency;
	double amplitude; 
    double pulseTime;
	
	double sampleRate;
	double pulseProgress;
    double theta;
    double outputFrequency;
	
}

@property (assign) id <LarvaJoltAudioDelegate> delegate;

@property double dutyCycle;
@property double frequency;
@property double amplitude;
@property double pulseTime;


@property double sampleRate;
@property double pulseProgress;
@property double theta;
@property double outputFrequency;

- (void)createToneUnit;

- (void)playPulse;
- (void)stopPulse;

@end

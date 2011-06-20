//
//  LarvaJoltViewController.h
//  LarvaJolt
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>
#import "LarvaJoltAudio.h"

@interface LarvaJoltViewController : UIViewController <LarvaJoltAudioDelegate, UITextFieldDelegate>
{
	LarvaJoltAudio *pulse;
	
	NSNumberFormatter *numberFormatter;
    NSTimer *backgroundTimer;
    double backgroundBlue;
    double ogHeight;
	
	IBOutlet UISlider *frequencySlider;
	IBOutlet UISlider *dutyCycleSlider;
    IBOutlet UISlider *pulseTimeSlider;
    IBOutlet UISlider *outputFrequencySlider;
    IBOutlet UITextField *frequencyField;
    IBOutlet UITextField *pulseWidthField;
    IBOutlet UITextField *pulseTimeField;
    IBOutlet UITextField *outputFrequencyField;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *stopButton;
	
}

@property (nonatomic,retain) LarvaJoltAudio *pulse;

- (void)updateBackgroundColor;

- (void)setViewMovedUp:(BOOL)movedUp withOffset:(int)theOffset;


- (void)infoPop;
- (void)updateViewFrom:(NSString *)source;

- (double)checkValue:(double)value forMin:(double)min andMax:(double)max;

- (IBAction)sliderMoved:(UISlider *)sender;
- (IBAction)textFieldUpdated:(UITextField *)sender;
- (IBAction)playPulse:(id)sender;
- (IBAction)stopPulse:(id)sender;

- (void)setup;
- (void)releaseOutletsAndInstances;


@end


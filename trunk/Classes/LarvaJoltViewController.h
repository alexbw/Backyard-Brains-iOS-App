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

@protocol LarvaJoltViewDelegate
@required
@property (nonatomic, retain) LarvaJoltAudio *pulse;
@optional
- (void)hideLarvaJolt;
@property (nonatomic,retain) IBOutlet UIButton *stimButton;
@end

@interface LarvaJoltViewController : UIViewController <LarvaJoltAudioDelegate, UITextFieldDelegate>
{
	id <LarvaJoltViewDelegate> delegate;
    
	
	NSNumberFormatter *numberFormatter;
    NSTimer *backgroundTimer;
    double backgroundBlue;
	
	IBOutlet UISlider *frequencySlider;
	IBOutlet UISlider *dutyCycleSlider;
    IBOutlet UISlider *pulseTimeSlider;
    IBOutlet UISlider *toneFreqSlider;
    IBOutlet UITextField *frequencyField;
    IBOutlet UITextField *pulseWidthField;
    IBOutlet UITextField *pulseTimeField;
    IBOutlet UITextField *toneFreqField;
    IBOutlet UISwitch *constantToneSwitch;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *stopButton;
	
}


@property (assign) id <LarvaJoltViewDelegate> delegate;

- (void)updateBackgroundColor;

- (void)setViewMovedUp:(BOOL)movedUp;


- (void)updateViewFrom:(NSString *)source;

- (double)checkValue:(double)value forMin:(double)min andMax:(double)max;

- (IBAction)sliderMoved:(UISlider *)sender;
- (IBAction)textFieldUpdated:(UITextField *)sender;
- (IBAction)playPulse:(id)sender;
- (IBAction)stopPulse:(id)sender;
- (IBAction)done:(UIBarButtonItem *)sender;
- (IBAction)toggleConstantTone:(UISwitch *)sender;

- (void)setup;
- (void)releaseOutletsAndInstances;


@end


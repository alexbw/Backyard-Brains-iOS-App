//
//  LJController.h
//  Backyard Brains
//
//  Created by Zachary King on 12/9/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LarvaJoltAudio.h"

@protocol LarvaJoltViewDelegate
@required
@property (nonatomic, retain) LarvaJoltAudio *pulse;
@optional
- (void)hideLarvaJolt;
@property (nonatomic,retain) IBOutlet UIButton *stimButton;
@end

@interface LJController : UIViewController <LarvaJoltAudioDelegate, UITextFieldDelegate> 
{
    id <LarvaJoltViewDelegate> delegate;
    
    
	NSNumberFormatter *numberFormatter;
    NSTimer *backgroundTimer;	
    
    double backgroundBlue;

}

@property (assign) id <LarvaJoltViewDelegate> delegate;

@property (nonatomic,retain) NSNumberFormatter *numberFormatter;
@property (nonatomic,retain) NSTimer *backgroundTimer;
@property double backgroundBlue;


- (IBAction)sliderMoved:(UISlider *)sender;
- (IBAction)textFieldUpdated:(UITextField *)sender;
- (void)updateViewFrom:(NSString *)source;

- (IBAction)playPulse:(id)sender;
- (IBAction)stopPulse:(id)sender;


- (double)checkValue:(double)value forMin:(double)min andMax:(double)max;


- (void)updateBackgroundColor;

- (void)setViewMovedUp:(BOOL)movedUp byDist:(UInt32)dist;


- (void)setup;
- (void)releaseOutletsAndInstances;

@end

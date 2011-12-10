//
//  LJController.m
//  Backyard Brains
//
//  Created by Zachary King on 12/9/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import "LJController.h"



@implementation LJController

@synthesize delegate;
@synthesize backgroundBlue;
@synthesize numberFormatter, backgroundTimer;
@synthesize playButton, stopButton;


#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{    
    if (![self.backgroundTimer isValid])
        self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateBackgroundColor) userInfo:nil repeats:YES];
    
    self.playButton.enabled = NO;
    self.stopButton.enabled = YES;
}

- (void)pulseIsStopped
{
    if ([self.backgroundTimer isValid])
        [self.backgroundTimer invalidate];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    self.playButton.enabled = YES;
    self.stopButton.enabled = NO;
}


#pragma mark - methods

- (IBAction)sliderMoved:(UISlider *)sender
{
	[self updateViewFrom:@"Slider"];
}


- (IBAction)textFieldUpdated:(UITextField *)sender
{
    [self updateViewFrom:@"Field"];
}

- (void)updateViewFrom:(NSString *)source 
{

}


- (IBAction)playPulse:(id)sender 
{
	[self.delegate.pulse playPulse];
}

- (IBAction)stopPulse:(id)sender 
{
	[self.delegate.pulse stopPulse];
}


- (double)checkValue:(double)value forMin:(double)min andMax:(double)max
{
    if (value >= min && value <= max)   { return value; }
    else if (value < min)               { return min; }
    else                                { return max; }
}




- (void)updateBackgroundColor
{
    double blue = self.backgroundBlue;
    if (blue > 0.0)  
    { 
        blue = fabs(blue) + 0.02;
        self.backgroundBlue = blue;
    }
    else      
    { 
        blue = fabs(blue) - 0.02;
        self.backgroundBlue = blue * -1;
    }
    
    if (blue > 0.5)
    {    
        blue = 0.5;     
        self.backgroundBlue = blue * -1;
    }
    else if (blue < 0.2)    
    {    
        blue = 0.2;   
        self.backgroundBlue = blue;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:blue alpha:1];  
}


//method to move the view up/down whenever the keyboard is shown/dismissed


-(void)setViewMovedUp:(BOOL)movedUp byDist:(UInt32)dist
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= dist;
        rect.size.height += dist;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height;
    }
    NSLog(@"Did move up = %@\n", (movedUp ? @"YES" : @"NO"));
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



- (void)setup
{
	// Initialize and set objects
	self.numberFormatter = [[NSNumberFormatter alloc] init];
	[self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //[self.numberFormatter setMinimumIntegerDigits:1];
    [self.numberFormatter setMaximumFractionDigits:1];
    
    self.backgroundBlue = 0.05;
    
	NSLog(@"Setup successful.");
}

- (void)releaseOutletsAndInstances{}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    // register for keyboard notifications
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window]; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    }
    
    self.delegate.pulse.delegate = self;
    
    if ([self.delegate.pulse playing])
        [self pulseIsPlaying];
    else
        [self pulseIsStopped];
    
    //update the output frequency from the settings menu
    //[self.delegate.pulse updateOutputFreq];
    
    [self updateViewFrom:@"Slider"];
    
    NSLog(@"View will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self pulseIsStopped];
    
    // unregister for keyboard notifications while not visible.
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

- (void)viewDidLoad
{
    [self setup];
}


@end

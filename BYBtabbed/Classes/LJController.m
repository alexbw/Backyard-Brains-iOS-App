//
//  LJController.m
//  Backyard Brains
//
//  Created by Zachary King on 12/9/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import "LJController.h"
#import "ToneStimViewController.h"
#import "iPodStimViewController.h"


@implementation LJController

@synthesize delegate;

@synthesize backgroundBlue;

@synthesize backgroundTimer;
@synthesize playButton, stopButton;
@synthesize toneVC, iPodVC, opticalVC, calibrationVC;
@synthesize currentController;

@synthesize theContainerView;


#pragma mark - view lifecycle

- (void)dealloc
{
    [super dealloc];
    
    [playButton release];
    [stopButton release];
    [backgroundTimer release];
    [toneVC release];
    [iPodVC release];
    [opticalVC release];
    [calibrationVC release];
    [currentController release];
    [theContainerView release];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder])
    {
        // Initialize and set objects
        if (self.toneVC==nil)
        {
            self.toneVC = [[ToneStimViewController alloc]
                           initWithNibName:@"ToneStimView" bundle:nil];
            self.toneVC.viewTypeString = @"Tone";        
        }
        if (self.opticalVC==nil)
        {
            self.opticalVC = [[ToneStimViewController alloc]
                              initWithNibName:@"OpticalStimView" bundle:nil];
            self.opticalVC.viewTypeString = @"Optical";
        }
        if (self.iPodVC==nil)
        {
            self.iPodVC = [[iPodStimViewController alloc]
                           initWithNibName:@"iPodStimView" bundle:nil];        
        }
        if (self.calibrationVC==nil)
        {
            self.calibrationVC = [[ToneStimViewController alloc]
                                  initWithNibName:@"LJCalibrationView" bundle:nil];
            self.calibrationVC.viewTypeString = @"Calibration";        
        }
        
        
        
        self.backgroundBlue = 0.05;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

    self.delegate.pulse.delegate = self;
    
    if ([self.delegate.pulse playing])
        [self pulseIsPlaying];
    else
        [self pulseIsStopped];
    
    
    NSLog(@"View will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self pulseIsStopped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.toneVC.delegate        = self.delegate;
    self.opticalVC.delegate     = self.delegate;
    self.iPodVC.delegate        = self.delegate;
    self.iPodVC.ljController    = self;
    self.calibrationVC.delegate = self.delegate;



    [self switchToController:self.toneVC];
    
}


#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{    
    if (![self.backgroundTimer isValid])
        self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateBackgroundColor) userInfo:nil repeats:YES];
    
    self.playButton.enabled = NO;
    self.stopButton.enabled = YES;
    
    [(id <LarvaJoltAudioDelegate>)self.currentController pulseIsPlaying];
}

- (void)pulseIsStopped
{
    if ([self.backgroundTimer isValid])
        [self.backgroundTimer invalidate];
    UIColor *thisBlack =  [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.view.backgroundColor = thisBlack;
    self.currentController.view.backgroundColor = thisBlack;
    
    self.playButton.enabled = YES;
    self.stopButton.enabled = NO;
    
    [(id <LarvaJoltAudioDelegate>)self.currentController pulseIsStopped];
}

#pragma mark - segmented control

- (IBAction)selectorSelected:(UISegmentedControl *)segmentedControl
{
    NSString *selectedOption =
        [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    if ([selectedOption isEqualToString:@"Tone"])
        [self switchToController:(UIViewController *)self.toneVC];
    else if ([selectedOption isEqualToString:@"iPod"])
        [self switchToController:(UIViewController *)self.iPodVC];
    else if ([selectedOption isEqualToString:@"Optical"])
        [self switchToController:(UIViewController *)self.opticalVC];
    else if ([selectedOption isEqualToString:@"Setup"])
        [self switchToController:(UIViewController *)self.calibrationVC];
    else if ([selectedOption isEqualToString:@"Pulse"])
        return;
}

- (void)switchToController:(UIViewController *)newCtl
{
    if(newCtl == self.currentController)
        return;
    if([self.currentController isViewLoaded])
        [self.currentController.view removeFromSuperview];
    
    if(newCtl != nil)
    {
        [self.theContainerView addSubview:newCtl.view];
        [self.theContainerView bringSubviewToFront:newCtl.view];
    }
    
    self.currentController = newCtl;
}

#pragma mark - methods

- (IBAction)playPulse:(id)sender 
{
	[self.delegate.pulse playPulse];
}

- (IBAction)stopPulse:(id)sender 
{
	[self.delegate.pulse stopPulse];
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
    
    UIColor *thisBlue = [UIColor colorWithRed:0.05 green:0.05 blue:blue alpha:1];  
    self.view.backgroundColor = thisBlue;
    self.currentController.view.backgroundColor = thisBlue;
}



@end

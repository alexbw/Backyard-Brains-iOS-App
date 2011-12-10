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


#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{    
}

- (void)pulseIsStopped
{
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


- (void)setup{}
- (void)releaseOutletsAndInstances{}



@end

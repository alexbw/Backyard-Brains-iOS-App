//
//  ToneStimViewController.m
//  Controls optical & tone views.
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 Backyard Brains.
//

#define kOFFSET_FOR_KEYBOARD 110.0

#import "ToneStimViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ToneStimViewController () //private properties


@property (nonatomic,retain) IBOutlet UISlider *frequencySlider;
@property (nonatomic,retain) IBOutlet UISlider *dutyCycleSlider;
@property (nonatomic,retain) IBOutlet UISlider *pulseTimeSlider;
@property (nonatomic,retain) IBOutlet UITextField *frequencyField;
@property (nonatomic,retain) IBOutlet UITextField *pulseWidthField;
@property (nonatomic,retain) IBOutlet UITextField *pulseTimeField;
@property (nonatomic,retain) IBOutlet UISwitch *constantToneSwitch;

@property (nonatomic,retain) IBOutlet UISlider *toneFreqSlider;
@property (nonatomic,retain) IBOutlet UITextField *toneFreqField;
@property (nonatomic,retain) IBOutlet UITextField *calibAField, *calibBField, *calibCField;

@property (nonatomic,retain) NSNumberFormatter *numberFormatter;

@end


@implementation ToneStimViewController

@synthesize delegate;
@synthesize viewTypeString;

@synthesize frequencySlider, dutyCycleSlider, pulseTimeSlider;
@synthesize frequencyField, pulseWidthField, pulseTimeField;
@synthesize constantToneSwitch;
@synthesize toneFreqField, toneFreqSlider;
@synthesize calibAField, calibBField, calibCField;

@synthesize numberFormatter;

#pragma mark - Initiation methods and messages from the system

- (void)dealloc
{
	//release outlets
    [viewTypeString release];
	[frequencyField release];
	[pulseWidthField release];
	[pulseTimeField release];
	[frequencySlider release];
	[dutyCycleSlider release];
	[pulseTimeSlider release];
    [constantToneSwitch release];
    [toneFreqField release];
    [toneFreqSlider release];
    [calibAField release];
    [calibBField release];
    [calibCField release];
    [numberFormatter release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.numberFormatter = [[NSNumberFormatter alloc] init];
	[self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //[self.numberFormatter setMinimumIntegerDigits:1];
    [self.numberFormatter setMaximumFractionDigits:1];
    
    if ([self.viewTypeString isEqualToString:@"Tone"]
        || [self.viewTypeString isEqualToString:@"Optical"])
    {
        //assign delegates of text fields to control keyboard behavior
        self.frequencyField.returnKeyType = UIReturnKeyDone;
        self.frequencyField.delegate = self;
        self.pulseWidthField.returnKeyType = UIReturnKeyDone;
        self.pulseWidthField.delegate = self;
        self.pulseTimeField.returnKeyType = UIReturnKeyDone;
        self.pulseTimeField.delegate = self;
    }
    else if ([self.viewTypeString isEqualToString:@"Calibration"]) 
    {
        //assign delegates of text fields to control keyboard behavior
        self.toneFreqField.returnKeyType = UIReturnKeyDone;
        self.toneFreqField.delegate = self;
        self.calibAField.returnKeyType = UIReturnKeyDone;
        self.calibAField.delegate = self;
        self.calibBField.returnKeyType = UIReturnKeyDone;
        self.calibBField.delegate = self;
        self.calibCField.returnKeyType = UIReturnKeyDone;
        self.calibCField.delegate = self;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window]; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    }
    
    //No longer playing a song
    self.delegate.pulse.songSelected = NO;

    [self updateViewFrom:@"Slider" fromView:self.viewTypeString];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{
    if ([self.viewTypeString isEqualToString:@"Tone"]
        || [self.viewTypeString isEqualToString:@"Optical"])
    {
        self.pulseTimeField.enabled = NO;
        self.pulseTimeSlider.enabled = NO;
    }
    
}
- (void)pulseIsStopped
{
    if ([self.viewTypeString isEqualToString:@"Tone"]
        || [self.viewTypeString isEqualToString:@"Optical"])
    {
        self.pulseTimeField.enabled = YES;
        self.pulseTimeSlider.enabled = YES;
    }
}



#pragma mark - Implementation of UITextField delegate protocol.


- (void)textFieldDidEndEditing:(UITextField *)textField
{/*
  if ((   [textField isEqual:self.pulseTimeField]
  || [textField isEqual:self.toneFreqField]
  || [textField isEqual:self.calibAField]
  || [textField isEqual:self.calibBField]
  || [textField isEqual:self.calibCField]  )
  && self.view.frame.origin.y < 0)
  {
  [self setViewMovedUp:NO byDist:0];
  }*/
}

// this helps dismiss the keyboard when the "done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    /*if  (self.view.frame.origin.y >= 0)
     {
     if ([sender isEqual:self.pulseTimeField] || [sender isEqual:self.toneFreqField])
     {
     //move the main view, so that the keyboard does not hide it.
     
     [self setViewMovedUp:YES byDist:kOFFSET_FOR_KEYBOARD];
     }
     else if (   [sender isEqual:self.calibAField]
     || [sender isEqual:self.calibBField]
     || [sender isEqual:self.calibCField] )
     {
     [self setViewMovedUp:YES byDist:200];
     }
     }*/
}

#pragma mark - keyboard control

- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
    /*if (([self.pulseTimeField isFirstResponder] || [self.toneFreqField isFirstResponder])
        && self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES byDist:kOFFSET_FOR_KEYBOARD];
    }
    else if (!([self.pulseTimeField isFirstResponder]
               || [self.toneFreqField isFirstResponder]
               || [self.calibAField isFirstResponder]
               || [self.calibBField isFirstResponder]
               || [self.calibCField isFirstResponder])
             && self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO byDist:0];
    }
    else if ([self.calibAField isFirstResponder]
             || [self.calibBField isFirstResponder]
             || [self.calibCField isFirstResponder])
    {
        [self setViewMovedUp:YES byDist:200];
    }*/
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    //[self setViewMovedUp:NO byDist:0];
}


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




# pragma mark - Update methods


- (void)updateViewFrom:(NSString *)source fromView:(NSString *)view
{	
    
    
    if ([view isEqualToString:@"Optical"] || [view isEqualToString:@"Tone"])
    {
        if (source==@"Slider")
        {
            self.delegate.pulse.pulseTime = self.pulseTimeSlider.value;
            
            if (self.constantToneSwitch.on) {
                self.delegate.pulse.frequency = 0;
                self.frequencyField.enabled  = NO;
                self.frequencySlider.enabled = NO;
                self.pulseWidthField.enabled = NO;
                self.dutyCycleSlider.enabled = NO;
            }
            else
            {
                self.delegate.pulse.frequency = self.frequencySlider.value;
                self.delegate.pulse.dutyCycle = self.dutyCycleSlider.value;
                
                self.frequencyField.enabled  = YES;
                self.frequencySlider.enabled = YES;
                self.pulseWidthField.enabled = YES;
                self.dutyCycleSlider.enabled = YES;
            }  
            NSLog(@"Updated from Slider");
        }
        else
        {
            if (!self.constantToneSwitch.on)
            {
                self.delegate.pulse.frequency = [self checkValue:[self.frequencyField.text doubleValue]
                                                          forMin:self.frequencySlider.minimumValue
                                                          andMax:self.frequencySlider.maximumValue ];
                
                self.delegate.pulse.dutyCycle =
                [self checkValue:[self.pulseWidthField.text doubleValue] / 1000 * self.delegate.pulse.frequency
                          forMin: self.dutyCycleSlider.minimumValue
                          andMax: self.dutyCycleSlider.maximumValue ];
            }
            self.delegate.pulse.pulseTime = [self checkValue:[self.pulseTimeField.text doubleValue] * 1000
                                                      forMin: self.pulseTimeSlider.minimumValue
                                                      andMax: self.pulseTimeSlider.maximumValue ];
            
                    
            NSLog(@"Updated from Field");
        }
        
        if (!self.constantToneSwitch.on)
        {
            self.frequencySlider.value = self.delegate.pulse.frequency;
            NSNumber *num1 = [NSNumber numberWithDouble:self.delegate.pulse.frequency];
            self.frequencyField.text = [self.numberFormatter stringFromNumber:num1];
            
            self.dutyCycleSlider.value = self.delegate.pulse.dutyCycle;
            NSNumber *num2 = [NSNumber numberWithDouble:(self.delegate.pulse.dutyCycle/self.delegate.pulse.frequency*1000)];
            self.pulseWidthField.text = [self.numberFormatter stringFromNumber:num2];
        }
        
        self.pulseTimeSlider.value = self.delegate.pulse.pulseTime;
        NSNumber *num3 = [NSNumber numberWithDouble:(self.delegate.pulse.pulseTime/1000)];
        self.pulseTimeField.text = [self.numberFormatter stringFromNumber:num3];
    }
    
    if ([view isEqualToString:@"Calibration"])
    {
        if (source==@"Slider")
        {
            self.delegate.pulse.ledControlFreq = self.toneFreqSlider.value;            
        }
        else
        {
            self.delegate.pulse.ledControlFreq = 
            [ self checkValue:[[self.toneFreqField.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]
                       forMin: self.toneFreqSlider.minimumValue 
                       andMax: self.toneFreqSlider.maximumValue ];
            
            self.delegate.pulse.calibA = [self.calibAField.text doubleValue];
            self.delegate.pulse.calibB = [self.calibBField.text doubleValue];
            self.delegate.pulse.calibC = [self.calibCField.text doubleValue];
            NSLog(@"calibA: %f calibB: %f calibC: %f", self.delegate.pulse.calibA,
                  self.delegate.pulse.calibB, self.delegate.pulse.calibC);
            NSLog(@"Updated from Field");
        }
        
        self.toneFreqSlider.value = self.delegate.pulse.ledControlFreq;
        NSNumber *num = [NSNumber numberWithDouble:self.delegate.pulse.ledControlFreq];
        self.toneFreqField.text = [self.numberFormatter stringFromNumber:num];
    }
}


- (double)checkValue:(double)value forMin:(double)min andMax:(double)max
{
    if (value >= min && value <= max)   { return value; }
    else if (value < min)               { return min;   }
    else                                { return max;   }
}


- (IBAction)sliderMoved:(UISlider *)sender {
	[self updateViewFrom:@"Slider" fromView:self.viewTypeString];
}
- (IBAction)textFieldUpdated:(UITextField *)sender {
    [self updateViewFrom:@"Field" fromView:self.viewTypeString];
}


- (IBAction)toggleConstantTone:(UISwitch *)sender
{
    [self updateViewFrom:@"Slider" fromView:self.viewTypeString];
}


@end

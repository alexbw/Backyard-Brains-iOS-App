//
//  LarvaJoltViewController.m
//  LarvaJolt
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 Zachary King.
//

#define kOFFSET_FOR_KEYBOARD 110.0

#import "LarvaJoltViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface LarvaJoltViewController () //private properties

@property (nonatomic,retain) NSNumberFormatter *numberFormatter;
@property (nonatomic,retain) NSTimer *backgroundTimer;
@property double backgroundBlue;

@property (nonatomic,retain) IBOutlet UISlider *frequencySlider;
@property (nonatomic,retain) IBOutlet UISlider *dutyCycleSlider;
@property (nonatomic,retain) IBOutlet UISlider *pulseTimeSlider;
@property (nonatomic,retain) IBOutlet UISlider *toneFreqSlider;
@property (nonatomic,retain) IBOutlet UITextField *frequencyField;
@property (nonatomic,retain) IBOutlet UITextField *pulseWidthField;
@property (nonatomic,retain) IBOutlet UITextField *pulseTimeField;
@property (nonatomic,retain) IBOutlet UITextField *toneFreqField;
@property (nonatomic,retain) IBOutlet UISwitch *constantToneSwitch;
@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) IBOutlet UIButton *stopButton;
@property (nonatomic,retain) IBOutlet UITextField *calibAField, *calibBField, *calibCField;

@end


@implementation LarvaJoltViewController

@synthesize delegate;
@synthesize numberFormatter, backgroundTimer, backgroundBlue;
@synthesize frequencySlider, dutyCycleSlider, pulseTimeSlider, toneFreqSlider;
@synthesize frequencyField, pulseWidthField, pulseTimeField, toneFreqField;
@synthesize playButton, stopButton, constantToneSwitch;
@synthesize calibAField, calibBField, calibCField;


#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{
    self.pulseTimeField.enabled = NO;
    self.pulseTimeSlider.enabled = NO;
    self.playButton.enabled = NO;
    self.stopButton.enabled = YES;
    
    //self.delegate.stimButton.enabled = NO;
    
    self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateBackgroundColor) userInfo:nil repeats:YES];
}
- (void)pulseIsStopped
{
    self.pulseTimeField.enabled = YES;
    self.pulseTimeSlider.enabled = YES;
    self.playButton.enabled = YES;
    self.stopButton.enabled = NO;
    
    //self.delegate.stimButton.enabled = YES;
    
    [self.backgroundTimer invalidate];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
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



- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
    if (([self.pulseTimeField isFirstResponder] || [self.toneFreqField isFirstResponder])
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
    }
}

- (void)keyboardWillHide:(NSNotification *)notif
{
        [self setViewMovedUp:NO byDist:0];
}



// ----------
// Methods


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



- (void)updateViewFrom:(NSString *)source
{	
    if (source==@"Slider")
    {
        if (!self.constantToneSwitch.on)
        {
            self.delegate.pulse.frequency = self.frequencySlider.value;
            self.delegate.pulse.dutyCycle = self.dutyCycleSlider.value;
        }
        self.delegate.pulse.pulseTime = self.pulseTimeSlider.value;
        self.delegate.pulse.ledControlFreq = self.toneFreqSlider.value;
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
        
        //NSLog(@"tone freq field text: %f", [self.toneFreqField.text doubleValue]);
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
    
    //NSLog(@"led control freq: %f", self.delegate.pulse.ledControlFreq);
    self.toneFreqSlider.value = self.delegate.pulse.ledControlFreq;
    NSNumber *num4 = [NSNumber numberWithDouble:self.delegate.pulse.ledControlFreq];
    self.toneFreqField.text = [self.numberFormatter stringFromNumber:num4];
    
}


- (double)checkValue:(double)value forMin:(double)min andMax:(double)max
{
    if (value >= min && value <= max)   { return value; }
    else if (value < min)               { return min; }
    else                                { return max; }
}


- (IBAction)sliderMoved:(UISlider *)sender
{
	[self updateViewFrom:@"Slider"];
}


- (IBAction)textFieldUpdated:(UITextField *)sender
{
    [self updateViewFrom:@"Field"];
}

- (IBAction)playPulse:(id)sender 
{
	[self.delegate.pulse playPulse];
}

- (IBAction)stopPulse:(id)sender 
{
	[self.delegate.pulse stopPulse];
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate hideLarvaJolt];
}

- (IBAction)toggleConstantTone:(UISwitch *)sender
{
    if (sender.on==YES)
    {
        self.delegate.pulse.frequency = 0;
        self.frequencyField.enabled  = NO;
        self.frequencySlider.enabled = NO;
        self.pulseWidthField.enabled = NO;
        self.dutyCycleSlider.enabled = NO;
    }
    else
    {
        self.frequencyField.enabled  = YES;
        self.frequencySlider.enabled = YES;
        self.pulseWidthField.enabled = YES;
        self.dutyCycleSlider.enabled = YES;
        [self updateViewFrom:@"Slider"];
    }
}


// ------------------------------------------------------------------------------------------------------------
// Initiation methods and messages from the system
//

- (void)setup
{
	// Initialize and set objects
	self.numberFormatter = [[NSNumberFormatter alloc] init];
	[self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //[self.numberFormatter setMinimumIntegerDigits:1];
    [self.numberFormatter setMaximumFractionDigits:1];
    
    self.backgroundBlue = 0.05;
    
    
    
    [self updateViewFrom:@"Slider"];
    NSLog(@"View updated.");
        
	NSLog(@"Setup successful.");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil])) {
		NSLog(@"View initialized.");
		[self setup];
	}
	return self;
}

- (void)awakeFromNib
{
	
	NSLog(@"Awoke from Nib.");
	[super awakeFromNib];
}




- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    //assign delegates of text fields to control keyboard behavior
    self.frequencyField.returnKeyType = UIReturnKeyDone;
    self.frequencyField.delegate = self;
    self.pulseWidthField.returnKeyType = UIReturnKeyDone;
    self.pulseWidthField.delegate = self;
    self.pulseTimeField.returnKeyType = UIReturnKeyDone;
    self.pulseTimeField.delegate = self;
    self.toneFreqField.returnKeyType = UIReturnKeyDone;
    self.toneFreqField.delegate = self;
    self.calibAField.returnKeyType = UIReturnKeyDone;
    self.calibAField.delegate = self;
    self.calibBField.returnKeyType = UIReturnKeyDone;
    self.calibBField.delegate = self;
    self.calibCField.returnKeyType = UIReturnKeyDone;
    self.calibCField.delegate = self;
    
    // register for keyboard notifications
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window]; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    }
    
    //update the output frequency from the settings menu
    //[self.delegate.pulse updateOutputFreq];
    
    [self updateViewFrom:@"Slider"];
    
    NSLog(@"View will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}






- (void)releaseOutletsAndInstances
{
	//release outlets
	[frequencyField release];
	[pulseWidthField release];
	[pulseTimeField release];
	[frequencySlider release];
	[dutyCycleSlider release];
	[pulseTimeSlider release];
    [toneFreqField release];
    [toneFreqSlider release];
    [constantToneSwitch release];
    [calibAField release];
    [calibBField release];
    [calibCField release];
	
	//release instances
	[numberFormatter release];
}

- (void)viewDidUnload
{
	[self releaseOutletsAndInstances];
}

- (void)dealloc
{
	[self releaseOutletsAndInstances];
    [super dealloc];
}

@end

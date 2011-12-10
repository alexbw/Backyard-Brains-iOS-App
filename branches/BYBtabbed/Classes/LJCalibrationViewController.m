//
//  LJCalibrationViewController.m
//  Backyard Brains
//
//  Created by Zachary King on 12/9/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import "LJCalibrationViewController.h"

@interface LJCalibrationViewController ()

    @property (nonatomic,retain) IBOutlet UITextField *calibAField, *calibBField, *calibCField;
    @property (nonatomic,retain) IBOutlet UISlider *toneFreqSlider;
    @property (nonatomic,retain) IBOutlet UITextField *toneFreqField;

@end



@implementation LJCalibrationViewController

@synthesize calibAField, calibBField, calibCField;
@synthesize toneFreqSlider, toneFreqField;

#pragma mark - IBActions


- (IBAction)done:(UIBarButtonItem *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - update methods

- (void)updateViewFrom:(NSString *)source
{	
    if (source==@"Slider")
    {
        self.delegate.pulse.ledControlFreq = self.toneFreqSlider.value;
        NSLog(@"Updated from Slider");
    }
    else
    {
        
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
    
    //NSLog(@"led control freq: %f", self.delegate.pulse.ledControlFreq);
    self.toneFreqSlider.value = self.delegate.pulse.ledControlFreq;
    NSNumber *num4 = [NSNumber numberWithDouble:self.delegate.pulse.ledControlFreq];
    self.toneFreqField.text = [self.numberFormatter stringFromNumber:num4];
    
}


#pragma mark - keyboard management

- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately

}

- (void)keyboardWillHide:(NSNotification *)notif
{
    [self setViewMovedUp:NO byDist:0];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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


- (void)releaseOutletsAndInstances
{
	//release outlets
    [toneFreqField release];
    [toneFreqSlider release];
    [calibAField release];
    [calibBField release];
    [calibCField release];
    [playButton release];
    [stopButton release];
	
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

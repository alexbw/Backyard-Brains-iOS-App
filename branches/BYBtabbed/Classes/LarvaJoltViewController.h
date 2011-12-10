//
//  LarvaJoltViewController.h
//  LarvaJolt
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>
#import "LJController.h"
#import "LJCalibrationViewController.h"


@interface LarvaJoltViewController : LJController
{
    
	
	IBOutlet UISlider *frequencySlider;
	IBOutlet UISlider *dutyCycleSlider;
    IBOutlet UISlider *pulseTimeSlider;
    IBOutlet UITextField *frequencyField;
    IBOutlet UITextField *pulseWidthField;
    IBOutlet UITextField *pulseTimeField;
    IBOutlet UISwitch *constantToneSwitch;
	
}

- (IBAction)toggleConstantTone:(UISwitch *)sender;
- (IBAction)openCalibrationView:(UIBarButtonItem *)sender;

- (void)keyboardWillShow:(NSNotification *)notif;
- (void)keyboardWillHide:(NSNotification *)notif;


@end


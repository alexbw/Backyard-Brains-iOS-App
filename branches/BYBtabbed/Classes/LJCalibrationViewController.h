//
//  LJCalibrationViewController.h
//  Backyard Brains
//
//  Created by Zachary King on 12/9/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJController.h"

@interface LJCalibrationViewController : LJController {

    IBOutlet UISlider *toneFreqSlider;
    IBOutlet UITextField *toneFreqField;
    IBOutlet UITextField *calibAField, *calibBField, *calibCField;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *stopButton;
}

- (IBAction)done:(UIBarButtonItem *)sender;

@end

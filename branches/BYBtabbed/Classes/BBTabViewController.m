//
//  BBTabViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/6/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBTabViewController.h"


@implementation BBTabViewController

@synthesize drawingDataManager;


- (void)dealloc {
    [super dealloc];
    
    [drawingDataManager release];
}

- (void)viewDidLoad {
	self.drawingDataManager = [[AudioSignalManager alloc] initWithCallbackType:kAudioCallbackContinuous];
	[self.drawingDataManager play];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return NO;
	}
	
	return NO;
}

# pragma mark - GainViewControllerDelegate Protocol
- (float) gain {
    return self.drawingDataManager.gain;
}

- (void) setGain:(float)newGain {
    if (gain != newGain) {
		self.drawingDataManager.gain = newGain;
    }
}


@end

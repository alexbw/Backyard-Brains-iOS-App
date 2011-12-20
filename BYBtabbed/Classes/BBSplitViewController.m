//
//  BBSplitViewController.m
//  Backyard Brains
//
//  Created by Zachary King on 9-15-2011.
//  Copyright 2011 University of Michigan. All rights reserved.
//

#import "BBSplitViewController.h"


@implementation BBSplitViewController

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

@end

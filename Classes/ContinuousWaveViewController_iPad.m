//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import "ContinuousWaveViewController_iPad.h"

@implementation ContinuousWaveViewController_iPad

@synthesize recordedFilesPopover;

- (void)dealloc {	
    [super dealloc];
	

}

- (IBAction)displayInfoPopover:(UIButton *)sender {
	
	FlipsideInfoViewController *flipController = [[FlipsideInfoViewController alloc] initWithNibName:@"FlipsideInfoView" bundle:nil];
	flipController.delegate = self;
	flipController.modalPresentationStyle = UIModalPresentationFormSheet;
	flipController.view.frame = CGRectMake(0, 0, 620, 540);
	[self presentModalViewController:flipController animated:YES];
	[flipController release];	
}

- (void)flipsideIsDone
{
	[self dismissModalViewControllerAnimated:YES];
}

// iPad settings popover delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[popoverController release];
}


- (IBAction)showFilePopover:(UIButton *)sender {
	
	[self.audioSignalManager pause];
	
	BBFileViewController *theViewController	= [[BBFileViewController alloc] initWithNibName:@"BBFileView" bundle:nil];
	theViewController.delegate = (id *)self;
	UINavigationController *theNavigationController = [[UINavigationController alloc] initWithRootViewController:theViewController];
	
	UIPopoverController *aPopover = [[UIPopoverController alloc] initWithContentViewController:theNavigationController];
	recordedFilesPopover = aPopover;
	recordedFilesPopover.delegate = self;
	[recordedFilesPopover setPopoverContentSize:CGSizeMake(320.0f, 480.0f)];
	recordedFilesPopover.passthroughViews = [NSArray arrayWithObject:self.cwView];
	[recordedFilesPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[theViewController release];
	[theNavigationController release];
	
	
}

- (void)hideFiles {
	// This is also a delegate action	
	[self.audioSignalManager play];
	[recordedFilesPopover dismissPopoverAnimated:YES];
}

- (void)done {
	[self hideFiles];
}



@end

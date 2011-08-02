//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/27/2011 Added LarvaJolt stimulation controller.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "ContinuousWaveViewController_iPad.h"

@implementation ContinuousWaveViewController_iPad

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
	
	[self.audioSignalManager pause];
}

//for FlipsideInfoViewDelegate
- (void)flipsideIsDone
{
	[self dismissModalViewControllerAnimated:YES];
	[self.audioSignalManager play];
}

//If the user dismissed by touching outside popover:
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popover {
	[self.audioSignalManager play];
}

@end

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

@synthesize recordedFilesPopover;
@synthesize ljvc;

- (void)dealloc {	
    [super dealloc];
	
    if (self.recordedFilesPopover)
        [recordedFilesPopover release];
    if (self.ljvc)
        [ljvc release];
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


- (IBAction)showFilePopover:(UIButton *)sender {
	
	[self.audioSignalManager pause];
	
	
    if (!self.recordedFilesPopover)
    {
        BBFileViewController *theViewController	= [[BBFileViewController alloc] initWithNibName:@"BBFileView" bundle:nil];
        theViewController.delegate = (id)self;
        
        UINavigationController *theNavigationController = [[UINavigationController alloc] initWithRootViewController:theViewController];
        
        
        self.recordedFilesPopover = [[UIPopoverController alloc] initWithContentViewController:theNavigationController];
        
        [theViewController release];
        [theNavigationController release];
        
        self.recordedFilesPopover.delegate = self;
    }
	[self.recordedFilesPopover setPopoverContentSize:CGSizeMake(320.0f, 480.0f)];
	//self.recordedFilesPopover.passthroughViews = [NSArray arrayWithObject:self.cwView];
	[self.recordedFilesPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}

//for BBFileViewControllerDelegate
- (void)hideFiles {
	[self.audioSignalManager play];
	[self.recordedFilesPopover dismissPopoverAnimated:YES];
}

//If the user dismissed by touching outside popover:
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popover {
	[self.audioSignalManager play];
}



- (IBAction)showLarvaJoltPopover:(UIButton *)sender
{
    
	[self.audioSignalManager pause];
    
    if (!self.ljvc)
    {
        self.ljvc = [[LarvaJoltViewController alloc] initWithNibName:@"LarvaJoltViewController" bundle:nil];
        self.ljvc.delegate = self;
        self.ljvc.modalPresentationStyle = UIModalPresentationFormSheet;
        self.ljvc.view.frame = CGRectMake(0, 0, 620, 540);
	}
    [self presentModalViewController:self.ljvc animated:YES];
    
}

//for LarvaJoltViewControllerDelegate
- (void)hideLarvaJolt
{
	[self dismissModalViewControllerAnimated:YES];
	[self.audioSignalManager play];
}


@end

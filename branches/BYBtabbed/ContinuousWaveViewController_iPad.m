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

@synthesize toolbar;
@synthesize recordButton, infoBarButton, stimButton;



- (void)dealloc {
    [toolbar release];
	[recordButton release];
	[infoBarButton release];
    [stimButton release];
    [super dealloc];
}	


- (void)viewDidUnload
{
    [super viewDidUnload];
    
	self.toolbar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)displayInfoPopover:(UIButton *)sender {
	
	FlipsideInfoViewController *flipController = [[FlipsideInfoViewController alloc] initWithNibName:@"FlipsideInfoView" bundle:nil];
	flipController.delegate = self;
	flipController.modalPresentationStyle = UIModalPresentationFormSheet;
	flipController.view.frame = CGRectMake(0, 0, 620, 540);
	[self presentModalViewController:flipController animated:YES];
	[flipController release];
	
	[self.drawingDataManager pause];
}

//for FlipsideInfoViewDelegate
- (void)flipsideIsDone
{
	[self dismissModalViewControllerAnimated:YES];
	[self.drawingDataManager play];
}

//If the user dismissed by touching outside popover:
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popover {
	[self.drawingDataManager play];
}


#pragma mark - Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
    NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    [itemsArray insertObject:barButtonItem atIndex:0];
    [toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar. 
    NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    [itemsArray removeObject:barButtonItem];
    [toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}

- (IBAction)stopRecording:(UIButton *)sender {
    [super stopRecording:sender];
    
    [[self.delegate fileController] checkForNewFilesAndReload];
	
}



@end

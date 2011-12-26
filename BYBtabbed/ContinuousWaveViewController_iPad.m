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


@synthesize recordButton    = _recordButton;
@synthesize infoBarButton   = _infoBarButton;
@synthesize stimButton      = _stimButton;
@synthesize fileButton      = _fileButton;

#pragma mark - view lifecycle

- (void)dealloc {
    
	[_recordButton release];
	[_infoBarButton release];
    [_stimButton release];
    
    [super dealloc];
}	
 
#pragma mark - actions

- (IBAction)displayInfoPopover:(UIButton *)sender {
	
	FlipsideInfoViewController *flipController = [[FlipsideInfoViewController alloc] initWithNibName:@"FlipsideInfoView" bundle:nil];
	flipController.delegate = self;
	flipController.modalPresentationStyle = UIModalPresentationFormSheet;
	flipController.view.frame = CGRectMake(0, 0, 620, 540);
	[self presentModalViewController:flipController animated:YES];
	[flipController release];
	
	[self.drawingDataManager pause];
}



- (IBAction)stopRecording:(UIButton *)sender {
    
    [super stopRecording:sender];
    
    if ([(NSObject *)self.delegate respondsToSelector:@selector(fileController)])
        [self.delegate.fileController checkForNewFilesAndReload];
	
}


#pragma mark - FlipsideInfoViewDelegate
- (void)flipsideIsDone
{
	[self dismissModalViewControllerAnimated:YES];
	[self.drawingDataManager play];
}



#pragma mark - UIPopoverControllerDelegate

//If the user dismissed by touching outside popover:
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popover {
	[self.drawingDataManager play];
}




@end

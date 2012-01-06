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
#import "LJController.h"

@implementation ContinuousWaveViewController_iPad


@synthesize fileButton       = _fileButton;
@synthesize stimSetupButton  = _stimSetupButton;
@synthesize stimShadowButton = _stimShadowButton;
@synthesize currentPopover   = _currentPopover;
@synthesize alphaTimer       = _alphaTimer;
@synthesize theAlpha         = _theAlpha;


#pragma mark - view lifecycle

- (void)dealloc {
    
	
    [_fileButton release];
    [_stimSetupButton release];
    [_stimShadowButton release];
    [_currentPopover release];
    [_alphaTimer release];
    
    [super dealloc];
}	
 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.delegate.pulse.delegate = self;
    self.theAlpha = 0;
}

#pragma mark - actions

- (IBAction)displayInfoPopover:(UIButton *)sender {
	
	FlipsideInfoViewController *flipController = [[FlipsideInfoViewController alloc] initWithNibName:@"FlipsideInfoView" bundle:nil];
	flipController.delegate = self;
	flipController.modalPresentationStyle = UIModalPresentationFormSheet;
	flipController.view.frame = CGRectMake(0, 0, 620, 540);
	[self presentModalViewController:flipController animated:YES];
	[flipController release];
	
	[self.audioSignalManager pause];
}


- (IBAction)displayFilePopover:(UIButton *)sender
{
    BBFileViewControllerTBV *fileController = [[BBFileViewControllerTBV alloc] initWithStyle:UITableViewStylePlain];
    
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:fileController] autorelease];
    
    UIPopoverController *popover = [[[UIPopoverController alloc] initWithContentViewController:navController] retain];
    popover.delegate = self;
    popover.popoverContentSize = CGSizeMake(320, [[BBFile allObjects] count]*54+60);
    self.currentPopover = popover;
    
    [self.audioSignalManager pause];
    
    CGRect rect = self.fileButton.frame;
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)displayStimSetupPopover:(UIButton *)sender
{
    LJController *stimController = [[[LJController alloc] initWithNibName:@"LJView" bundle:nil] autorelease];
    if (self.delegate.pulse)
    {
        stimController.delegate = (id <LarvaJoltViewDelegate>)self.delegate;
        self.delegate.pulse.delegate = stimController;
        [self pulseIsStopped];
    }
    
    UIPopoverController *popover = [[[UIPopoverController alloc] initWithContentViewController:stimController] retain];
    popover.delegate = self;
    popover.popoverContentSize = CGSizeMake(320, 431);
    self.currentPopover = popover;
    
    [self.audioSignalManager pause];
    
    
    CGRect rect = self.stimSetupButton.frame;
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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
    self.delegate.pulse.songSelected = NO;
    self.delegate.pulse.delegate = self;
    if (self.delegate.pulse.playing)
        [self pulseIsPlaying];
    else
        [self pulseIsStopped];
    
    [popover release];
    self.currentPopover = nil;
}

#pragma mark - rotation

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.currentPopover != nil)
    {
        [self.currentPopover dismissPopoverAnimated:YES];
        [self popoverControllerDidDismissPopover:self.currentPopover];
    }
}

#pragma mark - LarvaJoltAudioDelegate

- (void)pulseIsPlaying
{
    if (![self.alphaTimer isValid])
        self.alphaTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateStimShadowAlpha) userInfo:nil repeats:YES];
    
}

- (void)pulseIsStopped
{
    self.stimShadowButton.alpha = 0.0;
    if ([self.alphaTimer isValid])
        [self.alphaTimer invalidate];
}

- (void)updateStimShadowAlpha
{
    double alpha = self.theAlpha;
    if (alpha > 0.0)  
    { 
        alpha = fabs(alpha) + 0.02;
        self.theAlpha = alpha;
    }
    else      
    { 
        alpha = fabs(alpha) - 0.02;
        self.theAlpha = alpha * -1;
    }
    
    if (alpha > 0.8)
    {    
        alpha = 0.8;     
        self.theAlpha = alpha * -1;
    }
    else if (alpha < 0.2)    
    {    
        alpha = 0.2;   
        self.theAlpha = alpha;
    }
    
    self.stimShadowButton.alpha = alpha;
}

@end

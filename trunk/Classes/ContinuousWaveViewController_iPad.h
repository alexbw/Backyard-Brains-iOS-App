//
//  ContinuousWaveView.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import "ContinuousWaveViewController.h"
#import "BBFileViewController.h"
#import "FlipsideInfoViewController.h"
#import "LarvaJoltViewController.h"


@interface ContinuousWaveViewController_iPad : ContinuousWaveViewController <BBFileViewControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, FlipsideInfoViewDelegate, LarvaJoltViewDelegate> {

	UIPopoverController *recordedFilesPopover;
    UIPopoverController *larvaJoltPopover;
	
}

@property (nonatomic, retain) UIPopoverController *recordedFilesPopover;
@property (nonatomic, retain) UIPopoverController *larvaJoltPopover;

- (IBAction)displayInfoPopover:(UIButton *)sender;
- (IBAction)showFilePopover:(UIButton *)sender;
- (IBAction)showLarvaJoltPopover:(UIButton *)sender;

//for BBFileViewControllerDelegate
- (void)hideFiles;

@end

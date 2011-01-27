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


@interface ContinuousWaveViewController_iPad : ContinuousWaveViewController <BBFileViewControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, FlipsideInfoViewDelegate> {

	UIPopoverController *recordedFilesPopover;
	
}

@property (nonatomic, retain) UIPopoverController *recordedFilesPopover;

- (IBAction)displayInfoPopover:(UIButton *)sender;
- (IBAction)showFilePopover:(UIButton *)sender;

@end

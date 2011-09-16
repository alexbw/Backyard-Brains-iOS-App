//
//  ContinuousWaveView_iPad.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/27/2011 Added LarvaJolt stimulation controller.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "ContinuousWaveViewController.h"
#import "BBFileViewControllerTBV.h"
#import "FlipsideInfoViewController.h"

@interface ContinuousWaveViewController_iPad : ContinuousWaveViewController <UINavigationControllerDelegate, UIPopoverControllerDelegate, FlipsideInfoViewDelegate, SubstitutableDetailViewController> {
	
    UIToolbar *toolbar;
    
    UIBarButtonItem *stimButton, *recordButton, *infoBarButton;

}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *stimButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *infoBarButton;

- (IBAction)displayInfoPopover:(UIButton *)sender;

//for FlipsideInfoViewDelegate
- (void)flipsideIsDone;

@end

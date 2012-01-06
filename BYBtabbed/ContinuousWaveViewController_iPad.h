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
#import "LarvaJoltAudio.h"

@interface ContinuousWaveViewController_iPad : ContinuousWaveViewController 
    <UIPopoverControllerDelegate, FlipsideInfoViewDelegate, LarvaJoltAudioDelegate>


@property (nonatomic, retain) IBOutlet UIButton *fileButton;
@property (nonatomic, retain) IBOutlet UIButton *stimSetupButton;
@property (nonatomic, retain) IBOutlet UIButton *stimShadowButton;
@property (nonatomic, retain) UIPopoverController *currentPopover;
@property (nonatomic, retain) NSTimer *alphaTimer;
@property double theAlpha;

- (IBAction)displayInfoPopover:(UIButton *)sender;
- (IBAction)displayFilePopover:(UIButton *)sender;
- (IBAction)displayStimSetupPopover:(UIButton *)sender;

//for FlipsideInfoViewDelegate
- (void)flipsideIsDone;


- (void)updateStimShadowAlpha;

@end

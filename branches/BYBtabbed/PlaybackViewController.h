//
//  ContinuousWaveView.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/6/2011 Added delegate and methods to automatically set the viewing frame.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "DrawingViewController.h"
#import "PlaybackView.h"
#import "AudioSignalManager.h"
#import "AudioPlaybackManager.h"
#import "math.h"


@interface PlaybackViewController : DrawingViewController <DrawingDataManagerDelegate>
{
	// Data labels
	IBOutlet UIButton *playPauseButton;
    IBOutlet UILabel  *titleLabel;
    IBOutlet UISlider *scrubBar;
    IBOutlet UILabel  *elapsedTimeLabel;
    IBOutlet UILabel  *remainingTimeLabel;
    
	BBFile *bbFile;
	PlaybackView *pbView;
	
	AudioPlaybackManager *apm;
}

@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UISlider *scrubBar;
@property (nonatomic, retain) IBOutlet UILabel  *elapsedTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel  *remainingTimeLabel;

@property (nonatomic, retain) BBFile *bbFile;
@property (nonatomic, retain) PlaybackView *pbView;

@property (nonatomic, retain) AudioPlaybackManager *apm;

- (void)updateDataLabels;
- (void)showAllLabels;
- (void)hideAllLabels;

- (IBAction)playPause:(UIButton *)sender;

//for AudioPlaybackManagerDelegate
- (void)shouldAutoSetFrame;

@end

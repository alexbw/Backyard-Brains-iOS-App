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
#import "ContinuousWaveView.h"
#import "BBFileViewController.h"
#import "AudioRecorder.h"
#import "FlipsideInfoViewController.h"
#import "LarvaJoltViewController.h"
#import "LarvaJoltAudio.h"
#import "math.h"


@interface ContinuousWaveViewController : DrawingViewController <AudioSignalManagerDelegate, LarvaJoltViewDelegate> {
	
	// Data labels
	IBOutlet UIButton *recordButton;
	IBOutlet UIButton *stopButton;
	IBOutlet UIButton *fileButton;
    IBOutlet UIButton *stimButton;
    IBOutlet UIButton *stimSetupButton;
    
    BBFileViewController *fileViewController;
    
	ContinuousWaveView *cwView;
	
	AudioRecorder *audioRecorder;
    
    LarvaJoltViewController *larvaJoltController;
	LarvaJoltAudio *pulse;
}

@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *fileButton;
@property (nonatomic, retain) IBOutlet UIButton *stimButton;
@property (nonatomic, retain) IBOutlet UIButton *stimSetupButton;

@property (nonatomic, retain) BBFileViewController *fileViewController;

@property (nonatomic, retain) ContinuousWaveView *cwView;

@property (nonatomic, retain) AudioRecorder *audioRecorder;

@property (nonatomic, retain) LarvaJoltViewController *larvaJoltController;
@property (nonatomic, retain) LarvaJoltAudio *pulse;



- (void)updateDataLabels;
- (void)showAllLabels;
- (void)hideAllLabels;

- (IBAction)startRecording:(UIButton *)sender;
- (IBAction)stopRecording:(UIButton *)sender;
- (IBAction)startStopStim:(UIButton *)sender;

- (void)pissMyPants;

//for AudioSignalManagerDelegate
- (void)shouldAutoSetFrame;

@end

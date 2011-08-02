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
#import "math.h"


@interface ContinuousWaveViewController : DrawingViewController <DrawingDataManagerDelegate> {
	
	// Data labels
	IBOutlet UIButton *recordButton;
	IBOutlet UIButton *stopButton;
    IBOutlet UIButton *stimButton;
    
	ContinuousWaveView *cwView;
	
	AudioRecorder *audioRecorder;
}

@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *stimButton;

@property (nonatomic, retain) ContinuousWaveView *cwView;

@property (nonatomic, retain) AudioRecorder *audioRecorder;


- (void)updateDataLabels;
- (void)showAllLabels;
- (void)hideAllLabels;

- (IBAction)startRecording:(UIButton *)sender;
- (IBAction)stopRecording:(UIButton *)sender;

- (IBAction)startStim:(UIButton *)sender;

- (void)pissMyPants;

//for DrawingDataManagerDelegate
- (void)shouldAutoSetFrame;

@end

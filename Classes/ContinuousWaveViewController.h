//
//  ContinuousWaveView.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import "DrawingViewController.h"
#import "ContinuousWaveView.h"
#import "BBFileViewController.h"
#import "AudioRecorder.h"
#import "FlipsideInfoViewController.h"


@interface ContinuousWaveViewController : DrawingViewController {
	
	// Data labels
	IBOutlet UIButton *recordButton;
	IBOutlet UIButton *stopButton;
	IBOutlet UIButton *fileButton;
	
	ContinuousWaveView *cwView;
	
	AudioRecorder *audioRecorder;
	
}

@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *fileButton;

@property (nonatomic, retain) ContinuousWaveView *cwView;

@property (nonatomic, retain) AudioRecorder *audioRecorder;

- (void)updateDataLabels;
- (void)showAllLabels;
- (void)hideAllLabels;

- (IBAction)startRecording:(UIButton *)sender;
- (IBAction)stopRecording:(UIButton *)sender;
- (void)pissMyPants;

@end

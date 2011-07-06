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
#import "LarvaJoltViewController.h"
#import "math.h"


@interface ContinuousWaveViewController : DrawingViewController <AudioSignalManagerDelegate> {
	
	// Data labels
	IBOutlet UIButton *recordButton;
	IBOutlet UIButton *stopButton;
	IBOutlet UIButton *fileButton;
    IBOutlet UIButton *stimButton;
    
	ContinuousWaveView *cwView;
	
	AudioRecorder *audioRecorder;
    
    LarvaJoltViewController *larvaJoltController;
	
    //for AudioSignalManagerDelegate
    BOOL didAutoSetFrame;
}

@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *fileButton;
@property (nonatomic, retain) IBOutlet UIButton *stimButton;

@property (nonatomic, retain) ContinuousWaveView *cwView;

@property (nonatomic, retain) AudioRecorder *audioRecorder;

@property (nonatomic, retain) LarvaJoltViewController *larvaJoltController;


- (void)updateDataLabels;
- (void)showAllLabels;
- (void)hideAllLabels;

- (IBAction)startRecording:(UIButton *)sender;
- (IBAction)stopRecording:(UIButton *)sender;
- (void)pissMyPants;

//for AudioSignalManagerDelegate
@property BOOL didAutoSetFrame;
- (void)shouldAutoSetFrame;

@end

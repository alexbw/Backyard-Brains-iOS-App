//
//  ContinuousWaveView.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import "DrawingViewController.h"
#import "TriggerView.h"

@interface TriggerViewController : DrawingViewController <AudioSignalManagerDelegate> {
	
	// Data labels
	IBOutlet UILabel *triggerValueLabel;
	IBOutlet UIButton *numAveragesButton;
	IBOutlet UISlider *numAveragesSlider;
	IBOutlet UILabel *numAveragesLabel;
	
	TriggerView *triggerView;
    
    //for AudioSignalManagerDelegate
    BOOL didAutoSetFrame;
}

@property (nonatomic, retain) IBOutlet UILabel *triggerValueLabel;
@property (nonatomic, retain) IBOutlet UIButton *numAveragesButton;
@property (nonatomic, retain) IBOutlet UISlider *numAveragesSlider;
@property (nonatomic, retain) IBOutlet UILabel *numAveragesLabel;

@property (nonatomic, retain) TriggerView *triggerView;

- (void)updateDataLabels;
- (void)showAllLabels;
- (void)hideAllLabels;
- (CGPoint)translateScreenCoordinatesToNormalizedCoordinates:(CGPoint)point;
- (CGPoint)translateScreenCoordinatesToOpenGLCoordinates:(CGPoint)point;
- (CGPoint)translateOpenGLCoordinatesToNormalizedCoordinates:(CGPoint)point;

- (void)handleSingleTouchForTriggerView;
- (void)handlePinchingForTriggerView;

- (IBAction)toggleSliderVisiblity:(UIButton *)sender;
- (IBAction)updateNumTriggerAverages:(UISlider *)sender;

//for AudioSignalManagerDelegate
@property BOOL didAutoSetFrame;
- (void)shouldAutoSetFrame;

@end

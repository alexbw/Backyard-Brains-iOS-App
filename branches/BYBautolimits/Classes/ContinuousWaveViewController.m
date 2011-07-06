//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import "ContinuousWaveViewController.h"

@implementation ContinuousWaveViewController

@synthesize recordButton;
@synthesize stopButton;
@synthesize fileButton;
@synthesize audioRecorder;
@synthesize stimButton;

@synthesize cwView;

@synthesize larvaJoltController;

//for AudioSignalManagerDelegate
@synthesize didAutoSetFrame;

- (void)dealloc {	
    [super dealloc];
	
	[recordButton release];
	[stopButton release];
	[fileButton release];
    [stimButton release];
    if (self.larvaJoltController) {
        [self.larvaJoltController release];
    }

}


# pragma mark - IBActions

- (IBAction)startRecording:(UIButton *)sender {
	CGRect stopButtonRect = CGRectMake(stopButton.frame.origin.x, 0.0f, stopButton.frame.size.width, stopButton.frame.size.height);

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[stopButton setFrame:stopButtonRect];	
	[UIView commitAnimations];
	
	self.audioRecorder = [[AudioRecorder alloc] initWithAudioSignalManager:self.audioSignalManager];
	[audioRecorder startRecording];
	
}

- (IBAction)stopRecording:(UIButton *)sender {
	float offset = stopButton.frame.size.height;
	CGRect stopButtonRect = CGRectMake(stopButton.frame.origin.x, -offset, stopButton.frame.size.width, stopButton.frame.size.height);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[stopButton setFrame:stopButtonRect];
	[UIView commitAnimations];
	
	[audioRecorder stopRecording];
	[audioRecorder release];
	
}


- (void)pissMyPants {
	NSLog(@"I've pissed my pants");
	
}


# pragma mark - View Controller Events

- (void)viewDidLoad {
	[super viewDidLoad];

	self.cwView = (ContinuousWaveView *)[self view];
    
    //grab preferences
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"ContinuousWaveView.plist"];
	self.preferences = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	[self dispersePreferences];		
    
	//initialize BOOL
    self.didAutoSetFrame = NO;
}

- (void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
	
    
    // Grab the stim button setting from the NSUserDefaults THINGYYY
    BOOL enablestim = [[NSUserDefaults standardUserDefaults] boolForKey:@"enablestim"];
    //NSLog(@"==== ENABLE STIM set to: %u", enablestim);
    if (enablestim)
        self.stimButton.hidden = NO;
    else
        self.stimButton.hidden = YES;
    
	
	[self.audioSignalManager changeCallbackTo:kAudioCallbackContinuous];
	
	self.cwView.audioSignalManager = self.audioSignalManager;
    self.audioSignalManager.delegate = self;
	[self.cwView.audioSignalManager setVertexBufferXRangeFrom:self.cwView.xMin to:self.cwView.xMax];
	self.cwView.audioSignalManager.triggering = NO;
	[self.cwView.audioSignalManager play];
	
	[self updateDataLabels];
	
	self.cwView.gridVertexBuffer = (struct wave_s *)malloc(2*(self.cwView.numHorizontalGridLines+self.cwView.numVerticalGridLines)*sizeof(struct wave_s));

	self.cwView.minorGridVertexBuffer = (struct wave_s *)malloc(2*4*(self.cwView.numHorizontalGridLines+self.cwView.numVerticalGridLines)*sizeof(struct wave_s));
	[self.cwView updateMinorGridLines];
	
	[self.cwView startAnimation];
    
}


- (void)viewWillDisappear:(BOOL)animated {
	[self collectPreferences];
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"ContinuousWaveView.plist"];
	[preferences writeToFile:finalPath atomically:YES];
	[self.cwView stopAnimation];
	[self.audioSignalManager pause];
	
	if (audioRecorder != nil) {
		if (audioRecorder.isRecording == YES) {
			[self stopRecording:stopButton];
			

		}
	}
}



# pragma mark - Preference Handling

- (void)dispersePreferences {
	
	// Set the line color
	linecolor_s tmpLineColor;
	NSDictionary *tmpLineColorDict = [NSDictionary dictionaryWithDictionary:[preferences valueForKey:@"lineColor"]];
	tmpLineColor.R = (GLfloat)[[tmpLineColorDict valueForKey:@"R"] floatValue];
	tmpLineColor.G = (GLfloat)[[tmpLineColorDict valueForKey:@"G"] floatValue];
	tmpLineColor.B = (GLfloat)[[tmpLineColorDict valueForKey:@"B"] floatValue];
	tmpLineColor.A = (GLfloat)[[tmpLineColorDict valueForKey:@"A"] floatValue];
	self.cwView.lineColor = tmpLineColor;
	
	// Set the grid color
	linecolor_s tmpGridColor;
	tmpLineColorDict = [preferences valueForKey:@"gridColor"];
	tmpGridColor.R = (GLfloat)[[tmpLineColorDict valueForKey:@"R"] floatValue];
	tmpGridColor.G = (GLfloat)[[tmpLineColorDict valueForKey:@"G"] floatValue];
	tmpGridColor.B = (GLfloat)[[tmpLineColorDict valueForKey:@"B"] floatValue];
	tmpGridColor.A = (GLfloat)[[tmpLineColorDict valueForKey:@"A"] floatValue];
	self.cwView.gridColor = tmpGridColor;
	
	// Set the limits on what we're drawing
	self.cwView.xMin = -1000*kNumPointsInVertexBuffer/self.audioSignalManager.samplingRate;	
	self.cwView.xMax = [[preferences valueForKey:@"xMax"] floatValue];
	self.cwView.xBegin = [[preferences valueForKey:@"xBegin"] floatValue];
	self.cwView.xEnd = [[preferences valueForKey:@"xEnd"] floatValue];
		
	self.cwView.yMin = [[preferences valueForKey:@"yMin"] floatValue];    //-5 000 000
	self.cwView.yMax = [[preferences valueForKey:@"yMax"] floatValue];    // 5 000 000
	self.cwView.yBegin = [[preferences valueForKey:@"yBegin"] floatValue];//-5 000
	self.cwView.yEnd = [[preferences valueForKey:@"yEnd"] floatValue];    // 5 000
	
	self.cwView.numHorizontalGridLines = [[preferences valueForKey:@"numHorizontalGridLines"] intValue];
	self.cwView.numVerticalGridLines = [[preferences valueForKey:@"numVerticalGridLines"] intValue];
	
	self.cwView.showGrid = [[preferences valueForKey:@"showGrid"] boolValue];
	
}

- (void)collectPreferences {
	
	
	NSMutableDictionary *preferencesToWrite = [NSMutableDictionary dictionaryWithDictionary:self.preferences];
	
	linecolor_s lineColor = self.cwView.lineColor;
	NSMutableDictionary *tmpLineColorDict = [NSMutableDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"lineColor"]];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.R] forKey:@"R"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.G] forKey:@"G"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.B] forKey:@"B"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.A] forKey:@"A"];
	[preferencesToWrite setValue:tmpLineColorDict forKey:@"lineColor"];
	
	linecolor_s tmpGridColor = self.cwView.gridColor;
	NSMutableDictionary *tmpGridColorDict = [NSMutableDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"gridColor"]];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.R] forKey:@"R"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.G] forKey:@"G"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.B] forKey:@"B"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.A] forKey:@"A"];
	[preferencesToWrite setValue:tmpGridColorDict forKey:@"gridColor"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.xMax] forKey:@"xMax"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.xMin] forKey:@"xMin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.xBegin] forKey:@"xBegin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.xEnd] forKey:@"xEnd"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.yMax] forKey:@"YMax"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.yMin] forKey:@"yMin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.yBegin] forKey:@"yBegin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.yEnd] forKey:@"yEnd"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.numHorizontalGridLines] forKey:@"numHorizontalGridLines"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.cwView.numVerticalGridLines] forKey:@"numVerticalGridLines"];
	
	[preferencesToWrite setValue:[NSNumber numberWithBool:self.cwView.showGrid] forKey:@"showGrid"];
	
	self.preferences = [NSDictionary dictionaryWithDictionary:preferencesToWrite];
	
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;	
}



- (void)updateDataLabels {
	
	NSLog(@"yLabel x: %f, y: %f", yUnitsPerDivLabel.frame.origin.x, yUnitsPerDivLabel.frame.origin.y);
	// Spin through all the UILabels that we have control of, and make 'em better.

	float xPerDiv = (self.cwView.xEnd - self.cwView.xBegin)/3.0f;
	float yPerDiv = (self.cwView.yEnd - self.cwView.yBegin)/(4.0f*self.audioSignalManager.gain*kVoltScaleFactor);

	
	xUnitsPerDivLabel.text = [NSString stringWithFormat:@"%3.1f ms", xPerDiv];
	yUnitsPerDivLabel.text = [NSString stringWithFormat:@"%3.2f mV", yPerDiv];
	
}

#pragma mark - AudioSignalManagerDelegate

- (void)shouldAutoSetFrame
{
     
    //get a frame
    ringBuffer *secondStageBuffer = self.audioSignalManager.secondStageBuffer;
    
    float theMax = 0, theMin = 0;
    
    //find limits
    for (int i=0; i<secondStageBuffer->sizeOfBuffer; i++) {
        
        if (secondStageBuffer->data[i] > theMax)
            theMax = secondStageBuffer->data[i];
        else if (secondStageBuffer->data[i] < theMin)
            theMin = secondStageBuffer->data[i];
        
    }
    
    //Check for zero values
    if (theMax && theMin)
    {
        float newyMax;
        //set the window to 120% of the largest value
        if (fabs(theMax) >= fabs(theMin))
            newyMax = fabs(theMax) * 1.2f;
        else
            newyMax = fabs(theMin) * 1.2f;
    
        if ( -newyMax > self.cwView.yMin & -newyMax < 200) {
            self.cwView.yBegin = -newyMax;
            self.cwView.yEnd   = newyMax;
        }
        
        [self updateDataLabels];

    }
}

#pragma mark - Multitouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event];
	
	float viewWidth  = self.cwView.bounds.size.width;
	float viewHeight = self.cwView.bounds.size.height;
		
	self.pinchChangeInX /= viewWidth;
	self.pinchChangeInY /= viewHeight;
	self.pinchChangeInX *= 2.2f;
	self.pinchChangeInY *= 2.2f;
	
	
	float newxBegin = self.cwView.xBegin - self.cwView.xBegin*self.pinchChangeInX;
	float newyBegin = self.cwView.yBegin - self.cwView.yBegin*self.pinchChangeInY;
	

	
	if ( newyBegin > self.cwView.yMin & newyBegin < 200) {
		self.cwView.yBegin = newyBegin;
		self.cwView.yEnd = -newyBegin;
	}
	
	// Make sure we can't scale the x-axis past the number of collected samples,
	// and also not less than 10 milliseconds
	if ( newxBegin > self.cwView.xMin & newxBegin <= -10) {
		self.cwView.xBegin = newxBegin;
	}
	
	[self updateDataLabels];

	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event];
	[self.cwView updateMinorGridLines];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event];
}

- (void)showAllLabels {
	[xUnitsPerDivLabel setAlpha:1.0];
	[yUnitsPerDivLabel setAlpha:1.0];
	cwView.showGrid = YES;
}

- (void)hideAllLabels {
	[xUnitsPerDivLabel setAlpha:0.0];
	[yUnitsPerDivLabel setAlpha:0.0];
	cwView.showGrid = NO;
}

- (void)toggleVisibilityOfLabelsAndGrid {
	if (cwView.showGrid == YES) {
		[self hideAllLabels];
	}
	
	else {
		[self showAllLabels];
	}
}


@end

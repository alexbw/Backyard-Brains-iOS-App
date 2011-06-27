//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 11/15/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import "TriggerView.h"


@implementation TriggerView

@synthesize thresholdLine;
@synthesize middleOfWave;

// You must implement this method

- (void)dealloc {
    [super dealloc];
}


- (id)initWithCoder:(NSCoder*)coder {
    
	NSLog(@"init'd with coder");
	
	self = [super initWithCoder:coder];
	[self layoutSubviews];
	return self;
}

- (void)drawView {
	
	[self prepareOpenGLView];
	
	[self.audioSignalManager fillVertexBufferWithAverageTriggeredSegments];	// Grab the audio data
	
	if (self.showGrid)
		[self drawGridLines];
	
	[self drawThresholdLine];
	
	[self drawWave]; // Push those pixels, alright
	
	[self drawEverythingToScreen]; // now push it all to the screen
 	
}


- (void)drawWave {
	
		
	// Feed the data into the OpenGL context
    glVertexPointer(2, GL_FLOAT, 0, [self.audioSignalManager vertexBuffer]);
	
	// Set the line width to whatever we've chosen in waveLineWidth
	glLineWidth(self.waveLineWidth);
	
	// Let's color the line
	glColor4f(self.lineColor.R, self.lineColor.G, self.lineColor.B, self.lineColor.A);	
//	UInt32 startIdx = (UInt32)( kNumPointsInVertexBuffer*(xBegin-xMin)/(xMax-xMin) );
	UInt32 endIdx = (UInt32)( kNumPointsInVertexBuffer*(xEnd-xMin)/(xMax-xMin) );
		
	glDrawArrays(GL_LINE_STRIP, 0, kNumPointsInVertexBuffer); //self.audioSignalManager.lastFreshSample-startIdx
	
	if ( audioSignalManager.lastFreshSample > endIdx ) {
		audioSignalManager.triggered = NO;
	}
}

- (void)drawThresholdLine {
	
	// Draw solid horizontal line at thresholdValue
	thresholdLine[0].x = self.xBegin;
	thresholdLine[1].x = self.xEnd;
	thresholdLine[0].y = [audioSignalManager thresholdValue];
	thresholdLine[1].y = [audioSignalManager thresholdValue];
	
	// draw dashed vertical line at -0.5 (threshold crossing location)
//	for (int i=2; i < kNumDashesInVerticalTriggerLine+2; ++i) {
//		thresholdLine[i].x = self.middleOfWave;
//		thresholdLine[i].y = yBegin + (i-2)*(yEnd - yBegin)/(float)kNumDashesInVerticalTriggerLine;
//	}
	
	glColor4f(1.0, 0.0, 0.0, 1.0);
	glLineWidth(1.0);
	glVertexPointer(2, GL_FLOAT, 0, thresholdLine);
	glDrawArrays(GL_LINES, 0, 2+kNumDashesInVerticalTriggerLine);

}




@end

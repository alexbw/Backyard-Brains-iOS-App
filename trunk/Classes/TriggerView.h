//
//  oScope
//
//  Created by Alex Wiltschko on 11/15/09.
//  Modified by Zachary King
//      6/6/2011 Added delegate and methods to automatically set the viewing frame.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import "AudioSignalManager.h"

#define kNumDashesInVerticalTriggerLine 0

@interface TriggerView : EAGLView {
	struct wave_s *thresholdLine;
	float middleOfWave;

}

@property struct wave_s *thresholdLine;
@property float middleOfWave;

- (void)drawWave;
- (void)drawThresholdLine;
- (id)initWithCoder:(NSCoder *)coder;


@end

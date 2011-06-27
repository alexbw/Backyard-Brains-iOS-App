//
//  oScope
//
//  Created by Alex Wiltschko on 11/15/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import "AudioSignalManager.h"

#define kNumDashesInVerticalTriggerLine 50

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

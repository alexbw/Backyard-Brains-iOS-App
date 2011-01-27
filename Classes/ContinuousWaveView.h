//
//  ContinuousWaveView.h
//  oScope
//
//  Created by Alex Wiltschko on 11/15/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import "AudioSignalManager.h"

@interface ContinuousWaveView : EAGLView {

}

- (void)drawWave;
- (id)initWithCoder:(NSCoder *)coder;
- (void)updateMinorGridLines;

@end

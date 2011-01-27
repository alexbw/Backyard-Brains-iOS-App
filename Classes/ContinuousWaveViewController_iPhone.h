//
//  ContinuousWaveView_iPhone.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Copyright 2009 University of Michigan. All rights reserved.
//

#import "ContinuousWaveViewController.h"
#import "BBFileViewController.h"
#import "FlipsideInfoViewController.h"

@interface ContinuousWaveViewController_iPhone : ContinuousWaveViewController <UINavigationControllerDelegate, FlipsideInfoViewDelegate> {
	
	
}

- (IBAction)displayInfoFlipside:(UIButton *)sender;
- (IBAction)showFiles:(UIButton *)sender;
- (void)hideFiles;
- (void)flipsideIsDone;

@end

//
//  ContinuousWaveView_iPhone.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King on 6/27/2011.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "ContinuousWaveViewController.h"
#import "BBFileViewController.h"
#import "FlipsideInfoViewController.h"
#import "LarvaJoltViewController.h"

@interface ContinuousWaveViewController_iPhone : ContinuousWaveViewController <UINavigationControllerDelegate, FlipsideInfoViewDelegate, LarvaJoltViewDelegate, BBFileViewControllerDelegate> {
	
}

- (IBAction)displayInfoFlipside:(UIButton *)sender;
- (IBAction)showFiles:(UIButton *)sender;
- (void)flipsideIsDone;
- (IBAction)showLarvaJolt:(UIButton *)sender;

//for BBFileViewControllerDelegate
- (void)hideFiles;

@end

//
//  PlaybackViewController_iPad.m
//  Backyard Brains
//
//  Created by Zachary King on 8/26/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import "PlaybackViewController_iPad.h"

@implementation PlaybackViewController_iPad

@synthesize navItem = _navItem;

- (void)dealloc
{
    [_navItem release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
    
    self.navItem.title = self.file.subname;
    
}


- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end

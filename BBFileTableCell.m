//
//  BBFileTableCell.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/9/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileTableCell.h"


@implementation BBFileTableCell

@synthesize shortname;
@synthesize subname;
@synthesize lengthname;
@synthesize actionButton;
@synthesize isSelected;
@synthesize index;

@synthesize delegate;

-(IBAction)actionButtonSelected
{
    [self.delegate cellActionTriggeredFrom:self.index];
}

-(void)dealloc
{
    [index release];

    [super dealloc];
}

@end

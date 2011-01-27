//
//  BBFileTitleEditorViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/10/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileTitleEditorViewController.h"


@implementation BBFileTitleEditorViewController

@synthesize titleTextField;
@synthesize delegate;


- (void)dealloc {
	[titleTextField release];
	
	[super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
	Class cls = NSClassFromString(@"UIPopoverController");
	if (cls != nil)
	{
		CGSize size = {320, 480}; // size of view in popover, if we're on the iPad
		self.contentSizeForViewInPopover = size;
	}

	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.titleTextField setText:[[self.delegate file] shortname]];
	[self.titleTextField becomeFirstResponder];
	
	self.navigationItem.title = @"Filename";
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	BBFile *file = [delegate file];
	file.shortname = titleTextField.text;
	[file save];
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




@end

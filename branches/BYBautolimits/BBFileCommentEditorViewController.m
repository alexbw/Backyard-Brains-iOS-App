//
//  BBFileCommentEditorViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/10/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileCommentEditorViewController.h"


@implementation BBFileCommentEditorViewController

@synthesize delegate;
@synthesize commentTextView;

- (void)dealloc {
	[commentTextView release];
	
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


- (void)viewDidLoad {
    [super viewDidLoad];
	[self.commentTextView setText:[[self.delegate file] comment]];
	
	self.navigationItem.title = @"Comment";
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.commentTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	BBFile *file = [delegate file];
	file.comment = commentTextView.text;
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

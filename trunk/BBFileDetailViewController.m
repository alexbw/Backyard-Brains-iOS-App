//
//  BBFileDetailViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/9/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileDetailViewController.h"


@implementation BBFileDetailViewController

@synthesize delegate;

@synthesize titleButton;
@synthesize durationLabel;
@synthesize recordedInfoLabel;
@synthesize samplingRateLabel;
@synthesize gainLabel;
@synthesize commentButton;
@synthesize file;

- (void)dealloc {
	[titleButton release];
	[durationLabel release];
	[recordedInfoLabel release];
	[samplingRateLabel release];
	[gainLabel release];
	[commentButton release];
	[file release];
	
	[super dealloc];

}


- (void)viewWillAppear:(BOOL)animated {

	
	Class cls = NSClassFromString(@"UIPopoverController");
	if (cls != nil)
	{
		CGSize size = {320, 480}; // size of view in popover, if we're on the iPad
		self.contentSizeForViewInPopover = size;
	}

    [super viewWillAppear:animated];
	self.navigationItem.title = @"Info";
	
	BBFile *thisFile = delegate.file;
	
	// Load up the views!
	[self setButton:titleButton titleForAllStates:thisFile.shortname];
	durationLabel.text = [self stringWithFileLengthFromBBFile:thisFile];
	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"'Recorded on' EEEE',' MMM d',' YYYY 'at' h':'mm a"];
	recordedInfoLabel.text = [inputFormatter stringFromDate:thisFile.date];
	
	samplingRateLabel.text = [NSString stringWithFormat:@"%0.0f Hz", thisFile.samplingrate];
	gainLabel.text = [NSString stringWithFormat:@"%0.0f x", thisFile.gain];
	
	NSString *commentText = @"You haven't made a comment on this file yet! Tap to enter a comment for your file.";


	NSString *fileComment = delegate.file.comment;
	
	//[fileComment retain];
	if (fileComment != nil) {
		if (![fileComment isEqualToString:@""]) {
			commentText = fileComment;
		}
	}
	[self setButton:commentButton titleForAllStates:commentText];
	
    [inputFormatter release];
	//[fileComment release];
	
	
}

- (NSString *)stringWithFileLengthFromBBFile:(BBFile *)thisFile {
	int minutes = (int)floor(thisFile.filelength / 60.0);
	int seconds = (int)(thisFile.filelength - minutes*60.0);
	
	if (minutes > 0) {
		return [NSString stringWithFormat:@"%dm %ds", minutes, seconds];
	}
	else {
		return [NSString stringWithFormat:@"%ds", seconds];		
	}

	
}

- (IBAction)pushTitleEditorView:(UIButton *)sender {
	BBFileTitleEditorViewController *titleViewController = [[BBFileTitleEditorViewController alloc] initWithNibName:@"BBFileTitleEditorView" bundle:nil];
	self.file = [delegate file];
	titleViewController.delegate = self;
	
	[[self navigationController] pushViewController:titleViewController animated:YES];
	
	[titleViewController release];
}

- (IBAction)pushCommentEditorView:(UIButton *)sender {
	BBFileCommentEditorViewController *commentViewController = [[BBFileCommentEditorViewController alloc] initWithNibName:@"BBFileCommentEditorView" bundle:nil];
	self.file = delegate.file;
	commentViewController.delegate = self;
	
	[[self navigationController] pushViewController:commentViewController animated:YES];
	
	[commentViewController release];
}

-(void)setButton:(UIButton *)button titleForAllStates:(NSString *)aTitle
{
	[button setTitle:aTitle forState:UIControlStateNormal];
	[button setTitle:aTitle forState:UIControlStateHighlighted];
	[button setTitle:aTitle forState:UIControlStateDisabled];
	[button setTitle:aTitle forState:UIControlStateSelected];
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

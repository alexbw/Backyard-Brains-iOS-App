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
@synthesize files;
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
    
    
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                        style: UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(done)] autorelease];
        self.navigationItem.leftBarButtonItem.title = @"Cancel";
    
	self.files = delegate.files;
	
	if ([self.files count] == 1)
	{
		BBFile *file = [self.files objectAtIndex:1];
		[self.titleTextField setText:[file shortname]];
        [file release];
	}
	else
	{
		[self.titleTextField setText:[NSString stringWithFormat:@"Name and number (%i) Files", [files count]]];
	}
	
	[self.titleTextField becomeFirstResponder];
	
	self.navigationItem.title = @"Filename";
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (IBAction)done:(UIBarButtonItem *)sender
{

	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
   
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // For error information
    NSError *error;
 
	for (int i = 1; i <= [self.files count]; ++i)
	{
		NSString *newName = self.titleTextField.text;
		if (i > 1)
			newName = [newName stringByAppendingFormat:@"%u", i];
		
		//rename file
    	BBFile *file = [self.files objectAtIndex:i];
    	NSString *oldFilePath = [docPath stringByAppendingPathComponent:file.filename];
    
    	//Create a new path
    	NSString *newFilePath = [docPath stringByAppendingPathComponent:newName];
    
	    // Attempt the move
		if ([fileMgr moveItemAtPath:oldFilePath toPath:newFilePath error:&error] == YES)
		{
      		//change title and filename in BBFile
        	file.shortname = newName;
        	file.filename = newName;
        	NSLog(@"New file path: %@", newFilePath);
    	}
    	else
    	{
        	NSLog(@"Unable to move file: %@", [error localizedDescription]);
        	//Create UIAlertView alert
        	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"File already exists with this name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        	[alert show];
			break;
    	}
    
    	[file save];
	}
	
	//tk pop view controller
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

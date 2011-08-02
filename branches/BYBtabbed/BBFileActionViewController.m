//
//  BBFileActionViewController.m
//  Backyard Brains
//
//  Created by Zachary King on 7/13/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import "BBFileActionViewController.h"


@implementation BBFileActionViewController


@synthesize theTableView;
@synthesize files;

@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.theTableView.dataSource = self;
		self.theTableView.delegate = self;
		self.theTableView.sectionIndexMinimumDisplayRowCount=10;
		self.theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		
		self.navigationItem.title = @"Actions";
		
		NSMutableArray *actionOptions = [NSMutableArray arrayWithObjects:
										@"Play",
										@"Analyze",
										@"Details",
										@"Delete",
										@"Email",
										@"Download", nil];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableViewDelegate methods

//UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(BBFileTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [allFiles count];
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 
	 NSLog(@"=== Cell selected! === ");
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([cell.textLabel.text isEqualToString:@"Play"])
	{
		PlaybackViewController *pvc = [[PlaybackViewController alloc] initWithNibName:@"PlaybackView" bundle:nil];
		[[self navigationController] pushViewController:pvc animated:YES];
		[pvc release];	
	}
	else if ([cell.textLabel.text isEqualToString:@"Details"])
	{
		BBFileDetailViewController *dvc = [[BBFileDetailViewController alloc] initWithNibName:@"BBFileDetailView" bundle:nil];
		dvc.delegate = self;	
		[[self navigationController] pushViewController:dvc animated:YES];
		[dvc release];	
	}
	else if ([cell.textLabel.text isEqualToString:@"Email"])
	{
		//grab from old v.
	}
	else if ([cell.textLabel.text isEqualToString:@"Download"])
	{
		//grab from old v.
	}
	else if ([cell.textLabel.text isEqualToString:@"Analyze"])
	{
		//SpikeSortViewController *ssvc = [[SpikeSortViewController alloc] initWithNibName:@"SpikeSortView" bundle:nil];
		//ssvc.delegate = self;
		//[[self navigationController] pushViewController:ssvc animated:YES];
		//[ssvc release];
	}
	else if ([cell.textLabel.text isEqualToString:@"Delete"])
	{
		//grab from old v.
	}	

}

@end

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
@synthesize actionOptions;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.theTableView.dataSource = self;
		self.theTableView.delegate = self;
		self.theTableView.sectionIndexMinimumDisplayRowCount=10;
		self.theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.files = self.delegate.files;
    
    
    if ([self.files count] == 1) //single file
    {
        self.navigationItem.title = [[self.files objectAtIndex:0] shortname];
        
        self.actionOptions = [NSArray arrayWithObjects:
                              @"View Details",
                              @"Play",
                              @"Analyze",
                              @"Email",
                              @"Download",
                              @"Delete", nil];
    }
    else //multiple files
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%u Files", [self.files count]];
        
        self.actionOptions = [NSArray arrayWithObjects:
                              @"View details",
                              @"Email",
                              @"Download",
                              @"Delete", nil];
    }
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
    return [self.actionOptions count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // See if there's an existing cell we can reuse
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell"];
    if (cell == nil) {
        // No cell to reuse => create a new one
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"] autorelease];
        
        // Initialize cell
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // TODO: Any other initialization that applies to all cells of this type.
        //       (Possibly create and add subviews, assign tags, etc.)
    }
    
    // Customize cell
    cell.textLabel.text = [self.actionOptions objectAtIndex:[indexPath row]];
    
    return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 
	 NSLog(@"=== Cell selected! === ");
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([cell.textLabel.text isEqualToString:@"Play"])
	{
		/*PlaybackViewController *pvc = [[PlaybackViewController alloc] initWithNibName:@"PlaybackView" bundle:nil];
		[[self navigationController] pushViewController:pvc animated:YES];
		[pvc release];*/	
	}
	else if ([cell.textLabel.text isEqualToString:@"View Details"])// || [cell.textLabel.text isEqualToString:@"Edit details"] )
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
        NSString *deleteTitle;
        if ([self.files count] == 1)
            deleteTitle = [NSString stringWithFormat:@"Delete %@?", [[self.files objectAtIndex:0] shortname]];
        else
            deleteTitle = [NSString stringWithFormat:@"Delete %u files?", [self.files count]];
        
        UIActionSheet *mySheet = [[UIActionSheet alloc] initWithTitle:deleteTitle
                                                             delegate:self 
													cancelButtonTitle:@"No, go back."
                                               destructiveButtonTitle:@"Yes, delete!" 
													otherButtonTitles:nil];
        
        mySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [mySheet showInView:self.view];
        [mySheet release];
    }
}

//Delete files action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 0:
			[self.delegate deleteTheFiles:self.files];
            [self.navigationController popViewControllerAnimated:YES];//tk consider reordering
			break;
		default:
			break;
	}
	
}


- (void)play {}

- (void)editFiles {}
- (void)emailFiles {}
- (void)downloadFiles {}
- (void)analyzeFiles {}




@end

//
//  BBFileTableViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Modified by Zachary King
//      7/12/11 Set up everything for new tabbed interface. Removed audio player.
//  Copyright 2010 Backyard Brains. All rights reserved.
//

#import "BBFileViewController.h"


@implementation BBFileViewController

@synthesize theTableView;
@synthesize allFiles;

@synthesize selectedArray;
@synthesize selectedImage, unselectedImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.theTableView.dataSource = self;
		self.theTableView.delegate = self;
		self.theTableView.sectionIndexMinimumDisplayRowCount=10;
		self.theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		
		self.navigationItem.title = @"Your files";
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Select"
                                                        style: UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(togglePseudoEditMode)] autorelease];
        
        self.selectedImage =    [UIImage imageNamed:@"selected.png"];
        self.unselectedImage =  [UIImage imageNamed:@"unselected.png"];
		
    }
    return self;
	
}

- (void)viewWillAppear:(BOOL)animated 
{	
	[super viewWillAppear:animated];

	self.allFiles = [NSMutableArray arrayWithArray:[BBFile allObjects]];
    self.inPseudoEditMode = NO;
	
	[theTableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
    [theTableView release];
	[allFiles release];
	[selectedArray release];
	[selectedImage release];
	[unselectedImage release];
}



#pragma mark Table view methods


//UITableViewDelegate
 - (void)tableView:(UITableView *)tableView willDisplayCell:(BBFileTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (inPseudoEditMode)
    {
        [cell.actionButton setImage:self.unselectedImage forState:UIControlStateNormal];
        //cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        // Here, initiate animation to hide selection images
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.delegate = self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [allFiles count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static int numcellsmade = 0;
	numcellsmade += 1;
	
    static NSString *CellIdentifier = @"BBFileTableCell";    
    BBFileTableCell *cell = (BBFileTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BBFileTableCell" owner:nil options:nil];
		
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[BBFileTableCell class]])
			{
				cell = (BBFileTableCell *)currentObject;
				break;
			}
		}
		
    }
	
	BBFile *thisFile = [allFiles objectAtIndex:indexPath.row];

	if (thisFile.filelength > 0) {
		cell.lengthname.text = [self stringWithFileLengthFromBBFile:thisFile];
	}
	else {
		cell.lengthname.text = @"";
	}

	cell.shortname.text = thisFile.shortname; //[[allFiles objectAtIndex:indexPath.row] shortname];
	cell.subname.text = thisFile.subname; //[[allFiles objectAtIndex:indexPath.row] subname];
    return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 
	 NSLog(@"=== Cell selected! === ");
     
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
     
     [self cellActionTriggeredFrom:(BBFileTableCell *)[tableView cellForRowAtIndexPath:indexPath]];
	 	 
 }



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	// Note the BBFile for the particular row that's selected.
	[selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
	
	// Create the action view controller, load it with the delegate, and push it up onto the stack.
	BBFileActionViewController *actionViewController = [[BBFileActionViewController alloc] initWithNibName:@"BBFileActionView" bundle:nil];
	actionViewController.delegate = self;
	[[self navigationController] pushViewController:actionViewController animated:YES];
    [actionViewController release];
}




#pragma mark - Select multiple functions


- (IBAction)togglePseudoEditMode
{
    self.inPseudoEditMode = !inPseudoEditMode;	
	[self.theTableView reloadData];
}


//Setter for inPseudoEditMode property
- (void)setInPseudoEditMode:(BOOL)setting
{
    inPseudoEditMode = setting;
    
    if (inPseudoEditMode)
    {
        [self populateSelectedArray];
        self.navigationItem.leftBarButtonItem.title = @"Select";
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
    }
    else
    {
        self.navigationItem.leftBarButtonItem.title = @"Select";
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    }
}

//Getter for inPseudoEditMode property
- (BOOL)inPseudoEditMode
{
    return inPseudoEditMode;
}



- (void)populateSelectedArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[allFiles count]];
	for (int i=0; i < [allFiles count]; i++)
		[array addObject:[NSNumber numberWithBool:NO]];
	self.selectedArray = array;
	[array release];
}



- (void)cellActionTriggeredFrom:(BBFileTableCell *) cell
{
    
    //Check for pseudo edit mode
    if (inPseudoEditMode)
    {
        NSUInteger theRow = [[theTableView indexPathForCell:cell] row];
        NSLog(@"Cell at row %u", theRow);
        
        BOOL selected = ![[selectedArray objectAtIndex:theRow] boolValue];
        [selectedArray replaceObjectAtIndex:theRow withObject:[NSNumber numberWithBool:selected]];
         
        NSLog(@"Cell is selected: %i", selected);
        
        if (selected)
        {
            [cell.actionButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            
            NSLog(@"Swapped image for selectedImage ");
        } else {
            [cell.actionButton setImage:self.unselectedImage forState:UIControlStateNormal];
        }
    }
    
}





#pragma mark - Helper functions

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


#pragma mark - BBFileActionViewControllerDelegate
- (NSArray *)returnSelectedFiles
{
    NSMutableArray *returnArray;
    for (int i=0; i < [allFiles count]; i++)
    {
        if ([selectedArray objectAtIndex:i])
            [returnArray addObject:[allFiles objectAtIndex:i]];
    }
    return returnArray;
}



@end




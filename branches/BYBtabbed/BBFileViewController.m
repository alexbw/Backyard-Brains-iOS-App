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

@synthesize inPseudoEditMode;

@synthesize files;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		//self.theTableView.dataSource = self;
		//self.theTableView.delegate = self;
		//self.theTableView.sectionIndexMinimumDisplayRowCount=10; //tk
		//self.theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; //tk
		
		//self.navigationItem.title = @"Your files";
        
        //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Select"
        //                                                style: UIBarButtonItemStylePlain
        //                                                target:self
        //                                                action:@selector(togglePseudoEditMode)] autorelease];

        
		
    }
    return self;
	
}

- (void)viewWillAppear:(BOOL)animated 
{	
	[super viewWillAppear:animated];
    
    self.selectedImage =    [UIImage imageNamed:@"selected.png"];
    self.unselectedImage =  [UIImage imageNamed:@"unselected.png"];
    
    self.navigationItem.leftBarButtonItem.action = @selector(togglePseudoEditMode);
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;

	self.allFiles = [NSMutableArray arrayWithArray:[BBFile allObjects]];
    self.inPseudoEditMode = NO;
    
    [self populateSelectedArray];
	
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
    if ([indexPath indexAtPosition:0] == 0) //section # is 0
    {
        cell.delegate = self;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) //tk or is it 1?
	{
		return [allFiles count];
	} else if (section == 1) {
        
        if ([self.selectedArray containsObject:[NSNumber numberWithBool:YES]])
            return 1; //for multiple edit
        else
            return 0;
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


	if (indexPath.section == 0)
	{
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
		} else {
			cell.lengthname.text = @"";
		}
		
		cell.shortname.text = thisFile.shortname; //[[allFiles objectAtIndex:indexPath.row] shortname];
		cell.subname.text = thisFile.subname; //[[allFiles objectAtIndex:indexPath.row] subname];
        
        if (self.inPseudoEditMode)
        {
            CGRect labelRect =  CGRectMake(36, 11, 216, 21);
            CGRect subRect =    CGRectMake(36, 29, 216, 15);
            
            
            cell.actionButton.hidden = NO;
            if ([[self.selectedArray objectAtIndex:[indexPath row]] boolValue])
                [cell.actionButton setImage:self.selectedImage forState:normal];
            else
                [cell.actionButton setImage:self.unselectedImage forState:normal];
                 
            [cell.shortname setFrame:labelRect];
            [cell.subname setFrame:subRect];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
	}
	else if (indexPath.section == 1)
	{
		static NSString *CellIdentifier = @"editMultipleCell";    
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editMultipleCell"] autorelease];

            cell.textLabel.text = @"Edit multiple files";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
	}
	
    return NULL;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 
	 NSLog(@"=== Cell selected! === ");
     
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
     
     [self cellActionTriggeredFrom:(BBFileTableCell *)[tableView cellForRowAtIndexPath:indexPath]];
	 	 
 }



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	if ([indexPath indexAtPosition:0] == 0)
    {
		// Note the BBFile for the particular row that's selected.
        [self populateSelectedArrayWithSelectionAt:indexPath.row];
        [self pushActionView];
    }
}

- (void)pushActionView
{
    // Create the action view controller, load it with the delegate, and push it up onto the stack.
    NSMutableArray *theFiles = [[NSMutableArray alloc] initWithObjects:nil];
    
    for (int i = 0; i < [self.selectedArray count]; i++)
    {
        if ([[self.selectedArray objectAtIndex:i] boolValue])
        {
            BBFile *file = [self.allFiles objectAtIndex:i];
            [theFiles addObject:file];
        }
    }
    self.files = (NSArray *)theFiles;
    [theFiles release];
    
    BBFileActionViewController *actionViewController = [[BBFileActionViewController alloc] initWithNibName:@"BBFileActionView" bundle:nil];
    actionViewController.delegate = self;
    
    [self.navigationController pushViewController:actionViewController animated:YES];
    [actionViewController release];
}



#pragma mark - Select multiple functions


- (IBAction)togglePseudoEditMode
{
    //toggle the mode
    self.inPseudoEditMode = !inPseudoEditMode;

    //reset the selected array
    [self populateSelectedArray];
    
    //set up animations
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    //set new frames
    if(inPseudoEditMode) {
                
        self.navigationItem.leftBarButtonItem.title = @"Select";
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
        
        for (NSIndexPath *path in self.theTableView.indexPathsForVisibleRows)
        {
            if ([path indexAtPosition:0] == 0) //section # is 0
            {
                BBFileTableCell *cell = (BBFileTableCell *)[self.theTableView cellForRowAtIndexPath:path];

                
                CGRect labelRect =  CGRectMake(36, 11, 216, 21);
                CGRect subRect =    CGRectMake(36, 29, 216, 15);
                
                
                cell.actionButton.hidden = NO;
                [cell.actionButton setImage:self.unselectedImage forState:normal];
                [cell.shortname setFrame:labelRect];
                [cell.subname setFrame:subRect];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
        }
        
    } else { //not in pseudo edit mode
        
        self.navigationItem.leftBarButtonItem.title = @"Select";
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
        
        for (NSIndexPath *path in self.theTableView.indexPathsForVisibleRows)
        {
            if ([path indexAtPosition:0] == 0) //section # is 0
            {
                BBFileTableCell *cell = (BBFileTableCell *)[self.theTableView cellForRowAtIndexPath:path];
                
                
                CGRect labelRect =  CGRectMake(13, 11, 216, 21);
                CGRect subRect =    CGRectMake(13, 29, 216, 15);
                
                cell.actionButton.hidden = YES;
                [cell.shortname setFrame:labelRect];
                [cell.subname setFrame:subRect];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    
    //do the animation
    [UIView commitAnimations];
    
	[self.theTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}



- (void)populateSelectedArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[allFiles count]];
	for (int i=0; i < [allFiles count]; i++)
		[array addObject:[NSNumber numberWithBool:NO]];
	self.selectedArray = array;
	[array release];
}

- (void)populateSelectedArrayWithSelectionAt:(int)num
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[allFiles count]];
	for (int i=0; i < [allFiles count]; i++)
    if (num == i)
        [array addObject:[NSNumber numberWithBool:YES]];
    else
        [array addObject:[NSNumber numberWithBool:NO]];
	self.selectedArray = array;
	[array release];
}


- (void)cellActionTriggeredFrom:(BBFileTableCell *) cell
{
    NSUInteger theRow = [[theTableView indexPathForCell:cell] row];
    NSLog(@"Cell at row %u", theRow);
    
    if ([[self.theTableView indexPathForCell:cell] section] == 0)
    {
        //Check for pseudo edit mode
        if (inPseudoEditMode)
        {
            
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
            
            [self.theTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            
            [self populateSelectedArrayWithSelectionAt:theRow];
            [self pushActionView];
        }
    } else {
        //Select Multiple Button. selectedArray already set.
        [self pushActionView];
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

#pragma mark - for BBFileActionViewControllerDelegate
- (void)deleteTheFiles:(NSArray *)theseFiles
{
    for (BBFile *file in theseFiles)
    {
        int index = [self.allFiles indexOfObject:file];
        [[self.allFiles objectAtIndex:index] deleteObject];
        [self.allFiles removeObjectAtIndex:index];
        
        [theTableView reloadData];
    }
}

@end




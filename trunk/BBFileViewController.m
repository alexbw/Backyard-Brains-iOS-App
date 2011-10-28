//
//  BBFileTableViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileViewController.h"



#define kSyncWaitTime 10 //seconds

@interface BBFileViewController()

- (void)pushDropboxSettings;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)dbDisconnect;
- (void)dbUpdate;
- (void)dbUpdateTimedOut;
- (void)clearStatus;
- (void)compareBBFilesToNewFilePaths:(NSArray *)newPaths;

@property (nonatomic, retain) NSDictionary *preferences;

@property (nonatomic, retain) DBRestClient *restClient;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSTimer *syncTimer;
@property (nonatomic, retain) NSArray *lastFilePaths;
@property (nonatomic, retain) NSString *docPath;


@end

@implementation BBFileViewController

@synthesize theTableView;
@synthesize toolbar;
@synthesize allFiles;
@synthesize shareFileButton;
@synthesize deleteFileButton;
@synthesize buttonHolderView;
@synthesize selectButton, dropboxButton, doneButton;

@synthesize delegate;

// Properties required by BBFileDownloadViewControllerDelegate
@synthesize fileNamesToShare;

@synthesize timeElapsedLabel;
@synthesize timeLeftLabel;
@synthesize currentPositionInAudioFileSlider;
@synthesize selectedArray;
@synthesize playImage, pauseImage, selectedImage, unselectedImage;
@synthesize playingCell;
@synthesize dbStatusBar;
@synthesize preferences, restClient, status, syncTimer, lastFilePaths, docPath;
@synthesize triedCreatingFolder;

// Protocol properties
@synthesize file;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.theTableView.dataSource = self;
		self.theTableView.delegate = self;
		self.theTableView.sectionIndexMinimumDisplayRowCount=10;
		self.theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		

        
        self.playImage =        [UIImage imageNamed:@"play.png"];
        self.pauseImage =       [UIImage imageNamed:@"pause.png"];
        self.selectedImage =    [UIImage imageNamed:@"selected.png"];
        self.unselectedImage =  [UIImage imageNamed:@"unselected.png"];
		
		// audioPlayer will remain nil as long as nothing is playing
		audioPlayer = nil;
        
        
    }
    return self;
	
}

- (void)viewWillAppear:(BOOL)animated 
{	
    [super viewWillAppear:animated];

	Class cls = NSClassFromString(@"UIPopoverController");
	if (cls != nil)
	{
		CGSize size = {320, 450}; // size of view in popover, if we're on the iPad
		self.contentSizeForViewInPopover = size;
	}
	
	[super viewWillAppear:animated];

	self.allFiles = [NSMutableArray arrayWithArray:[BBFile allObjects]];
	
    
	/*for (BBFile *thisFile in allFiles) {
		[thisFile retain]; 
	}*/
    
    self.inPseudoEditMode = NO;
	
	[theTableView reloadData];
    
    /*make the dropbox button pretty...someone fix this, quick!!!! tk
    //load the image
    UIImage *buttonImage = [UIImage imageNamed:@"dropbox.png"];
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    self.dropboxButton.customView = button;
    self.dropboxButton.style = UIBarButtonItemStyleBordered;*/
    
    //create the status bar
    self.dbStatusBar = [[UIButton alloc] initWithFrame:CGRectMake(self.theTableView.frame.origin.x, self.toolbar.frame.size.height, self.theTableView.frame.size.width, 0)];
    [self.dbStatusBar setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5]];
    [self.dbStatusBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    //[self.dbStatusBar setTitle:@"bar" forState:UIControlStateNormal];
    [self.view addSubview:self.dbStatusBar];
    
    //grab the doc path
    self.docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	//Upload files when viewWillAppear
    //if ([[self.preferences valueForKey:@"isDBLinked"] boolValue])
    //    [self dbUpdate];
    
    self.triedCreatingFolder = NO;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
	[self stopPlaying];
    

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //grab preferences
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [pathStr stringByAppendingPathComponent:@"BBFileViewController.plist"];
    self.preferences = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    NSLog(@"a");
}

- (void)viewDidUnload {
    [super viewDidUnload];
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
    
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"BBFileViewController.plist"];
	[preferences writeToFile:finalPath atomically:YES];
}





- (IBAction)done;
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self.delegate hideFiles];
    else
        [self dismissModalViewControllerAnimated:YES];
}





#pragma mark Table view methods


//UITableViewDelegate
 - (void)tableView:(UITableView *)tableView willDisplayCell:(BBFileTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (inPseudoEditMode)
    {
        if ([[self.selectedArray objectAtIndex:[indexPath row]] boolValue])
        {
            [cell.actionButton setImage:self.selectedImage forState:UIControlStateNormal];
        }
        else
        {
            [cell.actionButton setImage:self.unselectedImage forState:UIControlStateNormal];
        }
        //move title
        //remove accessory
        
        //cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        [cell.actionButton setImage:self.playImage forState:UIControlStateNormal];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.delegate = self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if ([allFiles count] == 0) 
    {
		shareFileButton.enabled = NO;
		deleteFileButton.enabled = NO;
	}
	
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
	
	// Load up the BBFile for the particular row that's selected.
	// This is a property expected of the delegate for BBFileDetailViewController
	self.file = (BBFile *)[allFiles objectAtIndex:indexPath.row];
	
    
	// Create the detail view controller, load it with the delegate, and push it up onto the stack.
	BBFileDetailViewController *detailViewController = [[BBFileDetailViewController alloc] initWithNibName:@"BBFileDetailView" bundle:nil];
	detailViewController.delegate = self;
    
    //create the navigation view controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    detailViewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:detailViewController action:@selector(dismissModalViewControllerAnimated:)] autorelease];
	
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:navController animated:YES];
    
    [detailViewController release];
    [navController release];
}




#pragma mark - Select multiple functions


- (IBAction)togglePseudoEditMode
{
    //stop playing
    [self stopPlaying];
    
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
        shareFileButton.enabled = NO;
        deleteFileButton.enabled = NO;
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




#pragma mark - BBFileTableCellDelegate methods

-(void)cellActionTriggeredFrom:(BBFileTableCell *) cell
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
        
        if ([selectedArray containsObject:[NSNumber numberWithBool:YES]])
        {
            shareFileButton.enabled = YES;
            deleteFileButton.enabled = YES;
        } else {
            shareFileButton.enabled = NO;
            deleteFileButton.enabled = NO;
        }
        
        
    }
    else //not in pseudo edit mode
    {
        if (audioPlayer == nil)  //if you haven't played anything yet
        {
            [self startPlayingCell:cell];
        }
        else 
        {
            //make sure everything is paused
            if (audioPlayer.playing && cell==self.playingCell)
            {
                [self pausePlayingCell:cell];
            }
            else if (audioPlayer.playing && cell!=self.playingCell)
            {
                [self stopPlaying];
                [self startPlayingCell:cell];
            } 
            else //audioPlayer not playing
            {
                [self startPlayingCell:cell];
            }
            
        }
    }
    
}







#pragma mark - Audio Functions

- (IBAction)positionInFileChanged:(UISlider *)sender {
	NSLog(@"Position in file changed!");
    /*if (audioPlayer.playing)
    {
        [self pausePlayingCell:self.playingCell];
    }*/
	audioPlayer.currentTime = sender.value;
	[self updateCurrentTime];
}

- (void)startPlayingCell:(BBFileTableCell *)cell {
	
	NSLog(@" WANT TO START ");
	
	self.file = (BBFile *)[allFiles objectAtIndex:[[theTableView indexPathForCell:cell] row]];
	
	[cell.actionButton setImage:self.pauseImage forState:UIControlStateNormal];
    self.playingCell = cell;
	
	if (audioPlayer == nil) {
		// Make a URL to the BBFile's audio file
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[self.docPath stringByAppendingPathComponent:self.file.filename]];
        
		// Fire up an audio player
		audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        audioPlayer.volume = 1.0; // 0.0 - no volume; 1.0 full volume

        NSLog(@"File path %@", [self.docPath stringByAppendingPathComponent:self.file.filename]);
		NSLog(@"File duration: %f", audioPlayer.duration);

	
		NSLog(@"Starting the playing");
		
		currentPositionInAudioFileSlider.maximumValue = audioPlayer.duration;
		[self startUpdateTimer];
	
        [fileURL release];
	}	

	
	[audioPlayer play];
	
}

- (void)pausePlayingCell:(BBFileTableCell *)cell {
    
    NSLog(@"Pausing play!");
    
    if (!inPseudoEditMode)
    {
        [cell.actionButton setImage:self.playImage forState:UIControlStateNormal];
	}
        
	[audioPlayer pause];
}

- (void)stopPlaying {
	
	NSLog(@"Stopping play!");
    
    if (!inPseudoEditMode)// && audioPlayer.playing)
    {
        [self.playingCell.actionButton setImage:self.playImage forState:UIControlStateNormal];
        //NSLog(@"Set the image for cell at row: %u", [[self.theTableView indexPathForCell:self.playingCell] row]);
	}
    
	timeElapsedLabel.text = @"0:00";
	timeLeftLabel.text = @"-0:00";
	currentPositionInAudioFileSlider.value = 0.0f;
	
	[timerThread invalidate];
	[audioPlayer stop];
	[audioPlayer release];
	audioPlayer = nil;

}

#pragma mark - A Useful Timer
- (void)startUpdateTimer {
	timerThread = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES] retain];
}

/*//the thread starts by sending this message
- (NSTimer *)newTimerThread {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
	NSTimer *thisTimer = [[NSTimer scheduledTimerWithTimeInterval: 0.5f
									  target: self
									selector: @selector(updateCurrentTime)
									userInfo: nil
									 repeats: YES] retain];
	
	[runLoop run];
	[pool release];
	
	return thisTimer;
}*/

- (void)updateCurrentTime {
	currentPositionInAudioFileSlider.value = audioPlayer.currentTime;
	
		
	int minutesElapsed = (int)floor(audioPlayer.currentTime / 60.0);
	int secondsElapsed = (int)(audioPlayer.currentTime - minutesElapsed*60.0);
	
	int totalSecondsLeft = (int)(audioPlayer.duration - audioPlayer.currentTime);
	int minutesLeft = (int)floor(totalSecondsLeft / 60.0);
	int secondsLeft = (int)(totalSecondsLeft - minutesLeft*60.0);
	
	NSString *tmpElapsedString = [[NSString alloc] initWithFormat:@"%d:%02d", minutesElapsed, secondsElapsed];
	NSString *tmpLeftString = [[NSString alloc] initWithFormat:@"-%d:%02d", minutesLeft, secondsLeft];
	
	timeElapsedLabel.text = tmpElapsedString;
	[tmpElapsedString release];

	timeLeftLabel.text = tmpLeftString;
	[tmpLeftString release];
	
	if (totalSecondsLeft == 0) {
		[self stopPlaying];
        NSLog(@"timer stopped playing");
		[timerThread invalidate];
	}
	
	/*if (audioPlayer.playing == NO) {
        NSLog(@"timer stopped playing");
		[self stopPlaying];
		[timerThread invalidate];
	}*/
	
	
}


#pragma mark - Helper functions
/*
- (void)setCellToSelectedStyle:(BBFileTableCell *)cell {	
	cell.lengthname.textColor = [UIColor whiteColor];
	cell.shortname.textColor = [UIColor whiteColor];
	cell.subname.textColor = [UIColor whiteColor];
	
}

- (void)setCellToDeselectedStyle:(BBFileTableCell *)cell {
	cell.lengthname.textColor = [UIColor colorWithRed:0.196f green:0.408f blue:0.788f alpha:1.0f];
	cell.shortname.textColor = [UIColor blackColor];
	cell.subname.textColor = [UIColor colorWithWhite:0.6f alpha:1.0f];	
}*/

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


#pragma mark - Bottom panel actions

- (IBAction)deleteBBFileFromTableView:(UIButton *)sender {
    
    int num = [allFiles count] - 1;
    for (int i=num; i >= 0; i--)
    {
        if ([[selectedArray objectAtIndex:i] boolValue])
        {
            NSLog(@"selected index for deletion: %u", i);
            [[allFiles objectAtIndex:i] deleteObject]; // remove the file from the database
            [allFiles removeObjectAtIndex:i]; // remove the file from the array of current arrays.
            
            [theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationRight]; // remove file from the table view
        }
        
    }
}

- (IBAction)shareBBFile:(UIButton *)sender {
//	[self emailBBFile];

	UIActionSheet *mySheet = [[UIActionSheet alloc] initWithTitle:nil
													delegate:self 
													cancelButtonTitle:@"Cancel"
													destructiveButtonTitle:nil 
													otherButtonTitles:@"Email", @"Download with WiFi", nil];
	
    mySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [mySheet showInView:self.view];
    [mySheet release];
	
}

- (void)emailBBFile {
		
	// Identify the files we'll be sharing
    NSMutableArray *allFilesToShare = [NSMutableArray array];
    
	// Identify the files we'll be sharing
    int num = [allFiles count] - 1;
    for (int i=num; i >= 0; i--)
    {
        if ([[selectedArray objectAtIndex:i] boolValue])
        {
            NSLog(@"selected index for deletion: %u", i);
            BBFile *fileToShare = [allFiles objectAtIndex:i];
            [allFilesToShare addObject:fileToShare];
            
        }
        
    }

	
	// If we can't send email right now, let the user know about it
	if (![MFMailComposeViewController canSendMail]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Send Mail" message:@"Can't send mail right now. Double-check that your email client is set up and you have an internet connection"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];    
		[alert release];
		
		return;
	}
	
	
	
	MFMailComposeViewController *message = [[MFMailComposeViewController alloc] init];
	message.mailComposeDelegate = self;
	
	[message setSubject:@"A recording from my Backyard Brains iPhone app!"];
    
    for (BBFile *thisFile in allFilesToShare)
    {
        NSString *fullFilePath = [self.docPath stringByAppendingPathComponent:thisFile.filename];
        NSData *attachmentData = [NSData dataWithContentsOfFile:fullFilePath];
        [message addAttachmentData:attachmentData mimeType:@"audio/wav" fileName:thisFile.filename];
        // 32kadpcm
    }

    NSMutableString *bodyText = [NSMutableString stringWithFormat:@"<p>I recorded these files:"];
    for (BBFile *thisFile in allFilesToShare)
    {
        [bodyText appendFormat:[NSMutableString stringWithFormat:@"<p>\"%@,\" ", thisFile.shortname]];
        
        int minutes = (int)floor(thisFile.filelength / 60.0);
        int seconds = (int)(thisFile.filelength - minutes*60.0);
        
        if (minutes > 0) {
            [bodyText appendFormat: @"which lasted %d minutes and %d seconds.</p>", minutes, seconds];
        }
        else {
            [bodyText appendFormat:@"which lasted %d seconds.</p>", seconds];
        }
            
        
        [bodyText appendFormat:@"<p>Some other info about the file: <br>Sampling rate: %0.0f<br>", thisFile.samplingrate];
        [bodyText appendFormat:@"Gain: %0.0f</p>", thisFile.gain];
        [bodyText appendFormat:@"<p>%@</p>", thisFile.comment];
    }
    
	[message setMessageBody:bodyText isHTML:YES];
	
	[self presentModalViewController:message animated:YES];
	[message release];
	
}

- (void)allowDownloadOfBBFile {
	
    NSMutableArray *allFileNamesToShare = [NSMutableArray array];
    
	// Identify the files we'll be sharing
    int num = [self.allFiles count] - 1;
    for (int i=num; i >= 0; i--)
    {
        if ([[selectedArray objectAtIndex:i] boolValue])
        {
            NSLog(@"selected index for deletion: %u", i);
            BBFile *fileToShare = [allFiles objectAtIndex:i];
            [allFileNamesToShare addObject:fileToShare.filename];
            //[fileToShare release]; tk
        }
        
    }
    
    self.fileNamesToShare = [NSArray arrayWithArray:allFileNamesToShare];

	
	BBFileDownloadViewController *downloadViewController = [[BBFileDownloadViewController alloc] initWithNibName:@"BBFileDownloadView" bundle:nil];
	downloadViewController.delegate = self;
	[[self navigationController] pushViewController:downloadViewController animated:YES];
	[downloadViewController release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if ([actionSheet.title isEqualToString:@"Dropbox"])
    {
        switch (buttonIndex) {
            case 0:
                [self dbDisconnect];
                break;
            case 1:
                [self pushDropboxSettings];
                break;
            case 2:
                [self dbUpdate];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
                [self emailBBFile];
                break;
            case 1:
                [self allowDownloadOfBBFile];
                break;
            default:
                break;
        }
    }
	
}



#pragma mark - DropBox methods

- (IBAction)dbButtonPressed
{
    if ([[self.preferences valueForKey:@"isDBLinked"] boolValue])
    {
        //push action sheet
        UIActionSheet *mySheet = [[UIActionSheet alloc] initWithTitle:@"Dropbox" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Disconnect from Dropbox" otherButtonTitles:@"Change login settings", @"Upload now", nil];
        
        mySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [mySheet showInView:self.view];//showFromTabBar:self.tabBarController.tabBar];
        [mySheet release];
        
    }
    else
        [self pushDropboxSettings];
}

- (void)pushDropboxSettings
{
    DBLoginController* controller = [[DBLoginController new] autorelease];
    controller.delegate = self;
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];

    [self presentModalViewController:nav animated:YES];
    
}


- (void)dbDisconnect
{
    self.preferences = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"isDBLinked"];
    [self setStatus:@"Disconnected from Dropbox"];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dbUpdate) userInfo:nil repeats:NO];
}

- (void)dbUpdate
{
    if ([[self.preferences valueForKey:@"isDBLinked"] boolValue])
    {
        [self setStatus:@"Uploading to dropbox..."];
        
        [self.restClient loadMetadata:@"/BYB files" withHash:filesHash];
        
        //create a timer here that restClient:(DBRestClient*)client loadedMetadata: can invalidate
        //timer will call status=@"sync failed"
        self.syncTimer = [NSTimer scheduledTimerWithTimeInterval:kSyncWaitTime
                                                          target:self
                                                        selector:@selector(dbUpdateTimedOut)
                                                        userInfo:nil
                                                         repeats:NO];
        
    } else {
        [self setStatus:@""];
    }
}

- (void)dbUpdateTimedOut
{
    [self.syncTimer invalidate];
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(clearStatus)
                                   userInfo:nil
                                    repeats:NO];
    //try creating the folder and updating again
    if (!self.triedCreatingFolder) {
        [self setStatus:@"Creating folder 'BYB files'"];
        [self.restClient createFolder:@"BYB files"];
        self.triedCreatingFolder = YES;
        self.syncTimer = [NSTimer scheduledTimerWithTimeInterval:kSyncWaitTime
                                                          target:self
                                                        selector:@selector(dbUpdateTimedOut)
                                                        userInfo:nil
                                                         repeats:NO];
    }
    else
    {
        [self setStatus:@"Upload failed"];
    }
}

- (void)dbStopUpdate
{
    
    [self setStatus:@""];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    CGRect dbBarRect = CGRectMake(self.dbStatusBar.frame.origin.x,
                                  self.theTableView.frame.origin.y,
                                  self.dbStatusBar.frame.size.width,
                                  self.dbStatusBar.frame.size.height);
    [self.dbStatusBar setFrame:dbBarRect];
}

- (void)setStatus:(NSString *)theStatus { //setter
    
    status = theStatus;
    [self.dbStatusBar setTitle:theStatus forState:UIControlStateNormal];
    if ([theStatus isEqualToString:@""])
    {
        CGRect dbBarRect = CGRectMake(self.dbStatusBar.frame.origin.x,
                                      self.dbStatusBar.frame.origin.y,
                                      self.dbStatusBar.frame.size.width, 0);    
        //CGRect tableViewRect = CGRectMake(self.theTableView.frame.origin.x,
        //                                  0,
        //                                  self.theTableView.frame.size.width,
        //                                  self.view.window.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.dbStatusBar setFrame:dbBarRect];	
        //[self.theTableView setFrame:tableViewRect];
        [UIView commitAnimations];
    }
    else
    {
        if (self.dbStatusBar.frame.size.height < 20) {
            CGRect dbBarRect = CGRectMake(self.dbStatusBar.frame.origin.x,
                                          self.dbStatusBar.frame.origin.y,
                                          self.dbStatusBar.frame.size.width, 20);    
            //CGRect tableViewRect = CGRectMake(self.theTableView.frame.origin.x,
            //                                  20,
            //                                  self.theTableView.frame.size.width,
            //                                  self.view.window.frame.size.height-20);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.25];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self.dbStatusBar setFrame:dbBarRect];	
            //[self.theTableView setFrame:tableViewRect];
            [UIView commitAnimations];
        }
    }
}


- (void)clearStatus
{
    [self setStatus:@""];
}

- (void)compareBBFilesToNewFilePaths:(NSArray *)newPaths
{
    
    NSMutableArray *filesNeedingUpload   = [NSMutableArray arrayWithCapacity:[self.allFiles count]];
       for (int i = 0; i < [self.allFiles count]; ++i)
        [filesNeedingUpload addObject:[NSNumber numberWithBool:YES]];  //assume all uploads
    
    //for each path
    for (int l = 0; l < [newPaths count]; ++l)
    {
        BOOL match = FALSE;
        //for each file
        for (int m = 0; m < [self.allFiles count]; ++m)
        {
            // if there is a match
            if ([[[self.allFiles objectAtIndex:m] filename] isEqualToString:[[newPaths objectAtIndex:l] stringByReplacingOccurrencesOfString:@"/BYB files/" withString:@""]])
            {
                match = TRUE;
                [filesNeedingUpload replaceObjectAtIndex:m withObject:[NSNumber numberWithBool:NO]]; //don't upload that file
            }
        }
        
    }
    
    
    self.allFiles = [NSMutableArray arrayWithArray:[BBFile allObjects]];
    [self.theTableView reloadData];
    
    int c = 0;
    for (int m = 0; m < [filesNeedingUpload count]; ++m)
    {
        if ([[filesNeedingUpload objectAtIndex:m] boolValue])
        {
            NSString *theFile = [[self.allFiles objectAtIndex:m] filename];
            NSString *theFilePath = [self.docPath stringByAppendingPathComponent:theFile]; 
            NSString *dbPath = [NSString stringWithString:@"/BYB files"];
            [self.restClient uploadFile:theFile toPath:dbPath fromPath:theFilePath];
            c = c++;
        }
    }
    
    
    NSString *uploadStatus = [NSString stringWithFormat:@"Uploaded %d files", c];
    [self setStatus:uploadStatus];
    [self.syncTimer invalidate];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(clearStatus) userInfo:nil repeats:NO];
}


#pragma mark DBRestClientDelegate methods


- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
    [filesHash release];
    filesHash = [metadata.hash retain];
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"aif", @"aiff", nil];
    NSMutableArray* newFilePaths = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
    	NSString* extension = [[child.path pathExtension] lowercaseString];
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newFilePaths addObject:child.path];
        }
    }
    
    
    [self compareBBFilesToNewFilePaths:(NSArray *)newFilePaths];
    self.lastFilePaths = newFilePaths;
}


- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    [self compareBBFilesToNewFilePaths:self.lastFilePaths];
    NSLog(@"Metadata unchanged");
}


- (DBRestClient*)restClient { //getter
    if (restClient == nil) {
    	restClient = [[DBRestClient alloc] initWithSession: [DBSession sharedSession]];
    	restClient.delegate = (id)self;
    }
    return restClient;
}


- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder
{
    [self dbUpdate];
}

#pragma mark DBLoginControllerDelegate methods

- (void)loginControllerDidLogin:(DBLoginController*)controller {
    [controller.navigationController dismissModalViewControllerAnimated:YES];
    self.preferences = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"isDBLinked"];
    NSLog(@"Dropbox is linked!");
    [self dbUpdate];
}

- (void)loginControllerDidCancel:(DBLoginController*)controller {
    [controller.navigationController dismissModalViewControllerAnimated:YES];
    [self dbUpdate];
}


#pragma mark - Delegate stuffs.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
    [theTableView release];
    [shareFileButton release];
    [deleteFileButton release];
    [buttonHolderView release];
    [fileNamesToShare release];
    [timeElapsedLabel release];
    [timeLeftLabel release];
    [currentPositionInAudioFileSlider release];
	[allFiles release];
	[selectedArray release];
    [playingCell release];
    [playImage release];
    [pauseImage release];
	[selectedImage release];
	[unselectedImage release];
    [file release];
}



@end




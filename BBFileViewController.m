//
//  BBFileTableViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileViewController.h"


@implementation BBFileViewController

@synthesize theTableView;
@synthesize allFiles;
@synthesize shareFileButton;
@synthesize deleteFileButton;
@synthesize buttonHolderView;
@synthesize delegate;
@synthesize filename;
@synthesize timeElapsedLabel;
@synthesize timeLeftLabel;
@synthesize currentPositionInAudioFileSlider;

// Protocol properties
@synthesize file;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		theTableView.dataSource = self;
		theTableView.delegate = self;
		theTableView.sectionIndexMinimumDisplayRowCount=10;
		theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		
		self.navigationItem.title = @"Your files";
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
														style: UIBarButtonSystemItemDone
														target:self
														action:@selector(done)];
		
		// audioPlayer will remain nil as long as nothing is playing
		audioPlayer = nil;
		
    }
    return self;
	

}


- (void)viewWillAppear:(BOOL)animated {	

	Class cls = NSClassFromString(@"UIPopoverController");
	if (cls != nil)
	{
		CGSize size = {320, 480}; // size of view in popover, if we're on the iPad
		self.contentSizeForViewInPopover = size;
	}
	
	[super viewWillAppear:animated];

	allFiles = [NSMutableArray arrayWithArray:[BBFile allObjects]];
	[allFiles retain];
	
	for (BBFile *thisFile in allFiles) {
		[thisFile retain]; 
	}
	
	
	[theTableView reloadData];
}



- (void)viewWillDisappear:(BOOL)animated {
	[self stopPlaying];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if ([allFiles count] == 0) {
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
    if (cell == nil) {
		
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

 // Override to support row selection in the table view.
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 
	 NSLog(@"=== Cell selected! === ");
	 
	 shareFileButton.enabled = YES;
	 deleteFileButton.enabled = YES;
	 
	 BBFileTableCell *cell = (BBFileTableCell *)[tableView cellForRowAtIndexPath:indexPath];
	 
	 UIImage *playPauseImage = [UIImage imageNamed:@"Play.png"];
	 cell.playPauseButton.hidden = NO;
	 [cell.playPauseButton setImage:playPauseImage forState:UIControlStateNormal];
	 [cell.playPauseButton addTarget:self action:@selector(playPause) forControlEvents:UIControlEventTouchUpInside];
	 
	 [self setCellToSelectedStyle:cell];
	 	 
 }

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	BBFileTableCell *cell = (BBFileTableCell *)[tableView cellForRowAtIndexPath:indexPath];
	[self setCellToDeselectedStyle:cell];
	
	cell.playPauseButton.hidden = YES;
	
	self.file = (BBFile *)[allFiles objectAtIndex:indexPath.row];
	if (audioPlayer.playing) {
		[self stopPlaying];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	// Load up the BBFile for the particular row that's selected.
	// This is a property expected of the delegate for BBFileDetailViewController
	self.file = (BBFile *)[allFiles objectAtIndex:indexPath.row];
	
	// Create the detail view controller, load it with the delegate, and push it up onto the stack.
	BBFileDetailViewController *detailViewController = [[BBFileDetailViewController alloc] initWithNibName:@"BBFileDetailView" bundle:nil];
	detailViewController.delegate = self;
	[[self navigationController] pushViewController:detailViewController animated:YES];
}

#pragma mark - Audio Functions

// The IBOutlet for start playing

- (void)playPause {
	if (audioPlayer == nil) {
		[self startPlaying];
	}
	else {
		
		if (audioPlayer.playing) {
		[self pausePlaying];
		} else {
			[self startPlaying];
		}

	}

}

- (IBAction)positionInFileChanged:(UISlider *)sender {
	NSLog(@"Position in file changed!");
	audioPlayer.currentTime = sender.value;
	[self updateCurrentTime];
}

- (void)startPlaying {
	
	NSLog(@" WANT TO START ");
	
	self.file = (BBFile *)[allFiles objectAtIndex:[[theTableView indexPathForSelectedRow] row]];
	
	BBFileTableCell *currentCell = (BBFileTableCell *)[theTableView cellForRowAtIndexPath:[theTableView indexPathForSelectedRow]];
	UIImage *pauseImage = [UIImage imageNamed:@"Pause.png"];
	[currentCell.playPauseButton setImage:pauseImage forState:UIControlStateNormal];
	
	if (audioPlayer == nil) {
		// Make a URL to the BBFile's audio file
		NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:self.file.filename]];
		
		// Fire up an audio player
		audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
		NSLog(@"File duration: %f", audioPlayer.duration);

	
		NSLog(@"Starting the playing");
		
		currentPositionInAudioFileSlider.maximumValue = audioPlayer.duration;
		[self startUpdateTimer];
	
	}	

	
	[audioPlayer play];
	
}

- (void)pausePlaying {
	BBFileTableCell *currentCell = (BBFileTableCell *)[theTableView cellForRowAtIndexPath:[theTableView indexPathForSelectedRow]];
	UIImage *playImage = [UIImage imageNamed:@"Play.png"];
	[currentCell.playPauseButton setImage:playImage forState:UIControlStateNormal];
	
	[audioPlayer pause];
}

- (void)stopPlaying {
	
	NSLog(@"Stopping play!");
	
	BBFileTableCell *currentCell = (BBFileTableCell *)[theTableView cellForRowAtIndexPath:[theTableView indexPathForSelectedRow]];
	UIImage *playImage = [UIImage imageNamed:@"Play.png"];
	[currentCell.playPauseButton setImage:playImage forState:UIControlStateNormal];
	
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
//	timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(startTimerThread) object:nil]; //Create a new thread
	timerThread = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES] retain];
//	timerThread = [self startTimerThread];
//	[timerThread start]; //start the thread
}

//the thread starts by sending this message
- (NSTimer *)startTimerThread {
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
}

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
		[timerThread invalidate];
	}
	
	if (audioPlayer.playing == NO) {
		[self stopPlaying];
		[timerThread invalidate];
	}
	
	
}


#pragma mark - Helper functions

- (void)setCellToSelectedStyle:(BBFileTableCell *)cell {	
	cell.lengthname.textColor = [UIColor whiteColor];
	cell.shortname.textColor = [UIColor whiteColor];
	cell.subname.textColor = [UIColor whiteColor];
	
}

- (void)setCellToDeselectedStyle:(BBFileTableCell *)cell {
	cell.lengthname.textColor = [UIColor colorWithRed:0.196f green:0.408f blue:0.788f alpha:1.0f];
	cell.shortname.textColor = [UIColor blackColor];
	cell.subname.textColor = [UIColor colorWithWhite:0.6f alpha:1.0f];	
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


#pragma mark - Bottom panel actions

- (IBAction)deleteBBFileFromTableView:(UIButton *)sender {
	NSIndexPath *tmpPath = [theTableView indexPathForSelectedRow];
	NSArray *tmpArray = [NSArray arrayWithObject:tmpPath];
	NSUInteger rowToDelete = tmpPath.row;

	
	[[allFiles objectAtIndex:rowToDelete] deleteObject]; // remove the file from the database
	[allFiles removeObjectAtIndex:rowToDelete]; // remove the file from the array of current arrays.
	
	[theTableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationRight]; // remove file from the table view
	
	NSUInteger newRow = ([allFiles count]-1 < tmpPath.row) ? [allFiles count]-1 : tmpPath.row; // make sure we select a row that exists
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:tmpPath.section];	
	[theTableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone]; // select the next item in the table view
	[self tableView:theTableView didSelectRowAtIndexPath:newIndexPath];

		
	[self setCellToSelectedStyle:(BBFileTableCell *)[self.theTableView cellForRowAtIndexPath:newIndexPath]];
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
		
	// Identify the file we'll be sharing
	NSIndexPath *tmpPath = [theTableView indexPathForSelectedRow];

	NSUInteger rowToShare = tmpPath.row;
	BBFile *fileToShare = [allFiles objectAtIndex:rowToShare];
	
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
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *fullFilePath = [docPath stringByAppendingPathComponent:fileToShare.filename];
	NSData *attachmentData = [NSData dataWithContentsOfFile:fullFilePath];
	[message addAttachmentData:attachmentData mimeType:@"audio/wav" fileName:fileToShare.filename];
	// 32kadpcm
	NSMutableString *bodyText = [NSMutableString stringWithFormat:@"<p>I recorded a file named \"%@,\" ", fileToShare.shortname];
	
	int minutes = (int)floor(fileToShare.filelength / 60.0);
	int seconds = (int)(fileToShare.filelength - minutes*60.0);
	
	if (minutes > 0) {
		[bodyText appendFormat: @"which lasted %d minutes and %d seconds.</p>", minutes, seconds];
	}
	else {
		[bodyText appendFormat:@"which lasted %d seconds.</p>", seconds];
	}
	
	[bodyText appendFormat:@"<p>Some other info about the file: <br>Sampling rate: %0.0f<br>", fileToShare.samplingrate];
	[bodyText appendFormat:@"Gain: %0.0f</p>", fileToShare.gain];
	[bodyText appendFormat:@"<p>%@</p>", fileToShare.comment];
		
	[message setMessageBody:bodyText isHTML:YES];
	
	[self presentModalViewController:message animated:YES];
	[message release];
	
}

- (void)allowDownloadOfBBFile {
	
	// Identify the file we'll be sharing
	NSIndexPath *tmpPath = [theTableView indexPathForSelectedRow];
	NSUInteger rowToShare = tmpPath.row;
	BBFile *fileToShare = [allFiles objectAtIndex:rowToShare];
	
	
	BBFileDownloadViewController *downloadViewController = [[BBFileDownloadViewController alloc] initWithNibName:@"BBFileDownloadView" bundle:nil];
	self.filename = fileToShare.filename;
	downloadViewController.delegate = self;
	[[self navigationController] pushViewController:downloadViewController animated:YES];
	[downloadViewController release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
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

#pragma mark - Delegate stuffs.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
	[allFiles release];
}

- (void)done
{
	NSLog(@"All done?");
	[self.delegate hideFiles];	

	
}


@end





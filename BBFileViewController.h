//
//  BBFileTableViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBFile.h"
#import "BBFileTableCell.h"
#import "BBFileDetailViewController.h"
#import "BBFileDownloadViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@protocol BBFileViewControllerDelegate
@required
- (void)hideFiles;
@end


@interface BBFileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BBFileDetailDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, BBFileDownloadViewControllerDelegate, BBFileTableCellDelegate> {
	IBOutlet UITableView *theTableView;
	IBOutlet UIButton *shareFileButton;
	IBOutlet UIButton *deleteFileButton;
	IBOutlet UIView *buttonHolderView;
	IBOutlet UILabel *timeElapsedLabel;
	IBOutlet UILabel *timeLeftLabel;
	IBOutlet UISlider *currentPositionInAudioFileSlider;
	
	NSMutableArray *allFiles;
    
	NSMutableArray *selectedArray;
	BOOL inPseudoEditMode;
    UIImage *playImage;
    UIImage *pauseImage;
	UIImage *selectedImage;
	UIImage *unselectedImage;
    NSUInteger lastRowSelected;
    
    BBFileTableCell *playingCell;
    
	
	
	id <BBFileViewControllerDelegate> delegate;
	
	// Properties required by the BBFileDetailDelegate protocol
	BBFile *file;
	
    // Properties required by BBFileDownloadViewControllerDelegate
	NSArray *filesToShare; 
	
	AVAudioPlayer *audioPlayer;
	
	NSTimer *timerThread;
    
}


@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSArray *allFiles;
@property (nonatomic, retain) IBOutlet UIButton *shareFileButton;
@property (nonatomic, retain) IBOutlet UIButton *deleteFileButton;
@property (nonatomic, retain) IBOutlet UIView *buttonHolderView;
@property (nonatomic, retain) NSArray *filesToShare;
@property (nonatomic, retain) IBOutlet UILabel *timeElapsedLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, retain) IBOutlet UISlider *currentPositionInAudioFileSlider;

@property (nonatomic, retain) NSMutableArray *selectedArray;
@property BOOL inPseudoEditMode;
@property (nonatomic, retain) UIImage *playImage;
@property (nonatomic, retain) UIImage *pauseImage;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unselectedImage;

@property (nonatomic, assign) BBFileTableCell *playingCell;

@property (nonatomic, assign) id <BBFileViewControllerDelegate> delegate;

- (void)done;

- (IBAction)deleteBBFileFromTableView:(UIButton *)sender;
- (IBAction)shareBBFile:(UIButton *)sender;
- (IBAction)positionInFileChanged:(UISlider *)sender;

- (IBAction)positionInFileChanged:(UISlider *)sender;
- (void)startPlayingCell:(BBFileTableCell *)cell;
- (void)pausePlayingCell:(BBFileTableCell *)cell;
- (void)stopPlaying;

- (void)startUpdateTimer;
- (NSTimer *)startTimerThread;
- (void)updateCurrentTime;

- (void)emailBBFile;
- (void)allowDownloadOfBBFile;

/*- (void)setCellToSelectedStyle:(BBFileTableCell *)cell;
- (void)setCellToDeselectedStyle:(BBFileTableCell *)cell;*/
- (NSString *)stringWithFileLengthFromBBFile:(BBFile *)thisFile;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

- (IBAction)togglePseudoEditMode;
- (void)populateSelectedArray;

// Properties required by the BBFileDetailDelegate protocol
@property (nonatomic, retain) BBFile *file;
@end
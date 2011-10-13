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
#import "DropboxSDK.h"


@protocol BBFileViewControllerDelegate
@required
- (void)hideFiles;
@end


@interface BBFileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BBFileDetailDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, BBFileDownloadViewControllerDelegate, BBFileTableCellDelegate, DBLoginControllerDelegate> {
	IBOutlet UITableView *theTableView;
    IBOutlet UIToolbar *toolbar;
	IBOutlet UIButton *shareFileButton;
	IBOutlet UIButton *deleteFileButton;
	IBOutlet UIView *buttonHolderView;
	IBOutlet UILabel *timeElapsedLabel;
	IBOutlet UILabel *timeLeftLabel;
	IBOutlet UISlider *currentPositionInAudioFileSlider;
    IBOutlet UIBarButtonItem *selectButton;
    IBOutlet UIBarButtonItem *dropboxButton;
    IBOutlet UIBarButtonItem *doneButton;
	
	NSMutableArray *allFiles;
    
	NSMutableArray *selectedArray;
	BOOL inPseudoEditMode;
    UIImage *playImage;
    UIImage *pauseImage;
	UIImage *selectedImage;
	UIImage *unselectedImage;
    NSUInteger lastRowSelected;
    
    BBFileTableCell *playingCell;
    
    UIButton *dbStatusBar;
    
	id <BBFileViewControllerDelegate> delegate;
	
    // Properties required by BBFileDownloadViewControllerDelegate
	NSArray *fileNamesToShare; 
	
	// Properties required by the BBFileDetailDelegate protocol
	BBFile *file;
    
    // Instance variables that are not properties
	AVAudioPlayer *audioPlayer;
	NSTimer *timerThread;
    NSArray* filePaths;
    NSString* filesHash;
    
    // Private properties
    NSDictionary *preferences;
    DBRestClient *restClient;
    NSString *status;
    NSTimer *syncTimer;
    NSArray *lastFilePaths;
    NSString *docPath;
    
}


@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) NSMutableArray *allFiles;
@property (nonatomic, retain) IBOutlet UIButton *shareFileButton;
@property (nonatomic, retain) IBOutlet UIButton *deleteFileButton;
@property (nonatomic, retain) IBOutlet UIView *buttonHolderView;
@property (nonatomic, retain) IBOutlet UILabel *timeElapsedLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, retain) IBOutlet UISlider *currentPositionInAudioFileSlider;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *selectButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *dropboxButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) NSMutableArray *selectedArray;
@property BOOL inPseudoEditMode;
@property (nonatomic, retain) UIImage *playImage;
@property (nonatomic, retain) UIImage *pauseImage;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unselectedImage;

@property (nonatomic, retain) BBFileTableCell *playingCell;

@property (nonatomic, retain) UIButton *dbStatusBar;

@property (nonatomic, assign) id <BBFileViewControllerDelegate> delegate;

// Properties required by BBFileDownloadViewControllerDelegate
@property (nonatomic, retain) NSArray *fileNamesToShare;

- (void)done;

- (IBAction)deleteBBFileFromTableView:(UIButton *)sender;
- (IBAction)shareBBFile:(UIButton *)sender;
- (IBAction)positionInFileChanged:(UISlider *)sender;

- (IBAction)positionInFileChanged:(UISlider *)sender;
- (void)startPlayingCell:(BBFileTableCell *)cell;
- (void)pausePlayingCell:(BBFileTableCell *)cell;
- (void)stopPlaying;

- (void)startUpdateTimer;
//- (NSTimer *)newTimerThread;
- (void)updateCurrentTime;

- (void)emailBBFile;
- (void)allowDownloadOfBBFile;

/*- (void)setCellToSelectedStyle:(BBFileTableCell *)cell;
- (void)setCellToDeselectedStyle:(BBFileTableCell *)cell;*/
- (NSString *)stringWithFileLengthFromBBFile:(BBFile *)thisFile;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

- (IBAction)togglePseudoEditMode;
- (void)populateSelectedArray;

- (IBAction)dbButtonPressed;
- (IBAction)done;

// Properties required by the BBFileDetailDelegate protocol
@property (nonatomic, retain) BBFile *file;

@end
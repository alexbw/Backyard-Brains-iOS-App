//
//  BBFileActionViewControllerTBV.h
//  Backyard Brains
//
//  Created by Zachary King on 7/13/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BBFileDetailViewController.h"
#import "BBFileTableCell.h"
#import "PlaybackViewController.h"
#import "BBFileDownloadViewController.h"
#import "BBFileActionViewControllerTBV.h"


@protocol SubstitutableDetailViewController
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end



@protocol BBFileActionViewControllerDelegate
@required
    @property (nonatomic, retain) NSArray *filesSelectedForAction;
    @property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
    @property (nonatomic, retain) UIPopoverController *popoverController;
    @property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
    - (void)deleteTheFiles:(NSArray *)files;
@end


@interface BBFileActionViewControllerTBV : UITableViewController  <UISplitViewControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, BBFileDetailViewDelegate, BBFileDownloadViewControllerDelegate, DrawingViewControllerDelegate>
{
    
    UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    
    //IBOutlet UITableView *theTableView;
    
    NSArray *actionOptions;
    NSArray *fileNamesToShare;
    
    id <BBFileActionViewControllerDelegate> delegate;
    
    //AudioSignalManager *audioSignalManager;
    NSArray *files;
}

//@property (nonatomic, retain) IBOutlet UITableView *theTableView;


@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

@property (nonatomic, retain) NSArray *actionOptions;

@property (nonatomic, assign) id <BBFileActionViewControllerDelegate> delegate;

//for DrawingViewControllerDelegate
//@property (nonatomic, retain) AudioSignalManager *audioSignalManager;
@property (nonatomic, retain) NSArray *files;

- (void)emailFiles;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

- (void)downloadFiles;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

//For BBFileDownloadViewControllerDelegate
@property (nonatomic, retain) NSArray *fileNamesToShare;

@end

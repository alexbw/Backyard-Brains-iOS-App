//
//  BBFileActionViewController.h
//  Backyard Brains
//
//  Created by Zachary King on 7/13/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BBFileDetailViewController.h"
#import "BBFileTableCell.h"
#import "PlaybackViewController.h"
#import "BBFileDownloadViewController.h"

@protocol BBFileActionViewControllerDelegate
@required
    @property (nonatomic, retain) NSArray *files;
    - (void)deleteTheFiles:(NSArray *)files;
@end


@interface BBFileActionViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, BBFileDetailViewDelegate, BBFileDownloadViewControllerDelegate> {
    IBOutlet UITableView *theTableView;
    
    NSArray *files;
    NSArray *actionOptions;
    NSArray *fileNamesToShare;
    
    id <BBFileActionViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;

@property (nonatomic, retain) NSArray *files;
@property (nonatomic, retain) NSArray *actionOptions;

@property (nonatomic, assign) id <BBFileActionViewControllerDelegate> delegate;


- (void)emailFiles;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

- (void)downloadFiles;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

//For BBFileDownloadViewControllerDelegate
@property (nonatomic, retain) NSArray *fileNamesToShare;

@end

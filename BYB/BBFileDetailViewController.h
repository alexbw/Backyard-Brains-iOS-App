//
//  BBFileDetailViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/9/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFile.h"
#import "BBFileTitleEditorViewController.h"
#import "BBFileCommentEditorViewController.h"
@protocol BBFileDetailDelegate
	@required
		@property (nonatomic, retain) BBFile *file;
        @property (nonatomic, retain) UITableView *theTableView;
	@optional
		// NONE ARE OPTIONAL ALL ARE REQUIRED ZER VILL BE DISCIPLINE
@end





@interface BBFileDetailViewController : UIViewController <BBFileTitleEditorDelegate> {
	id <BBFileDetailDelegate> delegate;
	
	IBOutlet UIButton *titleButton;
	IBOutlet UILabel *durationLabel;
	IBOutlet UILabel *recordedInfoLabel;
	IBOutlet UILabel *samplingRateLabel;
	IBOutlet UILabel *gainLabel;
	IBOutlet UIButton *commentButton;
	
	BBFile *file;
}

@property (assign) id <BBFileDetailDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *recordedInfoLabel;
@property (nonatomic, retain) IBOutlet UILabel *samplingRateLabel;
@property (nonatomic, retain) IBOutlet UILabel *gainLabel;
@property (nonatomic, retain) IBOutlet UIButton *commentButton;
@property (nonatomic, retain) BBFile *file;


- (void)setButton:(UIButton *)button titleForAllStates:(NSString *)aTitle;
- (IBAction)pushTitleEditorView:(UIButton *)sender;
- (IBAction)pushCommentEditorView:(UIButton *)sender;
- (NSString *)stringWithFileLengthFromBBFile:(BBFile *)thisFile;

@end

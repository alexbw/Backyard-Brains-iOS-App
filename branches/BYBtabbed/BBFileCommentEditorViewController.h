//
//  BBFileCommentEditorViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/10/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFileTitleEditorViewController.h"

@interface BBFileCommentEditorViewController : UIViewController {
	
	IBOutlet UITextView *commentTextView;
	NSArray *files;
	id <BBFileTitleEditorDelegate> delegate; // we can reuse the delegate, since it's so simple.
}

@property (nonatomic, retain) IBOutlet UITextView *commentTextView;
@property (nonatomic, retain) NSArray *files;
@property (assign) id <BBFileTitleEditorDelegate> delegate;

- (IBAction)done:(UIBarButtonItem *)sender;

@end

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
	id <BBFileTitleEditorDelegate> delegate; // we can reuse the delegate, since it's so simple.
	IBOutlet UITextView *commentTextView;
}

@property (assign) id <BBFileTitleEditorDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextView *commentTextView;

@end

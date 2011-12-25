//
//  DrawingDataManager.h
//  Backyard Brains
//
//  Created by Zachary King on 8/1/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//
//  Superclass with subclasses ContinuousWaveViewController, TriggerViewController, 
//      PlaybackViewController
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


#define kMaxPixelDistanceToDetectTap 10
//#define kPortraitHeightWithTabBar 430
//#define kPortraitHeightWithTabBar_iPad 974
//#define kLandscapeHeightWithTabBar 270
//#define kLandscapeHeightWithTabBar_iPad 736

@class BBFileViewControllerTBV;
@class LarvaJoltAudio;

@protocol DrawingViewControllerDelegate
@required
@optional
//For Live play. This will be the AppDelegate
    @property (nonatomic, retain) DrawingDataManager *drawingDataManager;
    @property (nonatomic, retain) LarvaJoltAudio *pulse;
    @property (nonatomic, retain) BBFileViewControllerTBV *fileController; //for iPad
    @property (nonatomic, retain) UINavigationController *navigationController; //for iPad

//For Playback. This will be ActionViewControllerTBV
    @property (nonatomic, retain) NSArray *files; 

@end


@interface DrawingViewController : UIViewController <UISplitViewControllerDelegate> {
	DrawingDataManager *drawingDataManager;
	EAGLView *glView;
	
	NSMutableSet *currentTouches;
	
	CGPoint lastPointOne;
	CGPoint lastPointTwo;
	CGPoint firstPointOne;
	CGPoint firstPointTwo;
	float pinchChangeInX;
	float pinchChangeInY;
	float changeInX;
	float changeInY;
	
	BOOL showGrid;
	
	NSDictionary *preferences;
	
	IBOutlet id <DrawingViewControllerDelegate> delegate;
	
	IBOutlet UIImageView *tickMarks;
	IBOutlet UIButton *infoButton;
	IBOutlet UILabel *xUnitsPerDivLabel;
	IBOutlet UILabel *yUnitsPerDivLabel;
	IBOutlet UIImageView *msLegendImage;
	
}

@property (nonatomic, retain) DrawingDataManager *drawingDataManager;
@property (nonatomic, retain) EAGLView *glView;

@property (nonatomic, retain) NSMutableSet *currentTouches;
@property CGPoint lastPointOne;
@property CGPoint lastPointTwo;
@property CGPoint firstPointOne;
@property CGPoint firstPointTwo;
@property float pinchChangeInX;
@property float pinchChangeInY;
@property float changeInX;
@property float changeInY;
@property BOOL showGrid;

@property (nonatomic, retain) IBOutlet UIImageView *tickMarks;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UILabel *xUnitsPerDivLabel;
@property (nonatomic, retain) IBOutlet UILabel *yUnitsPerDivLabel;
@property (nonatomic, retain) IBOutlet UIImageView *msLegendImage;

@property (nonatomic, assign) id <DrawingViewControllerDelegate> delegate;

@property (nonatomic, retain) NSDictionary *preferences;

@property (nonatomic, retain) IBOutlet UIButton *fileButton;

//for iPad
@property (nonatomic,retain) IBOutlet UINavigationBar *navigationBar;


- (void)dealloc;

- (CGPoint)getXYCoordinatesOfTouch:(int)touchID;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)collectPreferences;
- (void)dispersePreferences;

/*- (void)didRotate:(NSNotification *)theNotification;
- (void)fitViewToCurrentOrientation;
- (void)fitTickMarksToLandscape;
- (void)fitTickMarksToPortrait;*/

- (IBAction)showInfoPanel:(UIButton *)sender;

- (IBAction)showFilePopover:(UIButton *)sender;
- (void)hideFileButton;
- (void)showFileButton;

@end


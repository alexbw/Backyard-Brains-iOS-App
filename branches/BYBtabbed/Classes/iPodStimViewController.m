//
//  iPodStimViewController.m
//  Backyard Brains
//
//  Created by Zachary King on 12/16/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import "iPodStimViewController.h"

@implementation iPodStimViewController

@synthesize delegate;
@synthesize theTableView;
@synthesize songNames;

#pragma mark - view lifecycle

- (void)dealloc
{
    [theTableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tell LarvaJolt to prep for a song
    self.delegate.pulse.songSelected = YES;
}

#pragma mark - Actions

- (IBAction)presentTheMediaPicker:(id)sender
{
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc]
     initWithMediaTypes: MPMediaTypeAnyAudio];                   
    
    [picker setDelegate: self];                                        
    [picker setAllowsPickingMultipleItems: YES];                       
    picker.prompt =
    NSLocalizedString (@"Add songs to play",
                       "Prompt in media item picker");
    
    [self presentModalViewController: picker animated: YES];
    [picker release];
}

- (void)updateTableWithCollection:(MPMediaItemCollection *)collection 
{
    self.songNames = [collection valueForKey:@""];
    
    [self.theTableView reloadData];
}

#pragma mark - Implementation of UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.songNames.count > 0) && (indexPath.row <= self.songNames.count-1))
    {
        NSString *thisSong = [self.songNames objectAtIndex:indexPath.row];
        UITableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:thisSong];
        if (cell == nil)
        {
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:thisSong] autorelease];
        }
        cell.textLabel.text = thisSong;
        return cell;
    }
    else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return self.songNames.count;
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{

}
- (void)pulseIsStopped
{

}

#pragma mark - Implementation of MPMediaPickerControllerDelegate

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) collection {
    
    [self dismissModalViewControllerAnimated:YES];
    [self updateTableWithCollection:collection];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
    [self dismissModalViewControllerAnimated:YES];
}


@end

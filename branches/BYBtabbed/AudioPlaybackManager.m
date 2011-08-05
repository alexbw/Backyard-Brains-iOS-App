//
//  AudioPlaybackManager.m
//  
//
//  Created by Zachary King on July 31, 2011.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import "AudioPlaybackManager.h"


UInt32 readSingleChannelRingBufferDataAsSInt16(AudioFileID audioFileID, AudioConverterRef audioConverter, UInt32 bytePosition) {

    OSStatus status;
    
	// Read from audio to file now
    //status = AudioFileReadBytes( audioFileID, NO, bytePosition, &numBytesToRead, tempBuffer );

  
    return bytePosition;
}

@implementation AudioPlaybackManager

@synthesize file;
@synthesize fileHandle;
@synthesize playImage, pauseImage;

- (id)init
{
    if ((self = [super init]))
    {
         
        numBytesToRead = kRecordingTimerIntervalInSeconds*self.file.samplingrate*sizeof(SInt16)*4*file.filelength;
        
		self.vertexBuffer = (struct wave_s *)malloc(kNumPointsInVertexBuffer*sizeof(struct wave_s));
        self.nWaitFrames = 0;
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:file.filename]];
        
        OSStatus status;
        status = AudioFileOpenURL ((CFURLRef)fileURL, 0x03, 0, &fileHandle); //inFileTypeHint?? just gonna pass 0

        
        //Just read out all the audio data
        
        [fileURL release];
        
        
        // audioPlayer will remain nil as long as nothing is playing
        audioPlayer = nil;

        
        self.playImage = [UIImage imageNamed:@"play.png"];
        self.pauseImage = [UIImage imageNamed:@"pause.png"];
  }
    
    return self;
}

- (void)grabNewFile
{
    self.file = delegate.file;
}

- (void)updateCurrentTimeTo:(float)time
{
}


- (void)fillVertexBufferWithAudioData
{
    //create a timer
    
  if (!self.paused) {
	//bytePosition = readSingleChannelRingBufferDataAsSInt16(self.fileHandle,audioConverter,bytePosition);
  }
}


- (void)playPause
{
    
    if (audioPlayer == nil)  //if you haven't played anything yet
    {
        [self play];
        return YES;
    }
    else 
    {
        //make sure everything is paused
        if (audioPlayer.playing)
        {
            [self pause];
            return NO;
        } 
        else //audioPlayer not playing
        {
            [self play];
            return YES;
        }
        
    }
}

- (void)play
{
    
	NSLog(@"Starting play!");
    
    //Audio
    
    if (audioPlayer == nil) {
		// Make a URL to the BBFile's audio file
		NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:self.file.filename]];
        
		// Fire up an audio player
		audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        audioPlayer.volume = 1.0; // 0.0 - no volume; 1.0 full volume
        
        NSLog(@"File path %@", [docPath stringByAppendingPathComponent:self.file.filename]);
		NSLog(@"File duration: %f", audioPlayer.duration);
        
        
		NSLog(@"Starting the playing");
		
		self.delegate.scrubBar.maximumValue = audioPlayer.duration;
		[self startUpdateTimer];
        
        [fileURL release];
	}	
    
	
	[audioPlayer play];
    
    
    //Visual
    
    
    [self.delegate.playPauseButton setImage:self.pauseImage forState:UIControlStateNormal];
    
}

- (void)pause
{
	NSLog(@"Pausing play!");
    
    //Audio
    [audioPlayer pause];
    
    //Visual
    
    [self.delegate.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
}

- (void)stop
{
	NSLog(@"Stopping play!");
    
    //Audio
    
	self.delegate.elapsedTimeLabel.text = @"0:00";
	self.delegate.remainingTimeLabel.text = @"-0:00";
	self.delegate.scrubBar.value = 0.0f;
	
	[timerThread invalidate];
	[audioPlayer stop];
	[audioPlayer release];
	audioPlayer = nil;
    
    [self.delegate.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
}

#pragma mark - A Useful Timer
- (void)startUpdateTimer {
	timerThread = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES] retain];
}

/*//the thread starts by sending this message
 - (NSTimer *)newTimerThread {
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
 }*/

- (void)updateCurrentTime {
	self.delegate.scrubBar.value = audioPlayer.currentTime;
	
    
	int minutesElapsed = (int)floor(audioPlayer.currentTime / 60.0);
	int secondsElapsed = (int)(audioPlayer.currentTime - minutesElapsed*60.0);
	
	int totalSecondsLeft = (int)(audioPlayer.duration - audioPlayer.currentTime);
	int minutesLeft = (int)floor(totalSecondsLeft / 60.0);
	int secondsLeft = (int)(totalSecondsLeft - minutesLeft*60.0);
	
	NSString *tmpElapsedString = [[NSString alloc] initWithFormat:@"%d:%02d", minutesElapsed, secondsElapsed];
	NSString *tmpLeftString = [[NSString alloc] initWithFormat:@"-%d:%02d", minutesLeft, secondsLeft];
	
	self.delegate.elapsedTimeLabel.text = tmpElapsedString;
	[tmpElapsedString release];
    
	self.delegate.remainingTimeLabel.text = tmpLeftString;
	[tmpLeftString release];
	
	if (totalSecondsLeft == 0) {
		[self stop];
        NSLog(@"timer stopped playing");
		[timerThread invalidate];
	}
	
	/*if (audioPlayer.playing == NO) {
     NSLog(@"timer stopped playing");
     [self stopPlaying];
     [timerThread invalidate];
     }*/
	
	
}





@end
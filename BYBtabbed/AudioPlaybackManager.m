//
//  AudioPlaybackManager.m
//  
//
//  Created by Zachary King on July 31, 2011.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import "AudioPlaybackManager.h"
#import "Constants.h"

#define kBarUpdateInterval 0.5f
#define kNumPointsInPlaybackVertexBuffer 32768
#define kNumWaitFrames 5


SInt16 * readSingleChannelRingBufferDataAsSInt16( AudioPlaybackManager *THIS, Float64 seconds) {

    //int numSamplesToWrite = kNumPointsInWave;
	
    AudioFileID audioFileID = THIS->fileHandle;
    UInt32 startByte = seconds * THIS->bitRate;// + THIS->dataOffset;
    
    UInt32 ioNumBytes = kNumPointsInPlaybackVertexBuffer*sizeof(SInt16);
    if (ioNumBytes > THIS->byteCount)
        ioNumBytes = THIS->byteCount - startByte;
    if (ioNumBytes <= 0)
    {
        THIS->numBytesRead = 0;
        return nil;
    }
    
    void *tempBuffer = malloc(ioNumBytes);
    
    NSLog(@"Starting byte is %lu and num of bytes is %lu", startByte, ioNumBytes);
    
    
	// Read from audio to file now
	OSStatus status = AudioFileReadBytes(audioFileID, YES, startByte, &ioNumBytes, tempBuffer);
    THIS->numBytesRead = ioNumBytes;
    
	if (status)
    {
		NSLog(@"AudioFileReadBytes failed: %ld, with ioNumBytes: %lu", status, ioNumBytes);
        return nil;
    }
    else
    {
        
		NSLog(@"AudioFileReadBytes succeeded with ioNumBytes: %lu", ioNumBytes);

        if (ioNumBytes > 0) {
            
            SInt16 *outBuffer = (SInt16 *)tempBuffer;
            
            for (int i=0; i < ioNumBytes/sizeof(SInt16); ++i) {//tk
                // We've gotta swap each sample's byte order from big endian to host format...
                outBuffer[i] = CFSwapInt16BigToHost(outBuffer[i]);
            }
            
            return outBuffer;
            
        }
        else 
        {
            // stop
            return nil;
        }
    }
    
}


@implementation AudioPlaybackManager

@synthesize file;
@synthesize playImage, pauseImage;

@synthesize lastTime;
@synthesize playing;

@synthesize fileHandle;
@synthesize numBytesRead, dataOffset, bitRate, byteCount;

- (id)initWithBBFile:(BBFile *)theFile
{
    if ((self = [super init]))
    {
        self.file = theFile; 
        
		self.vertexBuffer = (struct wave_s *)malloc(kNumPointsInPlaybackVertexBuffer*sizeof(struct wave_s));
        NSLog(@"Num points in vertex buffer: %d", kNumPointsInPlaybackVertexBuffer);
        
        self.nWaitFrames = 0;
        
        self.playing = NO;
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:self.file.filename]];
        //do i have the file yet?
        
        NSLog(@"Full file path: %@", [docPath stringByAppendingPathComponent:self.file.filename]);
        // Open the audio file, type = AIFF
        
        AudioFileID id;
        OSStatus status = AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadWritePermission, kAudioFileAIFFType, &id); //inFileTypeHint?? just gonna pass 0
        self.fileHandle = id;
        NSLog(@"Open Audio File status: %@", status);
        
        
        
        //Get byte count
        UInt64 outData = 0;
        UInt32 outDataSize = sizeof(UInt64);
        AudioFileGetProperty (  self.fileHandle,
                                kAudioFilePropertyAudioDataByteCount,
                              &outDataSize,
                              &outData
                              );
        NSLog(@"Byte count: %llu", outData);
        self.byteCount = outData;
        
        
        //should be 44100:
        self.bitRate = self.file.samplingrate*2;
        NSLog(@"bit rate: %llu", self.bitRate);
        
        //Just read out all the audio data
        
        [fileURL release];
        AudioFileClose(id);
        
        // audioPlayer will remain nil as long as nothing is playing
        audioPlayer = nil;

        
        self.playImage = [UIImage imageNamed:@"play.png"];
        self.pauseImage = [UIImage imageNamed:@"pause.png"];
  }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)dealloc
{
    [super dealloc];
    [file release];
    [playImage release];
    [pauseImage release];
}

- (void)grabNewFile
{
    self.file = delegate.file;
}

- (void)updateCurrentTimeTo:(float)time
{
    audioPlayer.currentTime = time;
    if (self.playing)
        [self pause];
}


# pragma mark - Visual playback methods



- (void)fillVertexBufferWithAudioData
{
    
    if (audioPlayer != nil)
    {
        
        //get the current time
        Float64 tNow = audioPlayer.currentTime;
        if (tNow != self.lastTime)
        {
            NSLog(@"Time now is %f", tNow);
            
            SInt16 *outBuffer = readSingleChannelRingBufferDataAsSInt16(self, tNow);

            if (outBuffer == nil)
            {
                [self stop];
                for (int i = 0; i < kNumPointsInPlaybackVertexBuffer; ++i)
                {
                    self.vertexBuffer[i].y = 0;
                }
            }
            else
            {
                NSLog(@"bytes read out: %llu", self.numBytesRead);
                
                for (int i = 0; i < kNumPointsInPlaybackVertexBuffer; ++i)
                {
                    self.vertexBuffer[i].y = outBuffer[i];
                }
                
            }
            self.lastTime = tNow;
        }
        
        //After kNumWaitFrames (5) buffers are filled, tell view controller to autoset its frame 
        if (self.nWaitFrames < kNumWaitFrames)
        {
            self.nWaitFrames += 1;
        }
        else if (self.nWaitFrames == kNumWaitFrames)
        {
            [delegate shouldAutoSetFrame];
            self.nWaitFrames += 1;
        }
    }
    else
    {
        for (int i = 0; i < kNumPointsInPlaybackVertexBuffer; ++i)
        {
            self.vertexBuffer[i].y = 0;
        }
    }
}


- (void)setVertexBufferXRangeFrom:(GLfloat)xBegin to:(GLfloat)xEnd {
	for (int i=0; i < kNumPointsInPlaybackVertexBuffer; ++i) {
		vertexBuffer[i].x = xBegin + i*(xEnd - xBegin)/kNumPointsInPlaybackVertexBuffer;
	}
}


# pragma mark - Audio playback methods

- (BOOL)playPause
{
    
    if (audioPlayer == nil)  //if you haven't played anything yet
    {
        [self play];
        return YES;
    }
    else 
    {
        //make sure everything is paused
        if (self.playing)
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
		
        self.delegate.scrubBar.minimumValue = 0;
		self.delegate.scrubBar.maximumValue = audioPlayer.duration;
		[self startUpdateTimer];
        
        [fileURL release];
	}	
    
	
	[audioPlayer play];
    self.playing = YES;
    
    //Visual
    
    
    [self.delegate.playPauseButton setImage:self.pauseImage forState:UIControlStateNormal];
    
}

- (void)pause
{
	NSLog(@"Pausing play!");
    
    //Audio
    [audioPlayer pause];
    self.playing = NO;
    
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
    
    self.playing = NO;
    
    [self.delegate.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
}

#pragma mark - A Useful Timer
- (void)startUpdateTimer {
	timerThread = [[NSTimer scheduledTimerWithTimeInterval:kBarUpdateInterval target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES] retain];
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
	
    //************************************
    //Now grab this audio data and present to screen
	
}


#pragma mark- Helper Functions

- (UInt32)CalculateBytesForTime:(Float64)inSeconds
{
    UInt32 startByte = inSeconds * self.bitRate + self.dataOffset;
    
    return startByte;
}



@end
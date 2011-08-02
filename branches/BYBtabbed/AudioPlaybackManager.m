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

- (id)initWithFile:(BBFile *)theFile
{
    if ((self = [super init]))
    {
        self.file = theFile;
        numBytesToRead = kRecordingTimerIntervalInSeconds*self.file.samplingrate*sizeof(SInt16)*4*file.filelength;
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:file.filename]];
        
        OSStatus status;
        status = AudioFileOpenURL ((CFURLRef)fileURL, 0x03, 0, &fileHandle); //inFileTypeHint?? just gonna pass 0

        
        //Just read out all the aduio data
        
        [fileURL release];
        
  }
    
    return self;
}



- (void)fillVertexBufferWithAudioData
{
    //create a timer
    
  if (!self.paused) {
	//bytePosition = readSingleChannelRingBufferDataAsSInt16(self.fileHandle,audioConverter,bytePosition);
  }
}

- (void)pause
{
    
}
- (void)play
{
    
}

# pragma mark - Timer/Thread Handling
/*
- (void)startTimer {
	self.timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(newTimerThread) object:nil]; //Create a new thread
	[self.timerThread start]; //start the thread
	//self.asm.secondStageBuffer->lastWrittenIndex = self.asm.secondStageBuffer->lastReadIndex; 
	bytePosition = 0;
}

//the thread starts by sending this message
- (void)newTimerThread {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
	self.aTimer = [[NSTimer scheduledTimerWithTimeInterval: kPlaybackTimerIntervalInSeconds
									  target: self
									selector: @selector(timerTick)
									userInfo: nil
									 repeats: YES] retain];
	
	[runLoop run];
	[pool release];
}

- (void)timerTick {
	
	if ([self.timerThread isCancelled]) {
		[self.aTimer invalidate];
		[self.timerThread release];
		return;
	}
	bytePosition = writeSingleChannelRingBufferDataToFileAsSInt16(self.fileHandle, audioConverter, self.asm.secondStageBuffer, outBuffer, bytePosition);
}
*/





@end
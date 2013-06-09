//
//  ScanViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanResultViewController.h"
#import <QRCodeReader.h>
#import <Decoder.h>
#import <TwoDDecoderResult.h>
#import "Utilities.h"
#import <AVFoundation/AVFoundation.h>
#import <DecoderDelegate.h>

@interface ScanViewController (AVCaptureVideoDataOutputSampleBufferDelegate)<AVCaptureVideoDataOutputSampleBufferDelegate>
-(void)decodeImage:(UIImage*)image;
- (void)setupCaptureSession;
@end

@interface ScanViewController(DecoderDelegate)<DecoderDelegate>

@end

@implementation ScanViewController

-(id)init
{
    self = [super init];
    if (self)
    {
        isFound = NO;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        isFound = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isFound = NO;
    }
    return self;
}

-(void)dealloc
{
    safeRelease(_session);
    safeRelease(_decoder);
    safeRelease(_points);
    safeRelease(_readers);
    [super dealloc];
}

static BOOL isFound = NO;
+(BOOL)isFound
{
    return isFound;
}

-(void)btnClicked:(id)sender
{
//    [nav popViewControllerAnimated:YES];
//    isFound = YES;
    UIImage * image = [UIImage imageNamed:@"sample2.jpeg"];
    [self decodeImage:image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isDecoding = NO;
    isFound = NO;
    
    QRCodeReader * reader = [[QRCodeReader alloc] init];
    _readers = [[NSSet alloc] initWithObjects:reader,nil];
    [reader release];
    
    _decoder = [[Decoder alloc] init];
    [_decoder setDelegate:self];
    [_decoder setReaders:_readers];
    
    [self setupCaptureSession];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    nav = self.navigationController;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_session startRunning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_session stopRunning];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView animateWithDuration:4 delay:3 options:UIViewAnimationOptionTransitionNone animations:^{} completion:^(BOOL finished)
    {
        if (finished && isFound)
        {
            UIStoryboard * storyBoard = self.storyboard;
            ScanResultViewController * result = [storyBoard instantiateViewControllerWithIdentifier:@"resultViewController"];
            
            result.fullName = [_resultDict objectForKey:kFullName];
            result.phoneNumber = [_resultDict objectForKey:kPhoneNumber];
            result.email = [_resultDict objectForKey:kEmail];
            result.personalSite = [_resultDict objectForKey:kPersonalSite];
            result.address = [_resultDict objectForKey:kAddress];
            result.image = _resultImage;
            
            [nav pushViewController:result animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate implementation
@implementation ScanViewController (AVCaptureVideoDataOutputSampleBufferDelegate)

// Create and configure a capture session and start it running
- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
        [session release];
        return;
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    // Specify the pixel format
    output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    //    output.minFrameDuration = CMTimeMake(1, 15);
    AVCaptureConnection * connection = [output connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoMinFrameDuration:CMTimeMake(1, 30)];
    
    // Assign session to an ivar.
    _session = [session retain];
    [session release];
    
    
    
    // Create video preview layer and add it to the UI
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    
    CALayer *viewLayer = [self.view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [self.view bounds];
    [newCaptureVideoPreviewLayer setFrame:bounds];
    
    if ([[newCaptureVideoPreviewLayer connection] isVideoOrientationSupported]) {
        [[newCaptureVideoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    
//    [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
    
    [newCaptureVideoPreviewLayer release];
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"captured");
    if (!_isDecoding)
    {
        [self decodeImage:[self imageFromSampleBuffer:sampleBuffer]];
    }
    
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

-(void)decodeImage:(id)image
{
    if (image)
    {
        _isDecoding = YES;
        [_decoder decodeImage:image];
    }
}

@end

#pragma mark - Decoder delegate implementation
@implementation ScanViewController(DecoderDelegate)
- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset
{
    NSLog(@"will decode image");
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    NSLog(@"found code %@", result.text);
    [_session stopRunning];
    //TODO: convert result into dictionary and set it to scanResult view
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.plist"];
    [result.text writeToFile:docPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:docPath];
    if (dict)
    {
        //TODO: correct format ==> show it to the result view
        _resultDict = [dict retain];
        _resultImage = [image retain];
        [nav popViewControllerAnimated:YES];
        isFound = YES;
    }
    else
    {
        //TODO: unknown format ==> continue scanning or show the data in a text view only
        _resultImage = [image retain];
        [nav popViewControllerAnimated:YES];
        isFound = YES;
    }
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    NSLog(@"failed to decode image");
    _isDecoding = NO;
    isFound = NO;
}

- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point
{
    NSLog(@"found points when decode image");
}

@end




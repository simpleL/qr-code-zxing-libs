//
//  ViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/20/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ViewController.h"
#import <QRCodeReader.h>
#import <ZXingWidgetController.h>
#import <TwoDDecoderResult.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomeImageView.h"
#import "Utilities.h"
#import "QRCodeGenerator.h"
#import "ScanView.h"

#import <zxing/ReaderException.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>

#import "AVCamCaptureManager.h"

@interface ViewController (AVCaptureVideoDataOutputSampleBufferDelegate)<AVCaptureVideoDataOutputSampleBufferDelegate>
-(void)decodeImage:(UIImage*)image;
- (void)setupCaptureSession;
@end

@implementation ViewController

@synthesize shouldDecode;
@synthesize session = _session;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [self.view addSubview:_scanView];
        [_scanView setCenter:CGPointMake(160, -240)];
        _isScanViewEnable = NO;
        _decoder = nil;
        _points = nil;
        // Do any additional setup after loading the view, typically from a nib.
        QRCodeReader * reader = [[QRCodeReader alloc] init];
        _readers = [[NSSet alloc] initWithObjects:reader,nil];
        [reader release];
        
        safeRelease(_decoder);
        _decoder = [[Decoder alloc] init];
        [_decoder setDelegate:self];
        [_decoder setReaders:_readers];
    }
    return self;
}

-(void)dealloc
{
    safeRelease(_decoder);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCaptureSession];
    
    // Create video preview layer and add it to the UI
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    
    CALayer *viewLayer = [_scanView layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [_scanView bounds];
    [newCaptureVideoPreviewLayer setFrame:bounds];
    
    if ([[newCaptureVideoPreviewLayer connection] isVideoOrientationSupported]) {
        [[newCaptureVideoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    
    [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
    
    [newCaptureVideoPreviewLayer release];
        
    self.shouldDecode = NO;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - override methods
// disable autorotation
-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - actions
-(void)startDecode:(id)sender
{
    safeRelease(_points);
    _points = [[NSMutableArray alloc] init];
    
    Decoder * decoder = [[Decoder alloc] init];
    [decoder setDelegate:self];
    [decoder setReaders:_readers];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.jpg"];
    
//    NSLog(@"%@", docPath);
    UIImage * image = [UIImage imageWithContentsOfFile:docPath];
    [decoder decodeImage:image];
}

-(void)startEncode:(id)sender
{
    UIImage * image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@", [_textView text]] imageSize:200];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.jpg"];
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    [imgData writeToFile:docPath atomically:NO];
    [(CustomeImageView*)self.view setImage:image];
}

-(void)cancelScan:(id)sender
{
    void (^runOutScanView)(void) = ^(void)
    {
        [_scanView setCenter:CGPointMake(160, -240)];
    };
    
    void (^finishRunOut)(BOOL finished) = ^(BOOL finished)
    {
        [_scanView setHidden:finished];
        [_btnScan setHidden:!finished];
    };
    
    [_btnScan setHidden:YES];
    _isScanViewEnable = NO;
    [_session stopRunning];
    self.shouldDecode = NO;
    safeRelease(_decoder);
    [UIView animateWithDuration:.4f animations:runOutScanView completion:finishRunOut];
}

-(void)startScan:(id)sender
{    
    void (^flyInScanView)(void) = ^(void)
    {
        [_scanView setCenter:CGPointMake(160, 240)];
    };
    
    void (^finishFlyIn)(BOOL finished) = ^(BOOL finished)
    {
        _isScanViewEnable = YES;
        if (_isScanViewEnable)
        {           
            self.shouldDecode = YES;
        }
    };
    // create new decoder
    safeRelease(_decoder);
    _decoder = [[Decoder alloc] init];
    [_decoder setDelegate:self];
    [_decoder setReaders:_readers];
    
    [_session startRunning];
    [_scanView setHidden:NO];
    [UIView animateWithDuration:.4f animations:flyInScanView completion:finishFlyIn];
}

#pragma mark - Implements decoder delegate
- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset
{
//    NSLog(@"will decode image");
}
- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    [_textView setText:[result text]];
    
    void (^runOutScanView)(void) = ^(void)
    {
        [_scanView setCenter:CGPointMake(160, -240)];
    };
    
    void (^finishRunOut)(BOOL finished) = ^(BOOL finished)
    {
        [_scanView setHidden:finished];
        [_btnScan setHidden:!finished];
    };
    
    [_btnScan setHidden:YES];
    _isScanViewEnable = NO;
    [_session stopRunning];
    self.shouldDecode = NO;
    safeRelease(_decoder);
    [UIView animateWithDuration:.4f animations:runOutScanView completion:finishRunOut];
}
- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    if (_isScanViewEnable)
    {
        safeRelease(_decoder);
        _decoder = [[Decoder alloc] init];
        [_decoder setDelegate:self];
        [_decoder setReaders:_readers];
        self.shouldDecode = YES;
    }
}
- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point
{
//    NSLog(@"found possible result point after decoding image");
//    NSLog(@"(%d, %d)", (int)point.x, (int)point.y);
//    [_points addObject:[NSValue valueWithCGPoint:point]];
}

@end


@implementation ViewController (AVCaptureVideoDataOutputSampleBufferDelegate)

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
    [self setSession:session];
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
//    NSLog(@"captured");
    if (self.shouldDecode)
    {
        // Create a UIImage from the sample buffer data
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        if (!image)
        {
            NSLog(@"nil");
        }else
        {
            self.shouldDecode = NO;
            try {
                [self decodeImage:image];
            } catch (zxing::ReaderException * e)
            {
                NSLog(@"%@", [NSString stringWithUTF8String:e->what()]);
            }        
        }
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
//    safeRelease(_points);
//    _points = [[NSMutableArray alloc] init];
    [_decoder decodeImage:image]; 
}

@end


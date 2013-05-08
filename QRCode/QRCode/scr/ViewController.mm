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
#import "QRCodeView.h"

#import <zxing/ReaderException.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>

#import "AVCamCaptureManager.h"

#define BUTTON_TAG_START_SCAN           1
#define BUTTON_TAG_CANCEL_SCAN          2
#define BUTTON_TAG_MY_INFO              3
#define BUTTON_TAG_CONTACT_LIST         4
#define BUTTON_TAG_MY_INFO_BACK         5
#define BUTTON_TAG_MY_INFO_SAVE         6
#define BUTTON_TAG_RESULT_CANCEL        7
#define BUTTON_TAG_RESULT_SAVE          8
#define BUTTON_TAG_CONTACT_INFO_BACK    9
#define BUTTON_TAG_CONTACT_INFO_QRIMAGE 10
#define BUTTON_TAG_QRCODE_BACK          11
#define BUTTON_TAG_QRCODE_SWITCH        12


typedef enum
{
    FlyDirectionLeft,
    FlyDirectionRight,
    FlyDirectionTop,
    FlyDirectionBottom
}FlyDirection;
#define FLY_FINISHED void (^)(BOOL finished)


#pragma mark - PROTOTYPE DECLARATION
@interface ViewController (AVCaptureVideoDataOutputSampleBufferDelegate)<AVCaptureVideoDataOutputSampleBufferDelegate>
-(void)decodeImage:(UIImage*)image;
- (void)setupCaptureSession;
@end

@interface ViewController (privateMethods)
-(void)preloadHUD;
-(void)startFlyIn:(UIView*)theView  completed:(FLY_FINISHED)completion;
-(void)startFlyOutTo:(FlyDirection)direction view:(UIView*)theView  completed:(FLY_FINISHED)completion;
@end

@interface ViewController (listContactView)<UITableViewDataSource, UISearchBarDelegate>
-(void)initGesture;
-(void)swipeGesture;
@end

#pragma mark - IMPLEMENTATION
@implementation ViewController
@synthesize screenH, screenW;
@synthesize shouldDecode;
@synthesize session = _session;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        screenW = [[UIScreen mainScreen] bounds].size.width;
        screenH = [[UIScreen mainScreen] bounds].size.height;
        _lastButtonPressedTag = 0;
        [self preloadHUD];
        [self initGesture];
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
    safeRelease(_readers);
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

-(void)buttonClicked:(id)sender
{
    UIView * btn = (UIView*)sender;
    
    if (btn.tag == BUTTON_TAG_START_SCAN)
    {        
        void (^finishFlyIn)(BOOL finished) = ^(BOOL finished)
        {
//TODO: uncomment these
            _isScanViewEnable = YES;
            if (_isScanViewEnable)
            {
                self.shouldDecode = YES;
            }
            
//            // -----------------------------create temporary result
////TODO: remove the code below
//            void (^runOutScanView)(void) = ^(void)
//            {
//                [_scanView setCenter:CGPointMake(160, -240)];
//            };
//            
//            void (^finishRunOut)(BOOL finished) = ^(BOOL finished)
//            {
//                [_scanView setHidden:finished];
//                [_btnScan setEnabled:finished];
//            };
//            
//            [_btnScan setEnabled:NO];
//            _isScanViewEnable = NO;
//            [_session stopRunning];
//            self.shouldDecode = NO;
//            [UIView animateWithDuration:.4f animations:runOutScanView completion:finishRunOut];
//
//            // ------------------------------end temporary
        };
        [_session startRunning];
        [_scanView setHidden:NO];        
        [self startFlyIn:_scanView completed:finishFlyIn];
    }
    
    if (btn.tag == BUTTON_TAG_CANCEL_SCAN)
    {        
        void (^finishRunOut)(BOOL finished) = ^(BOOL finished)
        {
            [_scanView setHidden:finished];
            [_btnScan setEnabled:finished];
        };
        
        _isScanViewEnable = NO;
        [_session stopRunning];
        self.shouldDecode = NO;
        [self startFlyOutTo:FlyDirectionTop view:_scanView completed:finishRunOut];
    }
    
    if (btn.tag == BUTTON_TAG_CONTACT_INFO_BACK)
    {
        
    }
    
    if (btn.tag == BUTTON_TAG_CONTACT_INFO_QRIMAGE)
    {
        
    }
    
    if (btn.tag == BUTTON_TAG_CONTACT_LIST)
    {
        [self startFlyIn:_contactListView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_MY_INFO)
    {                
        [self startFlyIn:_myInfoView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_MY_INFO_BACK)
    {
        [self startFlyOutTo:FlyDirectionLeft view:_myInfoView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_MY_INFO_SAVE)
    {
        // this function do nothing
//        [self startFlyIn:_contactInfoView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_QRCODE_BACK)
    {
        
    }
    
    if (btn.tag == BUTTON_TAG_QRCODE_SWITCH)
    {
        
    }
    
    if (btn.tag == BUTTON_TAG_RESULT_CANCEL)
    {
        
    }
    
    if (btn.tag == BUTTON_TAG_RESULT_SAVE)
    {
        
    }
    
    // set last tag pressed button
    _lastButtonPressedTag = btn.tag;
}

#pragma mark - Decoder delegate implementation
- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset
{
//    NSLog(@"will decode image");
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    [_textView setText:[result text]];
    
    void (^finishRunOut)(BOOL finished) = ^(BOOL finished)
    {
        [_scanView setHidden:finished];
        [_btnScan setEnabled:finished];
    };
    
    [_btnScan setEnabled:NO];
    _isScanViewEnable = NO;
    [_session stopRunning];
    self.shouldDecode = NO;
    [self startFlyOutTo:FlyDirectionTop view:_scanView completed:finishRunOut];
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    if (_isScanViewEnable)
    {
//        safeRelease(_decoder);
//        _decoder = [[Decoder alloc] init];
//        [_decoder setDelegate:self];
//        [_decoder setReaders:_readers];
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


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate implementation
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
    [self setSession:session];
    [session release];
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


@implementation ViewController (privateMethods)

-(void)startFlyIn:(UIView *)theView completed:(void (^)(BOOL))completion
{
    void (^flyIn)(void) = ^(void)
    {        
        [theView setCenter:CGPointMake(screenW/2, screenH/2)];
        [theView setAlpha:1];
    };
    [UIView animateWithDuration:.4f animations:flyIn completion:completion];
}

-(void)startFlyOutTo:(FlyDirection)direction view:(UIView *)theView completed:(void (^)(BOOL))completion
{
    void (^flyOut)(void) = ^(void)
    {
        switch (direction) {
            case FlyDirectionBottom:
            {
                [theView setCenter:CGPointMake(screenW/2, 3*screenH/2)];
            }
                break;
            case FlyDirectionLeft:
            {
                [theView setCenter:CGPointMake(-screenW/2, screenH/2)];
            }
                break;
            case FlyDirectionRight:
            {
                [theView setCenter:CGPointMake(3*screenW/2, screenH/2)];
            }
                break;
            case FlyDirectionTop:
            {
                [theView setCenter:CGPointMake(screenW/2, -screenH/2)];
            }
                break;
            default:
                break;
        }
        [theView setAlpha:0];
    };
    [UIView animateWithDuration:.4f animations:flyOut completion:completion];
}

-(void)preloadHUD
{    
    // my info view
    [self.view addSubview:_myInfoView];
    [_myInfoView setCenter:CGPointMake(-screenW/2, screenH/2)];
    [_myInfoView setAlpha:0];
    
    // scan view
    [self.view addSubview:_scanView];
    [_scanView setCenter:CGPointMake(screenW/2, -screenH/2)];
    [_scanView setAlpha:0];
    _isScanViewEnable = NO;
    
    // scan result view
    [self.view addSubview:_scanResultView];
    [_scanResultView setCenter:CGPointMake(screenW/2, 3*screenH/2)];
    [_scanResultView setAlpha:0];
    
    // contact info view
    [self.view addSubview:_contactInfoView];
    [_contactInfoView setCenter:CGPointMake(3*screenW/2, screenH/2)];
    [_contactInfoView setAlpha:0];
    
    // QRCode view
    [self.view addSubview:_qrcodeView];
    [_qrcodeView setCenter:CGPointMake(3*screenW/2, screenH/2)];
    [_qrcodeView setAlpha:0];
    
    // contact list view
    [self.view addSubview:_contactListView];
    [_contactListView setCenter:CGPointMake(3*screenW/2, screenH/2)];
    [_contactListView setAlpha:0];
}

@end


@implementation ViewController (listContactView)

-(void)initGesture
{
    _swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture)];
    [self.view addGestureRecognizer:_swipe];
}

-(void)swipeGesture
{
    [self startFlyOutTo:FlyDirectionRight view:_contactListView completed:nil];
}

@end

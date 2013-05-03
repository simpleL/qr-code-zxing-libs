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

#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>

#import "AVCamCaptureManager.h"

@interface ViewController (AVCamCaptureManagerDelegate)<AVCamCaptureManagerDelegate>

@end

@implementation ViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [self.view addSubview:_scanView];
        [_scanView setCenter:CGPointMake(160, -240)];
        _isScanViewEnable = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    if ([self captureManager] == nil) {
        AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
        [self setCaptureManager:manager];
        [manager release];
        
        [[self captureManager] setDelegate:self];
        
        if ([[self captureManager] setupSession]) {
            // Create video preview layer and add it to the UI
            AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
            UIView *view = _scanView;
            CALayer *viewLayer = [view layer];
            [viewLayer setMasksToBounds:YES];
            
            CGRect bounds = [view bounds];
            [newCaptureVideoPreviewLayer setFrame:bounds];
            
            if ([[newCaptureVideoPreviewLayer connection] isVideoOrientationSupported]) {
                [[newCaptureVideoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
            }
            
            [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            
            [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
            
            [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
            [newCaptureVideoPreviewLayer release];
            
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[[self captureManager] session] startRunning];
            });
            [_captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
        }
    }
    
    [super viewDidLoad];
    _points = nil;
	// Do any additional setup after loading the view, typically from a nib.
    QRCodeReader * reader = [[QRCodeReader alloc] init];
    _readers = [[NSSet alloc] initWithObjects:reader,nil];
    [reader release];
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
            [_captureManager captureStillImage];
        }        
    };
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
    NSLog(@"%@", [result text]);
    [_textView setText:[result text]];
    [(CustomeImageView*)self.view setPoints:_points];
    
    ALAssetsLibraryWriteImageCompletionBlock completionBlock = ^(NSURL *assetURL, NSError *error)
    {
        if (error)
        {
            [self captureManager:_captureManager didFailWithError:error];
        }
    };
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[_captureManager.capturedImage CGImage] orientation:(ALAssetOrientation)[_captureManager.capturedImage imageOrientation] completionBlock:completionBlock];
    
    [library release];
    
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
    [UIView animateWithDuration:.4f animations:runOutScanView completion:finishRunOut];
}
- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    NSLog(@"fail to decode b/c: %@", reason);
    if (_isScanViewEnable)
    {
        [_captureManager captureStillImage];
    }
}
- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point
{
//    NSLog(@"found possible result point after decoding image");
//    NSLog(@"(%d, %d)", (int)point.x, (int)point.y);
    [_points addObject:[NSValue valueWithCGPoint:point]];
}

@end


@implementation ViewController (AVCamCaptureManagerDelegate)

- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        if (_isScanViewEnable)
        {
            [_captureManager captureStillImage];
        }
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
//    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
//        [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Toggle recording button stop title")];
//        [[self recordButton] setEnabled:YES];
//    });
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager
{
//    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
//        [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Toggle recording button record title")];
//        [[self recordButton] setEnabled:YES];
//    });
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIImage * image = _captureManager.capturedImage;
        
        safeRelease(_points);
        _points = [[NSMutableArray alloc] init];
        
        Decoder * decoder = [[Decoder alloc] init];
        [decoder setDelegate:self];
        [decoder setReaders:_readers];
        [decoder decodeImage:image];
    });
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
//	[self updateButtonStates];
}

@end



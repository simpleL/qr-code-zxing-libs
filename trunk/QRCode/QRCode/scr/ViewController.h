//
//  ViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/20/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DecoderDelegate.h>

@class ScanView;
@class AVCamCaptureManager;
@class AVCaptureVideoPreviewLayer;
@class AVCaptureSession;
@class Decoder;

@interface ViewController : UIViewController<DecoderDelegate>
{
    NSSet               *_readers;
    NSMutableArray      *_points;
    Decoder             *_decoder;
    
    IBOutlet UIButton       * _btnStartDecode;
    IBOutlet UIButton       * _btnStartEncode;
    IBOutlet UITextView     * _textView;
    IBOutlet UIImageView    * _imageView;
    
    
    IBOutlet UIButton           * _btnScan;
    IBOutlet ScanView           * _scanView;
    IBOutlet UIBarButtonItem    * _btnCancel;
    BOOL                        _isScanViewEnable;
    
    AVCaptureSession            *_session;
    UIImage * tem;
}

@property (nonatomic, retain) AVCaptureSession * session;
@property BOOL shouldDecode;

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;


-(IBAction)startDecode:(id)sender;
-(IBAction)startEncode:(id)sender;
-(IBAction)cancelScan:(id)sender;
-(IBAction)startScan:(id)sender;

@end

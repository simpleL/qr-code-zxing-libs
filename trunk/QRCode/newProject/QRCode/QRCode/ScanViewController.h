//
//  ScanViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class Decoder;

@interface ScanViewController : UIViewController
{
    UINavigationController * nav;
    
    NSSet               *_readers;
    NSMutableArray      *_points;
    Decoder             *_decoder;
    
    AVCaptureSession    *_session;
    
    BOOL                _isDecoding;
}

+(BOOL)isFound;
-(IBAction)btnClicked:(id)sender;
@end

//
//  ScanViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DecoderDelegate.h>

@interface ScanViewController : UIViewController<DecoderDelegate>
{
    UINavigationController * nav;
    
    NSSet               *_readers;
    NSMutableArray      *_points;
    Decoder             *_decoder;
}

+(BOOL)isFound;
-(IBAction)btnClicked:(id)sender;
@end

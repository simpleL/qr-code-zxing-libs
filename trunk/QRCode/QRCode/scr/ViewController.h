//
//  ViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/20/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DecoderDelegate.h>

@interface ViewController : UIViewController<DecoderDelegate>
{
    NSSet               *_readers;
    NSMutableArray      *_points;
    
    IBOutlet UIButton       * _btnStartDecode;
    IBOutlet UITextField    * _textField;
    IBOutlet UIImageView    * _imageView;
}
-(IBAction)startDecode:(id)sender;


@end

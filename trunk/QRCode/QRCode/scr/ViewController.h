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
    IBOutlet UIButton * _btnStartDecode;
    NSSet               *_readers;
    IBOutlet UITextField * _textField;
}
-(IBAction)startDecode:(id)sender;


@end

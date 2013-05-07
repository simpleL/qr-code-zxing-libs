//
//  QRCodeView.h
//  QRCode
//
//  Created by ba phuoc on 5/8/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeView : UIView
{
    UIImage     *_qrImage;
}

-(void)setQRCodeImage:(UIImage*)image;
@end

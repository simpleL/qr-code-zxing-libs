//
//  CustomeImageView.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeImageView : UIView
{
    NSArray         *_points;
    UIImage         *_image;
}

-(void)setPoints:(NSArray*)points;
-(void)setImage:(UIImage*)image;

@end

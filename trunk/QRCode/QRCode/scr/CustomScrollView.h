//
//  CustomScrollView.h
//  QRCode
//
//  Created by ba phuoc on 5/20/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomScrollView : UIScrollView
{
    UITextField         *_fullName;
    UITextField         *_phoneNumber;
    UITextField         *_email;
    UITextField         *_address;
    UITextField         *_personalSite;
    UITextView          *_others;
    NSMutableDictionary *_dict;
    
    UITextField         *_focusingTextField;
}

-(void)setDict:(NSMutableDictionary*)dict;
-(NSMutableDictionary*)getDict;
-(UIImage*)getQRCode;
@end

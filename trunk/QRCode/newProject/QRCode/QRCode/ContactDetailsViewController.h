//
//  ContactDetailsViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
}

@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * personalSite;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * imageName;

@end

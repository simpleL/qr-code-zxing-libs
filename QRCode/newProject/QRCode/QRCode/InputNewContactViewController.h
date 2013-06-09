//
//  InputNewContactViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputNewContactViewController : UIViewController
{}
@property (nonatomic, retain) NSString * fullName, * phoneNumber, *email, *personalSite, *address;
@property (nonatomic, retain) IBOutlet UITableView * table;
@property BOOL isAddNew;

@end

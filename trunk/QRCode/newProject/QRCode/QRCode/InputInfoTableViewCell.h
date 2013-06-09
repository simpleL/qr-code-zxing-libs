//
//  InputInfoTableViewCell.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputInfoTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, retain) IBOutlet UITextField * fullName;
@property (nonatomic, retain) IBOutlet UITextField * phoneNumber;
@property (nonatomic, retain) IBOutlet UITextField * email;
@property (nonatomic, retain) IBOutlet UITextField * personalSite;
@property (nonatomic, retain) IBOutlet UITextField * address;
@end

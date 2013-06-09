//
//  ContactListTableViewCell.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListTableViewCell : UITableViewCell
{
    IBOutlet UILabel        *_lbFullName;
    IBOutlet UILabel        *_lbPhoneNumber;
    IBOutlet UILabel        *_lbEmail;
    IBOutlet UILabel        *_lbPersonalSite;
    IBOutlet UITextView     *_tvAddress;
    
    IBOutlet UIButton       *_btnCall;
    IBOutlet UIButton       *_btnGoToSite;
    IBOutlet UIButton       *_btnMailTo;
    IBOutlet UIButton       *_btnDetails;
}
@property int row;
+(int)getRow;
-(void) setInfoWithFullName:(NSString*)fullName phoneNumber:(NSString*)phoneNumber email:(NSString*)email personalSite:(NSString*)personalSite address:(NSString*)address;
-(IBAction)btnClicked:(id)sender;

@end

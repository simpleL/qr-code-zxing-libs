//
//  ScanResultTableViewCell.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanResultTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, retain) IBOutlet UIImageView * image;
@property (nonatomic, retain) IBOutlet UILabel * fullName;
@property (nonatomic, retain) IBOutlet UILabel * phoneNumber;
@property (nonatomic, retain) IBOutlet UILabel * email;
@property (nonatomic, retain) IBOutlet UILabel * personalSite;
@property (nonatomic, retain) IBOutlet UITextView   * address;
@property (nonatomic, retain) IBOutlet UIButton * btnCall, * btnEmail, *btnGoToSite;

-(IBAction)btnClicked:(id)sender;
@end

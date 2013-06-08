//
//  ContactListTableViewCell.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ContactListTableViewCell.h"

@implementation ContactListTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _lbFullName.text = @"Nguyen Ba Phuoc";
        _lbPhoneNumber.text = @"01689971684";
        _lbEmail.text = @"default@email.com";
        _lbPersonalSite.text = @"http://site.com";
        _tvAddress.text = @"no address";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfoWithFullName:(NSString *)fullName phoneNumber:(NSString *)phoneNumber email:(NSString *)email personalSite:(NSString *)personalSite address:(NSString *)address
{
    _lbFullName.text = fullName;
    _lbPhoneNumber.text = phoneNumber;
    _lbEmail.text = email;
    _lbPersonalSite.text = personalSite;
    _tvAddress.text = address;
}

-(void)btnClicked:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    if (btn == _btnCall)
    {
        NSLog(@"call to number %@", _lbPhoneNumber.text);
    }
    if (btn == _btnGoToSite)
    {
        NSLog(@"go to site %@", _lbPersonalSite.text);
    }
    if (btn == _btnMailTo)
    {
        NSLog(@"mail to %@", _lbEmail.text);
    }
}

@end

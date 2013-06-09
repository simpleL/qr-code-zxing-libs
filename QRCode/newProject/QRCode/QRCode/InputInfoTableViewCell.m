//
//  InputInfoTableViewCell.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "InputInfoTableViewCell.h"

@implementation InputInfoTableViewCell

@synthesize fullName, phoneNumber, email, personalSite, address;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

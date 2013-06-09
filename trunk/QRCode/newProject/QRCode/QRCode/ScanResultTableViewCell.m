//
//  ScanResultTableViewCell.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ScanResultTableViewCell.h"

@implementation ScanResultTableViewCell

@synthesize image, fullName, phoneNumber, email, personalSite, address, btnCall, btnEmail, btnGoToSite;

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


-(void)btnClicked:(id)sender
{
    UIButton * btn =(UIButton*)sender;
    if (btn==btnCall)
    {
        NSLog(@"call");
    }
    if (btn == btnEmail)
    {
        NSLog(@"email");
    }
    if(btn == btnGoToSite)
    {
        NSLog(@"go to site");
    }
}

@end

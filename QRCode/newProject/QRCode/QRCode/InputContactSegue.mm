//
//  InputContactSegue.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "InputContactSegue.h"
#import "InputInfoTableViewCell.h"
#import "InputNewContactViewController.h"
#import "ContactDetailsViewController.h"
#import "Utilities.h"
#import "FileManager.h"
#import "ViewController.h"

@implementation InputContactSegue
-(void)perform
{
    UINavigationController * nav = ((UIViewController*)self.sourceViewController).navigationController;
    //TODO: keep the contact in a dict
    InputNewContactViewController * sourceController = self.sourceViewController;
    UITableView * table = sourceController.table;
    
    NSIndexPath * indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    InputInfoTableViewCell * cell = (InputInfoTableViewCell*)[table cellForRowAtIndexPath:indexPath];
    if (sourceController.isAddNew)
    {
        ContactDetailsViewController * details = self.destinationViewController;
        details.fullName = cell.fullName.text;
        details.phoneNumber = cell.phoneNumber.text;
        details.email = cell.email.text;
        details.personalSite = cell.personalSite.text;
        details.address = cell.address.text;
        
        // create contact dict and insert to the contact list
        NSDictionary * dict = createDictWith(cell.fullName.text, cell.phoneNumber.text, cell.email.text, cell.personalSite.text, cell.address.text);
        UIImage * image = encode(dict);
        [FileManager insertNewContact:dict withImage:image];
        [nav popViewControllerAnimated:NO];
        [nav pushViewController:self.destinationViewController animated:YES];
    }else
    {
        // save to the my info
        NSMutableDictionary * dict = [FileManager getMyContactInfo];
        if (dict==nil)
        {
            dict = [[NSMutableDictionary alloc] init];
        }
        if (cell.fullName.text)
        {
            [dict setObject:cell.fullName.text forKey:kFullName];
        }
        if (cell.phoneNumber.text)
        {
            [dict setObject:cell.phoneNumber.text forKey:kPhoneNumber];
        }
        if (cell.email.text)
        {
            [dict setObject:cell.email.text forKey:kEmail];
        }
        if (cell.personalSite.text)
        {
            [dict setObject:cell.personalSite.text forKey:kPersonalSite];
        }
        if (cell.address.text)
        {
            [dict setObject:cell.address.text forKey:kAddress];
        }
        [FileManager saveMyContactInfo:dict];
        UIImage * image = encode(dict);
        [ViewController setImage:image];
        // load new qr code image
        [nav popToRootViewControllerAnimated:YES];
    }
}
@end

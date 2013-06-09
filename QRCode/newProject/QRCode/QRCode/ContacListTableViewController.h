//
//  ContacListTableViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContacListTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
{
    IBOutlet UITableView             *_tableViewListContacts;
}

@end

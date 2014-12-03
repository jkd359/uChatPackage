//
//  ContactsTableViewController.h
//  UChat
//
//  Created by Joel on 20/08/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

@interface ContactsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *contactList;
@property (strong, nonatomic) NSMutableDictionary *dictOfPerson;

@end

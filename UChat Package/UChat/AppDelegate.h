//
//  AppDelegate.h
//  UChat
//
//  Created by Joel on 20/08/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *contactListFirstNames;
@property (strong, nonatomic) NSMutableArray *contactListLastNames;
@property (strong, nonatomic) NSMutableArray *contactListMobiles;
@property (strong, nonatomic) NSMutableArray *contactListEmails;
@property (strong, nonatomic) NSArray *indexListEnglish;


@end

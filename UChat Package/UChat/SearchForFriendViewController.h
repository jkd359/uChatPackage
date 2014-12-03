//
//  SearchForFriendViewController.h
//  UChat
//
//  Created by Joel on 16/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchForFriendViewController : UIViewController
- (IBAction)searchButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSearchField;
- (IBAction)cancelButton:(id)sender;

@property (strong, nonatomic) NSString *searchTermString;

@end

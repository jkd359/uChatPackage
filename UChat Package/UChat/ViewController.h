//
//  ViewController.h
//  UChat
//
//  Created by Joel on 20/08/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)logOutButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textFielduChatID;
- (IBAction)saveButton:(id)sender;
@property (strong, nonatomic) NSString *uChatIDString;

@end

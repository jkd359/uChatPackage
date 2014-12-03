//
//  LogInViewController.h
//  UChat
//
//  Created by Joel on 8/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface LogInViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
- (IBAction)cancelButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textfieldMobileEmailUserName;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPassword;
- (IBAction)logInButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *logInButton;
- (IBAction)forgotPassButton:(id)sender;

@end

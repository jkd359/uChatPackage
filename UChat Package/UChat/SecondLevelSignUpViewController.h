//
//  SecondLevelSignUpViewController.h
//  UChat
//
//  Created by Joel on 11/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ViewController.h"


@interface SecondLevelSignUpViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSString *verificationNumberString;
@property (strong, nonatomic) NSString *mobileNumberString;
@property (strong, nonatomic) NSString *alternateUserName;

@property (strong, nonatomic) NSString *emailString;
- (void)sendSMSToNumber:(NSString *)number;
- (IBAction)doneButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textFieldConfirm;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@end

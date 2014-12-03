//
//  SignUpViewController.h
//  UChat
//
//  Created by Joel on 8/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryListViewController.h"

@interface SignUpViewController : UIViewController <CountryListViewDelegate, UITextFieldDelegate>
- (IBAction)cancelButton:(id)sender;
- (IBAction)countryButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *countryOutletButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UILabel *regionSelectionLabel;
@property (strong, nonatomic) IBOutlet UITextField *textfieldCountryCode;
@property (strong, nonatomic) IBOutlet UITextField *textfieldMobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
- (IBAction)signUpButton:(id)sender;

@end

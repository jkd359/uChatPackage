//
//  SignUpViewController.m
//  UChat
//
//  Created by Joel on 8/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "SignUpViewController.h"
#import "SecondLevelSignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize countryOutletButton, regionSelectionLabel, textfieldCountryCode, textFieldEmail, textfieldMobileNumber, signUpButton;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //Set sign up button to be enabled and disabled correctly when clicking between views
    if (textfieldCountryCode.text.length > 1 && textfieldMobileNumber.text.length > 0) {
        
        [self.signUpButton setEnabled:YES];
        
    } else [self.signUpButton setEnabled:NO];

    //UI customisation
    self.navigationController.navigationBarHidden = NO;
    
    countryOutletButton.layer.cornerRadius = 6;
    countryOutletButton.layer.borderWidth = 1;
    countryOutletButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    textfieldMobileNumber.layer.cornerRadius = 6;
    textfieldMobileNumber.layer.borderWidth = 1;
    textfieldMobileNumber.layer.borderColor = [UIColor grayColor].CGColor;
    
    textFieldEmail.layer.cornerRadius = 6;
    textFieldEmail.layer.borderWidth = 1;
    textFieldEmail.layer.borderColor = [UIColor grayColor].CGColor;
    
    textfieldCountryCode.layer.cornerRadius = 6;
    textfieldCountryCode.layer.borderWidth = 1;
    textfieldCountryCode.layer.borderColor = [UIColor grayColor].CGColor;
    
}

//Continuously update sign up button from text in textfields
- (void)textFieldEmailDidChange {
    
    if (textFieldEmail.text.length > 0) {
        
        [self.signUpButton setEnabled:YES];
        
        [textfieldMobileNumber setEnabled:NO];
        [textfieldMobileNumber setAlpha:0.3f];
        [textfieldCountryCode setEnabled:NO];
        [textfieldCountryCode setAlpha:0.3f];
        [textfieldMobileNumber setText:nil];
        
    } else if (textFieldEmail.text.length <= 0) {
        
        [self.signUpButton setEnabled:NO];
        
        [textfieldMobileNumber setEnabled:YES];
        [textfieldMobileNumber setAlpha:1.0f];
        [textfieldCountryCode setEnabled:YES];
        [textfieldCountryCode setAlpha:1.0f];
    }
    
}

//Continuously update sign up button from text in textfields
- (void)textFieldMobileDidChange {
    
    if (textfieldMobileNumber.text.length > 0 && textfieldCountryCode.text.length > 1) {
        
        [self.signUpButton setEnabled:YES];
        

        
    } else if (textfieldMobileNumber.text.length <= 0 && textfieldCountryCode.text.length <= 1) {
        
        [self.signUpButton setEnabled:NO];
        
    }
}

//Continuously update sign up button from text in textfields
- (void)textFieldCountryCodeDidChange {
    
    if (textfieldMobileNumber.text.length > 0 && textfieldCountryCode.text.length > 1) {
        
        [self.signUpButton setEnabled:YES];
        
    } else if (textfieldMobileNumber.text.length <= 0 && textfieldCountryCode.text.length <= 1) {
        
        [self.signUpButton setEnabled:NO];
        
    }
}

//Continuously update sign up button from text in textfields
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textFieldEmail.text.length > 0) {
        
        [self.signUpButton setEnabled:YES];
        
        [textfieldMobileNumber setEnabled:NO];
        [textfieldMobileNumber setAlpha:0.3f];
        [textfieldCountryCode setEnabled:NO];
        [textfieldCountryCode setAlpha:0.3f];
        [textfieldMobileNumber setText:nil];
        
    } else if (textFieldEmail.text.length <= 0) {
        
        [self.signUpButton setEnabled:NO];
        
        [textfieldMobileNumber setEnabled:YES];
        [textfieldMobileNumber setAlpha:1.0f];
        [textfieldCountryCode setEnabled:YES];
        [textfieldCountryCode setAlpha:1.0f];
        
    } else if (textfieldMobileNumber.text.length > 0 && textfieldCountryCode.text.length > 1) {
        
        [self.signUpButton setEnabled:YES];
        

        
    } else if (textfieldMobileNumber.text.length <= 0 && textfieldCountryCode.text.length <= 1) {
        
        [self.signUpButton setEnabled:NO];
        
        
    }
}

//Continuously update sign up button from text in textfields
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textFieldEmail.text.length > 0) {
        
        [self.signUpButton setEnabled:YES];
        
        [textfieldMobileNumber setEnabled:NO];
        [textfieldMobileNumber setAlpha:0.3f];
        [textfieldCountryCode setEnabled:NO];
        [textfieldCountryCode setAlpha:0.3f];
        [textfieldMobileNumber setText:nil];
        
    } else if (textFieldEmail.text.length <= 0) {
        
        [self.signUpButton setEnabled:NO];
        
        [textfieldMobileNumber setEnabled:YES];
        [textfieldMobileNumber setAlpha:1.0f];
        [textfieldCountryCode setEnabled:YES];
        [textfieldCountryCode setAlpha:1.0f];

        
    } if (textfieldMobileNumber.text.length > 0 && textfieldCountryCode.text.length > 1) {
        
        [self.signUpButton setEnabled:YES];
        
        
    } else if (textfieldMobileNumber.text.length <= 0 && textfieldCountryCode.text.length > 1) {
        
        [self.signUpButton setEnabled:NO];
        
        
    }
    
    [textfieldCountryCode resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //Keep '+' static
    NSRange substringRange = [textField.text rangeOfString:@"+"];
    
    if (range.location >= substringRange.location && range.location < substringRange.location + substringRange.length) {
        return NO;
    }
    
    NSMutableString *attString = [textfieldCountryCode.text mutableCopy];
    
    [textfieldCountryCode setText:attString];
    
    return YES;
}



-(void)hideKeyBoard {
    [textfieldCountryCode resignFirstResponder];
    [textFieldEmail resignFirstResponder];
    [textfieldMobileNumber resignFirstResponder];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textFieldEmail resignFirstResponder];
    
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Continuously update sign up button from text in textfields
    [textFieldEmail addTarget:self action:@selector(textFieldEmailDidChange) forControlEvents:UIControlEventEditingChanged];
    [textfieldMobileNumber addTarget:self action:@selector(textFieldMobileDidChange) forControlEvents:UIControlEventEditingChanged];
    [textfieldCountryCode addTarget:self action:@selector(textFieldCountryCodeDidChange) forControlEvents:UIControlEventEditingChanged];
    
    //Add clear button
    textfieldMobileNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFieldEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //Tap outside keyboard to dismiss
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    //Keeping '+' static
    NSString *fixedString = @"+";
    NSMutableString *attributedString = [[NSMutableString alloc] initWithString:fixedString];
    
    
    [textfieldCountryCode setText:attributedString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButton:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)countryButton:(id)sender {
    
    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
    
    [self presentViewController:cv animated:YES completion:nil];
}

- (void)didSelectCountry:(NSDictionary *)country {
    
    //Handles potential did not select error
    if (!country) {
        regionSelectionLabel.text = nil;
        textfieldCountryCode.text = nil;
    }
    
    //Set labels appropriately on selected region and country code
    NSLog(@"Selected Country: %@", country);
    regionSelectionLabel.text = country[@"name"];
    textfieldCountryCode.text = country[@"dial_code"];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"secondSignUp"]) {
        
        NSString *userName = [NSString stringWithFormat:@"%@%@", textfieldCountryCode.text, textfieldMobileNumber.text];
        
        NSString *emailUserName = [NSString stringWithFormat:@"%@", textFieldEmail.text];
        
        SecondLevelSignUpViewController *vc = [segue destinationViewController];
        
        if (textfieldMobileNumber.text.length > 0) {
            
            //Reference to destination vc
            vc.mobileNumberString = userName;
            vc.alternateUserName = textfieldMobileNumber.text;
            
        } else if (textFieldEmail.text.length > 0) {
            
            vc.emailString = emailUserName;
            
        }

    }
}


- (IBAction)signUpButton:(id)sender {
    
    //Pass information to strings and on next vc will start creating user and then ask for permission for contacts
    if (textfieldMobileNumber.text.length != 0 && textFieldEmail.text.length == 0 && textfieldCountryCode.text.length > 1) {
        
        NSString *mobileNumberString = nil;
        
        if ([textfieldMobileNumber.text hasPrefix:@"0"]) {
            NSRange range = NSMakeRange(0, 1);
            NSString *newMobilePhoneString = [textfieldMobileNumber.text stringByReplacingCharactersInRange:range withString:@"+61"];
            mobileNumberString = newMobilePhoneString;
        } else mobileNumberString = textfieldMobileNumber.text;
        
        NSString *userName = [NSString stringWithFormat:@"%@%@", textfieldCountryCode.text, mobileNumberString];
        NSLog(@"%@",userName);
        

    } else if (textfieldMobileNumber.text.length == 0 && textFieldEmail.text.length != 0 && textfieldCountryCode.text.length < 2) {
        
        NSLog(@"Email:%@", textFieldEmail.text);
        
        
    } else if (textfieldMobileNumber.text.length != 0 && textFieldEmail.text.length == 0 && textfieldCountryCode.text.length < 2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Information!" message:@"Please fill select country region or input region code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
        
        NSLog(@"Please select country region or in put region code");
        
    } else if ((textfieldCountryCode.text.length > 1 && textFieldEmail.text.length == 0 && textfieldMobileNumber.text.length == 0) || (textfieldCountryCode.text.length < 2 && textFieldEmail.text.length == 0 && textfieldMobileNumber.text.length == 0)) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Information!" message:@"Please fill out required information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
        
        NSLog(@"Please fill out required information");
        
    } else if ((textfieldMobileNumber.text.length != 0 && textFieldEmail.text.length != 0) || (textFieldEmail.text.length != 0 && textfieldCountryCode.text.length > 1)) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too Much Information!" message:@"Please only fill in Mobile OR Email, not both" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
        
        
        NSLog(@"Please only fill in Mobile OR Email, not both");
    }
}


@end

//
//  SecondLevelSignUpViewController.m
//  UChat
//
//  Created by Joel on 11/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "SecondLevelSignUpViewController.h"

@interface SecondLevelSignUpViewController ()

@end

@implementation SecondLevelSignUpViewController
@synthesize mobileNumberString, textFieldConfirm, verificationNumberString, emailString, doneButton, headerLabel, alternateUserName;

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
    
    //Tap outside keyboard to dismiss
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    //If mobile field filled out send verification SMS code
    if (mobileNumberString.length > 1) {
        
        [self sendSMSToNumber:mobileNumberString];
        
        NSString *confirmationString = [NSString stringWithFormat:@"A conformation code has been sent to %@", mobileNumberString];
        
        [[[UIAlertView alloc] initWithTitle:@"Verification"
                                    message:confirmationString
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];

    }
    
    //If email field filled out send verification email
    if (emailString.length > 0) {
        
        textFieldConfirm.hidden = YES;
        doneButton.hidden = YES;
        
        headerLabel.text = @"Please verify your account by clicking the link sent to you in the email.";
        
        PFUser *user = [PFUser user];
        user.username = emailString;
        user.email = emailString;
        user.password = @"commandercool1";
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //App working! Inside we go!
                
                NSString *confirmationString = [NSString stringWithFormat:@"A conformation email containing your temporary password has been sent to %@", emailString];
                
                [[[UIAlertView alloc] initWithTitle:@"Verification"
                                            message:confirmationString
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
                [PFUser logOut];
                
                
                
            } else if (error.code == 202) {
                
                [[[UIAlertView alloc] initWithTitle:@"Account already exists!"
                                            message:@"An account already exists with these details. Please try logging in or clicking our 'Forgot Password' button."
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
                
                NSLog(@"Error:%@", error.userInfo);
            } else if (error.code == 125) {
                
                [[[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                            message:@"Please enter a valid email address format."
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
                
                NSLog(@"Error:%@", error.userInfo);
            } else {
                
                [[[UIAlertView alloc] initWithTitle:@"Something went wrong!"
                                            message:@"Please try again - it was probably something on our end! You did nothing wrong, you're perfect."
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
                
                NSLog(@"Error:%@", error.userInfo);
            }
        }];
        
    }
    
}

-(void)hideKeyBoard {
    
    [textFieldConfirm resignFirstResponder];
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

/* Send invitation SMS to a phone number using Cloud Code and Twilio! */
- (void)sendSMSToNumber:(NSString *)number {
    
    //RandomNumberGeneration for verification
    int randomNumber;
    randomNumber = (arc4random()%9999)+1000; //Generates Number from 1 to 100.
    verificationNumberString = [NSString stringWithFormat:@"%i", randomNumber];
    NSLog(@"%@", verificationNumberString);
    
    NSString *verifyStringSentence = [NSString stringWithFormat:@"Verification code is:%@", verificationNumberString];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[number, verifyStringSentence] forKeys:@[@"number", @"verify"]];
    
    [PFCloud callFunctionInBackground:@"inviteWithTwilio" withParameters:params block:^(id object, NSError *error) {
        NSString *message = @"";
        if (!error) {
            message = @"Your SMS invitation has been sent!";
        } else {
            message = @"Uh oh, something went wrong :(";
        }
        
        NSLog(@"%@", message);
        
    }];
}

- (IBAction)doneButton:(id)sender {
    
    [textFieldConfirm resignFirstResponder];
    
    if ([textFieldConfirm.text isEqualToString:verificationNumberString]) {
        NSLog(@"Correct-o-mundo!");
        
        PFUser *user = [PFUser user];
        user.username = mobileNumberString;
        user.password = verificationNumberString;
        user[@"alternateUserName"] = alternateUserName;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //App working! Inside we go!
                
                [[[UIAlertView alloc] initWithTitle:@"Password"
                                            message:@"This pin is now your password so keep it safe! You can change your password later on in your Account Settings section."
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
                
                ViewController *startingVC = (ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"alreadyLoggedIn"];
                
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                [self presentViewController:startingVC animated:YES completion:nil];

            } else if (error.code == 202) {
                
                [[[UIAlertView alloc] initWithTitle:@"Account already exists!"
                                            message:@"An account already exists with these details. Please try logging in or clicking our 'Forgot Password' button."
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
                
                NSLog(@"Error:%@", error.userInfo);
            } else {
                
                [[[UIAlertView alloc] initWithTitle:@"Something went wrong!"
                                            message:@"Please try again - it was probably something on our end! You did nothing wrong, you're perfect."
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
                
                NSLog(@"Error:%@", error.userInfo);
            }
        }];
        
    } else {
        
        NSLog(@"Oh no");
        
        [[[UIAlertView alloc] initWithTitle:@"Something went wrong!"
                                    message:@"Please check the code and try entering it again."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
    }
}


@end

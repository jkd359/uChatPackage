//
//  LogInViewController.m
//  UChat
//
//  Created by Joel on 8/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "LogInViewController.h"
#import "ProgressHUD.h"

@interface LogInViewController ()

@end

@implementation LogInViewController
@synthesize textfieldMobileEmailUserName, textfieldPassword, logInButton;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    textfieldPassword.secureTextEntry = YES;
    
    //Set sign up button to be enabled and disabled correctly when clicking between views
    if (textfieldMobileEmailUserName.text.length > 0 && textfieldPassword.text.length > 0) {
        
        [self.logInButton setEnabled:YES];
        
    } else [self.logInButton setEnabled:NO];
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
    [textfieldMobileEmailUserName addTarget:self action:@selector(textfieldMobileEmailUserNameDidChange) forControlEvents:UIControlEventEditingChanged];
    [textfieldPassword addTarget:self action:@selector(textfieldPasswordDidChange) forControlEvents:UIControlEventEditingChanged];
    
    //Add clear button
    textfieldMobileEmailUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //Tap outside keyboard to dismiss
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];

}

- (void)textfieldMobileEmailUserNameDidChange {
    
    if (textfieldMobileEmailUserName.text.length > 0 && textfieldPassword.text.length > 0) {
        
        [self.logInButton setEnabled:YES];
        
    } else if (textfieldMobileEmailUserName.text.length < 1 || textfieldPassword.text.length < 1) {
        
        [self.logInButton setEnabled:NO];
    }
}

- (void)textfieldPasswordDidChange {
    
    if (textfieldPassword.text.length > 0 && textfieldMobileEmailUserName.text.length > 0) {
        
        [self.logInButton setEnabled:YES];
        
    } else if (textfieldPassword.text.length < 1 || textfieldMobileEmailUserName.text.length < 1) {
        
        [self.logInButton setEnabled:NO];
    }
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
- (IBAction)logInButton:(id)sender {
    
    if (textfieldPassword.text.length == 0 || textfieldMobileEmailUserName.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Information!" message:@"Please fill out all required information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
        
        NSLog(@"Please fill out all required information");
    }
    
    [PFUser logInWithUsernameInBackground:textfieldMobileEmailUserName.text password:textfieldPassword.text block:^(PFUser *user, NSError *error) {
        
        if (user) {
            
            ViewController *startingVC = (ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"alreadyLoggedIn"];
            
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            [self presentViewController:startingVC animated:YES completion:nil];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong!" message:@"Did you enter in the correct username and password? Remember usernames and passwords are case sensitive! It could be the connection or it could be our servers. Please try logging in again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert show];
            
            NSLog(@"Please log in!");
            
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)hideKeyBoard {
    
    [textfieldMobileEmailUserName resignFirstResponder];
    [textfieldPassword resignFirstResponder];
}

- (IBAction)forgotPassButton:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password?" message:@"Please enter your recovery email address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].delegate = self;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {

        [PFUser requestPasswordResetForEmailInBackground:[alertView textFieldAtIndex:0].text block:^(BOOL succeeded, NSError *error) {
            
            if (!error) {
        
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Please check your email for the reset password recovery link." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                // optional - add more buttons:
                [alert show];
                
            NSLog(@"Success!");
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong!" message:@"Are you sure you entered in the correct email address? Please try entering in your email again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                // optional - add more buttons:
                [alert show];
                
                NSLog(@"Something went wrong");
            }
        }
         ];
    };
}
@end

//
//  SearchForFriendViewController.m
//  UChat
//
//  Created by Joel on 16/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "SearchForFriendViewController.h"
#import "AddFriendViewController.h"

@interface SearchForFriendViewController ()

@end

@implementation SearchForFriendViewController
@synthesize searchTermString, textFieldSearchField;

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"buttonPressed"] isEqualToString:@"YES"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"search"]) {
        
        searchTermString = textFieldSearchField.text;
        
        AddFriendViewController *destVC = (AddFriendViewController *)segue.destinationViewController;
        destVC.passedDataIDString = searchTermString;
        
        PFQuery *queryForID = [PFUser query];
        [queryForID findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            NSLog(@"uChatID matching: %lu and is: %@", (unsigned long)objects.count, objects);
            
            for (PFObject *object in objects) {
                
                if ([object[@"uChatID"] isEqualToString:searchTermString]) {
                    NSLog(@"Yup found one");

                }
            }
        }];
        
 
    }
}

- (IBAction)searchButton:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    
    if ([textFieldSearchField.text isEqualToString:currentUser[@"uChatID"]]) {
        NSLog(@"You can't be your own friend! Or can you... - show an alert saying you can't add yourself!");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't be your own friend! Or can you...No you can't." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"friendsArray"] containsObject:textFieldSearchField.text]) {
        
        NSLog(@"Yup it is there! - Show an alert saying you are already friends");
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You are already friends!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        } else {
        
        [self performSegueWithIdentifier:@"search" sender:sender];

    }
    
}
- (IBAction)cancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

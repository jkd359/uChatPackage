//
//  ViewController.m
//  UChat
//
//  Created by Joel on 20/08/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "ViewController.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textFielduChatID, uChatIDString;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PFUser *currentLogUser = [PFUser currentUser];
    
    PFQuery *query = [PFUser query];
    [query whereKeyDoesNotExist:@"uChatID"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *object in objects) {
            
            NSString *userId = [NSString stringWithFormat:@"%@", object.objectId];
            NSString *currentUser = [NSString stringWithFormat:@"%@", currentLogUser.objectId];
            
            if ([userId isEqualToString:currentUser]) {
                NSLog(@"This is where user should be taken to screen to add a uChatID");
            }
        }
    }];
    

    
//    //Only show tutorial view on first launch
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"seenTutorial"]) {
//        
//        NSLog(@"Show tutorial Intro");
//        [self buildIntro];
//
//    } else
//        NSLog(@"Has already seen tutorial intro");
    
//    Set bool once user has viewed tutorial once, where appropriate
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"seenTutorial"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutButton:(id)sender {
    [PFUser logOut];
    NSLog(@"Logged out");
    


}
- (IBAction)saveButton:(id)sender {

    uChatIDString = textFielduChatID.text;
    
    PFQuery *queryUChatID = [PFUser query];
    [queryUChatID findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            if ([object[@"uChatID"] isEqualToString:uChatIDString]) {
                NSLog(@"Sorry can't create - already exists!");
            }
            else {
                
                PFUser *currentUser = [PFUser currentUser];
                currentUser[@"uChatID"] = uChatIDString;
                
                [currentUser saveInBackground];
                
                NSLog(@"created ID: %@", currentUser[@"uChatID"]);
            }
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }
    }];
}
@end

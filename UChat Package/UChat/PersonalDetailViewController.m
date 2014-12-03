//
//  PersonalDetailViewController.m
//  UChat
//
//  Created by Joel on 1/10/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "PersonalDetailViewController.h"
#import "utilities.h"
#import "ProgressHUD.h"

@interface PersonalDetailViewController ()

@end

@implementation PersonalDetailViewController
@synthesize passeduChatIdData, userIDLabel, usernameLabel, aboutMeLabel, chatStatusField, myImage, sendTextMessageButton, deleteFriendButton, changePictureButton, aboutMeTextField, characterCountLimitLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [chatStatusField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];

    //Tap outside keyboard to dismiss
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
        //Make delete and send message button invisible for the current user
        sendTextMessageButton.alpha = 0.0f;
        deleteFriendButton.alpha = 0.0f;
        
        NSLog(@"passeddata: %@", passeduChatIdData);
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"uChatID" equalTo:passeduChatIdData];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        userIDLabel.text = object[@"uChatID"];
        usernameLabel.text = object[@"fullname"];
        chatStatusField.text = object[@"chatStatus"];
        aboutMeLabel.text = object[@"aboutMe"];
        aboutMeTextField.text = object[@"aboutMe"];
        
        //Starting count
        NSUInteger characterCount = [chatStatusField.text length];
        
        NSUInteger reverseCharacterCount = 25 - characterCount;
        
        characterCountLimitLabel.text = [NSString stringWithFormat:@"%i", reverseCharacterCount];
        
        PFFile *filePictureThumbnail = object[@"picture"];
        [filePictureThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                 UIImage *image = [UIImage imageWithData:imageData];
                 [myImage setImage:image];
                 
                 //Creates a circle image - comment out to make image square again
                 self.myImage.layer.cornerRadius = self.myImage.frame.size.width / 2;
                 self.myImage.clipsToBounds = YES;
             }
         }];
        
    }
     
     ];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    
    currentUser[@"chatStatus"] = chatStatusField.text;
	currentUser[@"aboutMe"] = aboutMeTextField.text;
    [currentUser saveInBackground];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

//Limits the group name to 25 characters or less and keeps a running count for the user to see
- (void)editingChanged:(id)sender {
    
    NSUInteger characterCount = [chatStatusField.text length];
    
    NSUInteger reverseCharacterCount = 25 - characterCount;
    
    characterCountLimitLabel.text = [NSString stringWithFormat:@"%i", reverseCharacterCount];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength <= 25);
    
    NSLog(@"Length is:%lu", (unsigned long)newLength);
}

-(void)hideKeyBoard {
    [aboutMeTextField resignFirstResponder];
    [chatStatusField resignFirstResponder];

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [aboutMeTextField resignFirstResponder];
    [chatStatusField resignFirstResponder];
    
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (image.size.width > 140) image = ResizeImage(image, 140, 140);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
	[filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) [ProgressHUD showError:@"Network error."];
     }];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	myImage.image = image;
    
    //Creates a circle image - comment out to make image square again
    self.myImage.layer.cornerRadius = self.myImage.frame.size.width / 2;
    self.myImage.clipsToBounds = YES;
    
    //    To add a border around picture use this code.
    //    self.groupImagePreview.layer.borderWidth = 3.0f;
    //    self.groupImagePreview.layer.borderColor = [UIColor whiteColor].CGColor;
    
	//---------------------------------------------------------------------------------------------------------------------------------------------
	
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (image.size.width > 34) image = ResizeImage(image, 34, 34);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
	[fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) [ProgressHUD showError:@"Network error."];
     }];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    
	//---------------------------------------------------------------------------------------------------------------------------------------------
    PFUser *currentUser = [PFUser currentUser];
    
	currentUser[@"picture"] = filePicture;
	currentUser[@"thumbnail"] = fileThumbnail;
    [currentUser saveInBackground];
    
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changePicture:(id)sender {
    
    ShouldStartPhotoLibrary(self, YES);

}

@end

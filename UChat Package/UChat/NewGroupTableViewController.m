//
//  NewGroupTableViewController.m
//  UChat
//
//  Created by Joel on 21/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "NewGroupTableViewController.h"
#import "utilities.h"
#import "ProgressHUD.h"
#import "AddPeopleToGroupViewController.h"

@interface NewGroupTableViewController ()

@end

@implementation NewGroupTableViewController
@synthesize groupImagePreview, textFieldGroupName, changePictureButton, characterCountLimitLabel, passedImageData, passedImageDataThumbnail;

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
    
    [textFieldGroupName addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //Tap outside keyboard to dismiss
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    //Set default images for group chats
    UIImage *image = [UIImage imageNamed:@"blank_avatar.jpg"];
    
    if (image.size.width > 140) image = ResizeImage(image, 140, 140);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
	[filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) [ProgressHUD showError:@"Network error."];
     }];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	groupImagePreview.image = image;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (image.size.width > 34) image = ResizeImage(image, 34, 34);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
	[fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) [ProgressHUD showError:@"Network error."];
     }];
    
    passedImageData = filePicture;
	passedImageDataThumbnail = fileThumbnail;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (groupImagePreview.image != nil) {
        
        [changePictureButton setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
}

//Limits the group name to 25 characters or less and keeps a running count for the user to see
- (void)editingChanged:(id)sender {
    
    NSUInteger characterCount = [textFieldGroupName.text length];
    
    NSUInteger reverseCharacterCount = 25 - characterCount;
    
    characterCountLimitLabel.text = [NSString stringWithFormat:@"%i", reverseCharacterCount];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength <= 25);
    
    NSLog(@"Length is:%lu", (unsigned long)newLength);
}

-(void)hideKeyBoard {
    [textFieldGroupName resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textFieldGroupName resignFirstResponder];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addMembers"]) {
        
        AddPeopleToGroupViewController *destVC = [segue destinationViewController];
        
        destVC.groupNamePassedData = textFieldGroupName.text;
        
        destVC.passedImageData = passedImageData;
        destVC.passedImageDataThumbnail = passedImageDataThumbnail;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePictureButton:(id)sender {
    
    ShouldStartPhotoLibrary(self, YES);
    
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
	groupImagePreview.image = image;
    
    //Creates a circle image - comment out to make image square again
    self.groupImagePreview.layer.cornerRadius = self.groupImagePreview.frame.size.width / 2;
    self.groupImagePreview.clipsToBounds = YES;
    
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
	passedImageData = filePicture;
	passedImageDataThumbnail = fileThumbnail;

	//---------------------------------------------------------------------------------------------------------------------------------------------
	[picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

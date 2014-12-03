//
//  NewGroupTableViewController.h
//  UChat
//
//  Created by Joel on 21/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGroupTableViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *characterCountLimitLabel;
@property (strong, nonatomic) IBOutlet UITextField *textFieldGroupName;
- (IBAction)changePictureButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *changePictureButton;
@property (strong, nonatomic) IBOutlet UIImageView *groupImagePreview;
- (IBAction)cancelButton:(id)sender;

@property (nonatomic, retain) PFFile *passedImageData;
@property (nonatomic, retain) PFFile *passedImageDataThumbnail;

@end

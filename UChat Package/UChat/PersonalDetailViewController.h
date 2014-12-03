//
//  PersonalDetailViewController.h
//  UChat
//
//  Created by Joel on 1/10/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalDetailViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate>
@property (retain, nonatomic) NSString *passeduChatIdData;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
@property (strong, nonatomic) IBOutlet UILabel *userIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *characterCountLimitLabel;
@property (strong, nonatomic) IBOutlet UITextField *chatStatusField;
@property (strong, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendTextMessageButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteFriendButton;
@property (strong, nonatomic) IBOutlet UIButton *changePictureButton;
- (IBAction)changePicture:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *aboutMeTextField;

@end

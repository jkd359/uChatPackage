//
//  DetailContactTableViewController.h
//  UChat
//
//  Created by Joel on 20/08/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailContactTableViewController : UITableViewController
@property (retain, nonatomic) NSString *passeduChatIdData;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
@property (strong, nonatomic) IBOutlet UILabel *userIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *chatStatusLabel;
- (IBAction)sendATextMessageButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sendTextMessageButton;
@property (strong, nonatomic) IBOutlet UITextField *aboutMeTextField;

@end

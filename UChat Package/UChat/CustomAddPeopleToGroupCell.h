//
//  CustomAddPeopleToGroupCell.h
//  UChat
//
//  Created by Joel on 22/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAddPeopleToGroupCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *chatStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *addToGroupButton;
- (IBAction)addToGroup:(id)sender;

@end

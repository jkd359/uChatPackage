//
//  CustomAddUserCell.m
//  UChat
//
//  Created by Joel on 22/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "CustomAddUserCell.h"

@implementation CustomAddUserCell
@synthesize addFriendButton, userIdLabel, chatStatusLabel, myImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addFriend:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"checked_user-32.png"];
    
    [addFriendButton setImage:image forState:UIControlStateNormal];
    NSLog(@"button pressed");
    
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"buttonPressed"];
    
}

@end

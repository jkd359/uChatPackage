//
//  CustomGroupCell.h
//  UChat
//
//  Created by Joel on 22/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomGroupCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *groupImage;
@property (strong, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *peopleInGroup;

@end

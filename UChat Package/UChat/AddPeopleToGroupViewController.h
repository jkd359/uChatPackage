//
//  AddPeopleToGroupViewController.h
//  UChat
//
//  Created by Joel on 22/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <Parse/Parse.h>

@interface AddPeopleToGroupViewController : PFQueryTableViewController <UITextViewDelegate>

@property (nonatomic, retain) NSString *groupNamePassedData;
- (IBAction)confirmGroupCreation:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (nonatomic, retain) PFFile *passedImageData;
@property (nonatomic, retain) PFFile *passedImageDataThumbnail;

@end

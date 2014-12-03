//
//  AddFriendViewController.h
//  UChat
//
//  Created by Joel on 16/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import <Parse/Parse.h>

@interface AddFriendViewController : PFQueryTableViewController

@property (retain, nonatomic) NSString *passedDataIDString;
@property (retain, nonatomic) NSMutableArray *passedDataArray;
@property (retain, nonatomic) UIImage *passedImageData;

- (void)friendsArrayCheck;

@end

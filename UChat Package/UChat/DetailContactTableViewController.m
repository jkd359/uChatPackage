//
//  DetailContactTableViewController.m
//  UChat
//
//  Created by Joel on 20/08/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "DetailContactTableViewController.h"

@interface DetailContactTableViewController ()

@end

@implementation DetailContactTableViewController
@synthesize passeduChatIdData, userIDLabel, usernameLabel, chatStatusLabel, myImage, sendTextMessageButton, aboutMeTextField;

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
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isCurrentUser"] isEqualToString:@"YES"]) {
        
        //Make delete and send message button invisible for the current user
        sendTextMessageButton.alpha = 0.0f;
        aboutMeTextField.alpha = 1.0f;
        
        
    } else
    
    NSLog(@"passeddata: %@", passeduChatIdData);
    
    aboutMeTextField.alpha = 0.0f;
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"uChatID" equalTo:passeduChatIdData];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        userIDLabel.text = object[@"uChatID"];
        usernameLabel.text = object[@"fullname"];
        chatStatusLabel.text = object[@"chatStatus"];
        aboutMeTextField.text = object[@"aboutMe"];
        
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
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isCurrentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendATextMessageButton:(id)sender {
    
}


@end

//
//  AddFriendViewController.m
//  UChat
//
//  Created by Joel on 16/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "AddFriendViewController.h"
#import "CustomAddUserCell.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController
@synthesize passedDataIDString, passedDataArray, passedImageData;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"Stringis: %@", passedDataIDString);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)friendsArrayCheck {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        //Setting up query to be able to check in another VC whether or not friend ID was already added.
        
        //Get current user
        PFUser *currentUser = [PFUser currentUser];
        
        //Query the FriendRequest class for current user attempting to add another user
        PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
        [query whereKey:@"fromUser" equalTo:currentUser];
        [query whereKey:@"status" equalTo:@"approved"];
        [query includeKey:@"fromUser"];
        [query includeKey:@"toUser"];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        query.limit = 1000;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            NSMutableArray *friendsIdArray = [[NSMutableArray alloc] init];
            
            for (PFObject *obj in objects) {
                
                NSLog(@"get it: %@", obj[@"toUser"][@"uChatID"]);
                
                [friendsIdArray addObject:obj[@"toUser"][@"uChatID"]];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:friendsIdArray forKey:@"friendsArray"];
            NSLog(@"Array is:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"friendsArray"]);
            
            
            if (error) {
                NSLog(@"error is:%@%@", error.userInfo, error.localizedDescription);
            }
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self friendsArrayCheck];
    
        PFUser *currentUser = [PFUser currentUser];
        
        PFQuery *queryForID = [PFUser query];
        [queryForID findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            NSLog(@"uChatID matching: %lu and is: %@", (unsigned long)objects.count, objects);
            
            for (PFObject *object in objects) {
                
            if ([object[@"uChatID"] isEqualToString:passedDataIDString]) {
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"buttonPressed"] isEqualToString:@"YES"]) {
                    
                    
//              Used for adding and saving the friend to the current user
                PFObject *friendList = [PFObject objectWithClassName:@"FriendRequest"];
                friendList[@"fromUser"] = currentUser;
                friendList[@"toUser"] = object;
                friendList[@"status"] = @"approved";
                    
                //Setting up reverse relationship
                    PFObject *secondFriendList = [PFObject objectWithClassName:@"FriendRequest"];
                    secondFriendList[@"fromUser"] = object;
                    secondFriendList[@"toUser"] = currentUser;
                    secondFriendList[@"status"] = @"approved";
                    
                [friendList saveInBackground];
                    
                    
                } else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"buttonPressed"] isEqualToString:@"NO"]) {
                    
                    NSLog(@"Do nothing");
                }
            }
            }
        }];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFUser query];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.limit = 1000;
    self.paginationEnabled = NO;
    
    //**Used fo displaying friends list
    [query whereKey:@"uChatID" equalTo:passedDataIDString];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES];
    
    [query orderBySortDescriptor:sortName];
    
    [self.tableView reloadData];
    
    return query;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.objects.count;
    
    
    
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    CustomAddUserCell *cell = (CustomAddUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[CustomAddUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    
    NSString *userIdAndName = [NSString stringWithFormat:@"%@   %@", [object objectForKey:@"uChatID"], [object objectForKey:@"fullname"]];
    
    PFFile *userImageFile = object[@"thumbnail"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        passedImageData =[UIImage imageWithData:data];
        NSLog(@"hello:%@", passedImageData);

        
    }];
    
    cell.userIdLabel.text = userIdAndName;
    cell.chatStatusLabel.text = [object objectForKey:@"chatStatus"];
    cell.myImage.image = passedImageData;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end

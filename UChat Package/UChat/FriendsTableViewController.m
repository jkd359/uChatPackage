//
//  FriendsTableViewController.m
//  UChat
//
//  Created by Joel on 22/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "DetailContactTableViewController.h"
#import "CustomUserCell.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"buttonPressed"];
    
    [self loadObjects];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
        [self friendsArrayCheck];

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

- (void)friendsArrayCheck {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
    //Setting up query to be able to check in another VC whether or not friend ID was already added.
    
    PFUser *currentUser = [PFUser currentUser];
    
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

    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"fromUser" equalTo:currentUser];
    [query whereKey:@"status" equalTo:@"approved"];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.limit = 1000;
    
    [query findObjects];
    
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
    
    CustomUserCell *cell = (CustomUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[CustomUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSLog(@"chatstatus: %@", object[@"toUser"][@"chatStatus"]);
    
    //User objects are included in the "include key" search in the PFQuery so this is how you access the "object" properties
    cell.userIdLabel.text = object[@"toUser"][@"uChatID"];
    cell.statusLabel.text = object[@"toUser"][@"chatStatus"];
    
    
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


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
     
 // Delete the row from the data source
     
     PFObject *object = [self.objects objectAtIndex:indexPath.row];
     
     [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (succeeded) {
             
             NSLog(@"Success!");
             
             [self loadObjects];
         }
        
     }];

 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detail"]) {
        
        DetailContactTableViewController *destVC = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        destVC.passeduChatIdData = object[@"toUser"][@"uChatID"];

        NSLog(@"cellis:%@", object);
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end

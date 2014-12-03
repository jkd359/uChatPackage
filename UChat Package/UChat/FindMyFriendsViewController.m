//
//  FindMyFriendsViewController.m
//  UChat
//
//  Created by Joel on 7/10/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "FindMyFriendsViewController.h"
#import "ProgressHUD.h"
#import "CustomAddUserCell.h"

@interface FindMyFriendsViewController ()

@end

@implementation FindMyFriendsViewController
@synthesize passedImageData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ProgressHUD show:@"Finding your friends..."];
    
    //Contacts from phone
    [[NSUserDefaults standardUserDefaults] objectForKey:@"mobiles"];
    
    NSLog(@"yupyup:%@",    [[NSUserDefaults standardUserDefaults] objectForKey:@"mobiles"]);
    NSLog(@"nopenope:%@",    self.objects);

    
    [ProgressHUD dismiss];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self friendsArrayCheck];
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *queryForID = [PFUser query];
    [queryForID findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSLog(@"uChatID matching: %lu and is: %@", (unsigned long)objects.count, objects);
        
        for (PFObject *object in objects) {
            
            
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"buttonPressed"] isEqualToString:@"YES"]) {
                    
                    
                    //Used for adding and saving the friend to the current user
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
        
    }];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    
    //**Used for displaying friends list
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    
    [query findObjects];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        NSLog(@"no results from network");
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
    
    NSString *userIdAndName = [NSString stringWithFormat:@"%@   %@", object[@"uChatID"], object[@"fullname"]];
    
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

- (void)friendsArrayCheck {
    
    //Background - asynchronous method
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
            
            //Adding objects to the array and then saving to NSUserDefaults so array can be accessed anywhere throughout the app
            
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end

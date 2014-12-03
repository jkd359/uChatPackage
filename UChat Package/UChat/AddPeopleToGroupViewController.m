//
//  AddPeopleToGroupViewController.m
//  UChat
//
//  Created by Joel on 22/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "AddPeopleToGroupViewController.h"
#import "CustomAddPeopleToGroupCell.h"

@interface AddPeopleToGroupViewController ()

@property (nonatomic, strong) NSMutableArray *peopleArray;

@end

@implementation AddPeopleToGroupViewController
@synthesize groupNamePassedData, peopleArray, userTextField, passedImageDataThumbnail, passedImageData;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Tap outside keyboard to dismiss
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    //Set cancelstouchesinview to no to stop a tapgesture override glitch in xcode.
    [tapGesture setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:tapGesture];
    
    peopleArray = [[[NSMutableArray alloc] init] mutableCopy];
    
    NSLog(@"passed room name: %@", groupNamePassedData);
    
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
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

-(void)hideKeyBoard {
    [userTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [userTextField resignFirstResponder];
    
    return YES;
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
    
    CustomAddPeopleToGroupCell *cell = (CustomAddPeopleToGroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[CustomAddPeopleToGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSLog(@"chatstatus: %@", object[@"toUser"][@"chatStatus"]);
    
    //User objects are included in the "include key" search in the PFQuery so this is how you access the "object" properties
    cell.userIdLabel.text = object[@"toUser"][@"uChatID"];
    cell.chatStatusLabel.text = object[@"toUser"][@"chatStatus"];
    
    
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
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];

    CustomAddPeopleToGroupCell *cell = (CustomAddPeopleToGroupCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    UIImage *personImage = [UIImage imageNamed:@"add_user-32.png"];
    UIImage *personAddedImage = [UIImage imageNamed:@"checked_user-32.png"];
    
    if (cell.addToGroupButton.imageView.image == personImage) {
        
        cell.addToGroupButton.imageView.image = personAddedImage;
        
        [peopleArray addObject:cell.userIdLabel.text];
        
    } else if (cell.addToGroupButton.imageView.image == personAddedImage) {
        
        cell.addToGroupButton.imageView.image = personImage;
        
        [peopleArray removeObject:cell.userIdLabel.text];
        
    }
    
    NSString *textSearchString = [NSString stringWithFormat:@"%@", peopleArray];
    
    NSString *secondTextSearchString = [textSearchString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    
    NSString *thirdTextSearchString = [secondTextSearchString stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    userTextField.text = thirdTextSearchString;
    
}

- (IBAction)confirmGroupCreation:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    
    [peopleArray addObject:currentUser[@"uChatID"]];
    
    NSLog(@"peoplearray is:%@", peopleArray);
    
    NSLog(@"room: %@", groupNamePassedData);
    NSLog(@"owner: %@", currentUser);
    NSLog(@"pic: %@", passedImageData);
    NSLog(@"pic2: %@", passedImageDataThumbnail);

    
    PFObject *group = [PFObject objectWithClassName:@"ChatRooms"];
    group[@"room"] = groupNamePassedData;
    group[@"owner"] = currentUser;
    group[@"usersInGroup"]  = peopleArray;
	group[@"picture"] = passedImageData;
	group[@"thumbnail"] = passedImageDataThumbnail;
    [group saveInBackground];
    NSLog(@"object user is: %@", group);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

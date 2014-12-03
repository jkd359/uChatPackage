//
//  GroupTableViewController.m
//  UChat
//
//  Created by Joel on 17/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "GroupTableViewController.h"
#import "ProgressHUD.h"

#import "ChatViewController.h"
#import "utilities.h"
#import "CustomGroupCell.h"

@interface GroupTableViewController ()
{
	NSMutableArray *chatrooms;
}
@end

@implementation GroupTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.tableView.separatorInset = UIEdgeInsetsZero;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	chatrooms = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSLog(@"Current user is:%@", [PFUser currentUser][@"uChatID" ]);
	[self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[ProgressHUD show:nil];
	PFQuery *query = [PFQuery queryWithClassName:@"ChatRooms"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    NSString *currentUserID = [PFUser currentUser][@"uChatID"];
    
    [query whereKey:@"usersInGroup" equalTo:currentUserID];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {

         if (error == nil)
         {
             NSLog(@"objects found count: %i", objects.count);
             [chatrooms removeAllObjects];
             
             for (PFObject *object in objects)
             {
                 [chatrooms addObject:object];
             }
             [ProgressHUD dismiss];
             [self.tableView reloadData];
             

         }
         else if (error) {
             
         [ProgressHUD showError:@"Network error."];
             
         }
     }];
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [chatrooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CustomGroupCell *cell = (CustomGroupCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) cell = [[CustomGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    //Room
	PFObject *room = [chatrooms objectAtIndex:indexPath.row];
	cell.groupNameLabel.text = room[@"room"];
    
    //People in room
    
    NSMutableArray *peopleInGroup = [[[NSMutableArray alloc] initWithArray:room[@"usersInGroup"]] mutableCopy];
    
    NSString *resultString = [peopleInGroup componentsJoinedByString:@", "];
    
    cell.peopleInGroup.text = resultString;
        
    PFFile *filePictureThumbnail = room[@"thumbnail"];
    [filePictureThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
     {
         if (error == nil)
         {
             UIImage *image = [UIImage imageWithData:imageData];
             [cell.groupImage setImage:image];
         }
     }];
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        
        PFObject *object = [chatrooms objectAtIndex:indexPath.row];
        
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                NSLog(@"Success!");
                
                [self refreshTable];
                
            }
            
        }];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
	PFObject *chatroom = [chatrooms objectAtIndex:indexPath.row];
    NSLog(@"chatroommm:%@ and objectid:%@", chatroom, chatroom.objectId);

	ChatViewController *chatView = [[ChatViewController alloc] initWith:chatroom.objectId];
	chatView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:chatView animated:YES];
}


@end

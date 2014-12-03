//
//  ContactsTableViewController.m
//  UChat
//
//  Created by Joel on 20/08/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "ContactsTableViewController.h"

@interface ContactsTableViewController ()

@property (strong, nonatomic) NSArray *indexListEnglish;

@end

@implementation ContactsTableViewController
@synthesize contactList, dictOfPerson;

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
    
    _indexListEnglish = [[NSArray alloc] initWithObjects:@"", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    
    CFErrorRef *error = nil;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, error);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSLog(@"Permission granted.");
        } else {
            NSLog(@"Grant Permission douchebag");
        }
    });
    

    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    contactList = [[[NSMutableArray alloc] init] mutableCopy];
    
    NSLog(@"All people: %@", allPeople);
    NSLog(@"Count: %ld", (unsigned long)nPeople);
    
    for (int i = 0; i < nPeople; i ++) {
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        NSLog(@"Ref: %@", ref);
    
        CFStringRef firstName, lastName, email;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        //Email
        ABMutableMultiValueRef multiEmail = ABRecordCopyValue(ref, kABPersonEmailProperty);
        email = ABRecordCopyValue(ref, kABPersonEmailProperty);
        NSString *emailString = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiEmail, 0);
        
        //Phones
        ABMultiValueRef phones = (__bridge ABMultiValueRef)((__bridge NSString *)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        NSString *mobileNumberString = nil;
        
        NSString * mobileLabel;
        
        for (int i = 0; i < ABMultiValueGetCount(phones); i ++) {
            mobileLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            
            if ([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
                
                NSString *mobilePhoneString = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                
                NSLog(@"Mobile: %@", mobilePhoneString);
                
                mobileNumberString = mobilePhoneString;
            }
        }
        
        NSLog(@"FirstName: %@, LastName:%@, Email:%@", firstName, lastName, emailString);
        
        dictOfPerson = [[[NSMutableDictionary alloc] init] mutableCopy];
        
        if (firstName != nil || lastName != nil || email != nil || mobileNumberString !=nil) {
            
            NSString *firstNameString = (__bridge NSString *)(firstName);
            NSString *lastNameString = (__bridge NSString *)(lastName);
            
            if (firstNameString == nil) {
                firstNameString = @"";
            }
            
            if (lastNameString == nil) {
                lastNameString = @"";
            }
            
            if (emailString == nil) {
                emailString = @"";
            }
            
            if (mobileNumberString == nil) {
                mobileNumberString = @"";
            }
            
            if ([firstNameString isEqualToString:@""] && [lastNameString isEqualToString:@""] ) {
                NSLog(@"Email is: %@", emailString);
                firstNameString = emailString;
            }
            
            NSString *name = [NSString stringWithFormat:@"%@ %@", firstNameString, lastNameString];
            
            
            [dictOfPerson setObject:firstNameString forKey:@"firstName"];
            [dictOfPerson setObject:lastNameString forKey:@"LastName"];
            [dictOfPerson setObject:emailString forKey:@"email"];
            [dictOfPerson setObject:mobileNumberString forKey:@"mobile"];
            [dictOfPerson setObject:name forKey:@"fullName"];
            
        [contactList addObject:dictOfPerson];
        }
        
    NSLog(@"Contactlist: %@", contactList);
    NSLog(@"Count2: %ld", (unsigned long)contactList.count);

    }
    

    

    
    for (NSDictionary *dict in contactList) {
        
        NSString *firstNameString = dict[@"firstName"];
        NSString *lastNameString = dict[@"lastName"];
        
        //Checking Strings are correctly added, no mis-spacing.
        NSUInteger length = [firstNameString length];
        NSLog(@"FirstName: %@ with length: %i", firstNameString, length);
        
        //Alphabetising the sections - checking firstname then if nil checking lastname then if none of those match putting it in its own special section
        
            //FirstNames
            if ([firstNameString hasPrefix:@"A"] || [firstNameString hasPrefix:@"a"]) {
                
                [dict setValue:@"A" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"B"] || [firstNameString hasPrefix:@"b"]) {
                
                [dict setValue:@"B" forKey:@"section"];

            } else if ([firstNameString hasPrefix:@"C"] || [firstNameString hasPrefix:@"c"]) {
                
                [dict setValue:@"C" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"D"] || [firstNameString hasPrefix:@"d"]) {
                
                [dict setValue:@"D" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"E"] || [firstNameString hasPrefix:@"e"]) {
                
                [dict setValue:@"E" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"F"] || [firstNameString hasPrefix:@"f"]) {
                
                [dict setValue:@"F" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"G"] || [firstNameString hasPrefix:@"g"]) {
                
                [dict setValue:@"G" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"H"] || [firstNameString hasPrefix:@"h"]) {
                
                [dict setValue:@"H" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"I"] || [firstNameString hasPrefix:@"i"]) {
                
                [dict setValue:@"I" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"J"] || [firstNameString hasPrefix:@"j"]) {
                
                [dict setValue:@"J" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"K"] || [firstNameString hasPrefix:@"k"]) {
                
                [dict setValue:@"K" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"L"] || [firstNameString hasPrefix:@"l"]) {
                
                [dict setValue:@"L" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"M"] || [firstNameString hasPrefix:@"m"]) {
                
                [dict setValue:@"M" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"N"] || [firstNameString hasPrefix:@"n"]) {
                
                [dict setValue:@"N" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"O"] || [firstNameString hasPrefix:@"o"]) {
                
                [dict setValue:@"O" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"P"] || [firstNameString hasPrefix:@"p"]) {
                
                [dict setValue:@"P" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"Q"] || [firstNameString hasPrefix:@"q"]) {
                
                [dict setValue:@"Q" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"R"] || [firstNameString hasPrefix:@"r"]) {
                
                [dict setValue:@"R" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"S"] || [firstNameString hasPrefix:@"s"]) {
                
                [dict setValue:@"S" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"T"] || [firstNameString hasPrefix:@"t"]) {
                
                [dict setValue:@"T" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"U"] || [firstNameString hasPrefix:@"u"]) {
                
                [dict setValue:@"U" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"V"] || [firstNameString hasPrefix:@"v"]) {
                
                [dict setValue:@"V" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"W"] || [firstNameString hasPrefix:@"w"]) {
                
                [dict setValue:@"W" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"X"] || [firstNameString hasPrefix:@"x"]) {
                
                [dict setValue:@"X" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"Y"] || [firstNameString hasPrefix:@"y"]) {
                
                [dict setValue:@"Y" forKey:@"section"];
                
            } else if ([firstNameString hasPrefix:@"Z"] || [firstNameString hasPrefix:@"Z"]) {
                
                [dict setValue:@"Z" forKey:@"section"];
                
            }
        
        //LastNames
        if ([lastNameString hasPrefix:@"A"] || [lastNameString hasPrefix:@"a"]) {
            
            [dict setValue:@"A" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"B"] || [lastNameString hasPrefix:@"b"]) {
            
            [dict setValue:@"B" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"C"] || [lastNameString hasPrefix:@"c"]) {
            
            [dict setValue:@"C" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"D"] || [lastNameString hasPrefix:@"d"]) {
            
            [dict setValue:@"D" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"E"] || [lastNameString hasPrefix:@"e"]) {
            
            [dict setValue:@"E" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"F"] || [lastNameString hasPrefix:@"f"]) {
            
            [dict setValue:@"F" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"G"] || [lastNameString hasPrefix:@"g"]) {
            
            [dict setValue:@"G" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"H"] || [lastNameString hasPrefix:@"h"]) {
            
            [dict setValue:@"H" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"I"] || [lastNameString hasPrefix:@"i"]) {
            
            [dict setValue:@"I" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"J"] || [lastNameString hasPrefix:@"j"]) {
            
            [dict setValue:@"J" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"K"] || [lastNameString hasPrefix:@"k"]) {
            
            [dict setValue:@"K" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"L"] || [lastNameString hasPrefix:@"l"]) {
            
            [dict setValue:@"L" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"M"] || [lastNameString hasPrefix:@"m"]) {
            
            [dict setValue:@"M" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"N"] || [lastNameString hasPrefix:@"n"]) {
            
            [dict setValue:@"N" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"O"] || [lastNameString hasPrefix:@"o"]) {
            
            [dict setValue:@"O" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"P"] || [lastNameString hasPrefix:@"p"]) {
            
            [dict setValue:@"P" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"Q"] || [lastNameString hasPrefix:@"q"]) {
            
            [dict setValue:@"Q" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"R"] || [lastNameString hasPrefix:@"r"]) {
            
            [dict setValue:@"R" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"S"] || [lastNameString hasPrefix:@"s"]) {
            
            [dict setValue:@"S" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"T"] || [lastNameString hasPrefix:@"t"]) {
            
            [dict setValue:@"T" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"U"] || [lastNameString hasPrefix:@"u"]) {
            
            [dict setValue:@"U" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"V"] || [lastNameString hasPrefix:@"v"]) {
            
            [dict setValue:@"V" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"W"] || [lastNameString hasPrefix:@"w"]) {
            
            [dict setValue:@"W" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"X"] || [lastNameString hasPrefix:@"x"]) {
            
            [dict setValue:@"X" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"Y"] || [lastNameString hasPrefix:@"y"]) {
            
            [dict setValue:@"Y" forKey:@"section"];
            
        } else if ([lastNameString hasPrefix:@"Z"] || [lastNameString hasPrefix:@"Z"]) {
            
            [dict setValue:@"Z" forKey:@"section"];
            
        }

        
            if (dict[@"section" ] == NULL) {
                [dict setValue:@"#" forKeyPath:@"section"];
            }
        
        

        

        
        NSLog(@"FirstNames are: %@ LastNames are: %@ Section is: %@", dict[@"firstName"], dict[@"lastName"], dict[@"section"]);

    }
    
    PFObject *contactListArrayOfDictionaries = [PFObject objectWithClassName:@"UserContacts"];
    contactListArrayOfDictionaries[@"addressBook"] = contactList;
    [contactListArrayOfDictionaries saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Success!");
        } else if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            
            //If can't save initiates a "Save Eventually Block" which will cache and then save the data next time a network connection is available
            
            [contactListArrayOfDictionaries saveEventually];
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return contactList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    
    NSArray *sortDescs = [NSArray arrayWithObject:sortDesc];
    
    NSMutableArray *sortedContacts = [[contactList sortedArrayUsingDescriptors:sortDescs] copy];
    
    
    
    cell.textLabel.text = [[sortedContacts objectAtIndex:indexPath.row] objectForKey:@"fullName"];
    
    return cell;
}


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

@end

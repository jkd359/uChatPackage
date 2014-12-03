//
//  AppDelegate.m
//  UChat
//
//  Created by Joel on 20/08/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Only show tutorial view on first launch, dispatch block of code is for running in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

    [self syncAddressBookContacts];
    
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
    
    [Parse setApplicationId:@"APP_KEY_HERE"
                  clientKey:@"CLIENT_KEY_HERE"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *initialVCLoggedIn = [storyboard instantiateViewControllerWithIdentifier:@"alreadyLoggedIn"];
    
    UIViewController *notLoggedInInitialVC = [storyboard instantiateViewControllerWithIdentifier:@"SignUpLogIn"];

    PFUser *currentUser = [PFUser currentUser];
    
    //If user is logged in go to app otherwise show them the sign up and log in screens
    if (currentUser) {
        
        self.window.rootViewController = initialVCLoggedIn;

    } else {
        
        self.window.rootViewController = notLoggedInInitialVC;

    }
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)syncAddressBookContacts {
    
    //So this is an example of using the address book
    
    //The alphabetical listing down the side when implementing the tableview search function can be setup alphabetically for all languages but must be done manually if you are including your own symbols like we are in this example, eg: #
    
    _indexListEnglish = [[NSArray alloc] initWithObjects:@"", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    
    //Sets up error
    CFErrorRef *error = nil;
    
    //Creates addressbook instance
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, error);
    
    //Basically this is the asking to have access to a user's contacts and information, the actualy "Can we have access" message can be changed in the info.plist.
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSLog(@"Permission granted.");
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contacts Permission not granted" message:@"Please go to Settings -> Privacy -> Contacts and allow permission to fully experience the app!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
            NSLog(@"Grant Permission douchebag");
        }
    });
    
    
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    _contactListFirstNames = [[[NSMutableArray alloc] init] mutableCopy];
    _contactListMobiles = [[[NSMutableArray alloc] init] mutableCopy];
    _contactListLastNames = [[[NSMutableArray alloc] init] mutableCopy];
    _contactListEmails = [[[NSMutableArray alloc] init] mutableCopy];
    
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
                
                //Deals with the international phone codes issue for Australia, +61
                
                if ([mobilePhoneString hasPrefix:@"0"]) {
                    NSRange range = NSMakeRange(0, 1);
                    NSString *newMobilePhoneString = [mobilePhoneString stringByReplacingCharactersInRange:range withString:@"+61"];
                    NSString *mobileNumberNoSpaces = [newMobilePhoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
                    mobileNumberString = mobileNumberNoSpaces;
                } else
                    
                    mobileNumberString = mobilePhoneString;
            }
        }
        
        NSLog(@"FirstName: %@, LastName:%@, Email:%@", firstName, lastName, emailString);
        
        
        
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
        
        //Full name string in case needs to save full name strings into an array.
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstNameString, lastNameString];
        
        [_contactListFirstNames addObject:firstNameString];
        [_contactListEmails addObject:emailString];
        [_contactListLastNames addObject:lastNameString];
        [_contactListMobiles addObject:mobileNumberString];
    }
    [_contactListFirstNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //Saving each value to an array then saving those arrays to the UserDefaults for quick access and continuous storage.
    
    [[NSUserDefaults standardUserDefaults] setValue:_contactListFirstNames forKey:@"firstNames"];
    [[NSUserDefaults standardUserDefaults] setValue:_contactListLastNames forKey:@"lastNames"];
    [[NSUserDefaults standardUserDefaults] setValue:_contactListEmails forKey:@"emails"];
    [[NSUserDefaults standardUserDefaults] setValue:_contactListMobiles forKey:@"mobiles"];
    
    NSLog(@"Firstnamesarray: %@ and count:%i", [[NSUserDefaults standardUserDefaults] valueForKey:@"firstNames"], [[[NSUserDefaults standardUserDefaults] valueForKey:@"firstNames"] count]);
    NSLog(@"Lastnamesarray: %@ and count:%i", [[NSUserDefaults standardUserDefaults] valueForKey:@"lastNames"], [[[NSUserDefaults standardUserDefaults] valueForKey:@"lastNames"] count]);
    NSLog(@"Emailsarray: %@ and count:%i", [[NSUserDefaults standardUserDefaults] valueForKey:@"emails"], [[[NSUserDefaults standardUserDefaults] valueForKey:@"emails"] count]);
    NSLog(@"Mobilesarray: %@ and count:%i", [[NSUserDefaults standardUserDefaults] valueForKey:@"mobiles"], [[[NSUserDefaults standardUserDefaults] valueForKey:@"mobiles"] count]);
    
}


@end

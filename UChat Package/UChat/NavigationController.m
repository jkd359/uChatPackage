//
//  NavigationController.m
//  UChat
//
//  Created by Joel on 5/10/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "NavigationController.h"
#import "Constants.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	self.navigationBar.barTintColor = COLOR_NAVBAR_BACKGROUND;
	self.navigationBar.tintColor = COLOR_NAVBAR_BUTTON;
	self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:COLOR_NAVBAR_TITLE};
	self.navigationBar.translucent = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

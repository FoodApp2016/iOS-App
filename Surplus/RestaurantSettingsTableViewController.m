//
//  RestaurantSettingsTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/17/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantSettingsTableViewController.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "Constants.h"
#import "FacebookSignInViewController.h"

@interface RestaurantSettingsTableViewController ()

@end

@implementation RestaurantSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNSUserDefaultsRestaurantKey];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FacebookSignInViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kFacebookSignInViewControllerIdentifier];
        [self presentViewController:viewController animated:YES completion:nil];

    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSString *urlString = [@"mailto:" stringByAppendingString:kFeedbackEmailId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

@end

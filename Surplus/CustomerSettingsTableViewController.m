//
//  CustomerSettingsTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/8/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "CustomerSettingsTableViewController.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "Constants.h"
#import "FacebookSignInViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface CustomerSettingsTableViewController ()

@end

@implementation CustomerSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults] saveCustomer:nil key:kNSUserDefaultsCustomerKey];
        [[FBSDKLoginManager new] logOut];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FacebookSignInViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kFacebookSignInViewControllerIdentifier];
        [self presentViewController:viewController animated:NO completion:nil];
    }
}

@end

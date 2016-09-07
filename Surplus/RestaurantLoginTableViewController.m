//
//  RestaurantLoginTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/6/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantLoginTableViewController.h"

@interface RestaurantLoginTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation RestaurantLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textFields = @[self.usernameTextField, self.passwordTextField];
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
    return 2;
}

- (IBAction)doneButtonPressed:(id)sender {
    [super buttonPressed:sender
                 handler:^() {
        [self displayProcessingRegistrationAlertController];
    }];
}
- (IBAction)backButtonPressed:(id)sender {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end

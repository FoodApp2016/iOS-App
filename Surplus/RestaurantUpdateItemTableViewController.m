//
//  RestaurantUpdateItemTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/8/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantUpdateItemTableViewController.h"

@interface RestaurantUpdateItemTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *leftoversItemTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityAvailableTextField;

@end

@implementation RestaurantUpdateItemTableViewController

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
    return 3;
}

-(void)textFieldDidChange :(UITextField *)textField {
    
    if (textField.text != nil) {

    }
}


@end
